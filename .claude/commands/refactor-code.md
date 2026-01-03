---
allowed-tools: Read, Write, Edit, Bash
argument-hint: [file-path or description]
description: Refactor code with test coverage verification
---

# Refactor Code

Refactor: $ARGUMENTS

## Pre-Refactoring Checklist

- [ ] Tests exist for code being refactored
- [ ] Current tests pass
- [ ] Understand ALL usages of code

## Process

1. **Verify Test Coverage**
   ```bash
   # Backend
   cd backend && go test ./... -v

   # iOS - Build and run tests
   cd mobile/ios && make test

   # Android
   cd mobile/android && ./gradlew test
   ```

2. **Refactoring Techniques**
   - Extract Method/Function
   - Rename Variable/Method
   - Move Method/Field
   - Eliminate Dead Code
   - Simplify Conditionals

3. **Incremental Changes**
   - Small, focused changes
   - Run tests after EACH change
   - Commit working changes frequently

4. **Verify After Refactoring**
   - All tests still pass
   - No new linter warnings
   - Performance not degraded

## Patterns to Follow

**Backend (Go):**
- Keep handlers thin (delegate to services)
- Services contain business logic
- Repositories handle data access

**Mobile:**
- MVVM architecture
- Repository pattern for data
- Dependency injection via constructors

## Output

Provide:
1. Files modified
2. Summary of changes
3. Test results before/after
4. Any risks or considerations
