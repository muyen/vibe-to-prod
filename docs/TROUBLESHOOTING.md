# Troubleshooting

Common issues and solutions.

---

## Setup Script

### "Permission denied" on setup.sh

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### "gcloud: command not found"

Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install

```bash
# macOS
brew install google-cloud-sdk
```

---

## Backend (Go)

### "command not found: go"

```bash
brew install go
```

### "oapi-codegen: command not found"

```bash
go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest
```

Make sure `$GOPATH/bin` is in your PATH:

```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

### Build fails after OpenAPI changes

Regenerate code:

```bash
python scripts/openapi_workflow.py --full
```

---

## iOS

### "xcodegen: command not found"

```bash
brew install xcodegen
```

### "No such module 'App'"

Regenerate Xcode project:

```bash
cd mobile/ios
rm -rf App.xcodeproj
xcodegen generate
```

### Build fails with signing error

Open Xcode → Signing & Capabilities → Select your team.

---

## Android

### "SDK location not found"

Create `local.properties`:

```bash
cd mobile/android
echo "sdk.dir=$HOME/Library/Android/sdk" > local.properties
```

### Gradle sync fails

Update Gradle wrapper:

```bash
cd mobile/android
./gradlew wrapper --gradle-version 8.5
```

---

## Pulumi

### "pulumi: command not found"

```bash
brew install pulumi
```

### Permission denied / authentication error

```bash
gcloud auth application-default login
```

### State lock issues

```bash
cd infrastructure/pulumi
pulumi cancel --yes
pulumi refresh --stack dev --yes
```

### API not enabled

```bash
gcloud services enable run.googleapis.com --project=YOUR_PROJECT
```

---

## Claude Code

### "claude: command not found"

```bash
npm install -g @anthropic-ai/claude-code
```

### Hooks not running

Check `.claude/settings.json` exists and is valid JSON.

### Command not found (e.g., /commit)

Check `.claude/commands/` directory exists with `.md` files.

---

## OpenAPI

### "swagger: command not found"

```bash
npm install -g @apidevtools/swagger-cli
```

### Validation fails

Check YAML syntax:

```bash
swagger-cli validate backend/api/openapi.yaml
```

---

## Firebase

### "firebase: command not found"

```bash
npm install -g firebase-tools
firebase login
```

### Firestore permission denied

Check `firestore.rules` - ensure your auth rules match your use case.

### Emulator not starting

```bash
firebase emulators:start --project=demo-project
```

---

## CI/CD

### GitHub Actions failing

1. Check secrets are set: `GCP_PROJECT_ID`, `WIF_PROVIDER`, `WIF_SERVICE_ACCOUNT`
2. Verify Workload Identity Federation is configured
3. Check the Actions logs for specific errors

### Docker build fails

```bash
cd backend
docker build -t test .
```

---

## Still Stuck?

1. Check the error message carefully
2. Search the error in the repo issues
3. Ask Claude: `claude "I'm getting this error: [paste error]"`

---

*Most issues are solved by: reinstalling dependencies, regenerating code, or checking authentication.*
