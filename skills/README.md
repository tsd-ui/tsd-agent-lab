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
├── adr-writer/
│   └── SKILL.md           # Architecture Decision Record drafting
├── stale-docs-check/
│   └── SKILL.md           # Documentation staleness review
├── broken-builds/
│   └── SKILL.md           # CI failure diagnosis and reporting
└── pr-risk-triage/
    └── SKILL.md           # Fleet-wide PR risk scoring and triage
```

## Skill Index

| Skill | Mode | Fullsend Role | Description |
|-------|------|---------------|-------------|
| [codebase-map](codebase-map/SKILL.md) | read-only | triage | Explore a repo and produce a structured map |
| [bugfix-minimal](bugfix-minimal/SKILL.md) | patch-only | code | Fix a bug with the smallest possible change |
| [test-generation](test-generation/SKILL.md) | patch-only | quality | Generate tests without modifying production source |
| [pr-review](pr-review/SKILL.md) | read-only | review | Review code changes with severity-ranked findings |
| [adr-writer](adr-writer/SKILL.md) | patch-only | code | Draft an ADR following the project's format |
| [stale-docs-check](stale-docs-check/SKILL.md) | read-only | review | Cross-reference docs against repo state, report stale/review findings |
| [broken-builds](broken-builds/SKILL.md) | read-only | triage | Diagnose CI build failures from a structured JSON data bundle |
| [pr-risk-triage](pr-risk-triage/SKILL.md) | read-only | triage | Score open PRs for merge risk and produce a prioritized triage report |

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

## Pipelines

Some skills are the scoring/analysis step of a larger automated pipeline. This section documents those end-to-end flows.

### PR Risk Triage Pipeline

The PR risk triage pipeline runs daily to score all open PRs across monitored repos and produce a prioritized triage report. It has five stages:

1. **`scripts/macos/generate-repo-inventory.sh`** -- Generates `policies/generated/repo-inventory.txt`, the list of repos to monitor.
2. **`collectors/pr-inventory/collect.sh`** -- The "pr-inventory collector". Reads the repo list, queries GitHub via the `gh` CLI for open PR metadata, and writes `pr-inventory-data-YYYY-MM-DD.json`.
3. **`skills/pr-risk-triage/SKILL.md`** -- The skill that scores the JSON bundle and produces the triage report.
4. **`scripts/macos/pr-risk-triage-skill-run.sh`** -- The orchestrator script that chains steps 1--3: refreshes the repo inventory if stale, runs the collector, locates the JSON bundle, then invokes Claude with the skill and data.
5. **`automations/jobs/pr-risk-triage.yaml`** -- Schedules the orchestrator to run daily at 5:45 AM.

The triage output categorizes PRs into recommendations (deep-review, scan-review, monitor). The actual review follow-through is performed by a human or by the separate [pr-review](pr-review/SKILL.md) skill.
