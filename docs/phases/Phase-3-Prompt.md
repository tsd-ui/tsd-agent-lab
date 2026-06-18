---
aliases: 
tags: 
---
# Phase 3—Local harness v0

The first harness should be boring: clone repo, create run directory, create report, no pushing.

## Prompt 3A—Create task spec format

```markdown
Design a simple local task specification format for this agent lab.

Create:
- `schemas/task.schema.json`
- `examples/tasks/read-only-codebase-map.yaml`
- `examples/tasks/bugfix-patch-only.yaml`
- `examples/tasks/review-only.yaml`
- `docs/task-format.md`

The task spec should support:
- task_id
- title
- mode: read-only | patch-only | branch-only | draft-pr
- repo_url
- base_ref
- working_directory
- agent: codex | claude | gemini | opencode | manual
- prompt_file
- allowed_commands
- denied_commands
- verification_commands
- max_runtime_minutes
- expected_outputs
- notes

Security:
- Default mode should be read-only.
- No tokens in task files.
- No secrets in task files.
- Make it clear that branch/draft-pr modes require explicit human approval.

Keep the schema understandable and not over-engineered.
```

## Prompt 3B—Create run directory and report generator

```markdown
Implement the first local harness utilities.

Create:
- `harness/create-run.sh`
- `harness/write-report.sh`
- `harness/lib/common.sh`
- `docs/harness.md`
- `examples/reports/example-run-report.md`

Requirements:
- `create-run.sh` accepts a task file path.
- It validates basic required fields using `yq` if available, otherwise does a minimal fallback check.
- It creates a timestamped run directory under `~/workspaces/runs` by default.
- It copies the task file into the run directory.
- It creates placeholders for:
  - `agent-output.md`
  - `verification.log`
  - `summary.md`
  - `changed-files.txt`
- It prints the run directory path.
- It must not clone repos yet.
- It must not run agents yet.
- It must not require sudo.
- It must be idempotent where practical.

Add basic smoke tests or a documented manual test if automated testing is too much for now.
```

## Prompt 3C—Add safe clone/worktree support

```markdown
Extend the local harness to support safe repository preparation.

Create or update:
- `harness/prepare-repo.sh`
- `harness/lib/git.sh`
- `docs/harness.md`
- `examples/tasks/read-only-codebase-map.yaml`

Requirements:
- Accept a task file.
- Clone the configured repo into `~/workspaces/repos` if not already present.
- Fetch the requested base ref.
- Create a detached or isolated worktree for the run under the run directory.
- Never modify the original repo checkout directly.
- Never push.
- Never create branches on remote.
- Print clear next steps.
- Support a dry-run flag.
- Fail safely if the repo URL is missing.
- Warn if the repo is not in the allowlist, but do not implement hard enforcement yet.

Also update docs with examples.
```
