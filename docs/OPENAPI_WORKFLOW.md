# OpenAPI Workflow

> **Audience**: Developers and AI assistants working with the API-first development approach.

This document explains why we use an OpenAPI workflow and how it solves real-world problems.

---

## The Problem

Managing APIs across multiple platforms is hard:

```
Traditional Approach:
Backend → "I changed the /users response"
iOS Dev → "What changed? Let me update the Swift structs..."
Android Dev → "Wait, which fields? Let me update Kotlin data classes..."
Web Dev → "What's the new shape? I'll update TypeScript interfaces..."

Results:
- Mismatched types between platforms
- Runtime crashes from unexpected responses
- Manual sync work on every API change
- No single source of truth
```

---

## Why OpenAPI Workflow?

### 1. Single Source of Truth

```yaml
# backend/api/openapi.yaml - THE source of truth
paths:
  /users/{id}:
    get:
      responses:
        200:
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      required: [id, email]
      properties:
        id:
          type: string
        email:
          type: string
        name:
          type: string
```

### 2. Generated Type-Safe Clients

From this single spec, we generate:

```
openapi.yaml
    ↓
┌───────────────────────────────────────────────────────────┐
│                   Code Generation                          │
├─────────────────┬─────────────────┬───────────────────────┤
│ Go (Backend)    │ Swift (iOS)     │ Kotlin (Android)      │
│ oapi-codegen    │ openapi-gen     │ openapi-gen           │
├─────────────────┼─────────────────┼───────────────────────┤
│ type User struct│ struct User:    │ data class User(      │
│   ID    string  │   let id: String│   val id: String,     │
│   Email string  │   let email: ... │   val email: String,  │
│   Name  *string │   let name: ... │   val name: String?   │
│ }               │ }               │ )                      │
└─────────────────┴─────────────────┴───────────────────────┘
```

All platforms stay in sync automatically.

---

## Real-World Challenges Solved

### Challenge 1: Google Cloud API Gateway Requires OpenAPI v2

Google Cloud API Gateway only accepts **OpenAPI v2 (Swagger 2.0)** for configuration:

```
openapi.yaml (v3)     →  converter  →  openapi-v2.yaml  →  API Gateway
(development spec)                    (Swagger 2.0)        (GCP config)
```

The workflow handles this conversion automatically.

### Challenge 2: Microservices Need Merged Specs

Real backends often have multiple services:

```
services/
├── users-service/
│   └── api/openapi.yaml     # /users endpoints
├── orders-service/
│   └── api/openapi.yaml     # /orders endpoints
└── payments-service/
    └── api/openapi.yaml     # /payments endpoints

              ↓ merge ↓

backend/api/openapi-bundled.yaml   # Combined spec for clients
```

The workflow can merge multiple specs into one for client generation.

### Challenge 3: Build Verification

Code generation isn't enough - we need to verify:

```
OpenAPI Change
    ↓
Generate Code (Go, Swift, Kotlin)
    ↓
Build All Platforms
    ↓
Run Tests
    ↓
✓ Safe to commit
```

If any platform fails to build, the API change broke something.

---

## The Workflow

### Full Workflow (Recommended)

```bash
python scripts/openapi_workflow.py --full

# Steps:
# 1. Validate OpenAPI spec
# 2. Generate Go backend types
# 3. Generate iOS Swift client
# 4. Generate Android Kotlin client
# 5. Build backend (go build + go test)
# 6. Build iOS (xcodebuild)
# 7. Build Android (./gradlew)
```

### Partial Workflows

```bash
# Just validate the spec
python scripts/openapi_workflow.py --validate

# Generate code only (no build)
python scripts/openapi_workflow.py --codegen

# Build only (no generation)
python scripts/openapi_workflow.py --build

# Skip specific platforms
python scripts/openapi_workflow.py --full --skip-ios
python scripts/openapi_workflow.py --full --skip-android
```

---

## Workflow Diagram

```
┌────────────────────────────────────────────────────────────────────────┐
│                         OpenAPI Workflow                                │
├────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   ┌─────────────────┐                                                  │
│   │   Edit Spec     │  backend/api/openapi.yaml                        │
│   │  (Developer/AI) │                                                  │
│   └────────┬────────┘                                                  │
│            ↓                                                            │
│   ┌─────────────────┐                                                  │
│   │   Validate      │  swagger validate / redocly lint                 │
│   └────────┬────────┘                                                  │
│            ↓                                                            │
│   ┌─────────────────────────────────────────────────────────────┐      │
│   │                     Code Generation                          │      │
│   │  ┌──────────┐    ┌──────────┐    ┌──────────┐              │      │
│   │  │  Go      │    │  Swift   │    │  Kotlin  │              │      │
│   │  │ (oapi-   │    │ (openapi-│    │ (openapi-│              │      │
│   │  │ codegen) │    │ generator)│    │ generator)│              │      │
│   │  └──────────┘    └──────────┘    └──────────┘              │      │
│   └─────────────────────────────────────────────────────────────┘      │
│            ↓                                                            │
│   ┌─────────────────────────────────────────────────────────────┐      │
│   │                     Build Verification                       │      │
│   │  ┌──────────┐    ┌──────────┐    ┌──────────┐              │      │
│   │  │ go build │    │ xcodebuild│    │ gradlew  │              │      │
│   │  │ go test  │    │           │    │ build    │              │      │
│   │  └──────────┘    └──────────┘    └──────────┘              │      │
│   └─────────────────────────────────────────────────────────────┘      │
│            ↓                                                            │
│   ┌─────────────────┐                                                  │
│   │  ✓ Safe to      │  All platforms verified                         │
│   │    Commit       │                                                  │
│   └─────────────────┘                                                  │
│                                                                         │
└────────────────────────────────────────────────────────────────────────┘
```

---

## When to Run the Workflow

| Scenario | Command |
|----------|---------|
| Changed `openapi.yaml` | `python scripts/openapi_workflow.py --full` |
| Quick validation | `python scripts/openapi_workflow.py --validate` |
| Backend-only changes | `python scripts/openapi_workflow.py --full --skip-ios --skip-android` |
| Before PR merge | `python scripts/openapi_workflow.py --full` |

---

## Automatic Triggers

The workflow can be triggered automatically:

### Pre-commit Hook

```bash
# .git/hooks/pre-commit (already configured)
# Runs validation on openapi.yaml changes
```

### CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
# Runs full workflow on PRs that touch openapi.yaml
```

---

## Adding a New Endpoint

Example: Adding a `POST /users` endpoint

1. **Edit the spec**
   ```yaml
   # backend/api/openapi.yaml
   paths:
     /users:
       post:
         operationId: createUser
         requestBody:
           content:
             application/json:
               schema:
                 $ref: '#/components/schemas/CreateUserRequest'
         responses:
           201:
             content:
               application/json:
                 schema:
                   $ref: '#/components/schemas/User'
   ```

2. **Run the workflow**
   ```bash
   python scripts/openapi_workflow.py --full
   ```

3. **Implement the handler**
   ```go
   // backend/internal/handlers/user.go
   func (h *Handler) CreateUser(c echo.Context) error {
       var req CreateUserRequest  // Generated type!
       // ...
   }
   ```

4. **Use in mobile apps**
   ```swift
   // iOS - uses generated client
   let user = try await api.createUser(request)
   ```
   ```kotlin
   // Android - uses generated client
   val user = api.createUser(request)
   ```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `swagger: command not found` | `npm install -g @apidevtools/swagger-cli` |
| `oapi-codegen: command not found` | `go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest` |
| iOS generation fails | Create `mobile/ios/scripts/generate-api.sh` |
| Android generation fails | Add openapi-generator Gradle plugin |
| Build fails after generation | Check for breaking API changes |

---

## Tools Used

| Tool | Purpose | Install |
|------|---------|---------|
| **swagger-cli** | Validate OpenAPI spec | `npm install -g @apidevtools/swagger-cli` |
| **redocly** | Alternative validator + docs | `npm install -g @redocly/cli` |
| **oapi-codegen** | Go server/types generation | `go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest` |
| **openapi-generator** | Multi-language client generation | `brew install openapi-generator` |

---

## Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Why OpenAPI is part of the stack
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues
- [GETTING_STARTED.md](GETTING_STARTED.md) - Initial setup

---

*Last updated: 2026-01-03*
