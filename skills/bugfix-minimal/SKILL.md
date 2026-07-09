---
aliases: 
tags: 
name: bugfix-minimal
description: Fix a bug with the smallest possible code change
fullsend_role: code
---
# Bugfix Minimal

## Description

Fix a reported bug with the smallest, most targeted code change possible. This skill prioritizes correctness and minimal blast radius over cleanup or refactoring. The agent may edit files but must not commit, push, or add dependencies.

## When to Use

- A bug has been reported with a clear description or reproduction steps
- The fix should be surgical—change only what is necessary
- You want an agent to propose a fix for human review before merging

## When Not to Use

- The issue requires a design change or refactoring (scope is too large)
- The root cause is unknown and requires exploratory investigation (use codebase-map first)
- The fix requires installing new dependencies
- You want the agent to commit or create a PR

## Workflow

### Step 1: Read the bug description

Read the bug description from the task specification. Identify the expected behavior, actual behavior, and any reproduction steps.

### Step 2: Locate the relevant code

Use the bug description, error messages, and stack traces to find the files and functions involved.

### Step 3: Understand the root cause

Read the surrounding code to understand why the bug occurs. Do not change anything until you understand the root cause.

### Step 4: Identify the minimal change

Determine the smallest change that fixes the bug without altering unrelated behavior. Prefer fixing the root cause over adding workarounds.

### Step 5: Make the change

Edit only the files necessary to fix the bug. Do not refactor surrounding code, rename variables, or fix unrelated issues.

### Step 6: Run tests

Run the project's existing test suite to verify the fix does not break other functionality. Use the project's own test commands.

### Step 7: Document test failures

If any tests fail after the fix, document the failures in `agent-output.md` rather than reverting. Note whether failures are pre-existing or introduced by the change.

### Step 8: Write changed-files list

Write a list of all modified files to `changed-files.txt`, one file path per line.

### Step 9: Summarize

Write a summary to `agent-output.md` covering: what the bug was, what caused it, what you changed, and the test results.

## Expected Output

- Modified source files (minimal set)
- `changed-files.txt` listing all modified files
- `agent-output.md` with bug analysis, change description, and test results

## Safety Constraints

- **Patch-only mode.** Edit files but do not commit or push. (Safety preamble rule 1)
- Do not run `git push` or create remote branches. (Rule 2)
- Do not create, comment on, or close pull requests. (Rule 3)
- Do not add new dependencies without explicit approval. (Rule 4)
- Do not read or reference production secrets. (Rule 5)
- Use the project's own build and test scripts. (Rule 7)
- Document all changes and assumptions. (Rules 8, 9)
- Write findings to `agent-output.md`. (Rule 10)

## Verification

- The bug described in the task is fixed
- `git diff` shows only changes related to the fix
- No unrelated files were modified
- Test suite passes (or failures are documented)
- `changed-files.txt` accurately lists modified files
- `agent-output.md` explains the root cause and fix

## Notes

This skill expands the prompt at `prompts/claude/bugfix-patch-only.md` into the portable SKILL.md format. The Fullsend role `code` reflects its use as a code-writing task. The "minimal" qualifier is deliberate—agents should resist the urge to clean up surrounding code, which introduces risk and makes review harder.
