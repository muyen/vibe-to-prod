# The Challenge: From Vibe to Production

You can vibe code. You can prompt an AI to generate features, write APIs, build UIs.

But when it's time to ship for real, you hit a wall.

This document explains what that wall is made of — and how this template helps you get over it.

---

## The Gap

| What You Can Do (Vibe Coding) | What Production Requires |
|-------------------------------|-------------------------|
| Generate a working API | Multiple environments (dev/staging/prod) |
| Build a mobile app | CI/CD pipelines that actually deploy |
| Write backend logic | Infrastructure that scales |
| Create UI components | Authentication that's secure |
| Prototype fast | Monitoring, logging, error tracking |
| Get features working locally | Get features working for real users |

**The gap isn't code. It's everything around the code.**

---

## The 7 Walls of Production

### 1. Multiple Environments

**The problem:** Your laptop is not production.

- Development: localhost, fake data, no auth
- Staging: real infra, test data, limited users
- Production: real infra, real data, real users

**What you need:**
- Separate GCP projects (or at minimum, separate configs)
- Environment-specific secrets
- Deploy pipelines that know the difference

**This template provides:**
- `Pulumi.dev.yaml` and `Pulumi.prod.yaml`
- Makefile with `deploy-dev` and `deploy-prod`
- Production deploy requires confirmation

---

### 2. Infrastructure as Code

**The problem:** Clicking around in cloud consoles doesn't scale.

- Can't reproduce your setup
- Can't review changes
- Can't roll back
- Team members can't understand what exists

**What you need:**
- Infrastructure defined in code
- Version controlled
- Reviewable via PR
- One command to deploy

**This template provides:**
- Pulumi in Go (not YAML)
- Cloud Run, Firestore, Artifact Registry
- Service accounts with proper IAM
- `make deploy-dev` / `make deploy-prod`

---

### 3. CI/CD That Actually Works

**The problem:** "It works on my machine" isn't shipping.

- Builds must be automated
- Tests must run before merge
- Deploys must be triggered, not manual

**What you need:**
- Build on every push
- Test before merge
- Deploy on merge to main
- Separate pipelines for dev/prod

**This template provides:**
- `backend-ci.yml` - Go build + test
- `ios-ci.yml` - Xcode build
- `android-ci.yml` - Gradle build
- `deploy-cloudrun.yml` - Production deploy

---

### 4. Authentication & Security

**The problem:** Fake auth in development, real auth in production.

- Users need to sign in
- APIs need to verify tokens
- Data needs access control
- Secrets can't be in code

**What you need:**
- Auth provider (Firebase Auth)
- JWT verification in backend
- Security rules for database
- Secret management

**This template provides:**
- Firebase Auth configuration
- Firestore security rules
- Storage security rules
- Google Secret Manager integration

---

### 5. Database That's Not SQLite

**The problem:** Local SQLite isn't a real database.

- No real-time sync
- No offline support
- No access control
- No scale

**What you need:**
- Cloud-hosted database
- Security rules
- Backup strategy
- Local emulator for dev

**This template provides:**
- Firestore configuration
- Security rules
- Emulator setup in `firebase.json`
- Index configuration

---

### 6. Mobile App Distribution

**The problem:** Running on your phone isn't shipping.

- iOS needs TestFlight/App Store
- Android needs Play Store
- Both need signing
- Both need CI builds

**What you need:**
- Proper project configuration
- Signing setup
- CI pipelines
- Store metadata

**This template provides:**
- XcodeGen for iOS (reproducible builds)
- Gradle setup for Android
- CI workflows for both platforms
- Build configuration per environment

---

### 7. Testing That Runs Automatically

**The problem:** "I tested it manually" isn't testing.

- Tests must run in CI
- Tests must block bad merges
- Tests must cover critical paths

**What you need:**
- Unit tests
- Integration tests
- CI that runs them
- Coverage tracking

**This template provides:**
- Go test setup
- CI runs tests on every push
- Test commands in Makefile

---

## What This Template Gives You

| Challenge | Solution in This Template |
|-----------|--------------------------|
| Multiple environments | Pulumi dev/prod stacks |
| Infrastructure as code | Pulumi in Go |
| CI/CD | GitHub Actions workflows |
| Authentication | Firebase Auth + security rules |
| Database | Firestore + rules + emulator |
| Mobile builds | XcodeGen + Gradle + CI |
| Testing | Go tests + CI integration |
| AI workflow | Claude Code commands/hooks/skills |

---

## The Minimum Viable Production

This template is intentionally minimal:

- **Backend**: Health check + one example endpoint
- **iOS**: One screen that calls the API
- **Android**: One screen that calls the API
- **Infra**: Cloud Run + Firestore + Auth

It's a **skeleton**, not a finished app.

The value is: **the skeleton is production-ready.**

You add your features. The production infrastructure is already there.

---

## Next Steps

1. Read [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) — what accounts/secrets you need
2. Read [GETTING_STARTED.md](GETTING_STARTED.md) — how to run locally
3. Read [ARCHITECTURE.md](ARCHITECTURE.md) — why these technology choices
4. Run `./scripts/setup.sh` — let the script guide you

---

*Production is a skill, not a secret. This template is here to teach it.*
