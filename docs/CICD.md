# CI/CD Pipeline Documentation

> **Audience**: AI assistants and developers setting up continuous integration and deployment.

This document explains the GitHub Actions workflows included in this template.

---

## Overview

```
┌────────────────────────────────────────────────────────────────────────┐
│                          GITHUB ACTIONS                                 │
├────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  On Push/PR to main:                                                    │
│                                                                         │
│  ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐      │
│  │   Backend CI    │   │     iOS CI      │   │   Android CI    │      │
│  │                 │   │                 │   │                 │      │
│  │  • Go fmt check │   │  • XcodeGen     │   │  • Gradle check │      │
│  │  • Go build     │   │  • Build        │   │  • Lint         │      │
│  │  • Go test      │   │  • Test         │   │  • Test         │      │
│  │  • Docker build │   │                 │   │                 │      │
│  └────────┬────────┘   └─────────────────┘   └─────────────────┘      │
│           │                                                             │
│           │ on main                                                     │
│           ▼                                                             │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    Deploy to Cloud Run                           │   │
│  │                                                                   │   │
│  │  1. Auth via Workload Identity Federation (no keys!)             │   │
│  │  2. Build Docker image                                           │   │
│  │  3. Push to Artifact Registry                                    │   │
│  │  4. Deploy to Cloud Run                                          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Weekly:                                                                │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                      Security Scanning                           │   │
│  │                                                                   │   │
│  │  • gosec (Go security linter)                                    │   │
│  │  • govulncheck (vulnerability scanner)                           │   │
│  │  • CodeQL (GitHub's semantic analysis)                           │   │
│  │  • Trivy (container scanning)                                    │   │
│  │  • Dependency Review (PR dependencies)                           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└────────────────────────────────────────────────────────────────────────┘
```

---

## Workflow Files

| File | Trigger | Purpose |
|------|---------|---------|
| `backend-ci.yml` | Push/PR on `backend/**` | Build, test, lint Go code |
| `ios-ci.yml` | Push/PR on `mobile/ios/**` | Build, test iOS app |
| `android-ci.yml` | Push/PR on `mobile/android/**` | Build, test Android app |
| `deploy-cloudrun.yml` | Push to main, manual | Deploy backend to Cloud Run |
| `security.yml` | Push to main, weekly | Security scanning |

---

## Backend CI (`backend-ci.yml`)

**Triggers:** Push or PR to `backend/**`

```yaml
jobs:
  test:
    - Format check (gofmt)
    - Build (go build)
    - Test (go test)

  docker:
    - Build Docker image (only on main)
```

**What It Validates:**
- Code is properly formatted
- Code compiles
- All tests pass
- Docker image builds successfully

---

## iOS CI (`ios-ci.yml`)

**Triggers:** Push or PR to `mobile/ios/**`

```yaml
jobs:
  build:
    runs-on: macos-14
    steps:
      - Install XcodeGen
      - Generate Xcode project
      - Build for simulator
      - Run tests
```

**Important Notes:**
- Uses `macos-14` runner (Apple Silicon)
- `CODE_SIGNING_ALLOWED=NO` for CI builds
- Tests run on iPhone 15 simulator

---

## Android CI (`android-ci.yml`)

**Triggers:** Push or PR to `mobile/android/**`

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - Setup JDK 17
      - Run Gradle lint
      - Build debug APK
      - Run unit tests
```

---

## Deploy to Cloud Run (`deploy-cloudrun.yml`)

**Triggers:**
- Push to main (auto-deploy to dev)
- Manual dispatch (choose environment)

### Authentication: Workload Identity Federation

**No service account keys stored in GitHub!**

Instead, we use Workload Identity Federation (WIF):

```
GitHub Actions                    Google Cloud
     │                                 │
     │  1. "I am github/org/repo"      │
     └────────────────────────────────▶│
                                       │
     │  2. "Here's a short-lived token"│
     │◀────────────────────────────────┘
     │
     │  3. Uses token for gcloud/docker
     ▼
┌─────────────────────────────────────────┐
│  Artifact Registry, Cloud Run, etc.     │
└─────────────────────────────────────────┘
```

**Required Secrets:**

| Secret | Description |
|--------|-------------|
| `GCP_PROJECT_ID` | Your GCP project ID |
| `WIF_PROVIDER` | Workload Identity Provider path |
| `WIF_SERVICE_ACCOUNT` | Service account email |

### Deployment Flow

```yaml
steps:
  1. Authenticate to GCP (via WIF)
  2. Configure Docker for Artifact Registry
  3. Build Docker image
  4. Push to Artifact Registry
  5. Deploy to Cloud Run
  6. Output service URL
```

---

## Security Scanning (`security.yml`)

**Triggers:**
- Push to main
- Pull requests to main
- Weekly schedule (Sunday midnight)

### Scans Included

| Tool | What It Checks |
|------|----------------|
| **gosec** | Go security issues (SQL injection, crypto, etc.) |
| **govulncheck** | Known vulnerabilities in Go dependencies |
| **CodeQL** | Semantic code analysis |
| **Trivy** | Container image vulnerabilities |
| **Dependency Review** | PR dependency changes |

### SARIF Integration

Results upload to GitHub Security tab:

```yaml
- name: Upload SARIF file
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: results.sarif
```

View results in: **Repository → Security → Code scanning alerts**

---

## Setting Up CI/CD

### Step 1: Enable GitHub Actions

1. Go to repository **Settings → Actions → General**
2. Allow all actions (or restrict as needed)
3. Set workflow permissions to "Read and write"

### Step 2: Configure Secrets

Go to **Settings → Secrets and variables → Actions**

**Required for deployment:**

```bash
# GCP Project ID
GCP_PROJECT_ID=your-project-id

# Workload Identity Federation
WIF_PROVIDER=projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL/providers/PROVIDER
WIF_SERVICE_ACCOUNT=github-actions@your-project.iam.gserviceaccount.com
```

### Step 3: Set Up Workload Identity Federation

```bash
# 1. Create workload identity pool
gcloud iam workload-identity-pools create "github-pool" \
  --location="global" \
  --description="GitHub Actions pool"

# 2. Create provider
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='YOUR_ORG/YOUR_REPO'"

# 3. Create service account
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions"

# 4. Grant permissions
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

# 5. Allow GitHub to impersonate service account
gcloud iam service-accounts add-iam-policy-binding \
  github-actions@PROJECT_ID.iam.gserviceaccount.com \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/YOUR_ORG/YOUR_REPO"
```

### Step 4: Verify Setup

```bash
# Trigger a workflow manually
gh workflow run deploy-cloudrun.yml -f environment=dev

# Check workflow status
gh run list
```

---

## Environment Strategy

| Environment | Trigger | Branch | URL Pattern |
|-------------|---------|--------|-------------|
| **dev** | Auto on push | main | `api-dev.example.com` |
| **prod** | Manual dispatch | main | `api.example.com` |

### Manual Production Deploy

```bash
# Via GitHub CLI
gh workflow run deploy-cloudrun.yml -f environment=prod

# Or via GitHub UI
# Actions → Deploy to Cloud Run → Run workflow → Choose "prod"
```

---

## Troubleshooting

### Build Failures

| Error | Cause | Fix |
|-------|-------|-----|
| `gofmt: differences` | Code not formatted | Run `go fmt ./...` |
| `go build: failed` | Compilation error | Fix syntax/imports |
| `xcodebuild: error` | Missing files | Check XcodeGen config |

### Deployment Failures

| Error | Cause | Fix |
|-------|-------|-----|
| `Permission denied` | WIF misconfigured | Check service account roles |
| `Image not found` | Push failed | Check Artifact Registry access |
| `Service unavailable` | Bad container | Check Docker image locally |

### Debug Tips

```yaml
# Add debug step to workflow
- name: Debug
  run: |
    echo "GitHub SHA: ${{ github.sha }}"
    echo "Branch: ${{ github.ref }}"
    gcloud auth list
    gcloud config list
```

---

## Local Testing

### Run CI Checks Locally

```bash
# Backend
cd backend
go fmt ./...
go build ./...
go test ./...

# iOS
cd mobile/ios
xcodegen generate
xcodebuild build -scheme App -sdk iphonesimulator

# Android
cd mobile/android
./gradlew lint
./gradlew testDevDebugUnitTest
```

### Test Docker Build

```bash
cd backend
docker build -t test-api .
docker run -p 8080:8080 test-api
curl http://localhost:8080/health
```

---

## App Store Distribution (Fastlane)

Fastlane is included for automated app store uploads. Configuration files are in:
- `mobile/ios/fastlane/` - iOS TestFlight and App Store
- `mobile/android/fastlane/` - Android Play Store

### Quick Start

```bash
# iOS
cd mobile/ios
bundle install
make fastlane-beta    # Upload to TestFlight

# Android
cd mobile/android
bundle install
make fastlane-beta    # Upload to Play Store beta
```

### Required Setup

| Platform | Requirements |
|----------|-------------|
| **iOS** | Apple Developer account, App Store Connect API key, code signing |
| **Android** | Google Play Developer account, Play Store API key JSON |

### iOS Configuration

Edit `mobile/ios/fastlane/Appfile`:

```ruby
team_id("YOUR_TEAM_ID")
app_identifier("com.yourcompany.app")
apple_id("your-email@example.com")
```

### Android Configuration

Edit `mobile/android/fastlane/Appfile`:

```ruby
package_name("com.yourcompany.app")
json_key_file("path/to/play-store-key.json")
```

### CI/CD Integration

To add automated releases, create these workflows:

**`.github/workflows/ios-release.yml`:**
```yaml
name: iOS Release
on:
  push:
    tags: ['v*']
jobs:
  release:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: cd mobile/ios && bundle install
      - name: Deploy to TestFlight
        run: cd mobile/ios && bundle exec fastlane beta
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_KEY }}
```

**`.github/workflows/android-release.yml`:**
```yaml
name: Android Release
on:
  push:
    tags: ['v*']
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Install dependencies
        run: cd mobile/android && bundle install
      - name: Deploy to Play Store
        run: cd mobile/android && bundle exec fastlane beta
        env:
          GOOGLE_PLAY_KEY_FILE: ${{ secrets.GOOGLE_PLAY_KEY }}
```

---

## Related Documentation

- [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - All secrets needed
- [ARCHITECTURE.md](ARCHITECTURE.md) - Why these technologies
- [API_GATEWAY.md](API_GATEWAY.md) - Auth architecture

---

*Last updated: 2026-01-02*
