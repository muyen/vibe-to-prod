# API Gateway & Authentication Architecture

> **Audience**: AI assistants and developers implementing auth features.

This document explains how authentication and API routing work in this template.

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────┐
│                              MOBILE CLIENTS                               │
│                         (iOS / Android / Web)                             │
└───────────────────────┬──────────────────────┬───────────────────────────┘
                        │                      │
                        │ 1. Authenticate      │ 2. API Calls
                        │                      │
                        ▼                      ▼
┌───────────────────────────────┐   ┌──────────────────────────────────────┐
│        Firebase Auth          │   │            Cloud Run API             │
│  (Google, Apple, Email/Pass)  │   │                                      │
│                               │   │  ┌──────────────────────────────┐   │
│  Returns: ID Token (JWT)      │   │  │     Auth Middleware          │   │
└───────────────────────────────┘   │  │  - Validates Firebase JWT    │   │
                                    │  │  - Extracts user ID           │   │
                                    │  │  - Sets context               │   │
                                    │  └──────────────────────────────┘   │
                                    │                 │                    │
                                    │                 ▼                    │
                                    │  ┌──────────────────────────────┐   │
                                    │  │      Route Handlers          │   │
                                    │  │  - /health (public)          │   │
                                    │  │  - /api/v1/* (authenticated) │   │
                                    │  └──────────────────────────────┘   │
                                    │                 │                    │
                                    │                 ▼                    │
                                    │  ┌──────────────────────────────┐   │
                                    │  │        Firestore             │   │
                                    │  │   (User data, app data)      │   │
                                    │  └──────────────────────────────┘   │
                                    └──────────────────────────────────────┘
```

---

## Why This Pattern?

| Pattern Choice | Why |
|---------------|-----|
| **Firebase Auth** | Handles OAuth complexity (Google, Apple sign-in) without custom code |
| **JWT Validation in Backend** | Cloud Run validates tokens, no separate API Gateway needed |
| **No GCP API Gateway** | Simpler, cheaper, less latency. Auth middleware is ~10 lines of Go |

---

## Authentication Flow

### 1. Client Authentication (Mobile/Web)

```swift
// iOS Example
import FirebaseAuth

// Sign in with Google
Auth.auth().signIn(with: credential) { result, error in
    // Get ID token for API calls
    result?.user.getIDToken { token, error in
        // Use this token in API requests
    }
}
```

```kotlin
// Android Example
import com.google.firebase.auth.FirebaseAuth

// Sign in with Google
FirebaseAuth.getInstance().signInWithCredential(credential)
    .addOnSuccessListener { result ->
        // Get ID token for API calls
        result.user?.getIdToken(false)?.addOnSuccessListener { tokenResult ->
            // Use this token in API requests
        }
    }
```

### 2. API Request with Token

```
GET /api/v1/users/me
Authorization: Bearer <firebase-id-token>
```

### 3. Backend Token Validation

```go
// backend/internal/middleware/auth.go

func AuthMiddleware(firebaseApp *firebase.App) echo.MiddlewareFunc {
    return func(next echo.HandlerFunc) echo.HandlerFunc {
        return func(c echo.Context) error {
            // Extract token from header
            authHeader := c.Request().Header.Get("Authorization")
            if authHeader == "" {
                return echo.NewHTTPError(401, "missing authorization header")
            }

            token := strings.TrimPrefix(authHeader, "Bearer ")

            // Verify with Firebase Admin SDK
            client, _ := firebaseApp.Auth(c.Request().Context())
            decodedToken, err := client.VerifyIDToken(c.Request().Context(), token)
            if err != nil {
                return echo.NewHTTPError(401, "invalid token")
            }

            // Set user ID in context
            c.Set("userID", decodedToken.UID)
            c.Set("userEmail", decodedToken.Claims["email"])

            return next(c)
        }
    }
}
```

---

## Route Configuration

### Public Routes (No Auth Required)

```go
// backend/cmd/api/main.go

// Health check - no auth
e.GET("/health", healthHandler)

// API documentation - no auth (optional)
e.GET("/api/docs/*", swaggerHandler)
```

### Protected Routes (Auth Required)

```go
// Apply auth middleware to API routes
api := e.Group("/api/v1")
api.Use(AuthMiddleware(firebaseApp))

// All routes under /api/v1 require valid token
api.GET("/users/me", getUserProfile)
api.POST("/items", createItem)
api.GET("/items", listItems)
```

---

## Token Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                     TOKEN LIFECYCLE                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. User signs in → Firebase issues ID token (JWT)               │
│     └── Token valid for: 1 hour                                  │
│                                                                  │
│  2. Client stores token in memory (not persistent storage)       │
│     └── iOS: Keychain for refresh token only                    │
│     └── Android: EncryptedSharedPreferences for refresh only    │
│                                                                  │
│  3. Before each API call, check token expiry                     │
│     └── If expired, call getIdToken(forceRefresh: true)         │
│                                                                  │
│  4. On 401 response, refresh token and retry                     │
│     └── If refresh fails, redirect to login                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Security Best Practices

### Backend

| Practice | Implementation |
|----------|---------------|
| **Always validate tokens** | Use Firebase Admin SDK, never parse JWT manually |
| **Check token expiry** | Admin SDK does this automatically |
| **Log auth failures** | For security monitoring |
| **Rate limit auth endpoints** | Prevent brute force |

### Mobile Clients

| Practice | Implementation |
|----------|---------------|
| **Never store ID tokens persistently** | Keep in memory only |
| **Use secure storage for refresh** | iOS Keychain, Android EncryptedSharedPreferences |
| **Handle 401 gracefully** | Redirect to login, clear local state |
| **Implement token refresh** | Before expiry, not after |

---

## Firebase Setup Required

### Firebase Console Configuration

1. **Enable Authentication Providers**
   ```
   Firebase Console → Authentication → Sign-in method
   - Enable Email/Password
   - Enable Google Sign-In
   - Enable Apple Sign-In (required for iOS apps)
   ```

2. **Get Firebase Config**
   ```
   Firebase Console → Project Settings → Your Apps
   - iOS: Download GoogleService-Info.plist
   - Android: Download google-services.json
   ```

3. **Set Up Firebase Admin SDK**
   ```bash
   # Create service account key
   Firebase Console → Project Settings → Service Accounts
   → Generate New Private Key

   # Store as secret in GCP
   gcloud secrets create firebase-admin-key \
     --data-file=service-account-key.json
   ```

---

## Environment Variables

| Variable | Description | Where |
|----------|-------------|-------|
| `FIREBASE_PROJECT_ID` | Firebase project ID | Cloud Run env |
| `FIREBASE_ADMIN_KEY` | Path to admin SDK key | Secret Manager |
| `AUTH_ENABLED` | Enable/disable auth (dev) | Cloud Run env |

---

## Testing Authentication

### Local Development

```bash
# Disable auth for local testing
AUTH_ENABLED=false make run

# Or use a test token
curl -H "Authorization: Bearer <test-token>" http://localhost:8080/api/v1/users/me
```

### Integration Tests

```go
func TestProtectedEndpoint(t *testing.T) {
    // Create test user in Firebase emulator
    // Get valid token
    // Make request with token
    // Assert 200 OK
}

func TestProtectedEndpointNoAuth(t *testing.T) {
    // Make request without token
    // Assert 401 Unauthorized
}
```

---

## When to Use GCP API Gateway Instead

Consider adding GCP API Gateway if you need:

| Feature | API Gateway | Backend Middleware |
|---------|-------------|-------------------|
| **Rate limiting** | Built-in | Implement yourself |
| **API key management** | Built-in | Implement yourself |
| **Multiple backends** | Yes | N/A |
| **OAuth2 flows** | Built-in | Use Firebase |
| **Cost** | Per-request pricing | Included in Cloud Run |

For most startups, backend middleware is sufficient and simpler.

---

## Related Documentation

- [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Firebase setup steps
- [ARCHITECTURE.md](ARCHITECTURE.md) - Why Firebase Auth
- [Backend README](../backend/README.md) - API implementation

---

*Last updated: 2026-01-02*
