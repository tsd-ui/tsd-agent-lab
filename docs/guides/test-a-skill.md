# Test a Skill

How to evaluate skill quality using agent-eval-harness.

## What Is agent-eval-harness?

[agent-eval-harness](https://github.com/opendatahub-io/agent-eval-harness) is a systematic evaluation framework that scores agent output using configurable judges, tracks baselines, and detects regressions. It replaces ad-hoc "looks good to me" reviews with repeatable, comparable scores.

It's available as a set of `/eval-*` slash commands inside Claude Code sessions.

## Quick Start

Run these three commands in order for any skill:

```
/eval-analyze --skill codebase-map
```
Reads the skill's `SKILL.md` and generates an `eval.yaml` alongside it — defines what to evaluate and how to score it.

```
/eval-dataset
```
Generates 5 starter test cases based on the skill and eval.yaml schema.

```
/eval-run --model opus
```
Runs the skill against all test cases, scores with judges, and reports pass/fail against regression thresholds.

## Interpreting Results

- **Per-case scores** — which repos or inputs the skill handles well or poorly
- **Aggregate scores** — headline quality at a glance
- **Regression detection** — flags when a new run scores below the established baseline
- **Threshold failures** — which judges failed and why

If a judge fails, read the judge rationale in the output to understand what went wrong, then edit the `SKILL.md` to address it.

## Improving a Skill

After reviewing results:

```
/eval-review
```
Interactive human review — present scores, let you mark failures, propose SKILL.md edits.

```
/eval-optimize
```
Automated loop — reads failing judges, edits `SKILL.md`, re-runs, verifies no regressions.

## Full Command Reference

See [slash-commands.md](slash-commands.md) for all `/eval-*` commands with descriptions and examples.

Full reference: [reference/evaluation.md](../reference/evaluation.md)
