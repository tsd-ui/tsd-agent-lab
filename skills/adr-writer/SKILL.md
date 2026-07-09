---
aliases: 
tags: 
name: adr-writer
description: Draft an Architecture Decision Record following the project's ADR format
fullsend_role: code
---
# ADR Writer

## Description

Draft an Architecture Decision Record (ADR) following the project's established format and conventions. The skill reads existing ADRs for style consistency, determines the next sequential number, and produces a complete ADR with all required sections. The ADR is written as a file and the ADR index is updated.

## When to Use

- A significant architectural decision has been made and needs documentation
- A design discussion has concluded and the outcome should be recorded
- You are about to make a hard-to-reverse technical choice
- A previous ADR is being superseded by a new decision

## When Not to Use

- The decision is minor or easily reversible (no ADR needed)
- The decision is a tactical code-level choice, not architectural
- An ADR already exists for this decision and just needs updating
- You are exploring options and have not yet decided (write a design doc instead)

## Workflow

### Step 1: Read the context

Read the task specification to understand: what decision was made, why, what alternatives were considered, and what the consequences are.

### Step 2: Read the ADR format

Read `docs/adr/README.md` to understand the required ADR structure, naming conventions, and guidelines.

### Step 3: Read existing ADRs for style

Read 1-2 existing ADRs in `docs/adr/` to match the project's tone, level of detail, and formatting conventions.

### Step 4: Determine the next number

List files in `docs/adr/` to find the highest existing ADR number. The new ADR uses the next sequential number.

### Step 5: Draft the ADR

Write the ADR with all required sections from the format:
- **Status:** (Accepted, unless specified otherwise)
- **Context:** The problem, constraints, and forces at play
- **Decision:** What was decided and why
- **Consequences:** Positive and negative outcomes
- **Alternatives Considered:** Other options and why they were rejected
- **Notes:** Additional context or future considerations
- **References:** Links to related documents or discussions

### Step 6: Use specific names and versions

Reference specific technologies, tools, and versions—not generic categories. Follow the ADR README guideline: "Name specific technologies, not categories."

### Step 7: Keep it concise

Aim for 1-2 pages. Link to details rather than embedding them. Focus on "why" over "what."

### Step 8: Write the ADR file

Write the ADR to `docs/adr/NNNN-short-title.md` using the determined number and a descriptive kebab-case title.

### Step 9: Update the ADR index

Add the new ADR to the index in `docs/adr/README.md` under the appropriate section (Active, Superseded, or Deprecated).

### Step 10: Summarize

Write a summary to `agent-output.md` covering: what decision was documented, the ADR number and title, and any open questions or follow-up items.

## Expected Output

- `docs/adr/NNNN-short-title.md`—the new ADR file
- Updated `docs/adr/README.md`—index with the new entry
- `agent-output.md`—summary of what was created

## Safety Constraints

- **Patch-only mode.** Create and edit files but do not commit or push. (Safety preamble rule 1)
- Do not run `git push` or create remote branches. (Rule 2)
- Do not create, comment on, or close pull requests. (Rule 3)
- Do not read or reference production secrets. (Rule 5)
- Follow the project's existing ADR format exactly. (Rule 7)
- Document assumptions about the decision context. (Rules 8, 9)
- Write summary to `agent-output.md`. (Rule 10)

## Verification

- ADR file exists at the correct path with the correct number
- All required sections are present (Status, Context, Decision, Consequences, Alternatives, Notes, References)
- ADR follows the format in `docs/adr/README.md`
- Style is consistent with existing ADRs
- `docs/adr/README.md` index includes the new entry
- ADR is 1-2 pages, specific, and concise
- `agent-output.md` summarizes the work

## Notes

This is a new skill without a corresponding prompt in `prompts/claude/`. The Fullsend role `code` reflects that it creates files (the ADR document). While ADRs are documentation, the skill writes structured files that follow a strict format—closer to code generation than free-form writing.
