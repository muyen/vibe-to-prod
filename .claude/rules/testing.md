---
paths:
  - "**/*_test.go"
  - "**/*Test.kt"
  - "**/*Tests.swift"
  - "**/test/**"
  - "**/tests/**"
description: Rules for writing and maintaining tests
---

# Testing Rules

These rules apply when writing or modifying tests.

## Critical Rules

| Rule | Why | Instead |
|------|-----|---------|
| Test behavior, not implementation | Survives refactoring | Test outcomes |
| One assertion per test | Clear failures | Split into multiple tests |
| Table-driven for variations | DRY | Use test tables |
| Mock external deps only | Test real code | Don't mock everything |

## Test Naming

### Go
```go
func Test{Unit}_{Scenario}_{Result}(t *testing.T)
// Example: TestUserService_CreateUser_ReturnsID
```

### Swift
```swift
func test{Scenario}_{Result}()
// Example: func testCreateUser_ReturnsValidID()
```

### Kotlin
```kotlin
@Test
fun `scenario should result`()
// Example: fun `create user should return valid ID`()
```

## Test Structure (AAA Pattern)

All platforms follow Arrange-Act-Assert:

```go
func TestExample(t *testing.T) {
    // Arrange - setup
    input := "test"
    expected := "TEST"

    // Act - execute
    result := ToUpper(input)

    // Assert - verify
    assert.Equal(t, expected, result)
}
```

## What to Test

### Good Tests

| Type | Test This |
|------|-----------|
| Unit | Business logic, transformations |
| Integration | API endpoints, database queries |
| E2E | Critical user flows |

### Avoid Testing

| Type | Why | Instead |
|------|-----|---------|
| Implementation details | Breaks on refactor | Test outcomes |
| Third-party libraries | Not your code | Mock at boundary |
| Trivial code | No value | Focus on business logic |

## Performance Limits

| Type | Maximum Duration |
|------|-----------------|
| Unit test | 100ms |
| Integration test | 5s |
| E2E test | 30s |

## Test Commands

```bash
# Backend (Go)
cd backend && make test

# iOS (Swift)
cd mobile/ios && make test

# Android (Kotlin)
cd mobile/android && ./gradlew test
```

## Table-Driven Tests (Go)

```go
func TestValidation(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    bool
    }{
        {"valid email", "test@example.com", true},
        {"invalid email", "not-an-email", false},
        {"empty", "", false},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := IsValidEmail(tt.input)
            assert.Equal(t, tt.want, got)
        })
    }
}
```

## Mocking Guidelines

### Do Mock

- External API calls
- Database (for unit tests)
- Time-dependent code
- Random number generation

### Don't Mock

- Internal functions
- Data structures
- Pure functions
- Simple dependencies

## Quality Checklist

Before committing tests:

- [ ] Test prevents a real bug?
- [ ] Tests behavior, not implementation?
- [ ] Would app break visibly if test deleted?
- [ ] No flaky tests (random failures)?
- [ ] Fast enough for CI?
- [ ] Clear failure messages?
