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

# Help
help:
	@echo "Available targets:"
	@echo "  deps          - Download and tidy dependencies"
	@echo "  fmt           - Format code"
	@echo "  lint          - Run linter"
	@echo "  test          - Run tests"
	@echo "  test-coverage - Run tests with coverage report"
	@echo "  build         - Build binary"
	@echo "  build-prod    - Build optimized production binary"
	@echo "  run           - Run locally"
	@echo "  dev           - Run with hot reload (requires air)"
	@echo "  clean         - Clean build artifacts"
	@echo "  docker-build  - Build Docker image"
	@echo "  docker-run    - Run Docker container"
	@echo "  health        - Check health endpoint"
