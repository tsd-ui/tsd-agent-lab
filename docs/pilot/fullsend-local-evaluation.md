# Fullsend Local Evaluation

Comparison of the lab harness + Claude Code against Fullsend CLI running locally, both executing the codebase-map task against the same repository.

> **Status:** Complete (2026-06-23). Harness run succeeded; Fullsend run blocked by OpenShell sandbox/Podman compatibility. Comparison based on harness output + Fullsend architecture investigation.

## Setup

### Lab harness run

```bash
TASK=examples/tasks/fullsend-comparison-codebase-map.yaml
RUN_DIR=$(./harness/create-run.sh "$TASK")
./harness/prepare-repo.sh "$TASK" --run-dir "$RUN_DIR"
./harness/run-claude.sh "$TASK" --run-dir "$RUN_DIR"
./harness/verify-run.sh "$TASK" --run-dir "$RUN_DIR"
./harness/write-report.sh "$RUN_DIR"
```

- **Run ID:** `fullsend-comparison-codebase-map-2026-06-23-163904`
- **Status:** Verified (agent-output.md produced, all expected sections present)
- **Output:** 281-line structured codebase map covering directory structure, architecture, build/test commands, dependencies, risk areas, and recommended tasks
- **Time:** ~2.5 minutes agent execution

### Fullsend local run (attempted)

```bash
fullsend run codebase-map \
  --target-repo /Users/ryordan/Obsidian/tsd-agent-lab \
  --fullsend-dir /tmp/fullsend-eval/.fullsend \
  --no-post-script \
  --output-dir /tmp/fullsend-eval/output \
  --keep-sandbox
```

- **Status:** Blocked. Sandbox creation failed after 3 retries.
- **Root cause:** Fullsend v0.17.0 requires NVIDIA OpenShell for sandbox isolation. OpenShell v0.0.68 was installed and its gateway connected, but sandbox creation hung indefinitely against Podman (v5.8.2 via libkrun). OpenShell auto-detected the Podman driver (`openshell_driver_podman`) but container creation never completed. Docker CLI compatibility shim (`docker` → `podman` symlink) resolved the CLI check but not the runtime issue.
- **Setup created:** `.fullsend/` config with custom `harness/codebase-map.yaml`, `agents/codebase-map.md`, and `skills/codebase-map/SKILL.md`

## Comparison Dimensions

### Context Assembly

How each tool assembles the prompt and context for the agent.

| Aspect | Lab Harness | Fullsend CLI |
|--------|------------|-------------|
| Prompt source | `prompts/claude/` + safety preamble | Agent markdown file (`.fullsend/agents/*.md`) with YAML frontmatter (name, description, skills, tools, model) |
| Skills used | `skills/codebase-map/SKILL.md` (referenced in docs, not injected automatically) | Skills listed in harness YAML `skills:` array; resolved transitively (up to `--max-depth 10`) and composed into agent context |
| Context window | Composed prompt = safety preamble + task prompt (2 files concatenated) | Agent prompt + resolved skills + security hooks + sandbox-injected env vars + repo context |
| Safety constraints | Explicit 10-rule preamble (`safety-preamble.md`) + task mode enforcement | Container sandbox isolation (OpenShell) + policy YAML + security hooks (Tirith command scanning, SSRF, canary tokens, secret redaction, Unicode normalization) |
| Repo context | Detached git worktree of target repo; agent reads files freely | Target repo mounted into sandbox container; agent reads files within sandbox |

### Output Quality

The harness run completed; the Fullsend run did not. Scores reflect only the harness output.

| Dimension | Lab Harness (1-5) | Fullsend CLI (1-5) | Notes |
|-----------|-------------------|---------------------|-------|
| Usefulness | 4 | N/A (run blocked) | Tailored to tsd-agent-lab with actionable recommendations |
| Correctness | 4 | N/A | Accurate file paths and descriptions; minor note about committed `.obsidian/` |
| Completeness | 5 | N/A | All 6 sections present with good depth; risk areas well-identified |
| Safety compliance | 5 | N/A | No files modified; read-only constraint respected |
| Reviewer burden | 4 | N/A | Ready to use with minor formatting adjustments (numbered section headings vs expected flat headings) |

### Gaps

Features or capabilities that one tool provides and the other doesn't.

| Feature | Lab Harness | Fullsend CLI | Notes |
|---------|------------|-------------|-------|
| Local execution | Yes — direct CLI in worktree | Yes — but requires container sandbox (OpenShell) | Harness is simpler; Fullsend provides stronger isolation |
| GitHub integration | No | Yes — status comments, labels, PR review, issue triage | Fullsend is designed for GitHub event-driven workflows |
| Multi-agent support | Manual (run scripts sequentially) | Built-in agent roles (triage, code, review, fix, retro, prioritize) with per-role harness YAML | Fullsend agents are specialized; harness agents are generic |
| Evaluation framework | agent-eval-harness (plugin) | Not built-in; separate eval infrastructure | Lab has dedicated evaluation pipeline |
| Skill portability | SKILL.md format (Fullsend-compatible) | SKILL.md format (native) with transitive resolution | Same format; Fullsend adds dependency resolution |
| Container isolation | None (worktree isolation only) | OpenShell sandbox with security hooks | Significant safety difference for production use |
| Security scanning | Advisory policies (warn, don't block) | Multiple layers: DeBERTa prompt injection, Tirith bash scanning, SSRF detection, canary tokens, secret redaction | Fullsend is production-grade; harness is lab-grade |
| Pre/post scripts | None | Per-agent pre_script and post_script for GitHub mutations | Fullsend separates inference from side effects |
| Output validation | Verification commands in task YAML | Schema-based validation loop (up to N iterations) | Fullsend retries on schema mismatch |
| Credential management | Manual env vars | GCP WIF + token mint + OIDC exchange | Fullsend has full credential lifecycle |

### Assumptions

Findings from attempting the Fullsend local setup:

- **OpenShell is required.** Fullsend v0.17.0 has a hard dependency on `openshell` for sandbox creation. There is no `--no-sandbox` or local-only mode.
- **Podman compatibility is incomplete.** OpenShell detected the Podman driver but sandbox creation failed silently. The `docker info` template format also differs between Podman and Docker, breaking the `openshell doctor check`.
- **The triage agent is issue-focused.** Fullsend's built-in triage agent (`agents/triage.md`) is designed for GitHub issue assessment, not general codebase mapping. Creating a custom codebase-map agent required writing a new harness YAML, agent prompt, and skill — Fullsend doesn't ship a generic exploration agent.
- **SKILL.md format is compatible.** The lab's `skills/codebase-map/SKILL.md` follows the same frontmatter conventions Fullsend uses. The `fullsend_role: triage` mapping is correct conceptually (reconnaissance before work assignment).
- **Fullsend's `.fullsend/` directory is more complex than expected.** A per-repo install creates 10+ directories: `agents/`, `harness/`, `skills/`, `schemas/`, `env/`, `scripts/`, `policies/`, `plugins/`, `customized/`, `templates/`. The harness equivalent is 2 files (task YAML + prompt).

## Conclusions

### What the lab harness does better

- **Lower setup cost.** Zero container dependencies — runs Claude Code directly in a git worktree. Worked on first attempt. Fullsend required installing OpenShell, starting Podman, creating docker compatibility shims, and still failed.
- **Simpler mental model.** Five shell scripts in a linear pipeline. Each script does one thing. The entire harness is ~1,800 lines of bash. Fullsend's architecture spans container images, pre/post scripts, security hooks, schema validation loops, credential minting, and GitHub forge integration.
- **Better for experimentation.** The harness lets you iterate on prompts, run different agents, and compare outputs without infrastructure overhead. Ideal for a team learning how to use agents.
- **Evaluation integration.** agent-eval-harness plugin provides structured scoring, baseline comparison, and regression detection. Fullsend doesn't include evaluation tooling.

### What Fullsend does better

- **Production-grade security.** Container sandbox isolation, multiple security scanning layers (prompt injection, SSRF, canary tokens, secret redaction), policy enforcement, and credential lifecycle management. The harness's advisory-only policies are not comparable.
- **GitHub-native workflow.** Event-driven agent dispatch (issue opened → triage → code → review), status comments, label management, and PR posting. The harness has no GitHub integration.
- **Transitive skill resolution.** Skills can reference other skills with automatic dependency resolution up to configurable depth. The harness injects skills manually.
- **Output validation with retry.** Schema-based output validation with configurable retry loops ensures agents produce structurally correct output. The harness only checks after the fact.
- **Multi-agent orchestration.** Six specialized agent roles with per-role harness configs, coordinated via GitHub labels and events. The harness runs one agent at a time.

### Phase 13 Inputs

Findings that directly inform Phase 13 (Fullsend hosted lane):

1. **SKILL.md format works as-is.** The lab's SKILL.md files follow Fullsend conventions. No format adjustments needed for portability. The `fullsend_role` frontmatter field correctly maps to Fullsend agent roles.

2. **Context assembly differs significantly.** The harness composes a flat `safety-preamble + task-prompt` text. Fullsend assembles context from agent prompt + resolved skills + security hooks + environment, all within a container sandbox. Phase 13 should not assume harness prompts transfer directly — they need to be refactored into Fullsend agent definitions.

3. **Custom agents are needed.** Fullsend's built-in agents are GitHub-workflow-focused (triage → code → review). Codebase mapping requires a custom agent definition. Phase 13 should create lab-specific agents in `.fullsend/customized/agents/` rather than relying on built-in roles.

4. **Container runtime is a hard requirement.** The team needs Docker or a fully compatible Podman setup for Fullsend. The OpenShell/Podman integration (v0.0.68) is not production-ready — Phase 13 should verify Docker compatibility or wait for OpenShell Podman fixes.

5. **GCP infrastructure is a prerequisite.** Fullsend's hosted lane requires GCP Vertex for inference, WIF for authentication, and a token mint for credential exchange. Phase 13 scoping should include GCP project provisioning, WIF setup, and mint enrollment.

6. **Security posture gap.** The harness has advisory policies; Fullsend has enforced container isolation. Moving to Fullsend's hosted lane will significantly improve the safety model, but requires trusting the OpenShell sandbox and Fullsend's security hooks.

### Next Steps

- **Retry Fullsend run when Docker or improved OpenShell/Podman support is available.** The comparison would be more complete with actual Fullsend output to score.
- **Keep SKILL.md format aligned.** Continue writing skills in Fullsend-compatible format so portability remains a smooth transition.
- **Evaluate Fullsend's `review` agent** as a closer match to read-only analysis (vs. `triage` which is issue-focused).
- **Phase 13 prerequisite checklist:** Docker runtime, GCP project with Vertex API enabled, WIF provisioning, mint enrollment, OpenShell stability on team machines.
