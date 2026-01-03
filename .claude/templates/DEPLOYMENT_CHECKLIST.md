# Deployment Checklist

**Purpose**: Executable checklist for deploying to development and production.

---

## Pre-Deployment Verification

### Before ANY Deployment

- [ ] All tests passing locally: `make test`
- [ ] Backend builds: `cd backend && make build`
- [ ] Web builds: `cd web && npm run build`
- [ ] iOS builds (if changes affect iOS)
- [ ] OpenAPI validation passed
- [ ] Git status clean (all changes committed)

---

## Development Deployment

### Pre-Development Deployment

- [ ] Merged to `main` branch
- [ ] CI passing on `main`
- [ ] Database migrations tested locally (if any)
- [ ] Breaking changes documented (if any)

### Deploy to Development

```bash
# Via GitHub Actions (recommended)
# Go to Actions → Deploy to Dev → Run workflow

# Or via command line
make deploy-dev
```

### Post-Development Deployment

- [ ] Deployment completed successfully
- [ ] Health check passed: `curl https://[dev-url]/health`
- [ ] Manual smoke test:
  - [ ] Login works
  - [ ] Core feature works
  - [ ] No console errors
- [ ] Check logs for errors

---

## Production Deployment

### Pre-Production Checklist (CRITICAL)

- [ ] Development environment tested thoroughly
- [ ] All features work in development
- [ ] No critical bugs found
- [ ] Database migrations tested in development
- [ ] Performance tested
- [ ] Security review completed (if new endpoints)
- [ ] Breaking changes communicated
- [ ] Rollback plan documented

### Rollback Plan

**If deployment fails:**
1. Go to Cloud Run → Select service
2. Click "Manage Traffic"
3. Shift 100% traffic to previous revision
4. Document incident

### Deploy to Production

```bash
# Via GitHub Actions (recommended)
# Go to Actions → Deploy to Prod → Run workflow

# Requires confirmation
```

### Post-Production Verification

- [ ] Production health check passed
- [ ] Manual smoke test (all platforms)
- [ ] Monitor error rates
- [ ] Monitor latency
- [ ] Check user reports

---

## Rollback Procedure

### Automatic Rollback
- Production deploys auto-rollback if health checks fail

### Manual Rollback
1. Go to Cloud Run Console
2. Select service
3. Click "Manage Traffic"
4. Shift 100% to previous revision
5. Document incident

---

## Best Practices

- [ ] Always test in development first
- [ ] Use semantic versioning
- [ ] Run migrations in dev before prod
- [ ] Monitor deployments until complete
- [ ] Keep deployment notes
- [ ] Never deploy Friday afternoon
- [ ] Have rollback plan ready
