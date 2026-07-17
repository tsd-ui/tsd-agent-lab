# Evaluation

How to evaluate agent and skill quality using agent-eval-harness.

## Overview

The lab uses [agent-eval-harness](https://github.com/opendatahub-io/agent-eval-harness) for systematic evaluation instead of custom scripts. It provides multi-judge scoring, baseline comparison, regression detection, and MLflow tracking — giving repeatable, comparable results across agents and skills.

Agent-eval-harness replaces the need for ad-hoc evaluation by providing:

- **Structured evaluation definitions** (`eval.yaml`) alongside each skill
- **Multi-judge scoring** with configurable judge models (inline checks, LLM prompts, external modules)
- **Baseline tracking** to detect regressions between runs
- **MLflow integration** for experiment tracking and comparison

## Installation

The harness is installed as a Claude Code plugin from the opendatahub-skills marketplace.

### One-time marketplace setup

```bash
claude plugin marketplace add opendatahub-io/skills-registry
```

### Install the plugin (project scope)

```bash
claude plugin install agent-eval-harness@opendatahub-skills --scope project
```

This creates `.claude/settings.json` with the plugin enabled and makes all `/eval-*` slash commands available in new Claude Code sessions.

### Verify installation

```bash
claude plugin list
```

Expected output includes `agent-eval-harness@opendatahub-skills` with status `enabled`.

### Python dependencies

The plugin manages its own Python dependencies via an isolated venv (`.eval-venv/`) created automatically by a SessionStart hook. No manual `pip install` is needed for basic usage. For MLflow and LLM judges:

```bash
# Run /eval-setup in a Claude Code session, or manually:
pip install 'mlflow[genai]>=3.5' 'anthropic>=0.40'
```

## Setup

Run initial setup to verify dependencies and configure local tracking:

```
/eval-setup
```

This checks that required dependencies are available, verifies API keys, and optionally configures MLflow for local experiment tracking. MLflow is optional — the harness works without it.

For Vertex AI environments (like this lab), the plugin detects `ANTHROPIC_VERTEX_PROJECT_ID` automatically.

## Available Commands

| Command | Purpose |
|---|---|
| `/eval-setup` | Verify dependencies, configure MLflow, check API keys |
| `/eval-analyze` | Examine a skill's SKILL.md and generate `eval.yaml` |
| `/eval-dataset` | Generate test cases (default 5 starters) |
| `/eval-run` | Execute evaluations with scoring and regression detection |
| `/eval-review` | Interactive human review of results |
| `/eval-mlflow` | Sync datasets, log results, manage feedback with MLflow |
| `/eval-optimize` | Automated refinement loop (fix skill, re-run, verify) |
| `/eval-check` | Scan configuration for overlap, collisions, duplication |

## Creating Evaluations

Each skill can have an `eval.yaml` file alongside its `SKILL.md`. This file defines what to evaluate and how to score it.

### Generate from a skill

```
/eval-analyze --skill codebase-map
```

The generated `eval.yaml` includes:
- **Execution config** — mode (case or batch), arguments template, runner settings
- **Dataset schema** — natural language description of test case structure
- **Output descriptions** — what the skill produces (file artifacts, tool calls)
- **Judge configuration** — inline checks, LLM prompts, builtin reusable judges
- **Model defaults** — skill, judge, and hook model selections
- **Regression thresholds** — minimum scores to pass

### eval.yaml structure

```yaml
name: codebase-map-eval
skill: codebase-map

execution:
  mode: case
  arguments: "{prompt}"

runner:
  type: claude-code

models:
  skill: claude-opus-4-6
  judge: claude-opus-4-6

dataset:
  path: eval/dataset/cases
  schema: |
    Each case directory contains:
    - input.yaml: YAML file with 'repo_url' and 'base_ref' fields
    - reference.md: Gold standard codebase map for comparison

judges:
  - name: has_content
    check: |
      content = outputs["main_content"]
      if len(content.strip()) < 100:
          return False, f"Output too short ({len(content.strip())} chars)"
      return True, f"Output has {len(content.strip())} chars"

  - name: completeness
    prompt: |
      Rate the completeness of this codebase map on a 1-5 scale.
      1 = most sections missing. 3 = all sections present.
      5 = comprehensive with edge cases covered.

thresholds:
  has_content: {min_pass_rate: 1.0}
  completeness: {min_mean: 3.0}
```

See [skills/codebase-map/eval.yaml](../../skills/codebase-map/eval.yaml) for the current config.

## Test Cases

Bootstrap initial test cases for a skill:

```
/eval-dataset
```

Creates 5 starter test cases based on the skill definition and eval.yaml schema. Test cases are stored in the `dataset.path` directory specified in eval.yaml.

To generate more or fill coverage gaps:

```
/eval-dataset --count 20
/eval-dataset --strategy expand
```

## Running Evaluations

Full evaluation runs are the focus of Phase 9 (multi-agent comparison). The basic flow:

```
/eval-run --model opus              # Run all cases
/eval-run --model opus --case 001   # Run specific case
/eval-run --model opus --no-judge   # Skip LLM judges (faster iteration)
```

Compare runs via MLflow after logging results with `/eval-mlflow`.

## Interpreting Results

Results include per-test-case scores from each judge, aggregate scores per dimension, and pass/fail against regression thresholds.

- **Per-case scores** — identify which repos or scenarios an agent handles well or poorly
- **Aggregate scores** — compare agents at a high level
- **Regression detection** — flag when a new run scores below the established baseline
- **MLflow dashboard** — view trends over time via `mlflow ui`

## Conventions

- `eval.yaml` lives alongside `SKILL.md` in each skill directory (or under `eval/` for multi-skill projects)
- Test case data lives in the directory specified by `dataset.path` in eval.yaml
- Results are stored in `eval/runs/` (configurable via `AGENT_EVAL_RUNS_DIR`)
- Baselines are established during Phase 6 pilots and carried forward to Phase 9
- Judge prompts should be reviewed by the team before establishing baselines
- Do not build custom scoring scripts — agent-eval-harness provides multi-judge scoring, regression detection, and baseline comparison out of the box
