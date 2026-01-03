// @ts-check
const { test, expect } = require('@playwright/test');

/**
 * API Health Check Tests
 *
 * These tests verify the backend API is responding correctly.
 * Run with: npm test
 */

test.describe('Health Endpoints', () => {
  test('GET /health returns ok', async ({ request }) => {
    const response = await request.get('/health');

    expect(response.ok()).toBeTruthy();
    expect(response.status()).toBe(200);

    const body = await response.json();
    expect(body.status).toBe('ok');
  });

  test('GET /api/v1/health returns ok with version', async ({ request }) => {
    const response = await request.get('/api/v1/health');

    expect(response.ok()).toBeTruthy();
    expect(response.status()).toBe(200);

    const body = await response.json();
    expect(body.status).toBe('ok');
    expect(body.version).toBeDefined();
  });
});

test.describe('Hello Endpoint', () => {
  test('GET /api/v1/hello returns default greeting', async ({ request }) => {
    const response = await request.get('/api/v1/hello');

    expect(response.ok()).toBeTruthy();

    const body = await response.json();
    expect(body.message).toBe('Hello, World!');
  });

  test('GET /api/v1/hello?name=Test returns personalized greeting', async ({ request }) => {
    const response = await request.get('/api/v1/hello?name=Test');

    expect(response.ok()).toBeTruthy();

    const body = await response.json();
    expect(body.message).toBe('Hello, Test!');
  });
});

test.describe('Error Handling', () => {
  test('GET /nonexistent returns 404', async ({ request }) => {
    const response = await request.get('/nonexistent');

    expect(response.status()).toBe(404);
  });
});

test.describe('Security Headers', () => {
  test('Response includes security headers', async ({ request }) => {
    const response = await request.get('/health');

    const headers = response.headers();

    // Check security headers are present
    expect(headers['x-content-type-options']).toBe('nosniff');
    expect(headers['x-frame-options']).toBe('DENY');
    expect(headers['x-xss-protection']).toBe('1; mode=block');
  });
});
