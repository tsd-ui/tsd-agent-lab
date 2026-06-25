# Write a Skill

How to create a reusable `SKILL.md` that any LLM-based coding agent can follow.

## What Is a Skill?

A skill is a plain markdown file that specifies exactly what an agent should do, what it should produce, and what constraints it must follow. Skills are portable — they work with Claude Code, Fullsend, or any LLM that can read files and follow instructions.

The lab has five skills today: `codebase-map`, `bugfix-minimal`, `test-generation`, `pr-review`, `adr-writer`. See [skills/README.md](../../skills/README.md).

## Enhancement Tiers

Start at the lowest tier that accomplishes the task. Promote only after the skill proves reliable at the current tier.

| Tier | Mode | What the agent can do |
|------|------|----------------------|
| **1 — Read-only** | `read-only` | Observe only, zero risk of changes |
| **2 — Patch-only** | `patch-only` | Modify files locally, human reviews before anything goes anywhere |
| **3 — Commit-allowed** | `commit-allowed` | Commit to local branch, human reviews before push |
| **4 — PR-creation** | branch + PR | Create draft PRs, human reviews before merge |

## Step-by-Step Creation

### 1. Create the directory

```bash
mkdir skills/your-skill-name
```

Use a lowercase kebab-case name that describes the task (e.g., `doc-updater`, `migration-checker`).

### 2. Write SKILL.md

Create `skills/your-skill-name/SKILL.md` with this structure:

```markdown
---
name: your-skill-name
description: One-line summary of what this skill does
fullsend_role: code|review|triage|quality
---

# Display Name

## Description

2–3 sentences explaining what this skill does and why you'd use it.

## When to Use

- Situation A
- Situation B

## When Not to Use

- Situation X (too risky for this tier)
- Situation Y (out of scope)

## Workflow

1. Read the relevant files: [list them]
2. Analyze [what to look for]
3. Produce [expected output format]
4. Verify [self-check steps]

## Expected Output

Describe what the agent should produce: a report, modified files, a new file, etc.
Include format (markdown, YAML, etc.) and approximate length.

## Safety Constraints

This skill runs in [mode] mode. The agent MUST NOT:
- Push or create remote branches
- Commit changes (if patch-only)
- Modify files outside the specified paths

Follows rules [N] and [M] from prompts/common/safety-preamble.md.

## Verification

How to check the output is correct:
- [ ] All expected sections present
- [ ] No files modified outside allowed scope
- [ ] Output is accurate and actionable

## Notes

Portability notes, Fullsend integration context, known limitations.
```

### 3. Add to the skill index

In `skills/README.md`, add a row to the Skill Index table:

```markdown
| [your-skill-name](your-skill-name/SKILL.md) | patch-only | code | Brief description |
```

### 4. Manual testing

```bash
# Quick test via pipe
cat prompts/common/safety-preamble.md skills/your-skill-name/SKILL.md | claude -p

# Or via a task YAML (recommended — exercises the full harness)
# Add `prompt_file: skills/your-skill-name/SKILL.md` to a task file and run it
```

Check that the output matches your **Expected Output** section and that the agent stayed within the mode constraints.

### 5. Set up evaluation (optional but recommended)

```
/eval-analyze --skill your-skill-name
/eval-dataset
/eval-run
```

See [test-a-skill.md](test-a-skill.md) for the full eval workflow.

## Tips

- Keep the **Workflow** section concrete — numbered steps, not paragraphs
- The **Safety Constraints** section is what keeps the agent in bounds; be specific
- If the skill needs supporting files (templates, examples), add them to `skills/your-skill-name/references/`
- Test with `--dry-run` before the first real run
