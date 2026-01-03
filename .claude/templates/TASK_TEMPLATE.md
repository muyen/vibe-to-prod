# Task Template - Simplified SDLC

**Use For**: Single-platform work (Backend OR iOS OR Web), 2-8 hours

---

## Task Information

**Task ID**: [ID]
**Title**: [Task title]
**Platform**: [Backend / iOS / Android / Web]

---

## Simplified SDLC (6 Phases)

### Phase 1: Context Loading

- [ ] Fetch issue for context
- [ ] Read CLAUDE.md
- [ ] Create TodoWrite subtasks

---

### Phase 2: Implementation

**Backend:**
- [ ] Use generated types
- [ ] Follow error handling patterns
- [ ] Update TodoWrite as tasks complete

**iOS/Android:**
- [ ] Use generated API client
- [ ] Follow platform patterns
- [ ] Update UI components

**Web:**
- [ ] Use generated API client
- [ ] Follow Next.js/React patterns
- [ ] Handle errors gracefully

---

### Phase 3: Unit Tests

- [ ] Write tests for new logic (>80% coverage)
- [ ] Mock external dependencies
- [ ] Test edge cases
- [ ] Run: `make test` / `npm test`

---

### Phase 4: Integration Tests (If Needed)

- [ ] Test with real backend
- [ ] Test happy path + error scenarios
- [ ] Verify UI updates correctly

---

### Phase 5: Deploy & Verify

- [ ] Commit with descriptive message
- [ ] Push to branch
- [ ] Deploy to dev
- [ ] Verify feature works
- [ ] Check logs for errors

---

### Phase 6: Light Retrospective (MANDATORY)

**What worked:**
- [Thing that went smoothly]

**What didn't work:**
- [Issue - how to prevent next time?]

**Improvement made:**
- [ ] Updated [guide/file]: [what changed]
- [ ] Created [script/helper]: [what it does]
- [ ] Added [checklist item]: [where]

**⚠️ If no improvement listed, retrospective is INCOMPLETE**

---

## Quality Gates

- [ ] Implementation complete
- [ ] Unit tests pass (>80% coverage)
- [ ] Build succeeds
- [ ] Deployed & verified
- [ ] Retrospective done with improvement
