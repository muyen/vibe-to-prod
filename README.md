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
│  │ Swift/SwiftUI│  │Kotlin/Compose│  │   (planned)  │      │
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
│  │  (hosting)   │  │    (IaC)     │  │  (auth/db)   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
├────────────────────────────────────────────────────────────┤
│                        CI/CD                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  GitHub Actions  │  Security Scans  │  Auto Deploy  │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────┘
```

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
├── mobile/
│   ├── ios/                # Swift/SwiftUI + Fastlane
│   └── android/            # Kotlin/Compose + Fastlane
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
| [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | [SCALING.md](docs/SCALING.md) | [CLAUDE.md](CLAUDE.md) |
| | [CICD.md](docs/CICD.md) | |

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
