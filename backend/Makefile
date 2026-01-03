# Backend Makefile
# Minimal commands for Go API development

.PHONY: deps fmt test build run clean docker-build docker-run lint

# Go commands
GOCMD=go
BINARY_NAME=server
MAIN_PATH=./cmd/api

# Default target
all: deps fmt test build

# Install/update dependencies
deps:
	$(GOCMD) mod download
	$(GOCMD) mod tidy

# Format code
fmt:
	$(GOCMD) fmt ./...

# Run linter (requires golangci-lint)
lint:
	golangci-lint run ./...

# Run tests
test:
	$(GOCMD) test -v ./...

# Run tests with coverage
test-coverage:
	$(GOCMD) test -v -coverprofile=coverage.out ./...
	$(GOCMD) tool cover -html=coverage.out -o coverage.html

# Build binary
build:
	$(GOCMD) build -o build/$(BINARY_NAME) $(MAIN_PATH)

# Build for production (optimized)
build-prod:
	CGO_ENABLED=0 GOOS=linux $(GOCMD) build \
		-ldflags="-s -w" \
		-trimpath \
		-o build/$(BINARY_NAME) $(MAIN_PATH)

# Run locally
run:
	$(GOCMD) run $(MAIN_PATH)

# Run with hot reload (requires air: go install github.com/air-verse/air@latest)
dev:
	air

# Clean build artifacts
clean:
	$(GOCMD) clean
	rm -rf build/
	rm -f coverage.out coverage.html

# Docker commands
docker-build:
	docker build -t myapp:latest .

docker-run:
	docker run -p 8080:8080 -e ENV=development myapp:latest

# Health check
health:
	curl -s http://localhost:8080/health | jq .

# === SECURITY ===

# Run gosec security scanner
security-scan:
	@if command -v gosec &> /dev/null; then \
		gosec ./...; \
	else \
		echo "gosec not installed. Run: go install github.com/securego/gosec/v2/cmd/gosec@latest"; \
	fi

# Run govulncheck for vulnerability scanning
vuln-check:
	@if command -v govulncheck &> /dev/null; then \
		govulncheck ./...; \
	else \
		echo "govulncheck not installed. Run: go install golang.org/x/vuln/cmd/govulncheck@latest"; \
	fi

# Run all security checks
security: security-scan vuln-check

# === DOCUMENTATION ===

# Generate API docs (requires @redocly/cli)
docs:
	@../scripts/generate-api-docs.sh

# Serve API docs locally
docs-serve:
	@echo "Serving API docs at http://localhost:8000"
	@cd api/docs && python3 -m http.server 8000

# Help
help:
	@echo "Available targets:"
	@echo ""
	@echo "  DEVELOPMENT:"
	@echo "    deps          - Download and tidy dependencies"
	@echo "    fmt           - Format code"
	@echo "    lint          - Run linter (golangci-lint)"
	@echo "    run           - Run locally"
	@echo "    dev           - Run with hot reload (requires air)"
	@echo ""
	@echo "  BUILD:"
	@echo "    build         - Build binary"
	@echo "    build-prod    - Build optimized production binary"
	@echo "    docker-build  - Build Docker image"
	@echo "    docker-run    - Run Docker container"
	@echo ""
	@echo "  TEST:"
	@echo "    test          - Run tests"
	@echo "    test-coverage - Run tests with coverage report"
	@echo ""
	@echo "  SECURITY:"
	@echo "    security-scan - Run gosec security scanner"
	@echo "    vuln-check    - Run govulncheck vulnerability scan"
	@echo "    security      - Run all security checks"
	@echo ""
	@echo "  DOCUMENTATION:"
	@echo "    docs          - Generate API docs from OpenAPI"
	@echo "    docs-serve    - Serve API docs locally"
	@echo ""
	@echo "  OTHER:"
	@echo "    clean         - Clean build artifacts"
	@echo "    health        - Check health endpoint"
