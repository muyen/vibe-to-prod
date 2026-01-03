# Vibe-to-Prod Improvement Tasks

**Created:** 2026-01-03
**Source:** Comprehensive Pre-Release Review
**Total Tasks:** 23

---

## Task Categories

- **Security:** 4 tasks
- **CI/CD:** 5 tasks
- **Claude Code:** 8 tasks
- **Documentation:** 6 tasks

---

## Priority 1: Critical (Before Release)

### SEC-001: Fix npm vulnerabilities
**Priority:** CRITICAL | **Effort:** 15 min | **Category:** Security

**Issue:** 8 vulnerabilities found (3 high, 5 moderate)

**Action:**
```bash
cd web && npm audit fix
```

**Verification:**
```bash
npm audit
# Should show 0 vulnerabilities
```

---

### SEC-002: Add npm to Dependabot
**Priority:** CRITICAL | **Effort:** 5 min | **Category:** Security

**Issue:** npm dependencies not monitored by Dependabot

**Action:** Edit `.github/dependabot.yml`:
```yaml
  - package-ecosystem: "npm"
    directory: "/web"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    commit-message:
      prefix: "chore(deps)"
```

---

### DOC-001: Fix broken THE_CHALLENGE.md link
**Priority:** CRITICAL | **Effort:** 5 min | **Category:** Documentation

**Issue:** `docs/ARCHITECTURE.md` line 358 references non-existent file

**Action:** Either:
1. Create `docs/THE_CHALLENGE.md` with content explaining why template exists
2. Remove the reference from ARCHITECTURE.md

---

## Priority 2: High (Shortly After Release)

### SEC-003: Enable CI security workflows
**Priority:** HIGH | **Effort:** 30 min | **Category:** Security

**Issue:** Security scanning disabled in CI/CD

**Action:** Uncomment triggers in `.github/workflows/security.yml`:
```yaml
on:
  push:
    branches: [ main ]
    paths:
      - 'backend/**'
  pull_request:
    branches: [ main ]
    paths:
      - 'backend/**'
  schedule:
    - cron: '0 0 * * 0'  # Weekly
```

---

### CC-001: Port dev-workflow skill
**Priority:** HIGH | **Effort:** 1 hour | **Category:** Claude Code

**Source:** `proofmi/.claude/skills/dev-workflow/SKILL.md`

**Action:**
1. Create `.claude/skills/dev-workflow/SKILL.md`
2. Adapt SDLC phases for vibe-to-prod
3. Include MCP tool integrations (Linear, GitHub, etc.)

---

### CC-002: Port openapi-workflow skill
**Priority:** HIGH | **Effort:** 1 hour | **Category:** Claude Code

**Source:** `proofmi/.claude/skills/openapi-workflow/SKILL.md`

**Action:**
1. Create `.claude/skills/openapi-workflow/SKILL.md`
2. Integrate with existing OpenAPI tooling

---

### CC-003: Add agents directory
**Priority:** HIGH | **Effort:** 2 hours | **Category:** Claude Code

**Source:** `proofmi/.claude/agents/`

**Action:** Create and adapt agents:
```
.claude/agents/
├── debugger.md
├── architect.md
├── backend.md
├── code-reviewer.md
└── security-auditor.md
```

---

### DOC-002: Complete TESTING.md
**Priority:** HIGH | **Effort:** 2 hours | **Category:** Documentation

**Issue:** Document marked as WIP

**Action:**
1. Add iOS/Android test examples
2. Select and document E2E framework
3. Add load testing guidance
4. Complete coverage requirements section

---

## Priority 3: Medium (Roadmap)

### CICD-001: Add code coverage reporting
**Priority:** MEDIUM | **Effort:** 1 hour | **Category:** CI/CD

**Action:** Add to backend-ci.yml and web-ci.yml:
```yaml
- name: Upload coverage
  uses: codecov/codecov-action@v4
  with:
    files: ./coverage.out
    fail_ci_if_error: false
```

---

### CC-004: Port templates directory
**Priority:** MEDIUM | **Effort:** 2 hours | **Category:** Claude Code

**Source:** `proofmi/.claude/templates/`

**Action:** Create:
```
.claude/templates/
├── STORY_TEMPLATE.md
├── TASK_TEMPLATE.md
├── DEPLOYMENT_CHECKLIST.md
└── IMPROVEMENT_PROPOSAL_TEMPLATE.md
```

---

### CICD-002: Add mobile CI/CD
**Priority:** MEDIUM | **Effort:** 4 hours | **Category:** CI/CD

**Action:**
1. Create `.github/workflows/ios-ci.yml`
2. Create `.github/workflows/android-ci.yml`
3. Add Fastlane integration

---

### CC-005: Port code-review skill
**Priority:** MEDIUM | **Effort:** 1 hour | **Category:** Claude Code

**Source:** `proofmi/.claude/skills/code-review/SKILL.md`

---

### CC-006: Port security-scan skill
**Priority:** MEDIUM | **Effort:** 1 hour | **Category:** Claude Code

**Source:** `proofmi/.claude/skills/security-scan/SKILL.md`

---

### DOC-003: Complete SCALING.md
**Priority:** MEDIUM | **Effort:** 2 hours | **Category:** Documentation

**Issue:** Document marked as WIP

**Action:** Add concrete guidance for:
- Database scaling
- Cloud Run scaling
- CDN configuration
- Caching strategies

---

### CC-007: Add OpenSpec system
**Priority:** MEDIUM | **Effort:** 4 hours | **Category:** Claude Code

**Source:** `proofmi/openspec/` and `proofmi/.claude/commands/openspec/`

**Action:**
1. Create `openspec/` directory structure
2. Port OpenSpec commands
3. Add to CLAUDE.md instructions

---

## Priority 4: Low (Nice to Have)

### CICD-003: Add Lighthouse CI
**Priority:** LOW | **Effort:** 2 hours | **Category:** CI/CD

**Action:** Create `.github/workflows/lighthouse.yml` for web performance testing

---

### CICD-004: Add notification system
**Priority:** LOW | **Effort:** 2 hours | **Category:** CI/CD

**Action:** Add Slack/Discord notifications for:
- Deployment success/failure
- Security scan results
- PR review requests

---

### CICD-005: Add automated rollback
**Priority:** LOW | **Effort:** 4 hours | **Category:** CI/CD

**Action:** Create rollback workflow triggered by health check failure

---

### CC-008: Port remaining skills
**Priority:** LOW | **Effort:** 4 hours | **Category:** Claude Code

**Skills to consider:**
- `e2e-testing`
- `tdd`
- `quick-test`
- `smoke-test`
- `dependency-audit`
- `performance-analysis`
- `generate-tests`

---

### DOC-004: Add CHANGELOG.md
**Priority:** LOW | **Effort:** 1 hour | **Category:** Documentation

**Action:** Create changelog using keep-a-changelog format

---

### DOC-005: Standardize Go version
**Priority:** LOW | **Effort:** 30 min | **Category:** Documentation

**Issue:** Inconsistent Go version (1.21+ vs 1.24+) in docs

**Action:** Update all references to use current Go version

---

### DOC-006: Add infrastructure documentation
**Priority:** LOW | **Effort:** 2 hours | **Category:** Documentation

**Action:** Document Pulumi resources in `infrastructure/pulumi/README.md`

---

## Progress Tracking

### ✅ All Tasks Completed (2026-01-03)

**Security (3/3):**
- [x] SEC-001: Fixed npm vulnerabilities (vitest upgraded to v4, 3 remaining in glob transitive dep)
- [x] SEC-002: Added npm to Dependabot
- [x] SEC-003: Enabled CI security workflows

**Documentation (6/6):**
- [x] DOC-001: Fixed broken THE_CHALLENGE.md link (removed reference from ARCHITECTURE.md)
- [x] DOC-002: Completed TESTING.md (iOS XCTest, Android JUnit, Maestro E2E)
- [x] DOC-003: Completed SCALING.md
- [x] DOC-004: Added CHANGELOG.md
- [x] DOC-005: Standardized Go version to 1.24+
- [x] DOC-006: Added infrastructure/pulumi/README.md

**CI/CD (5/5):**
- [x] CICD-001: Added code coverage reporting (Codecov in backend-ci.yml)
- [x] CICD-002: Mobile CI/CD (skipped - not needed per user)
- [x] CICD-003: Added Lighthouse CI
- [x] CICD-004: Added notification system (Slack/Discord)
- [x] CICD-005: Added automated rollback workflow

**Claude Code (8/8):**
- [x] CC-001: Ported dev-workflow skill
- [x] CC-002: Ported openapi-workflow skill
- [x] CC-003: Added agents directory (5 agents)
- [x] CC-004: Ported templates directory (4 templates)
- [x] CC-005: Ported code-review skill
- [x] CC-006: Ported security-scan skill
- [x] CC-007: Added OpenSpec system
- [x] CC-008: Ported remaining skills (continuous-improvement, git-workflow, etc.)

---

## Notes

- All 22 improvement tasks completed (CICD-002 intentionally skipped)
- npm glob vulnerability is in @next/eslint-plugin-next transitive dependency - requires Next.js update
- Claude Code infrastructure expanded from 8 to 28 configuration files
- All CI/CD workflows now enabled on push/PR to main branch

---

*Completed: 2026-01-03*
