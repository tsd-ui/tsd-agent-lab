---
aliases: 
tags: 
name: test-generation
description: Generate tests for existing code without modifying production source
fullsend_role: quality
---
# Test Generation

## Description

Write tests for existing code, following the project's established testing conventions and frameworks. This skill creates new test files only—it never modifies production source code. The goal is to improve coverage for under-tested areas while maintaining consistency with existing test patterns.

## When to Use

- A module or function has no tests or insufficient coverage
- A codebase-map identified under-tested areas as a risk
- You want to add regression tests before a refactoring effort
- A bugfix needs a test to prevent recurrence

## When Not to Use

- The code under test needs to be refactored first to be testable
- You need to modify production source to make it testable (use bugfix-minimal)
- The project has no test framework set up and you would need to install one
- Tests already exist and you want to modify them (scope carefully)

## Workflow

### Step 1: Identify the target

Read the task specification to determine which module, function, or area needs tests.

### Step 2: Read and understand the code

Read the target code thoroughly. Understand its inputs, outputs, side effects, edge cases, and error conditions.

### Step 3: Identify the test framework

Find the project's existing test framework by checking config files (`jest.config.*`, `pytest.ini`, `*_test.go`, `.rspec`, etc.) and existing test files.

### Step 4: Check existing tests

Read any existing tests for the target or related modules. Note the conventions: file naming, directory structure, assertion style, fixture patterns, mock patterns.

### Step 5: Write tests following conventions

Write new test files that follow the project's established patterns. Cover:
- Happy path (normal operation)
- Edge cases (empty inputs, boundary values, nulls)
- Error cases (invalid inputs, failure modes)
- Any specific scenarios from the task specification

### Step 6: Run the new tests

Run only the new tests to verify they pass against the current code.

### Step 7: Run the full test suite

Run the project's full test suite to verify the new tests do not conflict with existing tests or expose pre-existing failures.

### Step 8: Write changed-files list

Write a list of all new test files to `changed-files.txt`, one file path per line.

### Step 9: Summarize

Write a summary to `agent-output.md` covering: what was tested, test count, coverage areas, any failures or issues discovered, and any areas intentionally left uncovered (with reasons).

## Expected Output

- New test files following the project's naming conventions
- `changed-files.txt` listing all new test files
- `agent-output.md` with test summary, coverage notes, and any issues found

## Safety Constraints

- **Patch-only mode.** Create test files but do not commit or push. (Safety preamble rule 1)
- **Never modify production source code.** Only create or modify test files.
- Do not run `git push` or create remote branches. (Rule 2)
- Do not create, comment on, or close pull requests. (Rule 3)
- Do not install test dependencies without explicit approval. (Rule 4)
- Do not read or reference production secrets in tests. (Rule 5)
- Use the project's existing test framework and commands. (Rule 7)
- Document all assumptions about test scope and coverage. (Rules 8, 9)
- Write findings to `agent-output.md`. (Rule 10)

## Verification

- All new test files follow the project's naming and directory conventions
- New tests pass when run individually
- Full test suite still passes
- No production source files were modified (check `git diff`)
- `changed-files.txt` lists only test files
- Tests cover happy path, edge cases, and error cases
- `agent-output.md` describes what was and was not covered

## Notes

This is a new skill without a corresponding prompt in `prompts/claude/`. The Fullsend role `quality` reflects its focus on improving code quality through testing. The strict rule against modifying production source ensures the skill's output is always safe to discard if tests reveal issues that need design discussion first.
