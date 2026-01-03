# Scaling & Production Considerations

> ⚠️ **Work in Progress**: This guide covers production considerations. Your specific needs may vary.

## Overview

This template is designed to scale from side project to production. Here's what you need to think about.

## The Scaling Journey

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Laptop    │ →  │  Cloud Run  │ →  │  K8s/ECS    │ →  │ Multi-Region│
│   Dev Mode  │    │  (Current)  │    │  (Growth)   │    │  (Scale)    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## Current Architecture (Cloud Run)

This template deploys to Google Cloud Run by default:

**Pros:**
- Zero-to-production in minutes
- Scales to zero (cost effective for side projects)
- Auto-scales up to 1000 instances
- No infrastructure management

**Limits:**
- Max 8GB RAM per instance
- Max 60min request timeout
- Cold starts (mitigated with min instances)
- Regional only (no built-in multi-region)

## When to Scale Up

### Stay on Cloud Run if:
- < 1000 req/sec sustained
- Request duration < 60 seconds
- Memory needs < 8GB
- Single region is acceptable
- Cost optimization is priority

### Consider Kubernetes/ECS when:
- Need more control over networking
- Multi-region requirements
- Custom auto-scaling logic
- GPU workloads
- Complex service mesh needs

## Database Considerations

### Current: Cloud SQL / Firestore

**Cloud SQL (Postgres):**
```
Side Project → db-f1-micro (shared, cheap)
Growing      → db-custom-2-4096 (dedicated)
Scale        → Read replicas + connection pooling
```

**Firestore:**
- Scales automatically
- Good for real-time sync (mobile)
- More expensive at scale

### Scaling Database Tips

1. **Add connection pooling early** (PgBouncer/PgCat)
2. **Use read replicas** for read-heavy workloads
3. **Add caching** (Redis/Memorystore) before scaling DB
4. **Optimize queries** before throwing hardware at it

## API Gateway & Auth

### Current Setup
- Cloud Run handles HTTP directly
- Firebase Auth for mobile (optional)

### Production Considerations
- Consider API Gateway for rate limiting
- Add CDN (Cloud CDN/Cloudflare) for static content
- Implement proper API versioning early

## Mobile Considerations

### iOS
- App Store review takes 1-3 days
- Force update mechanism for breaking changes
- Offline support for poor connectivity

### Android
- Play Store review usually faster
- Similar considerations to iOS
- Consider gradual rollouts

## Monitoring & Observability

### Minimum Viable Monitoring

```bash
# These are configured in CI/CD
- Health checks (already done)
- Error tracking (add Sentry)
- Basic metrics (Cloud Run provides)
```

### Production Monitoring

- Structured logging (already uses Zap)
- Distributed tracing (OpenTelemetry)
- Custom metrics (Prometheus/Cloud Monitoring)
- Alerting (PagerDuty/Opsgenie)

## Security Checklist

### Pre-Launch
- [ ] No secrets in code (use Secret Manager)
- [ ] HTTPS everywhere
- [ ] Auth on all protected endpoints
- [ ] Input validation
- [ ] Rate limiting
- [ ] Security headers (CORS, CSP)

### Production
- [ ] Vulnerability scanning in CI
- [ ] Dependency updates automated
- [ ] Audit logging
- [ ] Penetration testing
- [ ] Incident response plan

## Cost Optimization

### Cloud Run
```
# Minimum instances (prevent cold starts, costs money)
--min-instances=1  # ~$25/month for always-on

# Maximum instances (prevent runaway costs)
--max-instances=10

# CPU allocation
--cpu-throttling  # Cheaper, only pay for request time
```

### Database
- Use connection pooling
- Right-size instances
- Archive old data
- Use appropriate indexes

## Disaster Recovery

### Basics
1. **Backups**: Enable automated backups for Cloud SQL
2. **Multi-AZ**: Cloud Run does this automatically
3. **Runbooks**: Document recovery procedures

### Data
```bash
# Cloud SQL automated backups
gcloud sql instances patch INSTANCE --backup-start-time=02:00

# Point-in-time recovery window
gcloud sql instances patch INSTANCE --retained-backups-count=7
```

## Deployment Strategy

### Current: Direct Deploy
Simple but has downtime risk.

### Production: Blue-Green / Canary
Cloud Run supports traffic splitting:
```bash
# Deploy new version
gcloud run deploy myapp --tag=v2

# Send 10% traffic
gcloud run services update-traffic myapp --to-tags=v2=10

# Full rollout
gcloud run services update-traffic myapp --to-tags=v2=100
```

## What's NOT Included (Yet)

This template focuses on getting to production. You'll need to add:

- [ ] Proper database migrations
- [ ] Feature flags
- [ ] A/B testing
- [ ] Analytics
- [ ] Multi-tenant support
- [ ] Internationalization

## Contributing

This guide is a work in progress. Please share:
- What worked for you
- What you wish you knew earlier
- Your scaling war stories

Open an issue or PR!

---

**Last Updated**: 2026-01-02
