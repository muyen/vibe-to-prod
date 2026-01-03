# TODO - Automation & Features to Port

> Items to port from proofmi or add for production readiness.

## High Priority

### Automation (from proofmi)
- [x] **Review proofmi automation folder** - Ported useful generic scripts
- [ ] **Agents configuration** - Custom agent prompts if any
- [x] **Pre-commit formatting** - Auto-format on commit (Go formatting in pre-commit hook)
- [x] **Dependabot config** - Auto dependency updates
- [x] **GitHub PR template** - Consistent PR descriptions
- [x] **GitHub issue templates** - Bug report, feature request
- [x] **Workflow validation script** - Validates GitHub Actions workflows

### Testing
- [ ] **iOS XCTest setup** - Add test target to project.yml
- [ ] **Android JUnit setup** - Add test dependencies
- [ ] **E2E framework** - Pick Playwright/Cypress
- [ ] **Load testing** - k6 setup

### Security
- [ ] **Rate limiting** - Add to backend
- [ ] **Security headers** - CORS, CSP, etc.
- [ ] **API key rotation** - Document process

## Medium Priority

### Documentation
- [ ] **API documentation** - Generate from OpenAPI
- [ ] **Changelog automation** - From conventional commits
- [ ] **Contributing guide** - Add CONTRIBUTING.md

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

- [x] Git hooks (pre-commit, commit-msg, pre-push)
- [x] Backend unit tests
- [x] Backend integration tests
- [x] Smoke test script
- [x] PRODUCTION_GAP.md
- [x] TESTING.md
- [x] SCALING.md
- [x] AI_BOOTSTRAP.md
- [x] Claude commands (commit, code-review, security-scan, etc.)
- [x] Claude skills (continuous-improvement, systematic-debugging)
- [x] Session hooks (session-start, session-end)
- [x] Platform rules (backend, ios, android, testing)
- [x] Dependabot config (.github/dependabot.yml)
- [x] GitHub PR template (.github/PULL_REQUEST_TEMPLATE.md)
- [x] GitHub issue templates (bug_report, feature_request)
- [x] Workflow validation script (.github/scripts/validate-workflows.sh)

---

**Last Updated**: 2026-01-03
