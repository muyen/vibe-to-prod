# Production Release Checklist

> **Audience**: Developers and AI assistants preparing for production deployment.

Use this checklist before any production release. Each section must be verified.

---

## Pre-Release Verification

### 1. Security Checks

| Check | Command/Action | Status |
|-------|----------------|--------|
| **Security scan passes** | `make security-scan` or run `/security-scan` | [ ] |
| **No hardcoded secrets** | Search for API keys, passwords, tokens | [ ] |
| **Dependencies updated** | Check Dependabot alerts, run `go mod tidy` | [ ] |
| **Vulnerability scan** | `govulncheck ./...` in backend | [ ] |

### 2. Environment Configuration

| Check | Notes | Status |
|-------|-------|--------|
| **CORS_ALLOWED_ORIGINS set** | Must be production domain(s), not `*` | [ ] |
| **ENV=production** | Enables production logging, security settings | [ ] |
| **API Gateway rate limiting** | Configure at API Gateway level (not in backend) | [ ] |
| **API Gateway request timeout** | Configure at API Gateway level | [ ] |

### 3. Security Headers (Verified in `main.go`)

These are configured in `backend/cmd/api/main.go`. Verify they're appropriate:

| Header | Default | Production Notes |
|--------|---------|------------------|
| X-XSS-Protection | `1; mode=block` | Standard |
| X-Content-Type-Options | `nosniff` | Standard |
| X-Frame-Options | `DENY` | Change to `SAMEORIGIN` if using iframes |
| Referrer-Policy | `strict-origin-when-cross-origin` | Controls referrer leakage |
| Content-Security-Policy | `default-src 'none'; frame-ancestors 'none'` | Strict for APIs |
| Permissions-Policy | `geolocation=(), microphone=(), camera=()` | Disable browser features |
| Strict-Transport-Security | `max-age=31536000; includeSubDomains; preload` | Production only |
| Cache-Control | `no-store, no-cache...` | For authenticated requests |

### 4. Authentication & Authorization

| Check | Notes | Status |
|-------|-------|--------|
| **API Gateway auth configured** | Firebase Auth / JWT validation at gateway | [ ] |
| **Token validation working** | Test with valid/invalid tokens | [ ] |
| **Rate limiting per user** | Consider user-based limits for authenticated endpoints | [ ] |
| **Admin endpoints protected** | Additional authorization checks | [ ] |

### 5. Observability

| Check | Notes | Status |
|-------|-------|--------|
| **Logging configured** | Production logger enabled (`ENV=production`) | [ ] |
| **Request ID in logs** | Verify `X-Request-ID` is logged | [ ] |
| **Error tracking setup** | Sentry, Cloud Error Reporting, etc. | [ ] |
| **Metrics available** | Cloud Run metrics, custom metrics if needed | [ ] |
| **Health check accessible** | `/health` and `/api/v1/health` responding | [ ] |

### 6. Database (When Applicable)

| Check | Notes | Status |
|-------|-------|--------|
| **Connection pooling configured** | Appropriate pool size for expected load | [ ] |
| **Migrations applied** | All pending migrations run | [ ] |
| **Backup verified** | Recent backup, restore tested | [ ] |
| **Indexes optimized** | Query performance acceptable | [ ] |

### 7. Infrastructure

| Check | Command/Action | Status |
|-------|----------------|--------|
| **Cloud Run configured** | Memory, CPU, concurrency, min/max instances | [ ] |
| **Secrets in Secret Manager** | Not in environment variables directly | [ ] |
| **Domain and SSL** | Custom domain configured, HTTPS only | [ ] |
| **CDN/Load balancer** | If applicable, configured correctly | [ ] |

---

## Build Verification

```bash
# Backend
cd backend
make build      # Compiles successfully
make test       # All tests pass
make lint       # No linting errors

# Docker
docker build -t test-api .
docker run -p 8080:8080 -e ENV=production test-api
curl http://localhost:8080/health  # Returns {"status":"ok"}
```

---

## Deployment Steps

### Standard Deployment (Dev)

```bash
# Automatic on push to main
git push origin main

# Or manual
gh workflow run deploy-cloudrun.yml -f environment=dev
```

### Production Promotion

```bash
# 1. Verify dev is stable
curl https://api-dev.yourapp.com/health

# 2. Run smoke tests against dev

# 3. Promote to production (same image!)
gh workflow run prod-promotion.yml

# 4. Verify production health
curl https://api.yourapp.com/health
```

---

## Post-Deployment Verification

| Check | Action | Status |
|-------|--------|--------|
| **Health check** | `curl https://api.yourapp.com/health` | [ ] |
| **API version** | `curl https://api.yourapp.com/api/v1/health` | [ ] |
| **Smoke tests** | Run automated smoke test suite | [ ] |
| **Logs flowing** | Check Cloud Logging for requests | [ ] |
| **No errors** | Monitor for 15 minutes post-deploy | [ ] |

---

## Rollback Procedure

If issues are detected after deployment:

```bash
# 1. Get previous revision
gcloud run revisions list --service=api --region=us-central1

# 2. Route traffic to previous revision
gcloud run services update-traffic api \
  --region=us-central1 \
  --to-revisions=api-PREVIOUS_REVISION=100

# 3. Investigate and fix
# 4. Redeploy when ready
```

---

## Security Middleware Reference

The following security middleware is configured in `backend/cmd/api/main.go`:

| Middleware | Purpose | Configuration |
|------------|---------|---------------|
| **Recover** | Prevents server crash on panic | Echo built-in |
| **Logger** | Request logging | Echo built-in |
| **CORS** | Cross-origin requests | Configured via `CORS_ALLOWED_ORIGINS` |
| **Security Headers** | XSS, HSTS, CSP, etc. | Custom middleware (matches proofmi) |
| **RequestID** | Request tracing | Auto-generates UUID |
| **Structured Logging** | Audit trail | Method, path, status, latency, IP |

**Note**: Rate limiting and request timeouts are configured at the **API Gateway level** (e.g., GCP API Gateway, Firebase App Check) rather than in the backend directly. This follows the proofmi production pattern.

---

## Quick Reference: Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `ENV` | Yes | `development` | Set to `production` for prod |
| `PORT` | No | `8080` | Server port |
| `CORS_ALLOWED_ORIGINS` | Yes (prod) | localhost in dev | Comma-separated origins |

---

## Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| CORS errors | Wrong `CORS_ALLOWED_ORIGINS` | Set correct production domains |
| 429 Too Many Requests | API Gateway rate limit | Adjust at API Gateway level |
| Gateway timeout | Long-running request | Configure at API Gateway level |
| CSP violations | Strict Content-Security-Policy | Adjust CSP in main.go |

---

## Approval

Before production deployment, ensure:

- [ ] All checks above completed
- [ ] Code reviewed and approved
- [ ] QA sign-off (if applicable)
- [ ] Stakeholder notification

---

*Last updated: 2026-01-03*
