# Vibe to Production

> **The complete software development lifecycle for AI-assisted developers.**

You can vibe code features in hours. But shipping to production? That's weeks of CI/CD, security, infrastructure, testing, monitoring, and deployment pipelines.

**This template gives you the entire production stack from day one.**

---

## The Full Picture

```
                        WHAT VIBE CODING GIVES YOU
    ┌─────────────────────────────────────────────────────────┐
    │                                                         │
    │   Idea ───▶ Code ───▶ "It works on my machine!"        │
    │                                                         │
    └─────────────────────────────────────────────────────────┘

                      WHAT PRODUCTION REQUIRES
    ┌─────────────────────────────────────────────────────────┐
    │                                                         │
    │   Idea ───▶ Code ───▶ Tests ───▶ Security ───▶ CI/CD   │
    │                           │          │          │       │
    │                           ▼          ▼          ▼       │
    │                       Coverage    Scanning   Pipelines  │
    │                                                         │
    │   ───▶ Infrastructure ───▶ Deploy ───▶ Monitor ───▶ 🚀 │
    │              │               │            │             │
    │              ▼               ▼            ▼             │
    │          IaC/Pulumi    Cloud Run     Logging/Alerts    │
    │                                                         │
    └─────────────────────────────────────────────────────────┘

              THIS TEMPLATE = EVERYTHING IN THE SECOND BOX
```

---

## What You Get

| Phase | Without This Template | With This Template |
|-------|----------------------|-------------------|
| **Code** | Works locally | Works locally |
| **Testing** | "I'll add tests later" | Unit, integration, smoke tests ready |
| **Security** | Hope for the best | gosec, govulncheck, Trivy, security headers |
| **CI/CD** | Manual deploys | Automated pipelines, PR checks |
| **Infrastructure** | Click around in console | Pulumi IaC, reproducible |
| **Deploy** | "How do I deploy this?" | One command to Cloud Run |
| **Monitor** | "Is it down?" | Structured logging, health checks |

**Time saved: Weeks of setup, months of debugging production issues.**

---

## The Stack

```
┌────────────────────────────────────────────────────────────┐
│                        FRONTEND                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │     iOS      │  │   Android    │  │     Web      │      │
│  │ Swift/SwiftUI│  │Kotlin/Compose│  │  Next.js     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
├────────────────────────────────────────────────────────────┤
│                        BACKEND                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Go + Echo  │  OpenAPI  │  Structured Logging (Zap) │   │
│  └─────────────────────────────────────────────────────┘   │
├────────────────────────────────────────────────────────────┤
│                     INFRASTRUCTURE                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Cloud Run   │  │    Pulumi    │  │   Firebase   │      │
│  │ (backend)    │  │    (IaC)     │  │ (auth/db/web)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
├────────────────────────────────────────────────────────────┤
│                        CI/CD                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  GitHub Actions  │  Security Scans  │  Auto Deploy  │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────┘
```

### Web Architecture: Static + Dynamic

The web frontend uses **Firebase Hosting with Cloud Functions** for SSR:

```
┌─────────────────────────────────────────────────────────────┐
│                   Firebase Hosting (Web)                     │
│                                                              │
│   Static Assets (CDN)          Dynamic Routes (Functions)   │
│   ┌─────────────────┐          ┌─────────────────────┐      │
│   │ Images, CSS/JS  │  ───►    │ Server-side render  │      │
│   │ Static pages    │          │ Dynamic pages       │      │
│   └─────────────────┘          └─────────────────────┘      │
│                                                              │
│   Fast global CDN              Serverless, scales to zero   │
└─────────────────────────────────────────────────────────────┘
```

### Third-Party Services

| Service | Purpose | Why This Choice |
|---------|---------|-----------------|
| **Google Cloud Run** | Backend hosting | Serverless, scales to zero, pay-per-use |
| **Firebase Auth** | Authentication | Easy mobile SDKs, Google/Apple sign-in |
| **Firestore** | Database | NoSQL, real-time sync, generous free tier |
| **Artifact Registry** | Docker images | Private container registry on GCP |
| **GitHub Actions** | CI/CD | Free for public repos, easy secrets management |

### Deployment Environments

Two fully isolated environments - separate GCP projects and Firebase projects:

```
┌─────────────────────────────────────────────────────────────┐
│                    TWO-ENVIRONMENT SETUP                     │
│                                                              │
│          DEVELOPMENT                    PRODUCTION           │
│   ┌─────────────────────┐       ┌─────────────────────┐     │
│   │  GCP Project (dev)  │       │  GCP Project (prod) │     │
│   │  ┌───────────────┐  │       │  ┌───────────────┐  │     │
│   │  │   Cloud Run   │  │       │  │   Cloud Run   │  │     │
│   │  │   api-dev     │  │       │  │   api-prod    │  │     │
│   │  └───────────────┘  │       │  └───────────────┘  │     │
│   │  ┌───────────────┐  │       │  ┌───────────────┐  │     │
│   │  │   Firebase    │  │       │  │   Firebase    │  │     │
│   │  │  - Auth       │  │       │  │  - Auth       │  │     │
│   │  │  - Firestore  │  │       │  │  - Firestore  │  │     │
│   │  │  - Storage    │  │       │  │  - Storage    │  │     │
│   │  └───────────────┘  │       │  └───────────────┘  │     │
│   └─────────────────────┘       └─────────────────────┘     │
│                                                              │
│   Push to main ──▶ Auto-deploy to DEV                       │
│   Manual promote ──▶ Same image to PROD                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

| Environment | GCP Project | Firebase Project | Triggered By |
|-------------|-------------|------------------|--------------|
| **Development** | `yourapp-dev` | `yourapp-dev` | Push to `main` |
| **Production** | `yourapp-prod` | `yourapp-prod` | Manual promotion |

**Why separate projects?**
- Isolated data (dev data never touches prod)
- Separate billing and quotas
- Different IAM permissions
- Safe to experiment in dev

---

## Built for Claude Code

This template is designed specifically for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) - Anthropic's CLI for AI-assisted development.

### Why Claude Code?

```
┌─────────────────────────────────────────────────────────────┐
│                     CLAUDE CODE + THIS TEMPLATE              │
│                                                              │
│   You ───▶ claude ───▶ Full codebase access                 │
│                   │                                          │
│                   ├───▶ Pre-configured rules & skills        │
│                   │                                          │
│                   ├───▶ MCP servers for extended context     │
│                   │     • GitHub (PRs, issues, code search)  │
│                   │     • Memory (persistent knowledge)      │
│                   │     • Context7 (library docs)            │
│                   │     • Notion (team knowledge)            │
│                   │     • Pulumi (infrastructure)            │
│                   │                                          │
│                   └───▶ Hooks prevent mistakes automatically │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### MCP Servers (Model Context Protocol)

MCP servers extend Claude's capabilities beyond the codebase:

| MCP Server | What It Does | Why You Need It |
|------------|--------------|-----------------|
| **GitHub** | Create PRs, issues, search code | Ship without leaving the terminal |
| **Memory** | Persistent knowledge graph | Remember decisions across sessions |
| **Context7** | Latest library documentation | Always up-to-date API references |
| **Notion** | Team knowledge base | Connect to your docs |
| **Pulumi** | Infrastructure management | Deploy and manage cloud resources |

See [AI_WORKFLOW.md](docs/AI_WORKFLOW.md) for full MCP setup instructions.

### Pre-built AI Automation

| Type | What | Examples |
|------|------|----------|
| **Commands** | One-command workflows | `/commit`, `/code-review`, `/security-scan` |
| **Skills** | Auto-activate on context | `continuous-improvement`, `systematic-debugging` |
| **Hooks** | Quality gates | Block edits to generated files, enforce commit format |
| **Rules** | Platform-specific guidance | Backend, iOS, Android, Testing rules |

### Continuous Improvement Loop

```
┌─────────────────────────────────────────────────────────────┐
│                  AI DEVELOPMENT LIFECYCLE                    │
│                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│  │  Start   │───▶│   Code   │───▶│  Review  │              │
│  │ Session  │    │ Feature  │    │ /commit  │              │
│  └──────────┘    └──────────┘    └──────────┘              │
│       │                               │                     │
│       ▼                               ▼                     │
│  ┌──────────┐                   ┌──────────┐               │
│  │  Rules   │◀──────────────────│  Learn   │               │
│  │  Apply   │   Mistake?        │  & Fix   │               │
│  └──────────┘   Add rule!       └──────────┘               │
│                                                              │
│  After 3 months: Rules prevent mistakes before they happen  │
│                  Skills automate repetitive tasks           │
│                  Memory retains project knowledge           │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Start

```bash
# Clone
git clone https://github.com/muyen/vibe-to-prod my-app
cd my-app

# Setup (installs hooks, configures environment)
./scripts/setup.sh

# Run backend locally
cd backend && make run
# Health check: curl http://localhost:8080/health

# Deploy to cloud (after GCP setup)
cd infrastructure/pulumi && make deploy-dev
```

See [GETTING_STARTED.md](docs/GETTING_STARTED.md) for full setup instructions.

> **Important: Secrets Management**
>
> Never hardcode API keys, database passwords, or other secrets in your code.
> - **Local dev**: Use `.env.local` (gitignored)
> - **CI/CD**: Use GitHub Actions Secrets
> - **Production**: Use [Google Secret Manager](docs/SECRETS.md)
>
> See [SECRETS.md](docs/SECRETS.md) for the complete guide.

### For AI Assistants

If you're an AI assistant (Claude, etc.) working on this project for the first time:

```
Read docs/AI_BOOTSTRAP.md first
```

This contains project structure, key rules, source vs generated files, and common workflows optimized for AI context.

---

## Production Readiness

This template follows patterns from a real production application:

| Feature | Implementation | Status |
|---------|---------------|--------|
| **Security Headers** | CORS, CSP, HSTS, XSS protection | Done |
| **Security Scanning** | gosec, govulncheck, Trivy | Done |
| **CI/CD Pipelines** | Build, test, deploy on every push | Done |
| **Production Promotion** | Test in dev, promote to prod | Done |
| **Infrastructure as Code** | Pulumi with Go | Done |
| **Structured Logging** | Zap logger with request tracing | Done |
| **Health Checks** | `/health` endpoints for orchestration | Done |
| **Environment Parity** | Docker everywhere | Done |

See [PRODUCTION_GAP.md](docs/PRODUCTION_GAP.md) for the full checklist.

---

## Project Structure

```
.
├── backend/                 # Go API server
│   ├── cmd/api/            # Entry point with middleware
│   ├── internal/           # Business logic
│   ├── Makefile            # build, test, run, lint
│   └── Dockerfile          # Production container
├── web/                     # Next.js web application
│   ├── src/app/            # App Router pages
│   ├── firebase.json       # Firebase Hosting config
│   └── Makefile            # deploy-dev, deploy-prod
├── mobile/
│   ├── ios/                # Swift/SwiftUI + Fastlane
│   └── android/            # Kotlin/Compose + Fastlane
├── automation/              # E2E testing
│   ├── playwright/         # Browser tests
│   └── postman/            # API tests
├── infrastructure/
│   └── pulumi/             # Cloud Run, networking, IAM
├── .github/
│   └── workflows/          # CI/CD pipelines
├── .claude/                # AI workflow config
│   ├── commands/           # Slash commands
│   ├── skills/             # Auto-activate behaviors
│   ├── hooks/              # Quality gates
│   └── rules/              # Platform-specific rules
├── scripts/                # Setup and automation
└── docs/                   # Comprehensive documentation
```

---

## Documentation

| Getting Started | Production | AI Workflow |
|-----------------|------------|-------------|
| [GETTING_STARTED.md](docs/GETTING_STARTED.md) | [PRODUCTION_GAP.md](docs/PRODUCTION_GAP.md) | [AI_BOOTSTRAP.md](docs/AI_BOOTSTRAP.md) |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | [RELEASE_CHECKLIST.md](docs/RELEASE_CHECKLIST.md) | [AI_WORKFLOW.md](docs/AI_WORKFLOW.md) |
| [OPENAPI_WORKFLOW.md](docs/OPENAPI_WORKFLOW.md) | [SCALING.md](docs/SCALING.md) | [CLAUDE.md](CLAUDE.md) |
| [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | [CICD.md](docs/CICD.md) | |
| [SECRETS.md](docs/SECRETS.md) | [SETUP_CHECKLIST.md](docs/SETUP_CHECKLIST.md) | |

---

## Who This Is For

- **Solo developers** who want production infrastructure without the research
- **AI-assisted developers** who need a template that works with Claude Code
- **Side project builders** who want to ship, not configure
- **Teams** who want a production-ready starting point

---

## Contributing

This template is extracted from a real production project and actively maintained.

- Found a gap? [Open an issue](https://github.com/muyen/vibe-to-prod/issues)
- Fixed something? Submit a PR
- Shipped with this? Share your experience

---

## License

[MIT](LICENSE) — Use it. Fork it. Ship it.

---

**Stop demoing. Start shipping.**
