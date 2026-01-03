import type { NextConfig } from "next";
import path from "path";

const deploymentTarget = process.env.DEPLOYMENT_TARGET;
const isFirebaseHosting = deploymentTarget === "firebase";

const nextConfig: NextConfig = {
  // Set the output file tracing root to the web directory to avoid lockfile conflicts
  outputFileTracingRoot: path.join(__dirname),

  // Deployment targets:
  // - firebase: Standalone for Firebase Web Frameworks (supports dynamic routes via Cloud Functions)
  // - cloudrun: Standalone server for Cloud Run
  // - undefined: Default to standalone
  output: "standalone",

  // Optimize for serverless functions
  serverExternalPackages: [],

  // Configure Server Actions body size limit
  experimental: {
    serverActions: {
      bodySizeLimit: "10mb",
    },
  },

  // Add proper error handling for Cloud Functions
  onDemandEntries: {
    maxInactiveAge: 60 * 1000, // 1 minute
    pagesBufferLength: 2,
  },

  // Configure images for external domains
  images: {
    unoptimized: isFirebaseHosting,
    remotePatterns: [
      {
        protocol: "https",
        hostname: "storage.googleapis.com",
        port: "",
        pathname: "/**",
      },
      {
        protocol: "https",
        hostname: "firebasestorage.googleapis.com",
        port: "",
        pathname: "/**",
      },
      // Allow localhost for local development
      {
        protocol: "http",
        hostname: "localhost",
        port: "8080",
        pathname: "/api/v1/**",
      },
    ],
  },

  // Ensure trailing slash consistency
  trailingSlash: false,

  // Security headers (OWASP Reference: A05:2021 - Security Misconfiguration)
  async headers() {
    return [
      {
        source: "/:path*",
        headers: [
          // Prevent clickjacking attacks
          {
            key: "X-Frame-Options",
            value: "DENY",
          },
          // Prevent MIME type sniffing
          {
            key: "X-Content-Type-Options",
            value: "nosniff",
          },
          // Control referrer information
          {
            key: "Referrer-Policy",
            value: "strict-origin-when-cross-origin",
          },
          // Restrict browser features
          {
            key: "Permissions-Policy",
            value: "camera=(), microphone=(), geolocation=()",
          },
          // Content Security Policy - restrict resource loading
          {
            key: "Content-Security-Policy",
            value: [
              "default-src 'self'",
              "script-src 'self' 'unsafe-eval' 'unsafe-inline'",
              "style-src 'self' 'unsafe-inline'",
              "img-src 'self' data: blob: https://storage.googleapis.com https://firebasestorage.googleapis.com",
              "font-src 'self'",
              "connect-src 'self' https://*.googleapis.com https://*.firebaseio.com https://*.run.app wss://*.firebaseio.com",
              "frame-src 'self' https://accounts.google.com https://appleid.apple.com",
              "frame-ancestors 'none'",
            ].join("; "),
          },
          // Prevent XSS attacks (legacy, but still useful)
          {
            key: "X-XSS-Protection",
            value: "1; mode=block",
          },
        ],
      },
    ];
  },

  // Environment variables are loaded from .env.* files
  // No fallbacks - fail fast if NEXT_PUBLIC_API_URL is not set
};

export default nextConfig;
