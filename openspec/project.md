# Vibe-to-Prod Project Conventions

## Project Overview

**Vibe-to-Prod** is a production-ready mobile app template optimized for AI-assisted development.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Go + Echo |
| Database | Firestore |
| Auth | Firebase Auth |
| iOS | Swift + SwiftUI |
| Android | Kotlin + Jetpack Compose |
| Web | TypeScript + Next.js |
| Infrastructure | Pulumi (Go) |
| CI/CD | GitHub Actions |

## Architecture Principles

1. **OpenAPI-First**: API spec is the source of truth
2. **Static Typing**: Go, Swift, Kotlin, TypeScript everywhere
3. **Monorepo**: All platforms in one repository
4. **AI-Native**: Optimized for Claude/AI-assisted development

## Directory Structure

```
vibe-to-prod/
├── backend/           # Go API server
│   ├── api/          # OpenAPI spec
│   ├── cmd/          # Entry points
│   └── internal/     # Business logic
├── mobile/
│   ├── ios/          # Swift/SwiftUI
│   └── android/      # Kotlin/Compose
├── web/              # Next.js
├── infrastructure/   # Pulumi IaC
├── .claude/          # AI workflow config
└── openspec/         # Spec-driven development
```

## Conventions

### Naming
- Files: lowercase with hyphens (`user-service.go`)
- Go packages: lowercase single word (`handlers`)
- API routes: lowercase with hyphens (`/api/v1/user-profiles`)

### API Design
- RESTful conventions
- Versioned endpoints (`/api/v1/`)
- JSON request/response bodies
- Standard HTTP status codes

### Commit Messages
- Format: `type: description`
- Types: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `chore`

### Testing
- Unit tests: `*_test.go` / `*.test.ts`
- Integration tests: `*_integration_test.go`
- Coverage target: >80% for new code

## Quality Gates

Before marking work complete:
- [ ] All tests pass
- [ ] Build succeeds (all platforms)
- [ ] OpenAPI spec valid
- [ ] No security issues
- [ ] Documentation updated
