---
name: OpenSpec: Archive
description: Archive a deployed OpenSpec change and update specs.
category: OpenSpec
tags: [openspec, archive]
---

# OpenSpec Archive

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- Refer to `openspec/AGENTS.md` for additional conventions or clarifications.

**Steps**
1. Determine the change ID to archive:
   - If this prompt already includes a specific change ID, use that value.
   - Otherwise, run `ls openspec/changes/` to list available changes.
   - Confirm which change the user intends to archive.
2. Verify the change is complete:
   - All tasks marked done
   - Tests pass
   - Code merged
3. Move the change folder to `openspec/changes/archive/`:
   ```bash
   mv openspec/changes/<id> openspec/changes/archive/
   ```
4. Update any specs that were affected by this change.
5. Commit the archive with a clear message.

**Post-Archive Checklist**
- [ ] Change moved to archive/
- [ ] Specs updated if needed
- [ ] Commit created
