package com.example.app

import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * Sample unit test class demonstrating JUnit patterns.
 * Follow AAA pattern: Arrange, Act, Assert.
 *
 * Run with: ./gradlew test
 */
class ExampleUnitTest {

    /**
     * Test naming: `scenario should result`
     */
    @Test
    fun `addition is correct`() {
        // Arrange
        val a = 2
        val b = 2

        // Act
        val result = a + b

        // Assert
        assertEquals(4, result)
    }

    @Test
    fun `string concatenation works`() {
        // Arrange
        val greeting = "Hello"
        val expected = "Hello, World!"

        // Act
        val result = "$greeting, World!"

        // Assert
        assertEquals(expected, result)
    }
}
