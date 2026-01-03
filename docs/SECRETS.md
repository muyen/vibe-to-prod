# Secrets Management

> **Audience**: Developers and AI assistants managing sensitive configuration.

This guide covers how to securely manage secrets in production using Google Secret Manager.

---

## Overview

```
┌────────────────────────────────────────────────────────────────────────────┐
│                         SECRETS ARCHITECTURE                                │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Development (Local)           Production (Cloud Run)                     │
│   ──────────────────           ─────────────────────                       │
│                                                                             │
│   ┌─────────────────┐          ┌─────────────────────────────────────┐    │
│   │    .env.local   │          │        Google Secret Manager         │    │
│   │                 │          │                                       │    │
│   │  DATABASE_URL=  │          │  ┌─────────────┐  ┌─────────────┐   │    │
│   │  API_KEY=       │          │  │ database-url│  │   api-key   │   │    │
│   │  STRIPE_KEY=    │          │  └─────────────┘  └─────────────┘   │    │
│   └────────┬────────┘          └──────────┬────────────────────────────┘   │
│            │                               │                               │
│            │ os.Getenv()                   │ Secret Manager Client         │
│            ▼                               ▼                               │
│   ┌─────────────────────────────────────────────────────────────────┐     │
│   │                        Backend API                               │     │
│   │                                                                  │     │
│   │  func getSecret(name string) string { ... }                     │     │
│   └─────────────────────────────────────────────────────────────────┘     │
│                                                                             │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Quick Reference

| Environment | Where to Store Secrets | How to Access |
|------------|------------------------|---------------|
| Local Dev | `.env.local` (gitignored) | `os.Getenv()` |
| CI/CD | GitHub Actions Secrets | `${{ secrets.X }}` |
| Production | Google Secret Manager | SDK or mount as env var |

---

## Google Secret Manager Setup

### 1. Enable the API

The infrastructure already enables this, but if you need to do it manually:

```bash
gcloud services enable secretmanager.googleapis.com --project=YOUR_PROJECT_ID
```

### 2. Create a Secret

```bash
# Create a secret
echo -n "your-secret-value" | gcloud secrets create my-secret \
  --data-file=- \
  --project=YOUR_PROJECT_ID

# Or from a file
gcloud secrets create my-secret \
  --data-file=./path/to/secret.txt \
  --project=YOUR_PROJECT_ID
```

### 3. Add a New Version

```bash
echo -n "new-secret-value" | gcloud secrets versions add my-secret \
  --data-file=- \
  --project=YOUR_PROJECT_ID
```

### 4. Access a Secret (CLI)

```bash
# Get latest version
gcloud secrets versions access latest --secret=my-secret --project=YOUR_PROJECT_ID

# Get specific version
gcloud secrets versions access 1 --secret=my-secret --project=YOUR_PROJECT_ID
```

---

## Accessing Secrets in Go

### Option 1: Mount as Environment Variable (Recommended for Cloud Run)

In your Cloud Run service configuration:

```yaml
# In Pulumi or Terraform
env:
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: database-url
        key: latest
```

Then in Go:
```go
dbURL := os.Getenv("DATABASE_URL")
```

### Option 2: Use Secret Manager SDK

Install the SDK:
```bash
go get cloud.google.com/go/secretmanager/apiv1
```

Access secrets programmatically:

```go
package secrets

import (
    "context"
    "fmt"

    secretmanager "cloud.google.com/go/secretmanager/apiv1"
    "cloud.google.com/go/secretmanager/apiv1/secretmanagerpb"
)

// Client wraps the Secret Manager client
type Client struct {
    client    *secretmanager.Client
    projectID string
}

// New creates a new Secret Manager client
func New(ctx context.Context, projectID string) (*Client, error) {
    client, err := secretmanager.NewClient(ctx)
    if err != nil {
        return nil, fmt.Errorf("failed to create secret manager client: %w", err)
    }
    return &Client{client: client, projectID: projectID}, nil
}

// Get retrieves the latest version of a secret
func (c *Client) Get(ctx context.Context, secretName string) (string, error) {
    name := fmt.Sprintf("projects/%s/secrets/%s/versions/latest", c.projectID, secretName)

    result, err := c.client.AccessSecretVersion(ctx, &secretmanagerpb.AccessSecretVersionRequest{
        Name: name,
    })
    if err != nil {
        return "", fmt.Errorf("failed to access secret %s: %w", secretName, err)
    }

    return string(result.Payload.Data), nil
}

// Close closes the client connection
func (c *Client) Close() error {
    return c.client.Close()
}
```

Usage:

```go
func main() {
    ctx := context.Background()
    projectID := os.Getenv("GCP_PROJECT")

    secretClient, err := secrets.New(ctx, projectID)
    if err != nil {
        log.Fatal(err)
    }
    defer secretClient.Close()

    dbURL, err := secretClient.Get(ctx, "database-url")
    if err != nil {
        log.Fatal(err)
    }

    // Use dbURL...
}
```

---

## Common Secrets to Store

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `database-url` | Database connection string | `postgres://user:pass@host/db` |
| `firebase-admin-key` | Firebase Admin SDK JSON | `{"type": "service_account"...}` |
| `stripe-secret-key` | Stripe API key | `sk_live_xxx` |
| `sendgrid-api-key` | Email service API key | `SG.xxx` |
| `jwt-signing-key` | JWT signing secret | Random 256-bit key |

---

## Cloud Run Integration

### Via Pulumi

Update `infrastructure/pulumi/main.go`:

```go
// Create the secret
secret, err := secretmanager.NewSecret(ctx, "database-url", &secretmanager.SecretArgs{
    SecretId: pulumi.String("database-url"),
    Project:  pulumi.String(projectID),
    Replication: &secretmanager.SecretReplicationArgs{
        Automatic: &secretmanager.SecretReplicationAutomaticArgs{},
    },
})

// Add a version
_, err = secretmanager.NewSecretVersion(ctx, "database-url-v1", &secretmanager.SecretVersionArgs{
    Secret:     secret.ID(),
    SecretData: pulumi.String("postgres://user:pass@host/db"),
})

// Reference in Cloud Run
cloudRunService, err := cloudrun.NewService(ctx, "api-service", &cloudrun.ServiceArgs{
    // ... other config ...
    Template: &cloudrun.ServiceTemplateArgs{
        Spec: &cloudrun.ServiceTemplateSpecArgs{
            Containers: cloudrun.ServiceTemplateSpecContainerArray{
                &cloudrun.ServiceTemplateSpecContainerArgs{
                    Envs: cloudrun.ServiceTemplateSpecContainerEnvArray{
                        &cloudrun.ServiceTemplateSpecContainerEnvArgs{
                            Name: pulumi.String("DATABASE_URL"),
                            ValueFrom: &cloudrun.ServiceTemplateSpecContainerEnvValueFromArgs{
                                SecretKeyRef: &cloudrun.ServiceTemplateSpecContainerEnvValueFromSecretKeyRefArgs{
                                    Name: pulumi.String("database-url"),
                                    Key:  pulumi.String("latest"),
                                },
                            },
                        },
                    },
                },
            },
        },
    },
})
```

### Via gcloud

```bash
gcloud run services update api-service \
  --update-secrets=DATABASE_URL=database-url:latest \
  --project=YOUR_PROJECT_ID \
  --region=us-central1
```

---

## Best Practices

### Do

- Store all production secrets in Secret Manager
- Use descriptive secret names (e.g., `stripe-secret-key`, not `key1`)
- Enable secret rotation for critical secrets
- Grant minimal permissions (use specific secrets, not wildcard)
- Version secrets for rollback capability

### Don't

- Never commit secrets to git (even in `.env`)
- Never log secret values
- Never include secrets in error messages
- Never hardcode secrets in code
- Never share secrets via Slack/email

---

## Secret Rotation

For automatic rotation, use Secret Manager's rotation feature:

```bash
# Set up automatic rotation (30 days)
gcloud secrets update my-secret \
  --rotation-period=2592000s \
  --next-rotation-time="2024-12-31T00:00:00Z" \
  --project=YOUR_PROJECT_ID
```

---

## Troubleshooting

### Error: Permission Denied

```
Error accessing secret: rpc error: code = PermissionDenied
```

**Fix:** Ensure the service account has the `roles/secretmanager.secretAccessor` role:

```bash
gcloud secrets add-iam-policy-binding my-secret \
  --member="serviceAccount:your-sa@project.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor" \
  --project=YOUR_PROJECT_ID
```

### Error: Secret Not Found

```
Error accessing secret: rpc error: code = NotFound
```

**Fix:** Check the secret name and project:

```bash
gcloud secrets list --project=YOUR_PROJECT_ID
```

### Local Development

For local development, don't connect to Secret Manager. Use environment variables:

```go
func getSecret(name string) string {
    // In development, use env vars
    if os.Getenv("ENV") != "production" {
        return os.Getenv(name)
    }

    // In production, use Secret Manager
    return secretClient.Get(context.Background(), name)
}
```

---

## Related Documentation

- [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Initial project setup
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture overview
- [CICD.md](CICD.md) - GitHub Actions secrets

---

*Last updated: 2026-01-03*
