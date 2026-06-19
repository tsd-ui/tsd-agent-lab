---
aliases: []
tags: []
---
# Superpowers-Style Workflows

A guide to structured, reusable agent capabilities in the TSD Agent Lab.

## What Are Superpowers-Style Workflows?

Superpowers-style workflows are pre-defined, structured agent capabilities that can be invoked on demand. Instead of giving an agent open-ended instructions, you point it at a skill document that specifies exactly what to do, what to produce, and what constraints to follow. This makes agent behavior predictable, reviewable, and repeatable.

The term "Superpowers" refers to the pattern of packaging agent capabilities as discrete, reusable units—not to any specific product.

## Skills by Enhancement Tier

Skills follow a progressive enhancement model, starting with safe read-only operations and advancing to more powerful modes:

### Tier 1: Read-Only

No file modifications. Safe to run against any repo at any time.

| Skill | Purpose |
|-------|---------|
| [codebase-map](../skills/codebase-map/SKILL.md) | Explore and document a repository's structure |
| [pr-review](../skills/pr-review/SKILL.md) | Review code changes and produce a findings report |

### Tier 2: Patch-Only

Creates or modifies files but does not commit, push, or create PRs. Changes require human review.

| Skill | Purpose |
|-------|---------|
| [bugfix-minimal](../skills/bugfix-minimal/SKILL.md) | Fix a bug with minimal code changes |
| [test-generation](../skills/test-generation/SKILL.md) | Generate tests without modifying production source |
| [adr-writer](../skills/adr-writer/SKILL.md) | Draft an Architecture Decision Record |

### Future Tiers

These tiers are planned but not yet implemented:

- **Tier 3: Commit-Allowed** — Agent can commit to a local branch (requires Phase 7)
- **Tier 4: PR-Creation** — Agent can create draft PRs for review (requires Phase 8)

## Manual Invocation Patterns

### Pipe via `cat | claude -p`

Compose the safety preamble with a skill and pipe to Claude Code:

```bash
cat prompts/common/safety-preamble.md skills/bugfix-minimal/SKILL.md | claude -p
```

### Reference in task YAML

Set the `prompt_file` field in a task specification:

```yaml
prompt_file: skills/test-generation/SKILL.md
```

The harness runner prepends the safety preamble automatically.

### Ask the agent in-session

During an interactive Claude Code session:

```
Follow the workflow in skills/pr-review/SKILL.md to review the changes on this branch.
```

## Portability Across Agents

Skills are written as plain markdown with no agent-specific features. This makes them portable:

| Agent | How to Use Skills |
|-------|-------------------|
| **Claude Code** | Pipe via `cat \| claude -p` or reference in-session |
| **Fullsend** | Place in `.agents/skills/` directory; `fullsend_role` maps to agent roles |
| **Gemini / OpenCode** | Copy SKILL.md and follow the workflow steps as markdown instructions |

The key to portability is that skills specify *what to do* (read files, analyze code, write output) rather than *how to invoke agent-specific APIs*. Any LLM that can read files and follow instructions can execute a skill.

## Evaluation Criteria

How to judge whether a skill execution was successful:

| Criterion | What to Check |
|-----------|---------------|
| **Correctness** | Is the output factually accurate? |
| **Completeness** | Are all expected sections and findings present? |
| **Safety** | Did the agent respect mode constraints? |
| **Usefulness** | Is the output actionable for a human? |
| **Efficiency** | Did the agent avoid unnecessary steps or tool calls? |
| **Consistency** | Does repeated execution produce similar quality? |

Phase 6 introduces systematic evaluation using [agent-eval-harness](https://github.com/opendatahub-io/agent-eval-harness), which provides multi-judge scoring, baseline comparison, and regression detection.

## Progressive Enhancement Strategy

The lab uses progressive enhancement to manage risk as agent capabilities expand:

```
read-only → patch-only → commit-allowed → PR-creation → autonomous
```

Each tier grants more capability and requires more trust:

1. **Read-only** (Phases 0-4): Agent can only observe. Zero risk of unintended changes.
2. **Patch-only** (Phase 5): Agent can modify files locally. Human reviews all changes before they go anywhere.
3. **Commit-allowed** (Phase 7): Agent can commit to local branches. Human reviews before push.
4. **PR-creation** (Phase 8): Agent can create draft PRs. Human reviews before merge.
5. **Autonomous** (future): Agent handles end-to-end with guardrails. Highest trust required.

Start every new skill at the lowest tier that accomplishes the task. Promote to a higher tier only after the skill has proven reliable at the current tier.

## Relationship to Other Lab Components

| Component | Relationship to Skills |
|-----------|----------------------|
| **Safety preamble** (`prompts/common/safety-preamble.md`) | Skills reference preamble rules by number; preamble is prepended at invocation |
| **Task format** (`docs/task-format.md`) | Tasks specify which skill to use via `prompt_file` |
| **Harness** (`harness/`) | Runner composes and invokes skills; verifier checks output |
| **Policies** (`policies/`) | Command and repo allowlists constrain what skills can access |
| **Existing prompts** (`prompts/claude/`) | Three skills expand on Phase 4 prompts; both systems coexist |

## Future Directions

- **Phase 6:** Systematic evaluation — use agent-eval-harness to score skill executions, establish baselines, and detect regressions
- **Phase 9:** Multi-agent comparison — run the same skill across Claude Code, Gemini, and OpenCode to compare output quality
- **Phase 13:** Fullsend hosted lane — skills move to Fullsend's `.agents/skills/` format for hosted execution with secure credential delivery
