# Slash Commands

Reference for all `/eval-*` and utility slash commands available in Claude Code sessions in this lab.

## Evaluation Commands (`/eval-*`)

These are provided by the agent-eval-harness plugin.

| Command | When to Use | Example |
|---------|-------------|---------|
| `/eval-setup` | First-time setup; verify deps and API keys | `/eval-setup` |
| `/eval-analyze` | Generate `eval.yaml` for a skill | `/eval-analyze --skill codebase-map` |
| `/eval-dataset` | Generate test cases (default: 5 starter cases) | `/eval-dataset` |
| `/eval-dataset --count N` | Generate more test cases | `/eval-dataset --count 20` |
| `/eval-dataset --strategy expand` | Expand coverage gaps | `/eval-dataset --strategy expand` |
| `/eval-run` | Run all test cases and score | `/eval-run --model opus` |
| `/eval-run --case N` | Run a specific test case | `/eval-run --model opus --case 001` |
| `/eval-run --no-judge` | Skip LLM judges for faster iteration | `/eval-run --model opus --no-judge` |
| `/eval-review` | Human review of results — mark failures, propose fixes | `/eval-review` |
| `/eval-optimize` | Automated skill improvement loop | `/eval-optimize` |
| `/eval-mlflow` | Sync datasets and results to MLflow | `/eval-mlflow` |
| `/eval-check` | Audit harness config for overlap and structural issues | `/eval-check` |

### Typical eval workflow

```
/eval-analyze      # generate eval.yaml
/eval-dataset      # create test cases
/eval-run          # score the skill
/eval-review       # review results
/eval-optimize     # fix failing judges automatically
```

## Code Quality Commands

| Command | When to Use |
|---------|-------------|
| `/code-review` | Review the current diff for bugs and improvements |
| `/code-review --fix` | Review and apply fixes directly |
| `/code-review --comment` | Post findings as inline PR comments |
| `/simplify` | Review changed code for simplification and efficiency, then apply |
| `/security-review` | Security-focused review of changes on the current branch |

## Verification and Testing

| Command | When to Use |
|---------|-------------|
| `/verify` | Run the app and observe behavior after a change |
| `/run` | Launch the project app to confirm a change works |

## Documentation and Research

| Command | When to Use |
|---------|-------------|
| `/codebase-map` | Explore and map the current repository structure |
| `/deep-research` | Multi-source web research with cited report |
| `/review` | Review a GitHub pull request (pass PR URL) |

## Lab Configuration

| Command | When to Use |
|---------|-------------|
| `/update-config` | Configure hooks, permissions, env vars in settings.json |
| `/fewer-permission-prompts` | Scan transcripts and add an allowlist to reduce prompts |
| `/init` | Initialize a new CLAUDE.md in the current repo |

## Tips

- Skill-scoped commands run in context of the skill directory; navigate there first if needed.
- `/eval-optimize` makes changes to `SKILL.md` — review its edits before accepting.
- `/code-review --fix` applies changes directly to working files — review the diff after.
