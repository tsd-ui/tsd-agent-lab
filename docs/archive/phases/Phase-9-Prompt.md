---
aliases: 
tags: 
---
# Phase 9—Multi-agent comparison

Now you can compare Claude Code vs Gemini vs other agents without changing the harness design. Claude is the primary agent, but the harness should support experimentation with alternatives.

## Prompt 9A—Add agent adapter interface

```markdown
Refactor the harness to support multiple local agent adapters.

Agents:
- claude (primary)
- gemini
- opencode placeholder
- manual

Create or update:
- `harness/agents/claude.sh`
- `harness/agents/gemini.sh`
- `harness/agents/opencode.sh`
- `harness/agents/manual.sh`
- `harness/run-agent.sh`
- `docs/agent-adapters.md`

Requirements:
- `run-agent.sh` reads `agent` from the task file
- Each adapter supports `--dry-run`
- Missing tools should produce helpful errors
- Do not assume all agents support the same flags
- Start with minimal implementations
- For non-Claude agents, add TODOs where command syntax needs confirmation
- Claude adapter should be the most complete and well-tested

Focus on:
- Making it easy to compare different agents on the same task
- Documenting differences in behavior and capabilities
- Sharing comparison results via Obsidian
- Building institutional knowledge about which agent works best for which tasks

Do not add cloud automation or GitHub Actions yet.
```

## Prompt 9B—Agent comparison via agent-eval-harness

```markdown
Use agent-eval-harness to systematically compare agents on the same tasks.

By this phase, agent-eval-harness should already be set up (Phase 6B) with
eval.yaml configs and baseline results from Claude Code pilot runs.

Steps:
1. For each agent adapter (claude, gemini, opencode), run `/eval-run` against
   the same eval.yaml and test cases. Use `runner.type` to switch agents:
   - `claude-code` for Claude Code
   - `cli` with appropriate wrapper for Gemini/OpenCode
2. Run `/eval-run --baseline <claude-run-id>` for non-Claude agents to
   compare against the Claude Code baseline.
3. Use pairwise comparison judges to score quality differences.
4. Log all results to MLflow for longitudinal tracking.

Create:
- `harness/compare-agents.sh` — thin wrapper that runs `/eval-run` per agent
- `docs/comparing-agents.md` — documents the comparison methodology
- `examples/tasks/comparison-read-only.yaml` — shared task for comparison

Do not build custom scoring scripts, templates, or side-by-side summaries.
agent-eval-harness provides:
- Multi-judge scoring (inline, LLM, pairwise)
- Regression detection (min_mean, min_pass_rate, min_win_rate thresholds)
- Baseline comparison (--baseline flag)
- MLflow experiment tracking

The custom comparison template from the original plan is replaced by
agent-eval-harness's built-in reporting and MLflow dashboards.

Start with read-only tasks only.
Do not allow patch/branch/draft-pr comparison mode yet.
```
