---
aliases: 
tags: 
name: codebase-map
description: Explore a repository and produce a structured codebase map
fullsend_role: triage
---
# Codebase Map

## Description

Explore an unfamiliar repository and produce a structured map covering architecture, build commands, dependencies, and risk areas. This is a read-only reconnaissance skill—it never modifies files. The output gives a human or downstream agent enough context to start working in the codebase safely.

## When to Use

- Onboarding to a new repository for the first time
- Preparing context before assigning agent tasks against a repo
- Auditing a repo's structure before a review or migration
- Building a reference document for team onboarding

## When Not to Use

- The codebase is already well-documented and familiar
- You need to fix a bug or make changes (use bugfix-minimal instead)
- You need a security audit (use pr-review with a security focus)

## Workflow

### Step 1: Read top-level files

Read `README.md`, `CONTRIBUTING.md`, `Makefile`, `package.json`, `pyproject.toml`, `Cargo.toml`, or equivalent project files. Note the project's purpose, language, and toolchain.

### Step 2: Map directory structure

List the top-level directories and their apparent purposes. Go one level deeper for directories that contain significant structure (e.g., `src/`, `lib/`, `cmd/`).

### Step 3: Identify architecture

Identify key modules, entry points, data flow, and how components connect. Note any patterns (MVC, hexagonal, monorepo, microservices).

### Step 4: Catalog build and test commands

Find and document how to build, test, lint, and run the project. Prefer commands from the project's own documentation or config files.

### Step 5: List dependencies

Note significant dependencies and what they provide. Focus on dependencies that shape the architecture, not every transitive package.

### Step 6: Flag risk areas

Identify parts of the codebase that look fragile, under-tested, complex, or poorly documented. Note any areas with high churn or known technical debt.

### Step 7: Recommend first agent tasks

Suggest 3-5 safe, high-value tasks an agent could tackle next (e.g., adding tests, fixing lint warnings, documenting modules, removing dead code).

### Step 8: Write output

Write all findings to `agent-output.md` in the run directory using the section headings above.

## Expected Output

A single file `agent-output.md` containing:
- Directory structure with descriptions
- Architecture overview
- Build and test commands
- Key dependencies
- Risk areas
- Recommended first tasks

## Safety Constraints

- **Read-only mode.** Do not modify any repository files. (Safety preamble rule 1)
- Do not run `git push` or create remote branches. (Rule 2)
- Do not install dependencies or run build commands—only document them. (Rule 4)
- Do not read or reference credentials, tokens, or API keys. (Rule 5)
- Document all assumptions explicitly. (Rule 9)
- Write all output to `agent-output.md`. (Rule 10)

## Verification

- `agent-output.md` exists and is non-empty
- All six content sections are present
- No repository files were modified (check `git status`)
- Recommendations are actionable and specific to the repo

## Notes

This skill expands the prompt at `prompts/claude/read-only-codebase-map.md` into the portable SKILL.md format. The Fullsend role `triage` reflects its use as an initial reconnaissance step before assigning work. The skill is agent-agnostic—any LLM that can read files and follow markdown instructions can execute it.
