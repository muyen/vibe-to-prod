---
allowed-tools: Read, Grep, Glob
description: Comprehensive code quality review with security, performance, and architecture analysis
argument-hint: [file or directory to review]
model: sonnet
---

# Code Review

Review code quality for: $ARGUMENTS

## Current Changes

- Modified files: !`git diff --name-only HEAD~1 2>/dev/null || git diff --name-only`

## Review Dimensions

### 1. Security (Critical)
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on all user inputs
- [ ] SQL injection / NoSQL injection prevention
- [ ] XSS prevention in any output
- [ ] Auth checks on protected endpoints

### 2. Code Quality
- [ ] Single responsibility principle
- [ ] Proper error handling
- [ ] Appropriate logging
- [ ] Testable design
- [ ] No code duplication

### 3. Performance
- [ ] No N+1 queries
- [ ] Appropriate caching
- [ ] Reasonable data sizes
- [ ] No unnecessary computation

### 4. Maintainability
- [ ] Clear naming conventions
- [ ] Reasonable function/file sizes
- [ ] Documentation for complex logic
- [ ] Follows project patterns

## Process

1. Read the files to review
2. Check against each dimension
3. Identify issues by severity
4. Provide actionable feedback

## Output Format

```markdown
## Code Review Summary

### Critical Issues
- [Blocking issues that must be fixed]

### Warnings
- [Non-blocking but should address]

### Suggestions
- [Optional improvements]

### Good Practices Observed
- [What was done well]
```
