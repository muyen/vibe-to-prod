# Testing Guide

> ⚠️ **Work in Progress**: This testing infrastructure is being built out. Contributions welcome!

## Quick Start

```bash
# Backend tests
cd backend && make test

# Smoke tests (requires backend running)
./scripts/smoke-test.sh backend

# All smoke tests
./scripts/smoke-test.sh all
```

## Test Pyramid

```
        /\
       /  \     E2E Tests (slow, few)
      /----\
     /      \   Integration Tests
    /--------\
   /          \ Unit Tests (fast, many)
  /__________\
```

## Current Status

| Platform | Unit Tests | Integration | E2E | Status |
|----------|------------|-------------|-----|--------|
| Backend (Go) | ✅ Basic | ✅ Basic | 🚧 | In progress |
| iOS (Swift) | 🚧 | 🚧 | 🚧 | Needs work |
| Android (Kotlin) | 🚧 | 🚧 | 🚧 | Needs work |
| Infrastructure | 🚧 | - | - | Needs work |

## Backend (Go)

### Running Tests

```bash
cd backend

# All tests
make test

# With coverage
make test-coverage

# Specific package
go test ./internal/handlers/... -v
```

### Test Structure

```
backend/
├── internal/
│   ├── handlers/
│   │   ├── health.go
│   │   ├── health_test.go      # Unit tests
│   │   ├── hello.go
│   │   └── hello_test.go       # Unit tests
│   ├── integration/
│   │   └── api_test.go         # Integration tests
│   └── testutil/
│       └── testutil.go         # Test helpers
```

### Writing Tests

Follow the AAA pattern:

```go
func TestHandler_Action_Result(t *testing.T) {
    // Arrange
    e := echo.New()
    req := httptest.NewRequest(http.MethodGet, "/path", nil)
    rec := httptest.NewRecorder()
    c := e.NewContext(req, rec)

    // Act
    err := handler.Action(c)

    // Assert
    require.NoError(t, err)
    assert.Equal(t, http.StatusOK, rec.Code)
}
```

## Smoke Tests

Quick validation that services are running:

```bash
# Start backend first
cd backend && make run

# In another terminal
./scripts/smoke-test.sh backend
```

What smoke tests check:
- ✅ Health endpoints responding
- ✅ API returning expected JSON structure
- ✅ Error codes (404, 405) working correctly
- ✅ Basic query parameter handling

## Load Testing (TODO)

We plan to add k6 for load testing:

```bash
# Future: k6 load test
k6 run tests/load/api-load.js
```

## Security Testing

```bash
cd backend

# Security scan
make security-scan

# Vulnerability check
make vuln-check

# All security
make security
```

## CI/CD Integration

Tests run automatically on:
- Push to backend/ios/android paths
- Pull requests

See `.github/workflows/` for CI configuration.

## Contributing

We need help with:
- [ ] iOS XCTest unit tests
- [ ] Android JUnit tests
- [ ] E2E test framework selection
- [ ] Load testing setup
- [ ] API contract testing

Please open issues or PRs!

---

**Last Updated**: 2026-01-02
