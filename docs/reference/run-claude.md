---
aliases: 
tags: 
---
# Running Claude

`harness/run-claude.sh` invokes Claude Code against a prepared task. It composes a safety-bounded prompt and runs `claude -p` inside the task's isolated worktree.

## Prerequisites

- **Claude CLI** installed and on `PATH` ([installation guide](https://docs.anthropic.com/en/docs/claude-code))
- **jq** for JSON manipulation
- A run directory created by `create-run.sh`
- A worktree prepared by `prepare-repo.sh`

## Usage

```bash
./harness/run-claude.sh <task-file> --run-dir <run-dir> [--dry-run]
```

### Examples

```bash
# Full run
RUN_DIR=$(./harness/create-run.sh examples/tasks/read-only-codebase-map.yaml)
./harness/prepare-repo.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"
./harness/run-claude.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"

# Preview without executing
./harness/run-claude.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR" --dry-run
```

## How Prompts Are Composed

1. The runner resolves the prompt file—either from the task's `prompt_file` field, or by deriving a default from `agent` + `mode`.
2. It concatenates the safety preamble (`prompts/common/safety-preamble.md`) with the task prompt.
3. The composed prompt is written to `composed-prompt.md` in the run directory for auditability.
4. Claude receives the composed prompt via stdin: `claude -p --output-format text < composed-prompt.md`.

See [docs/prompts.md](prompts.md) for the full prompt system documentation.

## What It Does

1. Validates the task agent is `claude-code`
2. Resolves the worktree from `run-metadata.json`
3. Resolves the prompt file (explicit or default-by-mode)
4. Composes safety preamble + task prompt into `composed-prompt.md`
5. Runs `claude -p` inside the worktree, capturing output to `agent-output.md`
6. Applies mode-based tool restrictions (e.g., `review-only` adds `--disallowedTools` and `--max-budget-usd`)
7. Updates `run-metadata.json` with exit code, timestamps, and status

## Run Metadata Updates

After execution, `run-metadata.json` gains these fields:

| Field | Description |
|-------|-------------|
| `status` | `agent-complete`, `agent-timeout`, or `agent-failed` |
| `agent` | Agent name (e.g., `claude-code`) |
| `agent_exit_code` | Process exit code |
| `agent_started_at` | ISO 8601 start timestamp |
| `agent_finished_at` | ISO 8601 end timestamp |

## Safety Notes

- The agent runs inside an isolated, detached worktree—no branch to push.
- The safety preamble is always prepended, regardless of the task prompt.
- If `max_runtime_minutes` is set in the task, the runner uses `timeout` to enforce it.
- The runner only supports `agent: claude-code`. Other agents will be rejected.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `Claude CLI not found` | Install Claude Code and ensure `claude` is on your PATH |
| `Cannot resolve prompt` | Set `prompt_file` in the task or use a supported mode |
| `Worktree directory not found` | Run `prepare-repo.sh` before `run-claude.sh` |
| `Agent timed out` | Increase `max_runtime_minutes` in the task or remove it |
