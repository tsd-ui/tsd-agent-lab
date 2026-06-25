---
aliases: []
tags: []
---
# Phase 6 Summary: First Real Pilot Task

**Status:** Complete

## Deliverables

### Sub-phase 6A: Pilot Task Preparation

| File | Description |
|------|-------------|
| `examples/tasks/pilot-read-only-codebase-map.yaml` | Pilot task spec with placeholders for real repos and quality verification |
| `docs/pilot/phase-1-read-only-pilot.md` | End-to-end pilot guide: repo selection, permissions, harness steps, evaluation, guardrails |

### Sub-phase 6D: Assessment Templates

| File | Description |
|------|-------------|
| `templates/reports/pilot-result-template.md` | Structured result template with ratings, risks, prompt analysis, and recommendation |
| `docs/pilot/evaluation-rubric.md` | 1-5 rating scales for usefulness, correctness, completeness, safety, reviewer burden |

### Sub-phase 6B: Evaluation Infrastructure

| File | Description |
|------|-------------|
| `docs/evaluation.md` | agent-eval-harness overview, installation, setup, eval.yaml format, test cases, conventions |
| `skills/codebase-map/eval.yaml` | Bootstrap evaluation config with 4 judges (completeness, correctness, usefulness, safety) |
| `.claude/settings.json` | Plugin enabled at project scope (`agent-eval-harness@opendatahub-skills` v1.9.1) |

**Plugin installed (Phase 6B update):** The `opendatahub-skills` marketplace was added and `agent-eval-harness` installed as a Claude Code plugin at project scope. All `/eval-*` slash commands are now available in new sessions. Remaining interactive steps:

1. Start a new Claude Code session (plugin loads at session start)
2. Run `/eval-setup` to verify dependencies and optionally configure MLflow
3. Run `/eval-analyze --skill codebase-map` to replace the bootstrap eval.yaml with a tool-generated version
4. Run `/eval-dataset` to bootstrap 5 initial test cases

### Sub-phase 6C: Fullsend Comparison

| File | Description |
|------|-------------|
| `docs/pilot/fullsend-local-evaluation.md` | Completed comparison: harness run, Fullsend investigation, gap analysis, Phase 13 inputs |
| `examples/tasks/fullsend-comparison-codebase-map.yaml` | Task spec used for the harness baseline run against tsd-agent-lab |

**Completed (2026-06-24):** Ran the lab harness against tsd-agent-lab (281-line codebase map, all sections present). Fullsend CLI v0.17.0 was installed and a custom `.fullsend/` config created with a codebase-map agent. Initial run was blocked by three issues (sandbox creation, network policy, authentication) — all three resolved. Fullsend now runs end-to-end with Vertex AI auth via ADC, completing the codebase-map task in 127s. The investigation produced comprehensive findings about Fullsend's architecture, context assembly model, and security posture that directly inform Phase 13.

## Verification Checklist

- [x] `pilot-read-only-codebase-map.yaml` follows task schema (task_id, title, mode, repo_url fields present)
- [x] Pilot task includes quality verification command (grep for expected section headings)
- [x] `phase-1-read-only-pilot.md` has all 7 required sections
- [x] `pilot-result-template.md` has summary table, verification results, ratings, risks, prompt analysis, recommendation
- [x] `evaluation-rubric.md` covers all 5 rating dimensions with 1-5 anchor descriptions
- [x] `evaluation-rubric.md` includes comparison methodology and scoring protocol for 4 agents
- [x] `eval.yaml` exists for codebase-map with 4 judge configurations and regression thresholds
- [x] `evaluation.md` documents installation (plugin + local), setup, eval creation, test cases, conventions
- [x] Fullsend comparison completed with harness baseline run and architecture investigation
- [x] Fullsend sandbox auth resolved — end-to-end run with Vertex AI, agent exit code 0
- [x] Pre-flight validation script created (`scripts/fullsend-preflight.sh`)
- [x] Phase-6-Summary.md created, README.md updated

## Architecture Decisions

- **Bootstrap eval.yaml refined by /eval-analyze:** The initial eval.yaml was created as a bootstrap version. With agent-eval-harness now installed as a plugin (v1.9.1), running `/eval-analyze --skill codebase-map` will replace the bootstrap with a tool-generated config that includes proper execution settings, model defaults, and builtin judges.
- **Fullsend comparison completed end-to-end:** Fullsend CLI v0.17.0 runs successfully with OpenShell + Podman. Three blockers were resolved: sandbox creation (gateway restart), network policy (Vertex AI endpoints), and authentication (`CLAUDE_CODE_USE_VERTEX=1` + `export` prefix + correct region). Key finding: Fullsend requires container-based sandbox isolation (no local-only mode) and `apiKeyHelper` is bypassed when Vertex mode is active — env vars must be injected directly via `.env.d/` sourcing.
- **Evaluation rubric is agent-agnostic:** The same rubric applies to all agents (Claude Code, Codex, Gemini, OpenCode). Agent-specific invocation notes are documented separately from the scoring dimensions.
- **Pilot task adds quality verification:** Unlike the basic example task which only checks file existence, the pilot task also greps for expected section headings—catching cases where the agent produces a file but misses key content.

## Next Steps

- **Phase 7:** Patch-only mode—extend the harness and skills to support agents that can modify files locally without committing.

---

## Outcome

```
⏺ Here's what was done and what's next:

  Completed in this session:
  - Added the opendatahub-skills marketplace to Claude Code (claude plugin marketplace add)
  - Installed agent-eval-harness@opendatahub-skills as a project-scoped plugin (v1.9.1)
  - Updated docs/evaluation.md with correct installation instructions, all 8 available commands, and the actual eval.yaml structure
  - Updated docs/phases/Phase-6-Summary.md to reflect plugin installation

  Remaining steps (need a new Claude Code session — plugin loads at session start):

  1. /eval-setup — verifies dependencies, optionally configures MLflow
  2. /eval-analyze --skill codebase-map — replaces the bootstrap eval.yaml with a proper
  tool-generated config
  3. /eval-dataset — bootstraps 5 initial test cases for the codebase-map skill

  These three commands are interactive skills that need the plugin active. Start a new Claude Code session and run them in order.

✻ Cooked for 4m 42s

  5 tasks (3 done, 2 open)
  ✔ Clone and install agent-eval-harness locally
  ◻ Run eval-analyze against skills/codebase-map/
  ◻ Run eval-dataset to bootstrap 5 test cases
  ✔ Update docs/evaluation.md to reflect actual setup
  ✔ Create Phase 6B summary
```

First run of `/eval-setup`:

```
❯ /agent-eval-harness:eval-setup

  Thought for 2s (ctrl+o to expand)

⏺ Running environment checks for the agent-eval-harness.

⏺ Bash(VENV_PYTHON="/Users/ryordan/.claude/plugins/cache/opendatahub-skills/agent-eval-harness/1.9.1
      /.eval-venv/bin/python3"
      test -x "$VENV_PYTHON" && echo "venv: OK"…)
  ⎿  venv: OK
     Invalid -W option ignored: invalid module name: 'urllib3.exceptions'
     pyyaml: OK
     … +4 lines (ctrl+o to expand)

⏺ Bash(python3 /Users/ryordan/.claude/plugins/cache/opendatahub-skills/agent-eval-harness/1.9.1/skil
      ls/eval-setup/scripts/check_env.py --fix 2>&1)
  ⎿  Invalid -W option ignored: invalid module name: 'urllib3.exceptions'
     Environment Check
     ============================================================
     … +11 lines (ctrl+o to expand)

⏺ Bash(echo "ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY:+set}"
      echo "ANTHROPIC_VERTEX_PROJECT_ID=${ANTHROPIC_VERTEX_PROJECT_ID:-not set}"…)
  ⎿  ANTHROPIC_API_KEY=
     ANTHROPIC_VERTEX_PROJECT_ID=itpc-gcp-pnd-pe-eng-claude
     MLFLOW_TRACKING_URI=not set
     AGENT_EVAL_RUNS_DIR=eval/runs (default)

⏺ Bash(test -f eval.yaml && echo "eval.yaml: EXISTS" || echo "eval.yaml: NOT FOUND")
  ⎿  eval.yaml: NOT FOUND

⏺ Here's your environment status:

  ┌────────────────────┬─────────────────────────────────────────────┐
  │       Check        │                   Status                    │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ Venv               │ OK                                          │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ Python             │ 3.14.5                                      │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ pyyaml             │ OK (6.0.3)                                  │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ mlflow             │ OK (in venv, not system Python)             │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ anthropic          │ OK (in venv)                                │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ agent_eval symlink │ OK                                          │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ API auth           │ Vertex AI (ANTHROPIC_VERTEX_PROJECT_ID set) │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ MLflow tracking    │ Not configured (optional)                   │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ Runs directory     │ eval/runs (default)                         │
  ├────────────────────┼─────────────────────────────────────────────┤
  │ eval.yaml          │ Not found                                   │
  └────────────────────┴─────────────────────────────────────────────┘

  Everything needed to run evaluations is in place. The [-] marks for mlflow/anthropic in the preflight check are because it's checking system Python, but the packages are installed in the isolated venv where the harness actually runs — so you're good.

  MLflow is not configured. It's optional — the harness works without it. If you want tracking/UI later, you can run /eval-setup --tracking-uri http://127.0.0.1:5000 or /eval-mlflow after a run.

  Next steps:
  1. /eval-analyze --skill <name> — analyze a skill and generate eval.yaml
  2. /eval-dataset — generate test cases
  3. /eval-run --model <model> — execute the evaluation

  Which skill would you like to evaluate?
```

### `codebase-map` skill eval

```
⏺ Analysis complete. Here's what was generated:

  skills/codebase-map/eval.yaml — 5 judges configured:

  ┌──────────────────────┬─────────┬──────────────────────────────────────────────────────────┐
  │        Judge         │  Type   │                      What it checks                      │
  ├──────────────────────┼─────────┼──────────────────────────────────────────────────────────┤
  │ budget_check         │ builtin │ Cost under $3.00                                         │
  ├──────────────────────┼─────────┼──────────────────────────────────────────────────────────┤
  │ output_file_exists   │ check   │ agent-output.md produced with >200 chars                 │
  ├──────────────────────┼─────────┼──────────────────────────────────────────────────────────┤
  │ sections_present     │ check   │ All 6 required sections present                          │
  ├──────────────────────┼─────────┼──────────────────────────────────────────────────────────┤
  │ read_only_compliance │ check   │ No files modified                                        │
  ├──────────────────────┼─────────┼──────────────────────────────────────────────────────────┤
  │ output_quality       │ LLM     │ Comprehensive, accurate, actionable (1-5 scale, min 3.0) │
  └──────────────────────┴─────────┴──────────────────────────────────────────────────────────┘

  skills/codebase-map/eval.md — skill analysis cached (hash: 1a2636af26d5)

  Validation warnings (expected):
  - cases/ directory doesn't exist yet — no test cases
  - No execution.arguments — correct for this skill (it operates on the working directory)

  Next step: Run /eval-dataset to generate test cases. Each case will need a mini-repo structure
  (project files, src dirs) that the skill can explore.

✻ Worked for 1m 44s

※ recap: You're setting up evaluation for the codebase-map skill. I generated eval.yaml with 5
  judges and cached the analysis in eval.md. Next step: run /eval-dataset to create test cases
  before you can run the eval. (disable recaps in /config)
```

#### Setting up MLflow tracking (attempted)

```
⏺ The eval.yaml at skills/codebase-map/eval.yaml has mlflow.experiment: codebase-map-eval
  configured. Once you start the MLflow server, the experiment will be created automatically on the first /eval-run.

  No execution.env entries with $VAR references in the config, so no additional env vars are needed.

  Let me run final verification.

⏺ Bash(python3 /Users/ryordan/.claude/plugins/cache/opendatahub-skills/agent-eval-harness/1.9.1/skil
      ls/eval-setup/scripts/check_env.py 2>&1)
  ⎿  Invalid -W option ignored: invalid module name: 'urllib3.exceptions'
     Environment Check
     ============================================================
     … +11 lines (ctrl+o to expand)

⏺ Here's the final status:

  ┌─────────────────────┬─────────────┬──────────────────────────────────────────────────┐
  │      Component      │   Status    │                      Notes                       │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ Python              │ 3.14.5      │ OK                                               │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ Venv deps           │ OK          │ mlflow, pyyaml, anthropic all in .eval-venv      │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ API auth            │ OK          │ Vertex AI (ANTHROPIC_VERTEX_PROJECT_ID set)      │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ agent_eval          │ OK          │ Symlinked                                        │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ eval.yaml           │ OK          │ skills/codebase-map/eval.yaml — 5 judges         │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ MLflow server       │ Not running │ Start with mlflow server --port 5000             │
  ├─────────────────────┼─────────────┼──────────────────────────────────────────────────┤
  │ MLFLOW_TRACKING_URI │ Not set     │ export MLFLOW_TRACKING_URI=http://127.0.0.1:5000 │
  └─────────────────────┴─────────────┴──────────────────────────────────────────────────┘

  To complete MLflow setup:
  1. Start the server in a separate terminal: mlflow server --port 5000
  2. Set the env var: export MLFLOW_TRACKING_URI=http://127.0.0.1:5000
  3. Add that export to your shell profile (~/.zshrc) for persistence

  MLflow is optional — the harness works without it. You can proceed with evaluation and add MLflow later.

  Next step: /eval-dataset to generate test cases for codebase-map (the cases/ directory doesn't
  exist yet)
```

### `/eval-dataset codebase-map`

```
⏺ All cases validate correctly. Here's the summary:

  5 cases generated at skills/codebase-map/cases/ using bootstrap strategy:

  ┌──────────────────────────────┬────────────┬────────────┬─────────────────────────────────────┐
  │             Case             │  Language  │ Complexity │            What it tests            │
  ├──────────────────────────────┼────────────┼────────────┼─────────────────────────────────────┤
  │ case-001-simple-python-cli   │ Python     │ simple     │ Straightforward repo with good      │
  │                              │            │            │ docs, pyproject.toml, tests         │
  ├──────────────────────────────┼────────────┼────────────┼─────────────────────────────────────┤
  │ case-002-complex-node-webapp │ JavaScript │ complex    │ Monorepo with workspaces,           │
  │                              │            │            │ docker-compose, multiple layers     │
  ├──────────────────────────────┼────────────┼────────────┼─────────────────────────────────────┤
  │ case-003-edge-minimal-repo   │ Python     │ simple     │ Sparse repo — no README, no tests,  │
  │                              │            │            │ no config. Edge case.               │
  ├──────────────────────────────┼────────────┼────────────┼─────────────────────────────────────┤
  │ case-004-go-microservice     │ Go         │ medium     │ gRPC + Makefile + protobuf +        │
  │                              │            │            │ multi-stage Docker                  │
  ├──────────────────────────────┼────────────┼────────────┼─────────────────────────────────────┤
  │ case-005-rust-monorepo       │ Rust       │ medium     │ Cargo workspace with two crates +   │
  │                              │            │            │ GitHub Actions CI                   │
  └──────────────────────────────┴────────────┴────────────┴─────────────────────────────────────┘

  Coverage: Simple/complex/edge cases present. 4 languages. Covers monorepo vs flat structure,
  well-documented vs undocumented, various build systems (pip, npm, make, cargo). No external-state
  fields — all self-contained.

  No reference outputs generated — run with --gold to create them from the best results.

  Next steps:
  - /eval-run --model claude-opus-4-6 to test the skill against these cases
  - /eval-dataset --strategy expand --count 5 to add more cases later
```

### `/eval-run --model <model>`

Report produced, ooooh: file:///Users/ryordan/Obsidian/tsd-agent-lab/eval/runs/codebase-map/2026-06-23-opus/report.html

```
---
  Eval run complete: 2026-06-23-opus

  ┌──────────────────────┬────────────────────────────┐
  │        Judge         │           Score            │
  ├──────────────────────┼────────────────────────────┤
  │ budget_check         │ 100% (all under $3.00)     │
  ├──────────────────────┼────────────────────────────┤
  │ output_file_exists   │ 100% (3.7–6.5K chars each) │
  ├──────────────────────┼────────────────────────────┤
  │ sections_present     │ 100% (all 6 sections)      │
  ├──────────────────────┼────────────────────────────┤
  │ read_only_compliance │ 100%                       │
  ├──────────────────────┼────────────────────────────┤
  │ output_quality (LLM) │ 5.0/5                      │
  └──────────────────────┴────────────────────────────┘

  Run stats: 5 cases, 302s, $2.66 total ($0.53/case avg).

  Config fixes applied during this run:
  1. Added permissions.allow: [Read, Write, Bash, Edit] — headless mode needs explicit tool
  permissions
  2. Added dataset.workspace.files — test case repo files need to be copied into the workspace
  3. Updated read_only_compliance judge to exclude agent-output.md from modification checks
  4. Created .claude/commands/codebase-map.md so Claude Code CLI can discover the /codebase-map
  skill

  Report: eval/runs/codebase-map/2026-06-23-opus/report.html

  Next steps:
  - /eval-review --run-id 2026-06-23-opus for interactive review
  - /eval-run --model claude-sonnet-4-6 to compare a cheaper model
  - /eval-optimize --model claude-opus-4-6 to iterate on the skill based on results
```

## Phase 6C (local fullsend eval)

Plan: `~/.claude/plans/smooth-moseying-blum.md`

### Outcome

**Harness baseline:** Ran successfully against tsd-agent-lab. Created `examples/tasks/fullsend-comparison-codebase-map.yaml`, executed the 5-step pipeline, produced a 281-line codebase map with all expected sections. Run ID: `fullsend-comparison-codebase-map-2026-06-23-163904`.

**Fullsend attempt:** Installed Fullsend CLI v0.17.0 and NVIDIA OpenShell v0.0.68. Created a minimal `.fullsend/` config with custom codebase-map agent/harness/skill. Fullsend requires OpenShell for sandbox isolation—there is no local-only mode. OpenShell's Podman driver (v5.8.2, libkrun backend) detected the container runtime but sandbox creation hung indefinitely. A `docker` → `podman` symlink resolved CLI compatibility but not the runtime issue.

**Key findings documented in `docs/pilot/fullsend-local-evaluation.md`:**
- SKILL.md format is portable between lab harness and Fullsend (no changes needed)
- Fullsend's built-in agents are GitHub-workflow-focused (issue triage, PR review, code gen); generic exploration requires custom agent definitions
- Fullsend's security model (container sandbox + multiple scanning layers) is significantly more robust than the harness's advisory policies
- Phase 13 prerequisites: Docker runtime (or stable OpenShell/Podman), GCP project with Vertex API, WIF provisioning, mint enrollment

```
⏺ Good — Phase 6 artifacts were never committed (created in prior sessions). Our
  changes add to them. Let me verify the final state of the key deliverables.

  Searched for 2 patterns (ctrl+o to expand)

⏺ All verification criteria from the plan are met:

  - Zero [fill in] placeholders remaining in fullsend-local-evaluation.md
  - Harness run completed with verified output (281 lines, all sections present)
  - Comparison scores filled in using the evaluation rubric
  - Conclusions section has actionable findings
  - Phase 13 inputs section documents skill portability, context assembly differences,
  agent role readiness, and security/permission findings
  - Phase 6 summary updated to reflect 6C is genuinely complete

  Here's what was done:

  Step 1 — Harness baseline: Created
  examples/tasks/fullsend-comparison-codebase-map.yaml and ran the full 5-step pipeline
  against tsd-agent-lab. Produced a 281-line codebase map covering all 6 expected
  sections.

  Step 2/3 — Fullsend attempt: Installed Fullsend CLI v0.17.0 and NVIDIA OpenShell
  v0.0.68. Created a minimal .fullsend/ config with custom agent/harness/skill. The run
  was blocked by OpenShell sandbox creation failure with Podman backend — a docker →
  podman symlink was created to resolve CLI compatibility, but the runtime sandbox
  hung.

  Step 4 — Comparison document: Filled in docs/pilot/fullsend-local-evaluation.md with
  real data across all dimensions: context assembly, output quality scores, gap
  analysis (11 features compared), assumptions validated, conclusions, and Phase 13
  inputs.

  Step 5/6 — Phase 6 updates: Updated docs/phases/Phase-6-Summary.md to reflect 6C is
  complete with real findings rather than a template placeholder.

✻ Sautéed for 24m 31s
```

### Claude Code authentication inside Fullsend sandbox

**Resolved (2026-06-24).** Three blockers were encountered and all three are now fixed:

1. **OpenShell sandbox creation** — Fixed. Gateway restart after Podman was running. Sandbox creates in ~1.3s.
2. **Network policy** — Fixed. Custom policy in `policies/local-vertex.yaml` with `google_auth` and `vertex_ai` endpoint rules bound to the claude binary.
3. **Claude Code authentication** — Fixed. Root cause was two missing pieces in the env config injected into the sandbox.

#### Why `apiKeyHelper` doesn't work

When Vertex mode is active (`CLAUDE_CODE_USE_VERTEX=1`), Claude Code's auth precedence puts cloud provider credentials first. The `apiKeyHelper` script mechanism is bypassed entirely in Vertex mode — Claude Code never calls it. This was the wrong path to pursue.

#### What actually fixed auth

The real fix required two corrections to the sandbox environment:

**Missing `CLAUDE_CODE_USE_VERTEX=1`:** This env var was set on the host (in `~/.claude/settings.json`) but was never injected into the sandbox. Without it, Claude Code defaulted to Anthropic API auth and failed with "Not logged in · Please run /login" because there's no API key or OAuth session in the sandbox.

**Missing `export` prefix and wrong region:** Fullsend sources `.env.d/*.env` files via `. "$f"` (dot-source). Without the `export` keyword, variables are set as shell-local and don't reach the Claude Code child process. Additionally, `CLOUD_ML_REGION=global` caused Claude Code to connect to `aiplatform.googleapis.com` (no region prefix), which the sandbox network policy blocked. The correct env var is `ANTHROPIC_VERTEX_REGION=us-east5`, matching the region-specific endpoint already allowed by the policy.

#### Files changed

| File | Change |
|------|--------|
| `.fullsend/env/vertex.env` | Added `export CLAUDE_CODE_USE_VERTEX=1`, `export ANTHROPIC_VERTEX_REGION=us-east5`, kept `export` prefix on all vars |
| `local.env` | Added `CLAUDE_CODE_USE_VERTEX=1`, `ANTHROPIC_VERTEX_REGION=us-east5` |
| `.fullsend/harness/codebase-map.yaml` | Added `env_file: env/vertex.env`, `mode: "0600"` on ADC credentials mount |
| `scripts/fullsend-preflight.sh` (tsd-agent-lab) | New pre-flight validation script checking ADC, env vars, export syntax, harness config |

#### Verification

Fullsend ran successfully end-to-end:
- Sandbox created in ~1.3s
- Claude Code authenticated via Vertex AI (ADC refresh token exchange through `oauth2.googleapis.com`, API calls through `us-east5-aiplatform.googleapis.com`)
- Codebase-map agent completed in 127s, 47 turns, producing a full structured codebase map
- Agent exit code: 0, cost: $0.75