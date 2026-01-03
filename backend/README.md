# Backend API

Minimal Go API with Echo framework, ready for production deployment.

## Quick Start

```bash
# Install dependencies
make deps

# Run locally
make run

# Check health
curl http://localhost:8080/health
```

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check (for load balancers) |
| GET | `/api/v1/health` | API health with version |
| GET | `/api/v1/hello?name=X` | Hello endpoint example |

## Development

```bash
# Format code
make fmt

# Run tests
make test

# Run with hot reload (requires air)
make dev
```

## Docker

```bash
# Build image
make docker-build

# Run container
make docker-run
```

## Project Structure

```
backend/
├── cmd/
│   └── api/
│       └── main.go      # Entry point
├── internal/            # Private packages (add as needed)
├── Dockerfile           # Multi-stage build
├── Makefile            # Build commands
├── go.mod              # Dependencies
└── README.md
```

## Adding New Endpoints

1. Add route in `RegisterRoutes()` in `main.go`
2. For larger APIs, create handlers in `internal/handlers/`
3. Use dependency injection via FX for services

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Server port |
| `ENV` | `development` | Environment (development/production) |

## Deployment

This API is ready for:
- **Cloud Run** - Uses PORT env var, has health check
- **Kubernetes** - Distroless image, non-root user
- **Docker Compose** - Standard Dockerfile
