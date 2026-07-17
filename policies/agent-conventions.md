# Agent Conventions

Behavioral conventions for how agents produce output in this lab. These are not safety controls (see `default-policy.yaml`) — they are quality and consistency rules that every agent workflow must follow.

## Invocation

- **Prefer `claude -p`** for all non-interactive, scripted, or harness-driven invocations. Reserve interactive `claude` for human-in-the-loop sessions only.

## Naming

### Tasks and Automations

Use kebab-case for all machine-generated names:

```
{skill}-{target}-{variant}.yaml
```

Examples: `codebase-map-rhtas-console.yaml`, `bugfix-patch-only.yaml`

### Run Directories

```
{task-stem}-{YYYY-MM-DD-HHMMSS}
```

Example: `read-only-codebase-map-rhtas-console-2026-07-02-142840`

### Reports

```
{run-dir-name}-report.md
```

Example: `read-only-codebase-map-rhtas-console-2026-07-02-142840-report.md`

### Skills

Kebab-case directory name under `skills/`, containing a `SKILL.md`:

```
skills/
  bugfix-minimal/
    SKILL.md
  codebase-map/
    SKILL.md
```

### General Rules

- All names kebab-case. No spaces, underscores, or camelCase.
- Timestamps use `YYYY-MM-DD-HHMMSS` (local time, 24-hour).
- Keep names descriptive but under 80 characters.

## File Operations

### Write in Place — Never Copy-and-Rename

When modifying an existing file, write to it directly. Do **not**:

- Write to a temporary file and rename/move it over the original.
- Copy the original, modify the copy, then replace.

Atomic copy-and-rename breaks Obsidian: the original inode disappears, so any open tab for that file closes and the user loses their scroll position and edit state. This applies to all file formats, not just Markdown.

### Markdown Hygiene

When creating or modifying Markdown files (`.md`):

- **Trim trailing whitespace** on every line.
- **End files with a single newline** (no trailing blank lines).
- **No trailing spaces for line breaks** — use `<br>` if a hard break is truly needed (prefer restructuring the text instead).
- **Use consistent heading levels** — don't skip levels (e.g., `##` directly under `#`, not `####` under `#`).
- **No hard line wraps in prose** — write each sentence or paragraph as a single line. Do not insert newlines mid-sentence to wrap at 80 columns. Hard wraps create awkward mid-sentence breaks when rendered in Obsidian or other variable-width viewers. (Code blocks and tables are exempt.)

## Output Quality

- Reports should be self-contained: a reader unfamiliar with the task should understand what was done, what was found, and what to do next.
- Prefer concrete findings over boilerplate summaries.
- Include file paths and line numbers when referencing code.
