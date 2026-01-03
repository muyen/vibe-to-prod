---
name: code-review
description: Proactive code quality review. Triggers on significant code changes to check security, performance, architecture, and project patterns.
---

# Code Review Skill

Automatically reviews code quality when significant changes are made.

## When to Activate

This skill should activate when:
- User writes or modifies 50+ lines of code
- User implements a new feature or handler
- User asks for code review or feedback
- Changes touch authentication, payments, or security

## Review Dimensions

### 1. Security (Critical)
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on all user inputs
- [ ] SQL injection / NoSQL injection prevention
- [ ] XSS prevention in any output
- [ ] Auth checks on protected endpoints

### 2. Project Patterns (Critical)
- [ ] Generated types used (not `map[string]interface{}`)
- [ ] Routes registered properly
- [ ] Response schemas defined correctly
- [ ] OpenAPI spec updated for API changes

### 3. Performance
- [ ] No N+1 queries
- [ ] Appropriate indexes for queries
- [ ] Reasonable pagination limits
- [ ] No unnecessary data fetching

### 4. Architecture
- [ ] Single responsibility principle
- [ ] Proper error handling
- [ ] Appropriate logging
- [ ] Testable design

### 5. Platform Specific

**Backend (Go)**
- [ ] Uses Echo framework patterns
- [ ] Proper middleware usage
- [ ] Structured logging with Zap

**iOS (Swift)**
- [ ] SwiftUI best practices
- [ ] Source files < 400 lines
- [ ] Proper state management

**Android (Kotlin)**
- [ ] Jetpack Compose patterns
- [ ] Proper DI configuration
- [ ] Feature parity with iOS

**Web (TypeScript)**
- [ ] Next.js conventions followed
- [ ] Proper typing (no `any`)
- [ ] React best practices

## Output Format

```markdown
## Code Review Summary

### Critical Issues
- [List any blocking issues]

### Warnings
- [List non-blocking concerns]

### Suggestions
- [List optional improvements]

### Pattern Compliance
- [Check against CLAUDE.md rules]
```

## Reference

See `.claude/commands/code-review.md` for detailed review criteria.
