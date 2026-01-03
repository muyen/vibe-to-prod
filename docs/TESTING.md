# Testing Guide

This guide covers the testing strategy and patterns for all platforms in the vibe-to-prod template.

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
| Backend (Go) | ✅ | ✅ | ✅ | Complete |
| iOS (Swift) | ✅ | ✅ | ✅ | Complete |
| Android (Kotlin) | ✅ | ✅ | ✅ | Complete |
| Infrastructure | ✅ | - | - | Complete |

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

## iOS (Swift)

### Running Tests

```bash
cd mobile/ios

# Run all tests
xcodebuild test -scheme App -destination 'platform=iOS Simulator,name=iPhone 15'

# Or via make
make test
```

### Test Structure

```
mobile/ios/
├── App/
│   ├── Services/
│   │   ├── APIClient.swift
│   │   └── APIClientTests.swift     # Unit tests
│   └── ViewModels/
│       ├── HomeViewModel.swift
│       └── HomeViewModelTests.swift # Unit tests
└── AppTests/
    └── IntegrationTests/
        └── APIIntegrationTests.swift # Integration tests
```

### Writing Tests (XCTest)

```swift
import XCTest
@testable import App

final class UserServiceTests: XCTestCase {
    var sut: UserService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        // Arrange
        mockAPIClient = MockAPIClient()
        sut = UserService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func testFetchUser_ReturnsValidUser() async throws {
        // Arrange
        mockAPIClient.mockResponse = User(id: "1", name: "Test")

        // Act
        let user = try await sut.fetchUser(id: "1")

        // Assert
        XCTAssertEqual(user.id, "1")
        XCTAssertEqual(user.name, "Test")
    }

    func testFetchUser_ThrowsOnNetworkError() async {
        // Arrange
        mockAPIClient.mockError = NetworkError.noConnection

        // Act & Assert
        do {
            _ = try await sut.fetchUser(id: "1")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
```

### UI Testing

```swift
import XCTest

final class LoginUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLoginFlow_ValidCredentials_ShowsHome() {
        // Arrange & Act
        app.textFields["emailField"].tap()
        app.textFields["emailField"].typeText("test@example.com")
        app.secureTextFields["passwordField"].tap()
        app.secureTextFields["passwordField"].typeText("password123")
        app.buttons["loginButton"].tap()

        // Assert
        XCTAssertTrue(app.staticTexts["Welcome"].waitForExistence(timeout: 5))
    }
}
```

## Android (Kotlin)

### Running Tests

```bash
cd mobile/android

# Run unit tests
./gradlew test

# Run instrumented tests
./gradlew connectedAndroidTest

# Run specific test class
./gradlew test --tests "com.app.UserServiceTest"
```

### Test Structure

```
mobile/android/
└── app/
    └── src/
        ├── main/kotlin/com/app/
        │   ├── data/repository/
        │   └── ui/viewmodel/
        ├── test/kotlin/com/app/        # Unit tests
        │   ├── data/
        │   │   └── UserRepositoryTest.kt
        │   └── ui/
        │       └── HomeViewModelTest.kt
        └── androidTest/kotlin/com/app/ # Instrumented tests
            └── ui/
                └── LoginScreenTest.kt
```

### Writing Tests (JUnit5 + MockK)

```kotlin
import io.mockk.coEvery
import io.mockk.mockk
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class UserRepositoryTest {
    private lateinit var sut: UserRepository
    private lateinit var mockApiClient: ApiClient

    @BeforeEach
    fun setUp() {
        // Arrange
        mockApiClient = mockk()
        sut = UserRepository(mockApiClient)
    }

    @Test
    fun `fetchUser returns valid user`() = runTest {
        // Arrange
        val expectedUser = User(id = "1", name = "Test")
        coEvery { mockApiClient.getUser("1") } returns expectedUser

        // Act
        val result = sut.fetchUser("1")

        // Assert
        assertEquals(expectedUser, result)
    }

    @Test
    fun `fetchUser throws on network error`() = runTest {
        // Arrange
        coEvery { mockApiClient.getUser(any()) } throws NetworkException()

        // Act & Assert
        assertFailsWith<NetworkException> {
            sut.fetchUser("1")
        }
    }
}
```

### ViewModel Testing

```kotlin
import app.cash.turbine.test
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Test

class HomeViewModelTest {
    @Test
    fun `loadData updates state with users`() = runTest {
        // Arrange
        val mockRepository = mockk<UserRepository>()
        coEvery { mockRepository.getUsers() } returns listOf(User("1", "Test"))
        val viewModel = HomeViewModel(mockRepository)

        // Act & Assert
        viewModel.uiState.test {
            assertEquals(UiState.Loading, awaitItem())
            viewModel.loadData()
            val successState = awaitItem() as UiState.Success
            assertEquals(1, successState.users.size)
        }
    }
}
```

### UI Testing (Compose)

```kotlin
import androidx.compose.ui.test.*
import androidx.compose.ui.test.junit4.createComposeRule
import org.junit.Rule
import org.junit.Test

class LoginScreenTest {
    @get:Rule
    val composeTestRule = createComposeRule()

    @Test
    fun loginFlow_validCredentials_showsHome() {
        // Arrange
        composeTestRule.setContent {
            LoginScreen(onLoginSuccess = {})
        }

        // Act
        composeTestRule.onNodeWithTag("emailField")
            .performTextInput("test@example.com")
        composeTestRule.onNodeWithTag("passwordField")
            .performTextInput("password123")
        composeTestRule.onNodeWithText("Login")
            .performClick()

        // Assert
        composeTestRule.onNodeWithText("Welcome")
            .assertIsDisplayed()
    }
}
```

## E2E Testing

We recommend **Maestro** for cross-platform E2E testing:

### Why Maestro?

- Works on both iOS and Android
- Simple YAML-based test definitions
- No flaky waits - automatic synchronization
- Great error messages and screenshots

### Installation

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

### Writing E2E Tests

```yaml
# .maestro/login-flow.yaml
appId: com.yourapp
---
- launchApp
- tapOn: "Email"
- inputText: "test@example.com"
- tapOn: "Password"
- inputText: "password123"
- tapOn: "Login"
- assertVisible: "Welcome"
- takeScreenshot: login-success
```

### Running E2E Tests

```bash
# iOS Simulator
maestro test .maestro/

# Android Emulator
maestro test .maestro/ --platform android

# CI/CD
maestro cloud .maestro/ --app-file app.apk
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

Want to help improve the test suite? Here are some areas:

- [ ] Add more integration test examples
- [ ] Set up k6 load testing
- [ ] Add API contract testing with Pact
- [ ] Improve test coverage reporting

Please open issues or PRs!

---

**Last Updated**: 2026-01-03
