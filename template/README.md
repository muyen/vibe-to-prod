# Vibe to Production Starter Kit

**From Vibe Coding to Production in Days, Not Months**

This is a production-ready full-stack template with an AI-native development workflow.

## What's Included

### Codebase
- **Backend**: Go with Echo framework, OpenAPI-first
- **iOS**: Swift/SwiftUI with XcodeGen
- **Android**: Kotlin/Compose with Gradle

### Claude Code Configuration
- Pre-configured hooks for quality gates
- Skills for common development tasks
- Commands for commits, reviews, and more

### CI/CD
- GitHub Actions workflows for all platforms
- Build verification on pull requests
- Deployment automation ready

### Change Management
- OpenSpec framework for managing changes
- Proposal templates
- Task tracking

## Quick Start

1. **Clone and setup**:
   ```bash
   git clone <this-repo> my-app
   cd my-app
   ```

2. **Backend**:
   ```bash
   cd backend
   make run
   # API at http://localhost:8080
   ```

3. **iOS**:
   ```bash
   cd mobile/ios
   make setup  # Generates Xcode project
   open App.xcodeproj
   ```

4. **Android**:
   ```bash
   cd mobile/android
   ./gradlew assembleDebug
   ```

## Project Structure

```
.
├── backend/              # Go API server
│   ├── api/             # OpenAPI specs
│   ├── internal/        # Application code
│   └── Dockerfile
├── mobile/
│   ├── ios/             # Swift/SwiftUI app
│   └── android/         # Kotlin/Compose app
├── .claude/             # Claude Code configuration
├── .github/workflows/   # CI/CD pipelines
└── openspec/            # Change management
```

## Documentation

See the included Notion workspace for:
- Architecture guides
- Development workflows
- Deployment checklists
- Runbooks

## Support

- **Documentation**: This README + Notion workspace
- **Community**: Discord (link in purchase confirmation)
- **Product Issues**: Email support
- **Custom Work**: Consulting available
