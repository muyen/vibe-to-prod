---
allowed-tools: Read, Write, Edit, Bash
argument-hint: [file-path] | [component-name]
description: Generate comprehensive test suite with unit, integration, and edge case coverage
---

# Generate Tests

Generate tests for: $ARGUMENTS

## Detect Platform

Based on the file path, determine which testing framework to use:

### Backend (Go)
- File pattern: `backend/**/*.go`
- Test file: `*_test.go` in same directory
- Framework: Go testing + testify

### iOS (Swift)
- File pattern: `mobile/ios/**/*.swift`
- Test file: `*Tests.swift` in test directory
- Framework: XCTest

### Android (Kotlin)
- File pattern: `mobile/android/**/*.kt`
- Test file: `*Test.kt` in test directory
- Framework: JUnit + MockK

## Backend (Go) Tests

### Unit Test Template

```go
package domain_test

import (
    "context"
    "testing"

    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestFunctionName(t *testing.T) {
    t.Run("success case", func(t *testing.T) {
        // Arrange
        ctx := context.Background()

        // Act
        result, err := FunctionUnderTest(ctx, input)

        // Assert
        require.NoError(t, err)
        assert.Equal(t, expected, result)
    })

    t.Run("error case", func(t *testing.T) {
        // Test error scenarios
    })
}
```

### Run Backend Tests

```bash
cd backend && go test ./... -v
cd backend && go test ./... -short  # Skip integration tests
```

## iOS (Swift) Tests

### Unit Test Template

```swift
import XCTest
@testable import App

final class ComponentTests: XCTestCase {
    var sut: ComponentUnderTest!

    override func setUp() {
        super.setUp()
        sut = ComponentUnderTest()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSuccessCase() {
        // Arrange
        let input = ...

        // Act
        let result = sut.method(input)

        // Assert
        XCTAssertEqual(result, expected)
    }
}
```

## Android (Kotlin) Tests

### Unit Test Template

```kotlin
import org.junit.Test
import org.junit.Assert.*

class ComponentTest {

    @Test
    fun `success case returns expected result`() {
        // Arrange
        val sut = ComponentUnderTest()

        // Act
        val result = sut.method(input)

        // Assert
        assertEquals(expected, result)
    }
}
```

## Test Coverage Requirements

| Type | Required Coverage |
|------|-------------------|
| Service logic | 80%+ |
| Repository | 70%+ |
| Handlers | 60%+ |
| Utils | 90%+ |

## Process

1. Read the target file to understand functionality
2. Identify all testable functions/methods
3. Check existing test patterns in codebase
4. Create test file following project conventions
5. Implement tests: happy path, error cases, edge cases
6. Run tests to verify they pass
7. Report coverage improvement
