# Automation & E2E Testing

> End-to-end testing, API testing, and automation scripts.

## Structure

```
automation/
├── playwright/          # Browser-based E2E tests
│   ├── tests/          # Test files
│   └── playwright.config.js
├── postman/            # API testing collections
│   ├── collections/    # Postman collections
│   └── environments/   # Environment configs
├── scripts/            # Automation scripts
├── docs/               # Test documentation
└── reports/            # Test reports (gitignored)
```

## Quick Start

### Install Dependencies

```bash
cd automation
npm install
```

### Run Playwright Tests

```bash
# Run all tests
npm test

# Run with UI
npm run test:ui

# Run specific test file
npx playwright test tests/health.spec.js
```

### Run Postman Tests

```bash
# Using Newman (Postman CLI)
npm run test:api

# Or import collections into Postman app
```

## Writing Tests

### Playwright (Browser E2E)

```javascript
// playwright/tests/example.spec.js
import { test, expect } from '@playwright/test';

test('health check', async ({ request }) => {
  const response = await request.get('/health');
  expect(response.ok()).toBeTruthy();
});
```

### Postman (API Testing)

Import the collections from `postman/collections/` into Postman, or run via Newman CLI.

## Environment Configuration

Tests use environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `BASE_URL` | API base URL | `http://localhost:8080` |
| `ENV` | Environment (dev/prod) | `dev` |

## CI Integration

Tests run automatically in CI:
- Playwright: On PR and push to main
- Postman: On PR and push to main

See `.github/workflows/` for CI configuration.

## Reports

Test reports are generated in `reports/` directory (gitignored).

- Playwright: HTML report at `reports/playwright/`
- Postman: Newman report at `reports/postman/`
