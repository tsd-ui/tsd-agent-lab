---
aliases: 
tags: 
---
# Phase 4—Claude runner mode

This is where the harness starts invoking Claude, but only locally and safely.

For the first version, keep it CLI/script based. Only move to more sophisticated programmatic control once you know the workflow is worth formalizing. The Claude API/SDK is useful later for internal tools and workflows, but start simple.

## Prompt 4A—Create prompt-file system

```markdown
Create a prompt-file system for local agent tasks.

Create:
- `prompts/claude/read-only-codebase-map.md`
- `prompts/claude/bugfix-patch-only.md`
- `prompts/claude/review-only.md`
- `prompts/common/safety-preamble.md`
- `docs/prompts.md`

The prompts should be designed for Claude Code CLI.

Rules common to all prompts:
- Respect the task mode
- Focus on local, safe experimentation
- Do not push branches
- Do not create PRs
- Do not install dependencies without explicit approval
- Do not use production secrets
- Prefer existing repo commands
- Document what you're building
- Record assumptions
- Produce a clear final report

For `read-only-codebase-map`:
- No edits.
- Summarize architecture, setup, test commands, risk areas, and likely good first agent tasks.

For `bugfix-patch-only`:
- Make minimal code changes only.
- Run relevant verification commands.
- Produce changed-files summary.

For `review-only`:
- No edits.
- Review for correctness, tests, maintainability, and likely regressions.

Keep the prompts reusable across repositories.
```

## Prompt 4B—Add Claude runner script

```markdown
Implement a local Claude runner script.

Create:
- `harness/run-claude.sh`
- `harness/lib/agent.sh`
- `docs/run-claude.md`

Requirements:
- Accept a task file and an existing run directory
- Locate the prepared worktree
- Locate the prompt file from the task spec
- Compose the common safety preamble plus task-specific prompt
- Save the composed prompt to the run directory
- Run Claude Code from inside the worktree
- Capture output to `agent-output.md`
- Support `--dry-run`
- If `claude` is not installed, fail with helpful instructions
- Make it clear in docs that this is intended to be run as the dedicated non-admin `agent-lab` user

Safety constraints:
- Do not push branches
- Do not create PRs
- Do not use sudo
- Start with read-only operations, then progress to patch-only
- Do not add GitHub Actions or daemon/queue behavior yet
```

## Prompt 4C—Add verification step

```markdown
Add a verification step to the harness.

Create or update:
- `harness/verify-run.sh`
- `harness/lib/verify.sh`
- `docs/verification.md`
- `examples/tasks/bugfix-patch-only.yaml`

Requirements:
- Read `verification_commands` from the task file.
- Run commands from inside the prepared worktree.
- Capture output to `verification.log`.
- Stop on failure, but preserve logs.
- Print a concise pass/fail summary.
- Do not install dependencies automatically.
- If a command is not allowed by policy, warn and skip it for now.
- Include a future TODO for hard policy enforcement.

Also update `harness/write-report.sh` so the final report includes:
- task metadata
- agent used
- mode
- changed files
- verification result
- known issues
- next recommended human action
```

---
