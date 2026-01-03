# Project Memory

This is a production-ready full-stack template with an AI-native development workflow.

## Tech Stack

- **Backend**: Go with Echo framework
- **iOS**: Swift/SwiftUI with XcodeGen
- **Android**: Kotlin/Compose
- **CI/CD**: GitHub Actions

## Project Structure

```
.
├── backend/          # Go API server
├── mobile/
│   ├── ios/         # SwiftUI app
│   └── android/     # Compose app
├── .claude/         # AI workflow config
├── .github/         # CI/CD
└── openspec/        # Change management
```

## Development Commands

| Component | Run | Build | Test |
|-----------|-----|-------|------|
| Backend | `make run` | `make build` | `make test` |
| iOS | Open in Xcode | `make build` | Xcode |
| Android | Android Studio | `./gradlew build` | `./gradlew test` |

## Key Patterns

1. **API-First**: Backend exposes `/health` and `/api/v1/*` endpoints
2. **XcodeGen**: iOS uses `project.yml` as source of truth
3. **Compose UI**: Android uses Jetpack Compose
4. **CI on Push**: GitHub Actions runs on main branch

## Adding Features

1. Add backend endpoints in `backend/cmd/api/main.go`
2. Add iOS views in `mobile/ios/App/`
3. Add Android composables in `mobile/android/app/src/main/kotlin/`

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Backend server port |
| `ENV` | `development` | Environment mode |
