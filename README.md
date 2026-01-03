# From Vibe to Production

> A real-world, production-first fullstack template for AI-assisted developers.

**This is not a demo. This is not a toy. This is what production actually looks like.**

---

## The Problem

You can vibe code with AI. You can generate features, write backends, build mobile apps.

But when it's time to ship for real — production architecture, deployment, CI/CD, infrastructure — you're stuck googling "how to deploy to production" at 2am.

Most templates stop at boilerplate. This one goes to deployed.

**This template is extracted from a real side project that's about to go into production.** Every pattern here has been debugged, works in real CI/CD, and handles real edge cases. I open sourced it because I believe others will find it beneficial.

---

## What's Inside

| Layer | Tech | Why |
|-------|------|-----|
| **Backend** | Go + Echo | Static typing, fast builds, AI-friendly |
| **iOS** | Swift + SwiftUI | Native performance, type-safe |
| **Android** | Kotlin + Compose | Native performance, type-safe |
| **Infrastructure** | Pulumi (Go) | Real code, not YAML |
| **Database** | Firebase/Firestore | Mobile-first, generous free tier |
| **Hosting** | Google Cloud Run | Serverless, scales to zero |
| **CI/CD** | GitHub Actions | Just works |
| **AI Workflow** | Claude Code | Full config included |

Everything in one monorepo. Clone once, ship everything.

### Built-In: Continuous Improvement

Every mistake becomes a lesson. The AI workflow is designed to get smarter over time:

| Learning Type | Action |
|---------------|--------|
| Same mistake twice | Add rule to `.claude/rules/` |
| Complex manual process | Create skill in `.claude/skills/` |
| New pattern discovered | Store in Memory MCP |

After a few months: rules catch mistakes before they happen, skills automate processes, and memory contains project-specific knowledge. This is the difference between "using AI" and "building an AI-assisted workflow."

---

## Quick Start

```bash
# 1. Clone
git clone <this-repo> my-app
cd my-app

# 2. Run setup (configures GCP, Pulumi, Firebase)
./scripts/setup.sh

# 3. Deploy infrastructure
cd infrastructure/pulumi && make deploy-dev

# 4. Run backend
cd backend && make run

# 5. Open mobile apps
# iOS: cd mobile/ios && xcodegen generate && open App.xcodeproj
# Android: Open mobile/android in Android Studio
```

---

## Project Structure

```
.
├── backend/                 # Go API server
│   ├── api/                # OpenAPI spec (source of truth)
│   ├── cmd/api/            # Entry point
│   └── Makefile
├── mobile/
│   ├── ios/                # Swift/SwiftUI
│   └── android/            # Kotlin/Compose
├── infrastructure/
│   └── pulumi/             # Infrastructure as Code
├── scripts/
│   ├── setup.sh            # One-command setup
│   └── openapi_workflow.py # API code generation
├── .claude/                # Claude Code config
│   ├── commands/           # /commit, /code-review, etc.
│   ├── hooks/              # Quality gates
│   └── skills/             # Context-aware behaviors
├── .github/workflows/      # CI/CD
└── docs/                   # Documentation
```

---

## Documentation

### For Humans

| Doc | What It's For |
|-----|---------------|
| [GETTING_STARTED.md](docs/GETTING_STARTED.md) | Setup instructions |
| [SETUP_CHECKLIST.md](docs/SETUP_CHECKLIST.md) | All accounts and secrets needed |
| [THE_CHALLENGE.md](docs/THE_CHALLENGE.md) | Why production is hard |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Why these technologies |
| [VISION.md](VISION.md) | Project philosophy |

### For AI Assistants

| Doc | What It's For |
|-----|---------------|
| [CLAUDE.md](CLAUDE.md) | AI context and rules |
| [AI_WORKFLOW.md](docs/AI_WORKFLOW.md) | MCP servers to install |
| [API_GATEWAY.md](docs/API_GATEWAY.md) | Auth architecture |
| [.claude/](/.claude) | Skills, commands, hooks |

### Both

| Doc | What It's For |
|-----|---------------|
| Root [Makefile](Makefile) | Unified CLI commands |
| [WORKFLOWS.md](docs/WORKFLOWS.md) | Development patterns |
| [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Common issues |

---

## Why Open Source?

Because trust comes before transactions.

You can read every line. You can judge the decisions. You can run it, break it, fix it.

If the code is bad, you'll know. If it's good, you'll know that too.

Read more: [WHY_OPEN_SOURCE.md](WHY_OPEN_SOURCE.md)

---

## Philosophy

Read the full vision: [VISION.md](VISION.md)

**TL;DR:**
- Production is a skill, not a secret
- This is optimized for "I want to ship this for real"
- Money is not the first goal — credibility is

---

## Support the Project

If this helped you ship to production:

- Star the repo
- Share it with someone stuck on deployment

---

## License

[MIT](LICENSE) — Use it. Fork it. Ship it. Build something real.

---

*From Vibe to Production — Stop demoing. Start shipping.*
