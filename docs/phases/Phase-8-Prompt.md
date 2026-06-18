# Phase 8—Draft PR mode, manual and explicit

This is the first point where GitHub gets involved, and it should be explicit.

## Prompt 8A—Add draft PR script with hard confirmation

```markdown
Add an explicit draft PR helper.

Draft PR mode means:
- Human has reviewed the local diff.
- Human explicitly runs the draft PR command.
- The script may push a branch and open a draft PR.
- The script must never run automatically from comments or issue events.

Create:
- `harness/create-draft-pr.sh`
- `docs/draft-pr-mode.md`
- `examples/tasks/pilot-draft-pr.yaml`

Requirements:
- Require task mode `draft-pr`.
- Require an explicit `--confirm-push` flag before pushing.
- Require an explicit `--confirm-pr` flag before opening a PR.
- Use `gh` if available.
- Fail safely if `gh` is not authenticated.
- Print the repo/branch/title/body before creating the PR.
- Generate PR body from the run report.
- Mark the PR as draft.
- Do not request reviewers automatically.
- Do not assign labels automatically.
- Do not mention or trigger other bots.

Add docs explaining that this should only be used where the repo owner’s process allows it.
```
