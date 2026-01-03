# OpenSpec Instructions

Instructions for AI coding assistants using OpenSpec for spec-driven development.

## TL;DR Quick Checklist

- Search existing work: `openspec list`, `openspec spec list`
- Decide scope: new capability vs modify existing capability
- Pick a unique `change-id`: kebab-case, verb-led (`add-`, `update-`, `remove-`, `refactor-`)
- Scaffold: `proposal.md`, `tasks.md`, `design.md` (only if needed), and delta specs
- Write deltas: use `## ADDED|MODIFIED|REMOVED Requirements`
- Validate before requesting approval
- Request approval: Do not start implementation until proposal is approved

## Three-Stage Workflow

### Stage 1: Creating Changes

Create proposal when you need to:
- Add features or functionality
- Make breaking changes (API, schema)
- Change architecture or patterns
- Optimize performance (changes behavior)
- Update security patterns

Skip proposal for:
- Bug fixes (restore intended behavior)
- Typos, formatting, comments
- Dependency updates (non-breaking)
- Configuration changes
- Tests for existing behavior

**Workflow**
1. Review `openspec/project.md` and `openspec list` to understand current context
2. Choose a unique verb-led `change-id` and scaffold files under `openspec/changes/<id>/`
3. Draft spec deltas using `## ADDED|MODIFIED|REMOVED Requirements`
4. Validate and resolve issues before sharing

### Stage 2: Implementing Changes

Track these steps as TODOs and complete them one by one:
1. **Read proposal.md** - Understand what's being built
2. **Read design.md** (if exists) - Review technical decisions
3. **Read tasks.md** - Get implementation checklist
4. **Implement tasks sequentially** - Complete in order
5. **Confirm completion** - Ensure every item in `tasks.md` is finished
6. **Update checklist** - Set every task to `- [x]`
7. **Approval gate** - Do not start implementation until approved

### Stage 3: Archiving Changes

After deployment:
- Move `changes/[name]/` → `changes/archive/YYYY-MM-DD-[name]/`
- Update `specs/` if capabilities changed

## Directory Structure

```
openspec/
├── project.md              # Project conventions
├── AGENTS.md               # This file - AI instructions
├── specs/                  # Current truth - what IS built
│   └── [capability]/
│       └── spec.md         # Requirements and scenarios
├── changes/                # Proposals - what SHOULD change
│   ├── [change-name]/
│   │   ├── proposal.md     # Why, what, impact
│   │   ├── tasks.md        # Implementation checklist
│   │   └── specs/          # Delta changes
│   └── archive/            # Completed changes
```

## Creating Change Proposals

### Proposal Structure

1. **Create directory:** `changes/[change-id]/`

2. **Write proposal.md:**
```markdown
# Change: [Brief description]

## Why
[1-2 sentences on problem/opportunity]

## What Changes
- [Bullet list of changes]
- [Mark breaking changes with **BREAKING**]

## Impact
- Affected specs: [list capabilities]
- Affected code: [key files/systems]
```

3. **Create tasks.md:**
```markdown
## 1. Implementation
- [ ] 1.1 Task description
- [ ] 1.2 Task description
```

4. **Create design.md when needed** (cross-cutting changes, new dependencies, security/performance concerns)

## Spec File Format

### Requirements with Scenarios

```markdown
### Requirement: Feature Name
The system SHALL provide...

#### Scenario: Success case
- **WHEN** user performs action
- **THEN** expected result
```

### Delta Operations

- `## ADDED Requirements` - New capabilities
- `## MODIFIED Requirements` - Changed behavior
- `## REMOVED Requirements` - Deprecated features

## Best Practices

### Simplicity First
- Default to <100 lines of new code
- Single-file implementations until proven insufficient
- Avoid frameworks without clear justification

### Clear References
- Use `file.ts:42` format for code locations
- Reference specs as `specs/[capability]/spec.md`

### Capability Naming
- Use verb-noun: `user-auth`, `api-endpoints`
- Single purpose per capability
- Split if description needs "AND"

## Quick Reference

### CLI Commands (if available)
```bash
openspec list              # What's in progress?
openspec show [item]       # View details
openspec validate          # Is it correct?
openspec archive [id]      # Mark complete
```

### Stage Indicators
- `changes/` - Proposed, not yet built
- `specs/` - Built and deployed
- `archive/` - Completed changes

Remember: Specs are truth. Changes are proposals. Keep them in sync.
