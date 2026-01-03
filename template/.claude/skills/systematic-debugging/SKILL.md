---
name: systematic-debugging
description: Systematic debugging with 4-phase root cause analysis. Triggers when bugs are reported, errors encountered, or unexpected behavior observed.
---

# Systematic Debugging Skill

Apply structured 4-phase debugging to find root causes, not just symptoms.

## When to Activate

This skill should activate when:
- User reports a bug or unexpected behavior
- Error messages or stack traces appear
- Tests are failing
- User says "fix", "debug", "broken", "not working", "issue"
- Behavior differs from expected

## 4-Phase Debugging Process

### Phase 1: REPRODUCE
```
Before fixing anything:
1. Understand the expected behavior
2. Understand the actual behavior
3. Find reliable reproduction steps
4. Identify the exact error/symptom
```

**Questions to answer:**
- What should happen?
- What actually happens?
- Can I reproduce it consistently?
- What are the exact steps?

### Phase 2: ISOLATE
```
Narrow down the problem:
1. Find the smallest reproduction case
2. Identify which component/layer fails
3. Check recent changes (git log, git diff)
4. Add logging/debugging to trace execution
```

**Techniques:**
- Binary search through code changes
- Add strategic logging
- Comment out code sections
- Test with minimal input

### Phase 3: IDENTIFY ROOT CAUSE
```
Find the actual cause, not symptoms:
1. Follow the data flow
2. Check assumptions
3. Verify inputs/outputs at each step
4. Ask "why" 5 times
```

**Common root causes:**
| Symptom | Likely Root Cause |
|---------|-------------------|
| 404 on API | Route not registered |
| Type mismatch | Wrong type conversion |
| Null pointer | Uninitialized variable |
| Race condition | Missing synchronization |
| Auth failure | Token/session expired |

### Phase 4: FIX AND VERIFY
```
Fix properly:
1. Write a test that reproduces the bug
2. Implement the fix
3. Verify the test passes
4. Check for similar issues elsewhere
5. Prevent regression
```

## Debugging Commands

### Backend (Go)
```bash
# Run with verbose logging
go run ./cmd/api/main.go

# Run specific test with verbose output
go test -v -run TestName ./...

# Add debug logging
zap.L().Debug("checkpoint", zap.Any("data", data))
```

### iOS (Swift)
```swift
// Debug print (visible in Xcode console)
#if DEBUG
print("DEBUG: \(variable)")
#endif
```

### Android (Kotlin)
```kotlin
// Debug logging
Log.d("TAG", "Debug: $variable")
```

## Process

1. **Don't guess** - Reproduce first
2. **Don't fix symptoms** - Find root cause
3. **Verify assumptions** - Check each step
4. **Test the fix** - Write regression test
5. **Check for similar issues** - Fix all instances

## Output Format

```
## Bug Analysis

**Symptom**: [what user reported]
**Reproduction**: [steps to reproduce]

### Investigation
- [ ] Reproduced: [yes/no]
- [ ] Isolated to: [component/file]
- [ ] Root cause: [actual cause]

### Fix
- **File**: [file:line]
- **Change**: [what was changed]
- **Test**: [test that prevents regression]

### Verification
- [ ] Original issue fixed
- [ ] No new issues introduced
- [ ] Similar code checked
```
