# TODO - Automation & Features to Port

> Items to port from proofmi or add for production readiness.

## High Priority

### Missing Folders
- [ ] **automation/** - E2E testing folder (Playwright, Postman, mobile tests)
- [ ] **web/** - Web frontend scaffolding (React/Next.js)

### Bootstrap & Onboarding
- [ ] **Fresh clone test** - Clone to new folder, test with fresh AI session
- [ ] **Claude project configuration** - Verify MCP servers, tools, settings work

### Automation (from proofmi)
- [x] **Pre-commit formatting** - Auto-format on commit (Go formatting in pre-commit hook)
- [x] **Dependabot config** - Auto dependency updates
- [x] **GitHub PR template** - Consistent PR descriptions
- [x] **GitHub issue templates** - Bug report, feature request
- [x] **Workflow validation script** - Validates GitHub Actions workflows
- [x] **Production promotion pipeline** - Deploy tested image from dev to prod
- [x] **Local runner toggle script** - Switch between GitHub-hosted and self-hosted runners
- [ ] **Playwright E2E tests** - Browser-based E2E testing (in automation/)
- [ ] **Postman collections** - API testing collections (in automation/)

### Testing
- [ ] **iOS XCTest setup** - Add test target to project.yml
- [ ] **Android JUnit setup** - Add test dependencies
- [ ] **Load testing** - k6 setup

### Security
- [x] **Security headers** - CORS, CSP, XSS, HSTS configured (matches proofmi)
- [x] **Release checklist** - docs/RELEASE_CHECKLIST.md
- [ ] **API key rotation** - Document process
- [ ] **Rate limiting** - Configure at API Gateway level
- [ ] **Request timeout** - Configure at API Gateway level

## Medium Priority

### Documentation
- [ ] **API documentation** - Generate from OpenAPI
- [ ] **Changelog automation** - From conventional commits

### Mobile
- [ ] **Force update mechanism** - For breaking API changes
- [ ] **Offline support** - Basic caching
- [ ] **Push notifications** - Firebase setup

### Infrastructure
- [ ] **Database migrations** - Strategy and tooling
- [ ] **Feature flags** - LaunchDarkly or similar
- [ ] **Multi-region** - When needed

## Low Priority

- [ ] **Analytics** - User tracking
- [ ] **A/B testing** - Framework
- [ ] **Internationalization** - i18n setup

---

## Completed

### CI/CD
- [x] Production promotion workflow (.github/workflows/prod-promotion.yml)
- [x] Local runner toggle script (scripts/toggle-runner.sh)
- [x] Runner toggle support in all workflows (RUNNER_LABEL variable)
- [x] Fixed security.yml for private repos (removed CodeQL/SARIF)
- [x] Deploy workflow with git-sha labels for traceability

### Automation
- [x] Git hooks (pre-commit, commit-msg, pre-push)
- [x] Dependabot config (.github/dependabot.yml)
- [x] GitHub PR template (.github/PULL_REQUEST_TEMPLATE.md)
- [x] GitHub issue templates (bug_report, feature_request)
- [x] Workflow validation script (.github/scripts/validate-workflows.sh)

### Testing & Documentation
- [x] Backend unit tests
- [x] Backend integration tests
- [x] Smoke test script
- [x] PRODUCTION_GAP.md
- [x] TESTING.md
- [x] SCALING.md
- [x] AI_BOOTSTRAP.md
- [x] CICD.md - Self-hosted runners & prod promotion docs
- [x] CONTRIBUTING.md

### Claude Configuration
- [x] Claude commands (commit, code-review, security-scan, etc.)
- [x] Claude skills (continuous-improvement, systematic-debugging)
- [x] Session hooks (session-start, session-end)
- [x] Platform rules (backend, ios, android, testing)

### Security
- [x] Security audit passed - no hardcoded secrets or personal info
- [x] Secrets documentation in .env.example
- [x] Pre-commit hook blocks .env and secrets
- [x] .gitignore covers sensitive files
- [x] Security middleware in backend (headers, CORS - matches proofmi pattern)
- [x] RELEASE_CHECKLIST.md - Pre-deployment verification guide

---

**Last Updated**: 2026-01-03

## Summary of What's Missing

| Category | Item | Priority |
|----------|------|----------|
| **Folders** | `automation/` (E2E tests) | High |
| **Folders** | `web/` (frontend) | High |
| **Testing** | Playwright E2E | High |
| **Testing** | Postman collections | Medium |
| **Testing** | iOS XCTest | Medium |
| **Testing** | Android JUnit | Medium |
| **Testing** | k6 load tests | Low |
| **Mobile** | Force update mechanism | Medium |
| **Mobile** | Push notifications | Medium |
| **Infra** | Database migrations | Medium |
