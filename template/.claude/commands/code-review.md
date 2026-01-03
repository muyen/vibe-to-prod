---
allowed-tools: Read, Bash, Grep
argument-hint: [file-path or PR-number]
description: Comprehensive code quality review with security, performance, and architecture analysis
---

# Code Review

Review: $ARGUMENTS

## Review Checklist

### 1. Correctness
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] Error handling appropriate
- [ ] No obvious bugs

### 2. Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] No SQL/command injection
- [ ] Auth/authz checks in place

### 3. Performance
- [ ] No N+1 queries
- [ ] Appropriate caching
- [ ] No memory leaks
- [ ] Efficient algorithms

### 4. Architecture
- [ ] Follows project patterns
- [ ] Proper separation of concerns
- [ ] Dependencies injected correctly
- [ ] No circular dependencies

### 5. Readability
- [ ] Clear naming
- [ ] Functions not too long
- [ ] Complex logic commented
- [ ] Consistent style

### 6. Testing
- [ ] Tests exist for new code
- [ ] Edge cases tested
- [ ] Tests are meaningful

## Process

1. Read the code thoroughly
2. Check against each category
3. Note issues with file:line references
4. Suggest improvements
5. Highlight good practices

## Output Format

```
## Code Review: [file/PR]

### Summary
[Brief overview of the code]

### Issues Found

#### Critical
- [file:line] Issue description

#### Warnings
- [file:line] Issue description

#### Suggestions
- [file:line] Suggestion

### Good Practices
- [What's done well]

### Verdict
[ ] Approved
[ ] Approved with suggestions
[ ] Changes requested
```
