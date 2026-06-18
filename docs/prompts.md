# Prompt System

The TSD Agent Lab uses composable prompt files to instruct agents. The runner script concatenates a safety preamble with a task-specific prompt before invoking the agent.

## Directory Layout

```
prompts/
├── common/
│   └── safety-preamble.md    # Prepended to every agent prompt
└── claude/
    ├── read-only-codebase-map.md
    ├── bugfix-patch-only.md
    └── review-only.md
```

## Composition Model

When the runner executes a task, it builds a composed prompt:

1. **Safety preamble** (`prompts/common/safety-preamble.md`) — universal rules that apply to every run.
2. **Task prompt** — the prompt file referenced by the task, either explicitly via `prompt_file` or derived from the task's `agent` and `mode` fields.

The composed prompt is written to `composed-prompt.md` in the run directory for auditability.

## Referencing Prompts from Tasks

### Explicit reference

Set the `prompt_file` field in your task YAML:

```yaml
prompt_file: prompts/claude/bugfix-patch-only.md
```

### Default derivation

If `prompt_file` is not set, the runner derives a default from the task's `agent` and `mode`:

| Agent | Mode | Default prompt |
|-------|------|---------------|
| `claude-code` | `read-only` | `prompts/claude/read-only-codebase-map.md` |
| `claude-code` | `patch-only` | `prompts/claude/bugfix-patch-only.md` |
| `claude-code` | `review-only` | `prompts/claude/review-only.md` |
| `claude-code` | `commit-allowed` | `prompts/claude/bugfix-patch-only.md` |

## Adding New Prompts

1. Create a markdown file under `prompts/<agent>/`.
2. Use a descriptive filename matching the task mode or purpose.
3. The prompt should be self-contained — it will be concatenated after the safety preamble.
4. Reference it from task YAML via `prompt_file`, or add a default mapping in `harness/lib/agent.sh`.

## Safety Preamble

The safety preamble (`prompts/common/safety-preamble.md`) contains universal rules:

- Respect task mode (read-only, patch-only, etc.)
- No pushing, no PRs, no sudo
- No dependency installation without approval
- No production secrets
- Document work and produce a final report

Every composed prompt starts with this preamble. Do not remove or bypass it.
