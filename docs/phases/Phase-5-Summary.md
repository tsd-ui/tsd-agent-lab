---
aliases: []
tags: []
---
# Phase 5 Summary: Skills and Superpowers-Style Workflows

**Status:** Complete

## Deliverables

### Sub-phase 5A: Skills

| File | Mode | Fullsend Role | Description |
|------|------|---------------|-------------|
| `skills/codebase-map/SKILL.md` | read-only | triage | Explore a repo and produce a structured map |
| `skills/bugfix-minimal/SKILL.md` | patch-only | code | Fix a bug with the smallest possible change |
| `skills/test-generation/SKILL.md` | patch-only | quality | Generate tests without modifying production source |
| `skills/pr-review/SKILL.md` | read-only | review | Review code changes with severity-ranked findings |
| `skills/adr-writer/SKILL.md` | patch-only | code | Draft an ADR following the project's format |

Skills with existing prompt counterparts (codebase-map, bugfix-minimal, pr-review) expand on those prompts with additional structure, metadata, and safety references. Skills without counterparts (test-generation, adr-writer) are new.

### Sub-phase 5B: Documentation

| File | Description |
|------|-------------|
| `skills/README.md` | Skills directory overview, format reference, invocation guide, evaluation criteria |
| `docs/superpowers.md` | Superpowers-style workflow guide, progressive enhancement tiers, portability notes |

## Verification Checklist

- [x] All 5 SKILL.md files have YAML frontmatter with `name`, `description`, `fullsend_role`
- [x] All 5 SKILL.md files have all 8 required body sections (Description, When to Use, When Not to Use, Workflow, Expected Output, Safety Constraints, Verification, Notes)
- [x] Safety Constraints reference specific safety-preamble.md rule numbers
- [x] Skills with existing prompt counterparts are consistent with and expand on those prompts
- [x] `skills/README.md` indexes all 5 skills with mode and role
- [x] `docs/superpowers.md` covers progressive enhancement tiers, invocation patterns, portability, evaluation, and future directions
- [x] `README.md` shows Phase 5 complete and current phase as Phase 6
- [x] Fullsend role assignments are consistent (triage for exploration, code for file creation, review for reviews, quality for testing)

## Architecture Decisions

- **SKILL.md format over custom format:** YAML frontmatter matches Fullsend's required fields (`name`, `description`), avoiding a format migration when Fullsend integrates. `fullsend_role` is an informational extension.
- **Skills coexist with prompts:** The `prompts/claude/` directory from Phase 4 remains. Skills are the portable, detailed layer; prompts are the lightweight, harness-integrated layer. Teams can use either.
- **No scripts in skills:** Skills are pure markdown. No companion scripts, pre/post hooks, or runtime dependencies. This maximizes portability and simplifies review.
- **Safety rule references by number:** Skills reference specific safety-preamble.md rule numbers rather than restating rules. This avoids drift between the preamble and skill documents.
- **Fullsend role assignments:** `triage` for read-only exploration, `code` for file creation (including ADRs), `review` for code review, `quality` for testing. These map to Fullsend's agent role taxonomy.

## Next Steps

- **Phase 6:** First real pilot task — run skills against a real repository, evaluate output quality using agent-eval-harness, and establish baselines.
