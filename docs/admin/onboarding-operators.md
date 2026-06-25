# Onboarding Operators

Steps for new operators before their first workflow, and ongoing training schedule.

## New Operator Onboarding

Before your first workflow:

1. **Read the docs**
   - [docs/getting-started.md](../getting-started.md) — current lab overview and quick start
   - [architecture/threat-model.md](../architecture/threat-model.md) — threat analysis
   - [architecture/safety-model.md](../architecture/safety-model.md) — safety controls
   - [admin/operator-checklist.md](operator-checklist.md) — pre-flight and post-execution checklists

2. **Review policies**
   - `policies/default-policy.yaml`
   - `policies/repo-allowlist.yaml`
   - `policies/command-allowlist.yaml`

3. **Pair with an experienced operator**
   - Watch them run a workflow end-to-end
   - Ask questions
   - Run your first workflow together

4. **Complete training workflow**
   - Run the `codebase-map` skill against `demo-app` in read-only mode
   - Practice the emergency stop procedure (`Ctrl+C` + `killall -u agent-lab`)
   - Write a practice incident report using the template in [incident-response.md](incident-response.md)

5. **Get sign-off**
   - Team lead confirms you're ready
   - You have access to the agent-lab user account
   - You're added to the `#agent-lab` Slack channel

## Ongoing Training

| Cadence | Activity |
|---------|----------|
| **Monthly** | Review incident reports from the past month |
| **Quarterly** | Policy refresh — re-read policies, confirm they still make sense |
| **Annually** | Full security review with team |

## Metrics to Track (Self-Check)

Keep a rough tally week over week:

- Workflows run
- PRs created and merged
- Policy violations (goal: 0)
- Overrides used (document each one)
- Incidents (goal: 0)
