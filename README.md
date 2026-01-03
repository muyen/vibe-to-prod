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

## What Makes This Different

> ⚠️ **Work in Progress**: This template is actively being developed. Contributions welcome!

### 1. Continuous Improvement Built In

Every mistake becomes a lesson. The AI workflow gets smarter over time:

```
Repeated mistake  → Add rule to .claude/rules/
Complex process   → Create skill in .claude/skills/
New pattern       → Store in Memory MCP
Missing tool      → Create Linear issue for later
```

After a few months: rules catch mistakes before they happen, skills automate processes, and memory contains project-specific knowledge.

### 2. Linear Integration Solves AI Context

**The Problem**: Each AI session starts fresh. Context is lost. You repeat yourself.

**The Solution**: Linear MCP integration.

```
Session 1: Start task → Create Linear issue → Work → Update issue
Session 2: Read issue → Continue where you left off → Update issue
Session 3: Read issue → Finish → Close issue
```

Full context across sessions. No more "where was I?"

### 3. Claude Automation for Everything

Pre-built commands, skills, and hooks:

| Type | Examples | Purpose |
|------|----------|---------|
| **Commands** | `/commit`, `/code-review`, `/security-scan` | One-command workflows |
| **Skills** | `continuous-improvement`, `systematic-debugging` | Auto-activate on context |
| **Hooks** | `protect-generated-files`, `session-start` | Quality gates |

### 4. Security & Scale Considerations

- Security scanning in CI (gosec, govulncheck, CodeQL, Trivy)
- Production scaling guide (`docs/SCALING.md`)
- Workload Identity Federation (no stored secrets)
- OWASP considerations documented

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

---

## Quick Start

```bash
# 1. Clone
git clone <this-repo> my-app
cd my-app

# 2. Install git hooks (enforces commit format, prevents secrets)
git config core.hooksPath .githooks

# 3. Run setup (configures GCP, Pulumi, Firebase)
./scripts/setup.sh

# 4. Deploy infrastructure
cd infrastructure/pulumi && make deploy-dev

# 5. Run backend
cd backend && make run

# 6. Open mobile apps
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

### Start Here

| Doc | What It's For |
|-----|---------------|
| **[PRODUCTION_GAP.md](docs/PRODUCTION_GAP.md)** | **The gap between vibe coding and production** |
| [GETTING_STARTED.md](docs/GETTING_STARTED.md) | Setup instructions |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Why these technologies |

### Production Readiness

| Doc | What It's For |
|-----|---------------|
| [TESTING.md](docs/TESTING.md) | Testing strategy and examples |
| [SCALING.md](docs/SCALING.md) | When and how to scale |
| [CICD.md](docs/CICD.md) | CI/CD pipelines and secrets |
| [API_GATEWAY.md](docs/API_GATEWAY.md) | Auth and API architecture |
| [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Common issues and fixes |

### AI-Assisted Development

| Doc | What It's For |
|-----|---------------|
| [CLAUDE.md](CLAUDE.md) | AI memory and rules |
| [AI_BOOTSTRAP.md](docs/AI_BOOTSTRAP.md) | First session guide for AI |
| [AI_WORKFLOW.md](docs/AI_WORKFLOW.md) | MCP servers, Linear integration |

---

## Contributing

This is a work in progress. Contributions welcome!

- Found a gap? Open an issue
- Fixed something? Submit a PR
- Shipped to production with this? Share your experience

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
