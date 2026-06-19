---
name: pr-review
description: Review code changes and produce a structured findings report
fullsend_role: review
---

# PR Review

## Description

Review code changes (a diff, PR, or specified area of the codebase) and produce a structured findings report organized by severity. This is a read-only skill—it never modifies files. The output helps reviewers focus on the most important issues first.

## When to Use

- Reviewing a pull request or diff before merging
- Auditing a specific area of the codebase for quality issues
- Getting a second opinion on code changes before submitting a PR
- Reviewing agent-generated code before accepting it

## When Not to Use

- You need to fix the issues found (use bugfix-minimal after the review)
- You need a full codebase assessment (use codebase-map instead)
- The review scope is the entire repository with no focus area specified

## Workflow

### Step 1: Read the scope

Read the task specification to determine what to review: a diff, a PR, specific files, or a codebase area. If reviewing a diff, read the changed files and their surrounding context.

### Step 2: Understand the intent

Determine what the changes are trying to accomplish. Read commit messages, PR descriptions, or task notes for context.

### Step 3: Read code in context

Read each changed file in its full context, not just the diff. Understand how changes interact with the rest of the codebase.

### Step 4: Identify findings by severity

Categorize issues into four severity levels:

- **Critical:** Data loss, security vulnerabilities, production outages, correctness bugs that affect all users
- **High:** Bugs, missing error handling, logic errors that will affect users under normal conditions
- **Medium:** Code quality issues, missing edge cases, maintainability concerns, performance issues
- **Low:** Style inconsistencies, minor improvements, documentation gaps, naming suggestions

### Step 5: Document each finding

For each finding, record:
- **Location:** file path and line range
- **Issue:** what is wrong or risky
- **Recommendation:** how to fix it
- **Confidence:** high, medium, or low (how certain you are this is a real issue)

### Step 6: Note empty categories

If no issues are found in a severity category, state that explicitly. Do not omit empty categories.

### Step 7: Summarize

Write an overall assessment: is this change ready to merge, what are the blockers (if any), and what are the key risks.

### Step 8: Write output

Write all findings to `agent-output.md` in the run directory, organized by severity.

## Expected Output

A single file `agent-output.md` containing:
- Review scope and intent summary
- Findings organized by severity (Critical, High, Medium, Low)
- Each finding with Location, Issue, Recommendation, Confidence
- Empty-category notes where applicable
- Overall assessment and merge readiness

## Safety Constraints

- **Read-only mode.** Do not modify any repository files. (Safety preamble rule 1)
- Do not run `git push` or create remote branches. (Rule 2)
- Do not create, comment on, or close pull requests. (Rule 3)
- Do not read or reference production secrets. (Rule 5)
- Focus on the specified scope—do not review the entire codebase unless asked. (Rule 8)
- Document assumptions and confidence levels. (Rule 9)
- Write all output to `agent-output.md`. (Rule 10)

## Verification

- `agent-output.md` exists and is non-empty
- All four severity categories are present (even if empty)
- Each finding has Location, Issue, Recommendation, and Confidence
- Findings are relevant to the specified review scope
- No repository files were modified (check `git status`)
- Overall assessment is present

## Notes

This skill expands the prompt at `prompts/claude/review-only.md` into the portable SKILL.md format. The Fullsend role `review` maps directly to Fullsend's review agent. The confidence field on each finding helps reviewers prioritize which issues to investigate—low-confidence findings may be false positives and should not block merges.
