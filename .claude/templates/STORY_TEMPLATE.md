# Story Template - Full SDLC

**Use For**: Cross-platform features (Backend + iOS/Android + Web), 3-5 days work

---

## Story Information

**Story ID**: [ID]
**Title**: [Story title]
**Platforms Affected**: [Backend / iOS / Android / Web / All]

---

## SDLC Workflow

### Phase 1: Context Loading

- [ ] Fetch Linear/GitHub issue for context
- [ ] Read CLAUDE.md (principles and rules)
- [ ] Read task-specific guides
- [ ] Create TodoWrite tasks from acceptance criteria

**Session Start Comment Template:**
```markdown
## Session Start - [Date/Time]

**Context Loaded:**
- ✅ Reviewed issue
- ✅ Read CLAUDE.md guidelines
- ✅ Read guides: [list]

**TodoWrite Tasks Created:**
[Copy todo list here]

**Approach**: [Brief description of implementation approach]
```

---

### Phase 2: Architecture Review

- [ ] What is Source of Truth? (Edit source, regenerate derived)
- [ ] What is Impact Radius? (What systems affected?)
- [ ] What Could Go Wrong? (Edge cases, failure modes)
- [ ] If OpenAPI change: Plan spec updates first

---

### Phase 3: Implementation

**Backend:**
- [ ] Update OpenAPI spec if API changes
- [ ] Regenerate code: `make generate`
- [ ] Implement handler/service logic
- [ ] Use generated types

**iOS/Android:**
- [ ] Use generated API client
- [ ] Implement UI components
- [ ] Handle errors gracefully

**Web:**
- [ ] Use generated API client
- [ ] Implement React components
- [ ] Handle errors gracefully

---

### Phase 4: Testing

- [ ] Unit tests (>80% coverage for new code)
- [ ] Integration tests (real network calls)
- [ ] Manual testing on all platforms
- [ ] Cross-platform verification

---

### Phase 5: Code Review

- [ ] Self-review against CLAUDE.md rules
- [ ] OpenAPI-first workflow followed
- [ ] Error handling correct
- [ ] No security issues

---

### Phase 6: Deploy & Verify

- [ ] Commit with descriptive message
- [ ] Push to branch
- [ ] Create PR if needed
- [ ] Deploy to dev environment
- [ ] Verify deployment works
- [ ] Monitor logs for errors

---

### Phase 7: Retrospective (MANDATORY)

**What worked well:**
- [List what went smoothly]

**What didn't work:**
- [List issues encountered]

**Improvements made:**
- [ ] Updated documentation: [what]
- [ ] Added automation: [what]
- [ ] Fixed process gap: [what]

---

## Quality Gates (Must Pass Before "Done")

- [ ] All platforms implemented
- [ ] Tests pass (all platforms)
- [ ] Coverage >80% for new code
- [ ] Cross-platform verified
- [ ] OpenAPI compliance
- [ ] Retrospective done with actionable improvements
- [ ] Deployed & verified
