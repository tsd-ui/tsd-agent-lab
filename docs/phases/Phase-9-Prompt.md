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

## Prompt 9B—Add comparison runner

```markdown
Create a comparison workflow for running the same task with multiple agents.

Create:
- `harness/compare-agents.sh`
- `docs/comparing-agents.md`
- `templates/reports/agent-comparison-template.md`
- `examples/tasks/comparison-read-only.yaml`

Requirements:
- Start with read-only tasks only.
- Create separate run directories per agent.
- Do not allow patch/branch/draft-pr comparison mode yet.
- Summarize outputs side by side.
- Capture:
  - completion status
  - command failures
  - summary quality
  - likely hallucinations
  - usefulness
  - reviewer burden
- Keep the implementation simple.
```
