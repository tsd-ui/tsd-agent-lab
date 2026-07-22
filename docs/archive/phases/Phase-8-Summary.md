---
aliases: []
tags: []
---
# Phase 8 Summary: Draft PR Mode

**Status:** Complete

## Deliverables

### New files

| File | Action | Description |
|------|--------|-------------|
| `harness/create-draft-pr.sh` | Created | Confirmation-gated delivery script: previews repo/branch/base/title/body, then (with `--confirm-push`) pushes the branch and (with `--confirm-pr`) opens a draft PR via `gh pr create --draft`. Neutralizes @mentions in the PR body; assigns no reviewers/labels/assignees; supports `--force` and `--dry-run`; requires `mode == draft-pr`; reuses `create-local-branch.sh` for staging/branch/commit. |
| `docs/draft-pr-mode.md` | Created | End-to-end how-to for draft-pr mode. |
| `examples/tasks/pilot-draft-pr.yaml` | Created | Pilot task template for draft-pr mode (agent produces patch only; harness delivers PR). |

### Modified files

Wiring `draft-pr` alongside existing modes:

| File | Action | Description |
|------|--------|-------------|
| `harness/create-run.sh` | Modified | Added `draft-pr` to `VALID_MODES`. |
| `harness/lib/agent.sh` | Modified | Added `draft-pr` → `prompts/claude/bugfix-patch-only.md` prompt mapping. |
| `harness/create-local-branch.sh` | Modified | Added `draft-pr` to `ALLOWED_MODES`. |
| `harness/export-patch.sh` | Modified | Added `draft-pr` to `ALLOWED_MODES` (draft-pr produces the same patch artifacts as patch-only). |
| `harness/write-report.sh` | Modified | Added `draft-pr` next-steps arm pointing at `create-draft-pr.sh`. |
| `bin/lab-action` | Modified | Widened the `run_pipeline()` guard so `draft-pr` runs verify-run + export-patch like patch-only; `cmd_draft_fix` now runs the pipeline in `draft-pr` mode and points the operator at `create-draft-pr.sh <run-dir> --confirm-push --confirm-pr`. |
| `bin/lib/task-gen.sh` | Modified | `generate_draft_fix_task` now emits `mode: draft-pr`. |

## Verification Checklist

- [x] `harness/create-draft-pr.sh`—bash syntax check passes
- [x] All modified `.sh` files—bash syntax check passes
- [x] `draft-pr` accepted by `create-run.sh` (`VALID_MODES` updated)
- [x] Mode plumbing in `harness/lib/agent.sh` (`draft-pr` → `bugfix-patch-only.md`)
- [x] Gate enforcement: non-draft-pr run dies; no-confirm-flags previews and stops
- [x] Dry-run prints exact git/gh commands with @mentions neutralized
- [x] gh-logged-out path fails cleanly
- [x] README.md Phase 8 checkbox marked complete, current phase updated to Phase 9

## Architecture Decisions

- **draft-pr shares the bugfix-patch-only.md prompt:** The agent workflow is
  identical to patch-only/branch-only; only post-run delivery differs. No new
  prompt needed; the distinction is captured by the harness scripts.

- **Two explicit, safe steps:** The bot drafts the fix (patch + report), the
  operator reviews the diff, then explicitly delivers via confirm-gated flags.
  Nothing pushes automatically.

- **Operator CLI trigger only:** No comment/webhook trigger for fixes. `/agent fix`
  stays a documented non-goal; only `/agent review` is comment-triggerable.

- **@mention neutralization in the PR body:** Mirrors the pr-bot-worker to avoid
  pinging other users/bots.

- **No auto reviewers/labels/assignees:** Draft PR mode deliberately assigns no
  reviewers, labels, or assignees; the operator has full control before opening.

## Next Steps

- **Phase 9:** Multi-agent comparison—evaluate Claude Code, Superpowers, and OpenCode
  agents side-by-side on pilot tasks. Establish evaluation rubric and baseline
  metrics using agent-eval-harness integration.

- **Deferred:** PR-fix path (`draft-fix owner/repo#123` syntax) for a later phase
  when operator command syntax expands beyond inline flags.
