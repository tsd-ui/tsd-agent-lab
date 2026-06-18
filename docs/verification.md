# Verification

`harness/verify-run.sh` runs the verification commands defined in a task specification inside the run's worktree. It captures output to `verification.log` and updates `run-metadata.json` with the result.

## Defining Verification Commands

Add a `verification_commands` list to your task YAML:

```yaml
verification_commands:
  - "npm test"
  - "git diff --stat"
  - "test -f agent-output.md"
```

Commands run sequentially inside the worktree. The runner stops on the first failure (fail-fast).

## Usage

```bash
./harness/verify-run.sh <task-file> --run-dir <run-dir> [--dry-run]
```

### Examples

```bash
# Run verification
./harness/verify-run.sh examples/tasks/bugfix-patch-only.yaml --run-dir "$RUN_DIR"

# Preview commands without executing
./harness/verify-run.sh examples/tasks/bugfix-patch-only.yaml --run-dir "$RUN_DIR" --dry-run
```

## How It Works

1. Reads `verification_commands` from the task YAML.
2. For each command, performs a soft policy check against `policies/command-allowlist.yaml` (warns but does not block).
3. Runs the command inside the worktree, appending output to `verification.log`.
4. On first failure, stops and records the failing command.
5. Updates `run-metadata.json` with:

| Field | Description |
|-------|-------------|
| `verification_result` | `passed`, `failed`, or `skipped` |
| `verified_at` | ISO 8601 timestamp |
| `status` | Updated to `verified` or `verification-failed` |

## Policy Checking

Each command's base executable is checked against `policies/command-allowlist.yaml`. In Phase 4, this is a **soft check** — it logs a warning if the command is not in the allowlist but does not block execution. Hard enforcement is planned for a future phase.

## Failure Handling

- **Fail-fast:** The runner stops at the first failed command. This is intentional — later commands may depend on earlier ones.
- **Output preserved:** All output (including from the failed command) is captured in `verification.log`.
- **No cleanup:** The runner does not revert changes on failure. The worktree remains in its current state for inspection.

## Verification Log Format

```
# Verification Results

Started: 2026-06-18T14:30:22Z

$ npm test
---
<command output>

[PASS] exit code: 0

$ git diff --stat
---
<command output>

[PASS] exit code: 0

---

## Summary

Total:  2
Passed: 2
Failed: 0

Finished: 2026-06-18T14:30:45Z
```

## Tasks Without Verification Commands

If the task does not define `verification_commands`, the runner records `verification_result: skipped` and does not change the run status.
