---
allowed-tools: Read, Bash, Grep, Glob
argument-hint: [backend|ios|android|all]
description: Run security scan for specified platform - checks for secrets, vulnerabilities, and security best practices
model: sonnet
---

# Security Scan

Security scan for: $ARGUMENTS

---

## Scan Scope

### Backend (Go) Security Checks

1. **Hardcoded Secrets**: Search for API keys, tokens, passwords in code
2. **SQL/NoSQL Injection**: Check database queries for unsafe inputs
3. **Auth Bypass**: Verify authentication middleware on protected routes
4. **Input Validation**: Check for missing validation at API boundaries
5. **Dependencies**: Check for known vulnerabilities

### iOS (Swift) Security Checks

1. **Hardcoded Secrets**: Search for API keys in code
2. **Insecure Storage**: Check for Keychain usage vs UserDefaults
3. **Network Security**: Verify ATS settings in Info.plist
4. **Debug Code**: Check for print statements with sensitive data

### Android (Kotlin) Security Checks

1. **Hardcoded Secrets**: Search for API keys in code
2. **Insecure Storage**: Check for EncryptedSharedPreferences usage
3. **Network Security**: Check for cleartext traffic settings
4. **ProGuard/R8**: Verify obfuscation for release builds

---

## Quick Scan Commands

**Backend:**
```bash
# Check for hardcoded secrets
grep -rn --include="*.go" -E "(api[_-]?key|secret|password|token)\s*[:=]\s*\"[^\"]+\"" backend/

# Check for potential SQL injection (if using raw queries)
grep -rn --include="*.go" "fmt.Sprintf.*SELECT\|fmt.Sprintf.*INSERT\|fmt.Sprintf.*UPDATE" backend/
```

**iOS:**
```bash
# Check for hardcoded secrets
grep -rn --include="*.swift" -E "(api[_-]?key|secret|password|token)\s*[:=]\s*\"[^\"]+\"" mobile/ios/

# Check for UserDefaults with sensitive data
grep -rn --include="*.swift" "UserDefaults.*password\|UserDefaults.*token\|UserDefaults.*key" mobile/ios/
```

**Android:**
```bash
# Check for hardcoded secrets
grep -rn --include="*.kt" -E "(api[_-]?key|secret|password|token)\s*[:=]\s*\"[^\"]+\"" mobile/android/

# Check for SharedPreferences with sensitive data
grep -rn --include="*.kt" "SharedPreferences.*password\|SharedPreferences.*token" mobile/android/
```

---

## Instructions

1. Run appropriate security checks based on argument (backend, ios, android, or all)
2. Report findings by severity:
   - 🔴 **Critical**: Immediate action required
   - 🟠 **High**: Should fix before release
   - 🟡 **Medium**: Should fix soon
   - 🟢 **Low**: Consider fixing
3. Provide specific file:line references
4. Suggest remediations for each issue

---

## Common Security Issues

### Critical

| Issue | Impact | Fix |
|-------|--------|-----|
| Hardcoded API keys | Key exposure in git | Use environment variables |
| No auth on endpoints | Unauthorized access | Add middleware |
| Cleartext passwords | Password theft | Hash with bcrypt |

### High

| Issue | Impact | Fix |
|-------|--------|-----|
| Missing input validation | Injection attacks | Validate all inputs |
| Insecure token storage | Token theft | Use secure storage |
| Debug logs with secrets | Secret exposure | Remove before release |

---

## Security Best Practices

### All Platforms

- Never commit secrets to git
- Use environment variables or secret managers
- Validate all external input
- Use HTTPS everywhere
- Keep dependencies updated

### Backend Specific

- Use parameterized queries (not string concatenation)
- Implement rate limiting
- Use proper CORS configuration
- Hash passwords with bcrypt/argon2

### Mobile Specific

- Use Keychain (iOS) / EncryptedSharedPreferences (Android)
- Certificate pinning for sensitive APIs
- Obfuscate release builds
- Disable debug features in production

---

## Output Format

```
## Security Scan Results

### 🔴 Critical Issues
[List critical issues with file:line and remediation]

### 🟠 High Issues
[List high issues]

### 🟡 Medium Issues
[List medium issues]

### 🟢 Low Issues
[List low issues]

### ✅ Passed Checks
[List what passed]
```
