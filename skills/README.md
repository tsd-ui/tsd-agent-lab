---
aliases: []
tags: []
---
# Skills

Reusable, portable skill packages for agentic development workflows. Each skill is a self-contained directory with a `SKILL.md` that any LLM-based coding agent can follow.

## Directory Layout

```
skills/
├── README.md              # This file
├── codebase-map/
│   └── SKILL.md           # Read-only repo exploration
├── bugfix-minimal/
│   └── SKILL.md           # Minimal targeted bugfix
├── test-generation/
│   └── SKILL.md           # Test creation (no production changes)
├── pr-review/
│   └── SKILL.md           # Structured code review
└── adr-writer/
    └── SKILL.md           # Architecture Decision Record drafting
```

## Skill Index

| Skill | Mode | Fullsend Role | Description |
|-------|------|---------------|-------------|
| [codebase-map](codebase-map/SKILL.md) | read-only | triage | Explore a repo and produce a structured map |
| [bugfix-minimal](bugfix-minimal/SKILL.md) | patch-only | code | Fix a bug with the smallest possible change |
| [test-generation](test-generation/SKILL.md) | patch-only | quality | Generate tests without modifying production source |
| [pr-review](pr-review/SKILL.md) | read-only | review | Review code changes with severity-ranked findings |
| [adr-writer](adr-writer/SKILL.md) | patch-only | code | Draft an ADR following the project's format |

## SKILL.md Format

Every skill has a `SKILL.md` with this structure:

```markdown
---
name: kebab-case-name
description: one-line summary
fullsend_role: code|review|triage|quality
---

# Display Name

## Description        — 2-3 sentence overview
## When to Use        — appropriate use cases
## When Not to Use    — inappropriate situations
## Workflow           — numbered step-by-step instructions
## Expected Output    — what the agent produces
## Safety Constraints — references to safety-preamble.md rules
## Verification       — how to check the output
## Notes              — portability and integration context
```

YAML frontmatter fields (`name`, `description`) match Fullsend's required fields. `fullsend_role` is an informational extension documenting which Fullsend agent role this skill maps to.

## How to Add a New Skill

1. Create a directory under `skills/` with a kebab-case name
2. Add a `SKILL.md` following the format above
3. Include all 8 required body sections
4. Reference specific safety-preamble.md rule numbers in Safety Constraints
5. Add the skill to the index table in this README
6. Optionally add a `references/` subdirectory for supporting files

## How to Invoke a Skill

### Via the harness runner

Set `prompt_file` in your task YAML to the skill's `SKILL.md`:

```yaml
prompt_file: skills/codebase-map/SKILL.md
```

The harness runner (`harness/run-claude.sh`) prepends the safety preamble and pipes the composed prompt to `claude -p`.

### Manual invocation with Claude Code

```bash
cat prompts/common/safety-preamble.md skills/codebase-map/SKILL.md | claude -p
```

### In-session reference

Ask the agent to follow a skill during an interactive session:

```
Follow the workflow in skills/pr-review/SKILL.md to review the changes in this PR.
```

## How to Evaluate a Skill

Evaluate skills on these criteria:

- **Correctness:** Does the output contain accurate information?
- **Completeness:** Are all expected sections and findings present?
- **Safety:** Did the agent respect mode constraints (read-only, patch-only)?
- **Usefulness:** Is the output actionable for a human reviewer?
- **Efficiency:** Did the agent avoid unnecessary work?
- **Consistency:** Does repeated execution produce similar quality results?

Phase 6 introduces systematic evaluation using [agent-eval-harness](https://github.com/opendatahub-io/agent-eval-harness).

## How to Share Skills

Skills are plain markdown files, making them easy to share:

- **Obsidian vault:** Skills in this repo are accessible to anyone with vault access
- **Git PRs:** Propose new skills or improvements via pull requests
- **Copy-paste:** A SKILL.md is self-contained and can be copied to any project

## Fullsend Compatibility

Skills follow Fullsend's SKILL.md conventions for portability:

- Frontmatter uses Fullsend's required field names (`name`, `description`)
- `fullsend_role` documents the intended Fullsend agent role
- Skills can be placed in a Fullsend repo's `.agents/skills/` directory
- No dependency on Fullsend runtime—skills work standalone

When Fullsend integration arrives (Phase 13), these skills should work with minimal adaptation.

## Relationship to Prompts

The `prompts/claude/` directory contains harness-specific prompt files created in Phase 4. Three skills expand on those prompts:

| Skill | Source Prompt |
|-------|--------------|
| codebase-map | `prompts/claude/read-only-codebase-map.md` |
| bugfix-minimal | `prompts/claude/bugfix-patch-only.md` |
| pr-review | `prompts/claude/review-only.md` |

Both systems coexist. Prompts are lightweight and harness-integrated. Skills are portable, more detailed, and include metadata for cross-tool compatibility. Use whichever fits your workflow.
