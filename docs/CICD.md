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
| `deploy-cloudrun.yml` | Push to main, manual | Deploy backend to Cloud Run (dev) |
| `prod-promotion.yml` | Manual only | Promote tested image to production |
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

| Tool | What It Checks | Output |
|------|----------------|--------|
| **gosec** | Go security issues (SQL injection, crypto, etc.) | Console |
| **govulncheck** | Known vulnerabilities in Go dependencies | Console |
| **Trivy** | Container image vulnerabilities | Table (fails on CRITICAL/HIGH) |
| **Dependency Review** | PR dependency changes | PR comments |

### Private Repo Compatibility

This workflow is optimized for **private repositories**:
- Uses console/table output instead of SARIF uploads
- CodeQL removed (requires GitHub Advanced Security for private repos)
- No GitHub Security tab integration needed

### Enabling CodeQL (Public Repos or Enterprise)

If you have GitHub Advanced Security or a public repo, enable CodeQL:

1. Uncomment the CodeQL job in `.github/workflows/security.yml`
2. Enable "Code scanning" in repository settings
3. View results in **Repository → Security → Code scanning alerts**

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

## Production Promotion (`prod-promotion.yml`)

**Trigger:** Manual only (workflow_dispatch)

**Pattern:** Build once, deploy anywhere. The same Docker image tested in dev is promoted to production.

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Backend CI    │    │  Dev Deployment │    │ Prod Promotion  │
│  (build & test) │───▶│  (test in dev)  │───▶│ (same image!)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                       │
                              ▼                       ▼
                       Image: abc1234           Image: abc1234
                       (Artifact Registry)      (Same image)
```

### Key Features

| Feature | Description |
|---------|-------------|
| **SHA Resolution** | Auto-fetches latest SHA from dev if not provided |
| **Image Validation** | Verifies image exists before promoting |
| **Health Checks** | 5 retries with 15s intervals post-deploy |
| **Failure Notifications** | Creates GitHub issue on failure with rollback instructions |
| **Git Labels** | Tags Cloud Run revision with git-sha for traceability |

### Usage

```bash
# Promote latest dev image
gh workflow run prod-promotion.yml

# Promote specific SHA
gh workflow run prod-promotion.yml -f image_sha=abc1234

# Use self-hosted runner
gh workflow run prod-promotion.yml -f runner=self-hosted
```

### Required Secrets

| Secret | Description |
|--------|-------------|
| `WIF_PROVIDER_DEV` | Workload Identity Provider for dev project |
| `WIF_SERVICE_ACCOUNT_DEV` | Service account for dev project |
| `WIF_PROVIDER_PROD` | Workload Identity Provider for prod project |
| `WIF_SERVICE_ACCOUNT_PROD` | Service account for prod project |

### GitHub Environments

Configure approval gates in **Settings → Environments → production**:
- Required reviewers
- Wait timer
- Deployment branches (main only)

---

## Self-Hosted Runners

GitHub provides 2000 free minutes/month for private repos. This can run out quickly with active development.

### Why Use Self-Hosted Runners?

| Scenario | GitHub-Hosted | Self-Hosted |
|----------|--------------|-------------|
| **Cost** | 2000 min/mo free | Unlimited |
| **Speed** | Queue wait time | Immediate |
| **Resources** | Limited | Your hardware |
| **Privacy** | Code processed on GitHub | Code stays local |

### Quick Math

```
Backend CI: ~5 min per run
Security scan: ~8 min per run
Full deployment: ~15 min per run
─────────────────────────────────
10 pushes/day × 28 min = 280 min/day
280 min × 7 days = 1960 min (almost quota!)
```

### Toggle Script

Use the toggle script to switch between runners:

```bash
# Check current setting
./scripts/toggle-runner.sh status

# When GitHub quota runs low
./scripts/toggle-runner.sh local

# When quota resets (monthly)
./scripts/toggle-runner.sh github
```

### Setting Up a Self-Hosted Runner

#### Option 1: Local Machine

```bash
# 1. Go to: Settings → Actions → Runners → New self-hosted runner
# 2. Follow download instructions for your OS
# 3. Configure:
./config.sh --url https://github.com/YOUR_ORG/YOUR_REPO --token TOKEN

# 4. Run interactively:
./run.sh

# Or install as service (macOS):
./svc.sh install
./svc.sh start
```

#### Option 2: Cheap VPS ($5-10/month)

```bash
# On a DigitalOcean/Linode/Vultr VPS
# 1. Create Ubuntu 22.04 VM
# 2. Install Docker
# 3. Follow GitHub runner setup
# 4. Run as systemd service

# Create service file
sudo tee /etc/systemd/system/github-runner.service <<EOF
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
Type=simple
User=runner
WorkingDirectory=/home/runner/actions-runner
ExecStart=/home/runner/actions-runner/run.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable github-runner
sudo systemctl start github-runner
```

### All Workflows Support Runner Toggle

Every workflow uses this pattern:

```yaml
jobs:
  build:
    runs-on: ${{ vars.RUNNER_LABEL || 'ubuntu-latest' }}
```

The `RUNNER_LABEL` repository variable controls all workflows at once.

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
