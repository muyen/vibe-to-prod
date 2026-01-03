import XCTest
@testable import App

/// Sample test class demonstrating XCTest patterns.
/// Follow AAA pattern: Arrange, Act, Assert.
final class AppTests: XCTestCase {

    // MARK: - Example Tests

    /// Test naming: test{Scenario}_{Result}
    func testExample_ReturnsExpectedValue() {
        // Arrange
        let input = "Hello"
        let expected = "Hello, World!"

        // Act
        let result = "\(input), World!"

        // Assert
        XCTAssertEqual(result, expected)
    }

    /// Test async operations
    func testAsyncOperation_Completes() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Async operation completes")

        // Act
        Task {
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            expectation.fulfill()
        }

        // Assert
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        // Setup code before each test
    }

    override func tearDown() {
        // Cleanup code after each test
        super.tearDown()
    }
}
