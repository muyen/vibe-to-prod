# Architecture & Technology Choices

This document explains why each technology was chosen for this production-ready template.

---

## Design Philosophy

1. **AI-Native Development** - Optimized for AI-assisted coding (Claude, Copilot)
2. **Startup-Friendly** - Low cost, scales from zero, free tiers
3. **Production-Ready** - Security, observability, CI/CD from day one
4. **Mobile-First** - Designed for iOS + Android apps

---

## Why Monorepo?

| Why Monorepo? | Details |
|--------------|---------|
| **AI-Friendly** | AI assistants see the full codebase - understands relationships between backend, iOS, and Android |
| **Single Context** | One repo = one conversation context. AI can trace API changes from spec → backend → mobile clients |
| **Atomic Changes** | Change API + all clients in one commit. No version drift between repos |
| **Simpler Tooling** | One CI/CD config, one set of secrets, one Pulumi project |
| **Easier Onboarding** | Clone once, everything works together |

**Why Not Separate Repos?**
- AI assistants lose context when switching between repos
- API changes require coordinated commits across multiple repos
- More complex CI/CD with cross-repo dependencies
- Version synchronization becomes a problem

**How AI Benefits:**
```
User: "Add a new /users endpoint"

AI in Monorepo:
1. Reads openapi.yaml - understands current API
2. Adds endpoint to spec
3. Regenerates Go server code
4. Regenerates iOS client
5. Regenerates Android client
6. All in one atomic change ✓

AI in Multi-Repo:
1. Opens backend repo, makes changes
2. "I'll need you to switch to ios-app repo..."
3. Context lost, starts fresh
4. Mistakes, version drift, coordination overhead ✗
```

---

## Technology Stack

### Backend: Go + Echo

| Why Go? | Details |
|---------|---------|
| **Static Typing** | AI assistants work better with typed languages - fewer bugs, better completions |
| **Fast Compilation** | Sub-second builds, fast feedback loop |
| **Single Binary** | No runtime dependencies, simple Docker images |
| **Concurrency** | Built-in goroutines for async operations |
| **Cloud Native** | Kubernetes, Cloud Run, all major cloud platforms love Go |

**Why Echo Framework?**
- Minimal, high-performance HTTP framework
- Easy middleware (auth, logging, CORS)
- OpenAPI/Swagger integration
- Popular choice in Go community

**Why Uber FX?**
- Dependency injection for clean architecture
- Testable, modular code
- Lifecycle management (startup/shutdown hooks)

**Why Zap Logger?**
- Structured JSON logging (Cloud Logging compatible)
- Extremely fast, zero-allocation
- Proper log levels for production

---

### Mobile: Swift (iOS) + Kotlin (Android)

| Why Native Languages? | Details |
|----------------------|---------|
| **Type Safety** | Swift and Kotlin are statically typed - AI assistants excel |
| **Platform APIs** | Full access to native features (push notifications, etc.) |
| **Performance** | No JavaScript bridge overhead |
| **Ecosystem** | SwiftUI, Jetpack Compose are modern, declarative UIs |

**Why Not React Native or Flutter?**
- Cross-platform adds complexity for AI assistants
- Native gives better performance and UX
- Separate codebases are easier for AI to reason about
- We generate API clients from OpenAPI - DRY achieved differently

---

### Database: Firebase/Firestore

| Why Firebase? | Details |
|--------------|---------|
| **Mobile SDKs** | First-class iOS/Android support |
| **Real-time Sync** | Built-in offline support, live updates |
| **Authentication** | Google, Apple, Email auth out of the box |
| **Generous Free Tier** | 1GB storage, 50K reads/day, 20K writes/day FREE |
| **Serverless** | No database server to manage |
| **Security Rules** | Declarative access control |

**Trade-offs:**
- Not SQL (document database)
- Complex queries need composite indexes
- Vendor lock-in to Google

---

### Cloud: Google Cloud Platform

| Why GCP? | Details |
|---------|---------|
| **Startup Credits** | $350 free trial, startup programs up to $200K |
| **Firebase Integration** | Firestore, Auth, Storage are GCP products |
| **Cloud Run** | Best serverless container platform |
| **Simple Pricing** | Pay per request, scales to zero |

**Why Cloud Run?**

| Feature | Cloud Run | AWS Lambda | Vercel |
|---------|-----------|------------|--------|
| **Cold Start** | ~200ms | ~500ms+ | ~100ms |
| **Max Timeout** | 60 min | 15 min | 5 min |
| **Container** | Any Docker | Limited | No |
| **Pricing** | Pay per 100ms | Pay per 100ms | Complex |
| **Startup Cost** | $0 at zero traffic | $0 at zero traffic | Free tier then $$$ |

Cloud Run is perfect for startups:
- **Scales to zero**: No traffic = no cost
- **Any container**: Use standard Dockerfile
- **Easy**: `gcloud run deploy` and done
- **Integrated**: Works with Artifact Registry, Secret Manager, Cloud Build

---

### Infrastructure: Pulumi

| Why Pulumi? | Details |
|------------|---------|
| **Real Programming Languages** | Go, TypeScript, Python - not YAML/HCL |
| **AI-Friendly** | AI assistants understand Go better than Terraform HCL |
| **Type Safety** | IDE autocomplete, compile-time errors |
| **State Management** | Built-in, or use GCS bucket |
| **Multi-Cloud** | GCP, AWS, Azure all supported |

**Why Not Terraform?**
- HCL is a config language, not a programming language
- AI assistants struggle with complex HCL
- Pulumi uses real code = better AI assistance

---

### API Design: OpenAPI + Code Generation

| Why OpenAPI? | Details |
|-------------|---------|
| **Single Source of Truth** | API spec drives all code |
| **Type Safety** | Generated types prevent mismatches |
| **Documentation** | Spec = live documentation |
| **Tooling** | Swagger UI, Postman, client generators |

**Workflow:**
```
openapi.yaml (edit this)
      ↓
oapi-codegen → Go types + server interface
      ↓
openapi-generator → iOS client, Android client
      ↓
All platforms type-safe and in sync
```

---

### CI/CD: GitHub Actions

| Why GitHub Actions? | Details |
|--------------------|---------|
| **Native Integration** | Built into GitHub |
| **Free Tier** | 2,000 minutes/month for private repos |
| **macOS Runners** | iOS builds without extra setup |
| **Marketplace** | Thousands of pre-built actions |

---

## Cost Analysis (Startup Phase)

| Service | Free Tier | After Free Tier |
|---------|-----------|-----------------|
| **Cloud Run** | 2M requests/month | $0.00002/request |
| **Firestore** | 1GB, 50K reads/day | $0.18/100K reads |
| **Firebase Auth** | Unlimited users | Free |
| **Firebase Storage** | 5GB | $0.026/GB |
| **Cloud Build** | 120 min/day | $0.003/min |
| **Artifact Registry** | 0.5GB/project | $0.10/GB |

**Estimated monthly cost at 1,000 users:** $5-20/month

---

## Security Considerations

1. **Authentication**: Firebase Auth with JWT tokens
2. **Authorization**: Firestore security rules + backend validation
3. **Secrets**: Google Secret Manager (not env vars)
4. **HTTPS**: Automatic via Cloud Run
5. **Monitoring**: Cloud Logging, Error Reporting built-in

---

## Scaling Path

| Stage | Users | Infrastructure |
|-------|-------|----------------|
| **MVP** | 0-1K | Single Cloud Run instance |
| **Growth** | 1K-10K | Auto-scaling Cloud Run |
| **Scale** | 10K-100K | Add caching (Redis), CDN |
| **Enterprise** | 100K+ | Multi-region, dedicated resources |

The architecture scales automatically from zero to thousands of concurrent users without changes.

---

## Alternative Considerations

If this stack doesn't fit your needs:

| Current | Alternative | When to Switch |
|---------|-------------|----------------|
| Go | Node.js/TypeScript | More JS devs on team |
| Cloud Run | AWS Lambda | AWS ecosystem preference |
| Firestore | PostgreSQL | Complex queries, transactions |
| Firebase Auth | Auth0 | Enterprise SSO requirements |
| Pulumi | Terraform | Team already knows HCL |

---

*Last updated: 2026-01-02*
