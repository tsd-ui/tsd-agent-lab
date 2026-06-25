# Pilot Result: [TASK_ID]

_Completed: [DATE]_

## Summary

| Field | Value |
|-------|-------|
| Repository | [repo name and URL] |
| Agent | [claude-code / codex-cli / gemini / opencode] |
| Task type | [codebase-map / bugfix / test-gen / pr-review / adr] |
| Mode | [read-only / patch-only / commit-allowed / review-only] |
| Time spent | [wall-clock minutes] |
| Run ID | [run ID from harness] |

## Commands Run

List the commands executed during the run (from harness logs or agent output):

1. [command]
2. [command]

## Files Read

List key files the agent read during exploration:

- [file path]

## Files Changed

List any files the agent created or modified:

- [file path] — [description of change]

_For read-only runs, this section should be empty._

## Verification Results

| Check | Result |
|-------|--------|
| `agent-output.md` exists | [pass / fail] |
| Expected sections present | [pass / fail] |
| No repo files modified | [pass / fail] |
| [additional check] | [pass / fail] |

## Ratings

Use the [evaluation rubric](../../docs/pilot/evaluation-rubric.md) for anchor descriptions.

| Dimension | Rating (1-5) | Notes |
|-----------|-------------|-------|
| Usefulness | | |
| Correctness | | |
| Completeness | | |
| Safety compliance | | |
| Reviewer burden | | |

## Risks Observed

Note any safety concerns, unexpected agent behavior, or policy violations:

- [risk or observation]

## Prompt Analysis

### What worked

- [aspect of the prompt or skill that produced good results]

### What needed adjustment

- [aspect that should be revised for future runs]

## Recommendation

- [ ] **Continue** — output is useful, process works, ready for more tasks
- [ ] **Revise** — output has potential but prompt/skill/harness needs changes before expanding
- [ ] **Stop** — fundamental issues need resolution before proceeding

## Reviewer

| Field | Value |
|-------|-------|
| Reviewed by | [name] |
| Review date | [date] |
| Minimum reviewers met | [yes / no] |
