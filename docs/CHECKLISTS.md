# Checklists

Useful checklists for common development tasks.

---

## Feature Development

- [ ] Create Linear issue for tracking
- [ ] Create feature branch (`feature/description`)
- [ ] Implement backend changes
- [ ] Add backend tests
- [ ] Implement iOS changes (if needed)
- [ ] Implement Android changes (if needed)
- [ ] Run all tests (`make test`)
- [ ] Create PR
- [ ] Get code review
- [ ] Merge to main
- [ ] Update Linear issue

---

## PR Review

### Code Quality

- [ ] Code is readable and well-organized
- [ ] No obvious bugs or errors
- [ ] Edge cases handled
- [ ] Error handling appropriate

### Security

- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] Auth checks in place

### Testing

- [ ] Tests exist for new code
- [ ] All tests pass
- [ ] Edge cases tested

### Documentation

- [ ] Code comments where needed
- [ ] README updated if needed

---

## Deployment

### Pre-Deploy

- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Version bumped if needed
- [ ] Changelog updated

### Deploy

- [ ] Run `make deploy-dev` (or `make deploy-prod`)
- [ ] Health checks passing
- [ ] Smoke tests passing

### Post-Deploy

- [ ] Monitor for errors (Cloud Logging)
- [ ] Verify key features work
- [ ] Notify team

---

## New Developer Onboarding

- [ ] Clone repository
- [ ] Run `./scripts/setup.sh`
- [ ] Run backend locally (`cd backend && make run`)
- [ ] Run iOS app in simulator
- [ ] Run Android app in emulator
- [ ] Install Claude Code (`npm install -g @anthropic-ai/claude-code`)
- [ ] Create test branch
- [ ] Make small change
- [ ] Run tests
- [ ] Create practice PR

---

## Production Launch

### Infrastructure

- [ ] GCP project created
- [ ] Pulumi deployed (`make deploy-prod`)
- [ ] Firebase configured (Firestore, Auth, Storage)
- [ ] Domain configured (if applicable)
- [ ] SSL certificate active

### Security

- [ ] Firestore security rules reviewed
- [ ] Storage security rules reviewed
- [ ] API authentication working
- [ ] Secrets in Secret Manager (not env vars)

### Monitoring

- [ ] Cloud Logging enabled
- [ ] Error Reporting configured
- [ ] Alerts set up for critical errors

### Mobile

- [ ] iOS app submitted to App Store
- [ ] Android app submitted to Play Store
- [ ] Push notifications configured

---

*Copy these checklists into your issues/PRs as needed.*
