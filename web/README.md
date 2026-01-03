# Web Application

Next.js web application deployed via **Firebase Hosting with Cloud Functions** for SSR.

## Architecture: Static + Dynamic

This web app uses Firebase's Web Frameworks feature which combines:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Firebase Hosting                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   Static Assets (CDN)          Dynamic Routes (Cloud Functions)     │
│   ┌─────────────────┐          ┌─────────────────────────────┐      │
│   │ - Images        │          │ - Server-side rendering     │      │
│   │ - CSS/JS        │  ───►    │ - API routes                │      │
│   │ - Static pages  │          │ - Dynamic pages             │      │
│   └─────────────────┘          └─────────────────────────────┘      │
│                                                                      │
│   Fast global CDN              Serverless, scales automatically     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

**Why this approach?**
- Static assets served from global CDN (fast)
- SSR pages run as Cloud Functions (dynamic)
- Single deployment command
- No server management
- Scales to zero when idle

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Next.js 14** | React framework with App Router |
| **TypeScript** | Type safety |
| **Tailwind CSS** | Utility-first styling |
| **React Query** | Server state management |
| **Zustand** | Client state management |
| **Vitest** | Unit testing |

## Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Open http://localhost:3000
```

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server with Turbopack |
| `npm run build` | Build for production |
| `npm run lint` | Run ESLint |
| `npm run type-check` | TypeScript type checking |
| `npm run test` | Run Vitest tests |
| `npm run generate:api` | Generate TypeScript types from OpenAPI spec |

## Project Structure

```
web/
├── src/
│   ├── app/              # Next.js App Router pages
│   │   ├── layout.tsx    # Root layout
│   │   └── page.tsx      # Home page
│   ├── components/       # React components
│   ├── constants/        # App constants
│   ├── hooks/            # Custom React hooks
│   ├── lib/              # Utilities and API client
│   ├── stores/           # Zustand state stores
│   ├── styles/           # Global styles
│   ├── tests/            # Test setup and utilities
│   └── types/            # TypeScript types (including generated API types)
├── public/               # Static assets
├── firebase.json         # Firebase Hosting configuration
├── next.config.ts        # Next.js configuration
├── vitest.config.ts      # Vitest configuration
└── Makefile              # Build and deployment commands
```

## Environment Variables

Copy `.env.example` to `.env.local`:

```bash
cp .env.example .env.local
```

| Variable | Required | Description |
|----------|----------|-------------|
| `NEXT_PUBLIC_API_URL` | Yes | Backend API URL |
| `NEXT_PUBLIC_FIREBASE_API_KEY` | No | Firebase client API key |
| `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` | No | Firebase auth domain |
| `NEXT_PUBLIC_FIREBASE_PROJECT_ID` | No | Firebase project ID |

## Deployment

### Prerequisites

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Update `PROJECT_ID_DEV` and `PROJECT_ID_PROD` in `Makefile`

### Deploy

```bash
# Deploy to development
make deploy-dev

# Deploy to production
make deploy-prod
```

### What happens during deployment

1. **Pre-deploy checks**: lint, type-check, tests
2. **Build**: Next.js builds with `output: "standalone"`
3. **Deploy**: Firebase CLI uploads:
   - Static assets → Firebase Hosting CDN
   - Server code → Cloud Functions (us-central1)

### Environments

| Environment | Firebase Project | Example URL |
|-------------|-----------------|-------------|
| Development | your-project-dev | https://your-project-dev.web.app |
| Production | your-project-prod | https://your-project-prod.web.app |

## Testing

```bash
# Run all tests
npm test

# Watch mode
npm run test:watch

# Coverage report
npm run test:coverage
```

Tests use Vitest with jsdom environment. See `src/tests/setup.ts` for configuration.

## API Type Generation

Generate TypeScript types from the backend OpenAPI spec:

```bash
npm run generate:api
```

This creates `src/types/api-types.ts` with typed API interfaces, ensuring frontend and backend stay in sync.

## Security Headers

OWASP-compliant security headers are configured in `next.config.ts`:

- X-Frame-Options: DENY (prevent clickjacking)
- X-Content-Type-Options: nosniff
- Content-Security-Policy (restrict resource loading)
- Referrer-Policy: strict-origin-when-cross-origin
- Permissions-Policy (restrict browser features)
