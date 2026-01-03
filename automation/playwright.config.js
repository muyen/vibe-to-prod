// @ts-check
const { defineConfig } = require('@playwright/test');

/**
 * Playwright configuration for E2E tests
 * @see https://playwright.dev/docs/test-configuration
 */
module.exports = defineConfig({
  testDir: './playwright/tests',

  /* Run tests in parallel */
  fullyParallel: true,

  /* Fail the build on CI if you accidentally left test.only in the source code */
  forbidOnly: !!process.env.CI,

  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,

  /* Reporter to use */
  reporter: [
    ['html', { outputFolder: 'reports/playwright' }],
    ['list']
  ],

  /* Shared settings for all the projects below */
  use: {
    /* Base URL to use in actions like `await page.goto('/')` */
    baseURL: process.env.BASE_URL || 'http://localhost:8080',

    /* Collect trace when retrying the failed test */
    trace: 'on-first-retry',

    /* Screenshot on failure */
    screenshot: 'only-on-failure',
  },

  /* Configure projects for different environments */
  projects: [
    {
      name: 'api',
      testMatch: /.*\.api\.spec\.js/,
    },
    {
      name: 'e2e',
      testMatch: /.*\.e2e\.spec\.js/,
      use: {
        /* Use chromium for browser tests */
        browserName: 'chromium',
      },
    },
  ],

  /* Run local dev server before starting the tests */
  // webServer: {
  //   command: 'cd ../backend && make run',
  //   url: 'http://localhost:8080/health',
  //   reuseExistingServer: !process.env.CI,
  // },
});
