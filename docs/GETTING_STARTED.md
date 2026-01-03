# Getting Started

> **For Human Developers** - If you're an AI assistant, read [AI_BOOTSTRAP.md](AI_BOOTSTRAP.md) instead.

Get your app running in production in under 30 minutes.

---

## Quick Start

### 1. Run Setup Script

```bash
./scripts/setup.sh
```

This interactive script will:
- Check prerequisites (gcloud, pulumi, go)
- **Configure git hooks** (pre-commit, commit-msg, pre-push)
- Configure your Google Cloud project
- Enable required APIs
- Set up Pulumi infrastructure stacks

**Quick setup without GCP** (just git hooks and dependencies):
```bash
make setup-hooks     # Configure git hooks
cd backend && make deps  # Install Go dependencies
```

### 2. Deploy Infrastructure

```bash
cd infrastructure/pulumi
make deploy-dev
```

This creates:
- Artifact Registry (for Docker images)
- Cloud Run service
- Firestore database
- Service account with proper permissions

### 3. Run Backend Locally

```bash
cd backend
make run
```

Visit http://localhost:8080/health

### 4. Open Mobile Apps

**iOS:**
```bash
cd mobile/ios
xcodegen generate
open App.xcodeproj
```

**Android:**
- Open `mobile/android` in Android Studio
- Sync Gradle and run

---

## Prerequisites

| Tool | Install | Verify |
|------|---------|--------|
| **gcloud** | [Install Guide](https://cloud.google.com/sdk/docs/install) | `gcloud version` |
| **Pulumi** | `brew install pulumi` | `pulumi version` |
| **Go 1.24+** | `brew install go` | `go version` |
| **Node.js** | `brew install node` | `node --version` |
| **Firebase CLI** | `npm install -g firebase-tools` | `firebase --version` |

---

## Project Structure

```
.
├── backend/                 # Go API server
│   ├── cmd/api/main.go     # Entry point
│   └── Makefile            # Build commands
├── mobile/
│   ├── ios/                # SwiftUI app
│   │   ├── project.yml     # XcodeGen config
│   │   └── App/           # Source files
│   └── android/            # Kotlin/Compose app
│       └── app/           # Source files
├── infrastructure/
│   └── pulumi/             # Infrastructure as Code
│       ├── main.go        # Pulumi program
│       └── Makefile       # Deploy commands
├── scripts/
│   ├── setup.sh           # Initial setup
│   └── openapi_workflow.py # API code generation
└── docs/
    ├── ARCHITECTURE.md    # Technology decisions
    └── GETTING_STARTED.md # This file
```

---

## Development Workflow

### API-First Development

1. **Edit API spec**: `backend/api/openapi.yaml`
2. **Regenerate code**: `python scripts/openapi_workflow.py --full`
3. **Implement handlers**: Backend handlers are regenerated
4. **Build clients**: iOS and Android clients are regenerated

### Making Changes

```bash
# Backend changes
cd backend && make test && make run

# iOS changes
cd mobile/ios && xcodegen generate
# Open Xcode, build and run

# Android changes
cd mobile/android && ./gradlew build
# Run in Android Studio
```

### Deploying

```bash
# Deploy to development
cd infrastructure/pulumi
make deploy-dev

# Deploy to production (requires confirmation)
make deploy-prod
```

---

## Environment Configuration

### Development Stack (`Pulumi.dev.yaml`)
```yaml
config:
  gcp:region: us-central1
  gcp:project: YOUR_DEV_PROJECT
  app-infrastructure:environment: dev
```

### Production Stack (`Pulumi.prod.yaml`)
```yaml
config:
  gcp:region: us-central1
  gcp:project: YOUR_PROD_PROJECT
  app-infrastructure:environment: prod
```

---

## Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Add Firebase to your GCP project
3. Enable services:
   - **Firestore** (Native mode, us-central1)
   - **Authentication** (Email, Google, Apple Sign-In)
   - **Storage** (for file uploads)

4. Download config files:
   - iOS: `GoogleService-Info.plist`
   - Android: `google-services.json`

---

## Troubleshooting

### "Permission denied" on setup.sh
```bash
chmod +x scripts/setup.sh
```

### Pulumi state issues
```bash
cd infrastructure/pulumi
pulumi cancel --yes
pulumi refresh --stack dev --yes
```

### Backend won't start
```bash
cd backend
go mod tidy
make run
```

### iOS build fails
```bash
cd mobile/ios
rm -rf App.xcodeproj
xcodegen generate
```

---

## Next Steps

1. **Customize the API**: Edit `backend/api/openapi.yaml`
2. **Add authentication**: See Firebase Auth docs
3. **Set up CI/CD**: `.github/workflows/` is pre-configured
4. **Read architecture**: `docs/ARCHITECTURE.md`

---

*Need help? Check the [Troubleshooting](#troubleshooting) section or open an issue.*
