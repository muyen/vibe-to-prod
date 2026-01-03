# AI Bootstrap Guide

> **For AI Assistants**: Read this first when starting work on this project.

## Quick Context

This is a **vibe-to-prod** template - designed to take ideas from "vibing with AI" to actual production deployment. It includes:

- Go backend (Echo + Uber FX)
- iOS app (Swift/SwiftUI)
- Android app (Kotlin/Compose)
- Infrastructure as Code (Pulumi)
- CI/CD (GitHub Actions)
- Claude Code configuration

## First Session Checklist

When starting a new session, verify:

```bash
# 1. Check project status
git status
git log -3 --oneline

# 2. Check if there are pending Linear issues (if Linear MCP connected)
# Look for in-progress issues that need continuation

# 3. Verify builds work
cd backend && make build
cd mobile/ios && make build  # if on macOS
cd mobile/android && ./gradlew assembleDebug
```

## Key Rules to Remember

| Rule | Why |
|------|-----|
| Edit SOURCE, not GENERATED | OpenAPI → generates code |
| Verify ALL affected platforms | Change backend → verify mobile |
| Use `/commit` for commits | Consistent format |
| Update Linear issues | Context for next session |

## Source vs Generated Files

### SOURCE (Edit these)
```
backend/api/openapi.yaml      # API specification
mobile/ios/project.yml        # XcodeGen config
mobile/android/build.gradle   # Gradle config
infrastructure/pulumi/        # Pulumi programs
```

### GENERATED (Never edit)
```
backend/internal/api/generated/  # From OpenAPI
mobile/ios/*.xcodeproj/          # From XcodeGen
mobile/android/build/            # Gradle output
```

## Common Workflows

### Adding a Backend Endpoint

```bash
# 1. Edit API spec
vim backend/api/openapi.yaml

# 2. Regenerate code
cd backend && make generate

# 3. Implement handler
# 4. Add tests
# 5. Verify
make build && make test
```

### Fixing a Bug

```bash
# 1. Create/update Linear issue
# 2. Reproduce the bug
# 3. Write failing test
# 4. Fix the bug
# 5. Verify fix
# 6. Update Linear issue
# 7. Commit with /commit
```

### Multi-Session Work

1. **Start**: Check Linear for in-progress issues
2. **Work**: Update issue description as you progress
3. **End**: Add summary of what was done, what's next
4. **Next session**: Read the issue for context

## Project Structure

```
.
├── backend/                 # Go API server
│   ├── api/openapi.yaml    # API spec (EDIT THIS)
│   ├── cmd/api/main.go     # Entry point
│   ├── internal/           # Business logic
│   └── Makefile
├── mobile/
│   ├── ios/                # Swift/SwiftUI
│   │   ├── project.yml     # XcodeGen (EDIT THIS)
│   │   └── App/
│   └── android/            # Kotlin/Compose
│       └── app/
├── infrastructure/pulumi/   # IaC (Pulumi + Go)
├── scripts/
│   ├── setup.sh            # Initial setup
│   └── smoke-test.sh       # Quick validation
├── docs/                   # Documentation
└── .claude/                # AI workflow config
    ├── rules/              # Platform-specific rules
    ├── skills/             # Auto-activated behaviors
    ├── commands/           # Slash commands
    └── hooks/              # Automation hooks
```

## Secrets & Environment

This project needs these secrets for full functionality:

### Local Development
```bash
# Copy and fill in
cp .env.example .env
```

### CI/CD (GitHub Secrets)
```
GCP_PROJECT_ID          # Google Cloud project
WIF_PROVIDER            # Workload Identity Federation
WIF_SERVICE_ACCOUNT     # Service account for deployment
```

### MCP Servers (Personal Claude Config)
```
GITHUB_PERSONAL_ACCESS_TOKEN  # For GitHub MCP
LINEAR_API_KEY                # For Linear MCP (highly recommended)
NOTION_API_KEY                # For Notion MCP (optional)
```

See `docs/CICD.md` for detailed setup.

## Available Commands

```
/commit              # Create well-formatted commit
/code-review         # Review code for issues
/generate-tests      # Generate test suite
/ultra-think         # Deep analysis mode
/security-scan       # Security vulnerability check
/improve-claude-config  # Audit configuration
```

## Testing

```bash
# Backend
cd backend && make test

# Smoke tests (requires backend running)
./scripts/smoke-test.sh backend

# All platforms
./scripts/smoke-test.sh all
```

## When to Ask for Clarification

Ask the user if:
- Task spans multiple platforms (confirm scope)
- Architectural decision needed (multiple valid approaches)
- Breaking change required (confirm impact)
- Missing secrets needed (can't proceed without them)

## What Makes This Template Special

1. **Continuous Improvement**: Every mistake becomes a rule, every pattern becomes a skill
2. **Linear Integration**: Solves the AI context problem across sessions
3. **Claude Automation**: Commands, skills, and hooks automate repetitive work
4. **Production-Ready**: CI/CD, security scanning, deployment all configured

## Links

- [CLAUDE.md](../CLAUDE.md) - Main AI memory
- [AI_WORKFLOW.md](AI_WORKFLOW.md) - Detailed AI workflow guide
- [CICD.md](CICD.md) - CI/CD and secrets setup
- [TESTING.md](TESTING.md) - Testing guide
- [SCALING.md](SCALING.md) - Production scaling

---

**Read this, then check Linear for pending work.**
