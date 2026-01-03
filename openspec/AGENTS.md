# OpenSpec - Change Management Framework

OpenSpec is a structured approach to managing changes in your codebase.

## Quick Start

1. **Propose a Change**: Create a proposal in `openspec/changes/[id]/proposal.md`
2. **Get Approval**: Review with your team
3. **Implement**: Follow the tasks in `tasks.md`
4. **Archive**: Move to `openspec/changes/archive/` when done

## Directory Structure

```
openspec/
├── AGENTS.md           # This file
├── project.md          # Project conventions
├── specs/              # Current capabilities
│   └── [capability]/
│       ├── spec.md     # Requirements
│       └── design.md   # Technical decisions
└── changes/            # Proposed changes
    ├── [change-id]/
    │   ├── proposal.md # What & why
    │   ├── tasks.md    # Implementation steps
    │   └── design.md   # Technical approach
    └── archive/        # Completed changes
```

## Creating a Change Proposal

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

## Benefits

- **Traceability**: Every change is documented
- **Review**: Easy to review before implementation
- **History**: Archive provides decision history
- **AI-Friendly**: Claude can read and follow proposals
