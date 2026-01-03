# Setup Checklist

Everything you need to set up before going to production.

Use this as a checklist. You can also ask Claude to help you with each step:
> "Help me complete step 2.1 - create a GCP project"

---

## 1. Local Development Tools

Install these on your machine:

| Tool | Install Command | Verify |
|------|-----------------|--------|
| Go 1.21+ | `brew install go` | `go version` |
| Node.js | `brew install node` | `node --version` |
| gcloud CLI | [Install Guide](https://cloud.google.com/sdk/docs/install) | `gcloud version` |
| Pulumi | `brew install pulumi` | `pulumi version` |
| Firebase CLI | `npm install -g firebase-tools` | `firebase --version` |
| XcodeGen | `brew install xcodegen` | `xcodegen --version` |
| Claude Code | `npm install -g @anthropic-ai/claude-code` | `claude --version` |

**For iOS development:**
- [ ] Xcode 15+ (from App Store)
- [ ] Apple Developer account (for device testing)

**For Android development:**
- [ ] Android Studio
- [ ] Android SDK (installed via Android Studio)

---

## 2. Google Cloud Platform

### 2.1 Create GCP Projects

You need at least one project. Recommended: separate dev and prod.

```bash
# Development project
gcloud projects create YOUR-APP-dev --name="Your App Dev"

# Production project (optional but recommended)
gcloud projects create YOUR-APP-prod --name="Your App Prod"
```

**Record these:**
- [ ] Dev Project ID: `_______________`
- [ ] Prod Project ID: `_______________`

### 2.2 Enable Billing

Go to [GCP Console](https://console.cloud.google.com) → Billing → Link a billing account.

- [ ] Billing enabled on dev project
- [ ] Billing enabled on prod project

### 2.3 Enable APIs

The setup script does this, but you can do it manually:

```bash
gcloud services enable \
  run.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  firestore.googleapis.com \
  secretmanager.googleapis.com \
  firebase.googleapis.com \
  --project=YOUR-PROJECT-ID
```

- [ ] APIs enabled on dev project
- [ ] APIs enabled on prod project

### 2.4 Authenticate

```bash
# Login to gcloud
gcloud auth login

# Set application default credentials
gcloud auth application-default login

# Set default project
gcloud config set project YOUR-PROJECT-ID
```

- [ ] gcloud authenticated
- [ ] Application default credentials set

---

## 3. Firebase

### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Select your existing GCP project
4. Follow the wizard

- [ ] Firebase project created (dev)
- [ ] Firebase project created (prod)

### 3.2 Enable Firestore

1. Firebase Console → Build → Firestore Database
2. Click "Create database"
3. Choose "Start in production mode"
4. Select region: `us-central1` (recommended)

- [ ] Firestore enabled (dev)
- [ ] Firestore enabled (prod)

### 3.3 Enable Authentication

1. Firebase Console → Build → Authentication
2. Click "Get started"
3. Enable providers:
   - [ ] Email/Password
   - [ ] Google
   - [ ] Apple (for iOS)

### 3.4 Download Config Files

**For iOS:**
1. Firebase Console → Project Settings → Your apps → iOS
2. Register your iOS app (bundle ID: `com.yourcompany.yourapp`)
3. Download `GoogleService-Info.plist`
4. Place in `mobile/ios/App/`

- [ ] GoogleService-Info.plist downloaded

**For Android:**
1. Firebase Console → Project Settings → Your apps → Android
2. Register your Android app (package: `com.yourcompany.yourapp`)
3. Download `google-services.json`
4. Place in `mobile/android/app/`

- [ ] google-services.json downloaded

---

## 4. Pulumi

### 4.1 Initialize Pulumi

```bash
cd infrastructure/pulumi
pulumi login --local  # Or use Pulumi Cloud
```

- [ ] Pulumi logged in

### 4.2 Configure Stacks

```bash
# Development stack
pulumi config set gcp:project YOUR-DEV-PROJECT-ID --stack dev
pulumi config set gcp:region us-central1 --stack dev

# Production stack
pulumi config set gcp:project YOUR-PROD-PROJECT-ID --stack prod
pulumi config set gcp:region us-central1 --stack prod
```

- [ ] Dev stack configured
- [ ] Prod stack configured

### 4.3 Deploy Infrastructure

```bash
# Deploy dev first
make deploy-dev

# Once verified, deploy prod
make deploy-prod
```

- [ ] Dev infrastructure deployed
- [ ] Prod infrastructure deployed

**Record outputs:**
- [ ] Dev Cloud Run URL: `_______________`
- [ ] Prod Cloud Run URL: `_______________`

---

## 5. GitHub

### 5.1 Create Repository

1. [Create new repo](https://github.com/new)
2. Make it public or private
3. Don't initialize with README (you have one)

- [ ] GitHub repo created
- [ ] Repo URL: `_______________`

### 5.2 Configure Secrets

Go to: Repository → Settings → Secrets and variables → Actions

| Secret Name | Value | Where to Get It |
|-------------|-------|-----------------|
| `GCP_PROJECT_ID` | Your GCP project ID | GCP Console |
| `WIF_PROVIDER` | Workload Identity provider | See 5.3 |
| `WIF_SERVICE_ACCOUNT` | Service account email | See 5.3 |

- [ ] `GCP_PROJECT_ID` secret added
- [ ] `WIF_PROVIDER` secret added
- [ ] `WIF_SERVICE_ACCOUNT` secret added

### 5.3 Set Up Workload Identity Federation

This allows GitHub Actions to deploy without service account keys.

```bash
PROJECT_ID=YOUR-PROJECT-ID
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

# Create service account
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions" \
  --project=$PROJECT_ID

# Grant permissions
SA_EMAIL="github-actions@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/iam.serviceAccountUser"

# Create workload identity pool
gcloud iam workload-identity-pools create "github" \
  --location="global" \
  --display-name="GitHub Actions Pool" \
  --project=$PROJECT_ID

# Create provider
gcloud iam workload-identity-pools providers create-oidc "github" \
  --location="global" \
  --workload-identity-pool="github" \
  --display-name="GitHub" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --project=$PROJECT_ID

# Allow GitHub to impersonate service account
REPO="YOUR-GITHUB-USERNAME/YOUR-REPO-NAME"
gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/github/attribute.repository/${REPO}" \
  --project=$PROJECT_ID
```

**Record these for GitHub secrets:**
- `WIF_PROVIDER`: `projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github/providers/github`
- `WIF_SERVICE_ACCOUNT`: `github-actions@PROJECT_ID.iam.gserviceaccount.com`

- [ ] Workload Identity Federation configured
- [ ] GitHub secrets updated

---

## 6. Mobile App Signing (Optional for MVP)

### iOS (for TestFlight/App Store)

- [ ] Apple Developer Program membership ($99/year)
- [ ] App ID created in Apple Developer Portal
- [ ] Provisioning profiles created
- [ ] Certificates exported

### Android (for Play Store)

- [ ] Google Play Developer account ($25 one-time)
- [ ] App created in Play Console
- [ ] Signing key generated
- [ ] Upload key configured

---

## 7. Verification Checklist

Run through this to verify everything works:

```bash
# Backend runs locally
cd backend && make run
# Visit http://localhost:8080/health

# iOS builds
cd mobile/ios && xcodegen generate && open App.xcodeproj
# Build in Xcode

# Android builds
cd mobile/android && ./gradlew assembleDebug
# Or open in Android Studio

# Infrastructure deploys
cd infrastructure/pulumi && make preview-dev

# CI runs (push a commit)
git push origin main
# Check GitHub Actions
```

- [ ] Backend runs locally
- [ ] iOS builds successfully
- [ ] Android builds successfully
- [ ] Pulumi preview works
- [ ] GitHub Actions run successfully

---

## Quick Reference

| What | Where to Find It |
|------|------------------|
| GCP Project ID | GCP Console → Project selector |
| GCP Project Number | GCP Console → Project settings |
| Firebase Project ID | Firebase Console → Project settings |
| Service Account Email | GCP Console → IAM → Service accounts |
| WIF Provider | Format: `projects/NUMBER/locations/global/workloadIdentityPools/github/providers/github` |
| Cloud Run URL | Pulumi outputs or GCP Console → Cloud Run |

---

## Need Help?

Ask Claude:
> "I'm stuck on step 5.3 - help me set up Workload Identity Federation for my GitHub repo"

Claude can run the commands for you if you have the right permissions.

---

*Production is a series of checkboxes. Check them all.*
