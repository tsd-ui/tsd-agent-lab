# Task: Bugfix (Patch-Only)

Fix the bug described in the task specification. Make minimal, targeted code changes.

## Workflow

1. Read the bug description in the task notes.
2. Locate the relevant code.
3. Understand the root cause before changing anything.
4. Make the smallest change that fixes the bug.
5. Run the project's existing tests to verify the fix.
6. Write a list of changed files to `changed-files.txt` (one path per line).
7. Summarize what you changed and why in `agent-output.md`.

## Constraints

- **Patch-only.** You may edit files but must not commit or push.
- Do not refactor surrounding code beyond what the fix requires.
- Do not add new dependencies.
- Run verification commands listed in the task specification.
- If tests fail after your fix, document the failure rather than reverting.
