---
name: OpenSpec: Proposal
description: Scaffold a new OpenSpec change and validate strictly.
category: OpenSpec
tags: [openspec, change]
---

# OpenSpec Proposal

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- Refer to `openspec/AGENTS.md` for additional conventions or clarifications.
- Identify any vague or ambiguous details and ask the necessary follow-up questions before editing files.
- Do not write any code during the proposal stage. Only create design documents (proposal.md, tasks.md, design.md). Implementation happens in the apply stage after approval.

**Steps**
1. Review `openspec/project.md` and inspect related code or docs to ground the proposal in current behavior; note any gaps that require clarification.
2. Choose a unique verb-led `change-id` and scaffold `proposal.md`, `tasks.md`, and `design.md` (when needed) under `openspec/changes/<id>/`.
3. Map the change into concrete capabilities or requirements.
4. Capture architectural reasoning in `design.md` when the solution spans multiple systems, introduces new patterns, or demands trade-off discussion.
5. Draft `tasks.md` as an ordered list of small, verifiable work items that deliver user-visible progress.
6. Validate the proposal is complete and ready for review.

**Proposal Template**
```markdown
# [Change Title]

## Summary
One-line description of the change.

## Motivation
Why is this change needed?

## Proposed Solution
What are we doing?

## Impact
- Files affected
- Dependencies
- Risk level

## Tasks
- [ ] Task 1
- [ ] Task 2
```
