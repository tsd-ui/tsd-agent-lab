# Phase 10—Protocol playground

Phase 10—Protocol playground: MCP, A2A, AG-UI/A2UI

Do this after the local harness works. Don’t start here.

## Prompt 10A—Create protocol playground docs and event schema

```markdown
Create a protocol playground area for future experiments with MCP, A2A, AG-UI, and A2UI.

Create:
- `protocols/README.md`
- `protocols/events/agent-run-event.schema.json`
- `protocols/events/examples/*.json`
- `docs/protocol-playground.md`

The event schema should model local agent harness events:
- run_started
- repo_prepared
- agent_started
- agent_output
- verification_started
- verification_finished
- patch_exported
- draft_pr_created
- run_finished
- run_failed

Include fields:
- run_id
- task_id
- agent
- repo
- mode
- timestamp
- level
- message
- data

Explain how these events could later map to:
- AG-UI frontend streaming
- A2A agent coordination
- MCP tool calls
- A2UI/generated UI experiments

Do not implement a server yet.
Do not add dependencies unless necessary.
```

## Prompt 10B—Add local event logging

```markdown
Add simple local event logging to the harness.

Create or update:
- `harness/lib/events.sh`
- `docs/event-logging.md`
- relevant harness scripts

Requirements:
- Write JSONL events to `events.jsonl` in the run directory.
- Include run_id, task_id, timestamp, event_type, agent, mode, message.
- Do not require a server.
- Do not stream over the network.
- Keep it shell-friendly.
- Validate JSON with jq if available.
- Preserve existing behavior if jq is missing.

Update the final report to link to the event log.
```
