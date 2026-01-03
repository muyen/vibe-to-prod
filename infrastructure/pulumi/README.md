# Infrastructure Documentation

This directory contains Pulumi infrastructure-as-code for the vibe-to-prod project.

## Overview

Infrastructure is managed using **Pulumi with Go**, providing:
- Type-safe infrastructure definitions
- AI-friendly code (Go is well understood by AI assistants)
- Reproducible deployments
- State management

## Directory Structure

```
infrastructure/pulumi/
├── main.go           # Entry point, stack configuration
├── go.mod            # Go dependencies
├── go.sum
├── Pulumi.yaml       # Project configuration
├── Pulumi.dev.yaml   # Development stack config
└── Pulumi.prod.yaml  # Production stack config
```

## Resources Provisioned

### Google Cloud Platform

| Resource | Purpose |
|----------|---------|
| Cloud Run | Backend API hosting |
| Artifact Registry | Container image storage |
| Secret Manager | Secrets management |
| Cloud Build | CI/CD builds |
| Firebase | Auth, Firestore, Storage |

### Firebase

| Resource | Purpose |
|----------|---------|
| Firebase Project | App platform |
| Firestore | NoSQL database |
| Firebase Auth | User authentication |
| Firebase Storage | File storage |
| Firebase Hosting | Web hosting |

## Prerequisites

1. **Pulumi CLI**: Install from https://www.pulumi.com/docs/install/
2. **Go 1.24+**: Required for Pulumi Go SDK
3. **GCP Account**: With billing enabled
4. **gcloud CLI**: Authenticated with your account

## Quick Start

### Initialize

```bash
cd infrastructure/pulumi

# Login to Pulumi (use local backend for simplicity)
pulumi login --local

# Install dependencies
go mod download
```

### Deploy Development

```bash
# Select development stack
pulumi stack select dev

# Preview changes
pulumi preview

# Deploy
pulumi up
```

### Deploy Production

```bash
# Select production stack
pulumi stack select prod

# Preview changes (always preview first!)
pulumi preview

# Deploy with confirmation
pulumi up
```

## Stack Configuration

### Development (`Pulumi.dev.yaml`)

```yaml
config:
  gcp:project: your-project-dev
  gcp:region: us-central1
  app:environment: development
  app:min-instances: 0  # Scale to zero
  app:max-instances: 2
```

### Production (`Pulumi.prod.yaml`)

```yaml
config:
  gcp:project: your-project-prod
  gcp:region: us-central1
  app:environment: production
  app:min-instances: 1  # Always running
  app:max-instances: 10
```

## Common Operations

### View Current State

```bash
pulumi stack
```

### View Outputs

```bash
pulumi stack output
```

### Destroy Resources

```bash
# ⚠️ DANGER: This destroys all resources
pulumi destroy
```

### Import Existing Resources

```bash
pulumi import gcp:cloudrun/service:Service myservice projects/my-project/locations/us-central1/services/my-service
```

## Resource Patterns

### Cloud Run Service

```go
service, err := cloudrun.NewService(ctx, "api", &cloudrun.ServiceArgs{
    Location: pulumi.String("us-central1"),
    Template: &cloudrun.ServiceTemplateArgs{
        Spec: &cloudrun.ServiceTemplateSpecArgs{
            Containers: cloudrun.ServiceTemplateSpecContainerArray{
                &cloudrun.ServiceTemplateSpecContainerArgs{
                    Image: pulumi.String(imageUrl),
                    Ports: cloudrun.ServiceTemplateSpecContainerPortArray{
                        &cloudrun.ServiceTemplateSpecContainerPortArgs{
                            ContainerPort: pulumi.Int(8080),
                        },
                    },
                },
            },
        },
    },
})
```

### Secret Manager

```go
secret, err := secretmanager.NewSecret(ctx, "api-key", &secretmanager.SecretArgs{
    SecretId: pulumi.String("api-key"),
    Replication: &secretmanager.SecretReplicationArgs{
        Automatic: pulumi.Bool(true),
    },
})
```

## Secrets Management

**Never commit secrets to code.** Use:

1. **Pulumi Config Secrets**:
   ```bash
   pulumi config set --secret database-password "supersecret"
   ```

2. **Google Secret Manager** (recommended for runtime):
   - Create secrets in Secret Manager
   - Reference in Cloud Run as environment variables

## Troubleshooting

### "Resource already exists"

The resource exists but isn't in Pulumi state. Import it:
```bash
pulumi import <resource-type> <name> <id>
```

### "Permission denied"

Check IAM permissions for your GCP service account.

### "Quota exceeded"

Request quota increase in GCP Console.

## Best Practices

1. **Always preview before deploying**: `pulumi preview`
2. **Use stack references** for cross-stack dependencies
3. **Tag resources** for cost allocation
4. **Enable deletion protection** for production databases
5. **Use separate projects** for dev/staging/prod

## References

- [Pulumi GCP Provider](https://www.pulumi.com/registry/packages/gcp/)
- [Pulumi Go SDK](https://www.pulumi.com/docs/languages-sdks/go/)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
