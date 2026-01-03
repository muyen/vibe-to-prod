# Project Conventions

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Go + Echo |
| iOS | Swift + SwiftUI |
| Android | Kotlin + Compose |
| CI/CD | GitHub Actions |

## API Conventions

- Base path: `/api/v1/`
- Health check: `/health`
- JSON responses
- Error format: `{"error": "message"}`

## Code Style

### Go
- `gofmt` for formatting
- Uber FX for dependency injection
- Zap for logging

### Swift
- SwiftLint rules
- MVVM pattern
- Async/await for networking

### Kotlin
- ktlint for formatting
- Compose for UI
- Coroutines for async

## Git Conventions

- Branch: `feature/`, `fix/`, `chore/`
- Commits: Conventional commits (`feat:`, `fix:`, `docs:`)
- PRs: Require CI passing

## CI/CD

- Backend: Build, test, Docker build on push
- Mobile: Build on PR (add as needed)
