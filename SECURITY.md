# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

1. **Do NOT** open a public GitHub issue
2. Email security concerns to the repository maintainers
3. Include as much detail as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 1 week
- **Resolution Timeline**: Depends on severity
  - Critical: 24-48 hours
  - High: 1 week
  - Medium: 2 weeks
  - Low: Next release

## Security Best Practices

When using this template, ensure you:

1. **Never commit secrets** - Use environment variables
2. **Keep dependencies updated** - Run `npm audit` and `go mod tidy` regularly
3. **Review security headers** - Check `next.config.mjs` for CSP settings
4. **Enable branch protection** - Require PR reviews before merging
5. **Use HTTPS everywhere** - All API calls should use TLS

## Security Features Included

This template includes:

- Content Security Policy headers
- CORS configuration
- Input validation patterns
- Secure authentication examples
- Environment variable management
- `.gitignore` for sensitive files
