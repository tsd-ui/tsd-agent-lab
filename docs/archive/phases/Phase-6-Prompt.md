# Phase 6—First real pilot task

Do this against a low-risk repo. Start read-only.

## Prompt 6A—Prepare a first pilot task

```markdown
Help me prepare the first real pilot task for this local agent lab.

The goal is to run a read-only codebase mapping task against a low-risk repository.

Create:
- `examples/tasks/pilot-read-only-codebase-map.yaml`
- `docs/pilot/phase-1-read-only-pilot.md`

The pilot doc should include:
1. How to choose a repo.
2. What permissions are needed.
3. How to run the harness.
4. What output to expect.
5. How to judge whether the agent did useful work.
6. What not to do yet.
7. A checklist for sharing results with the team.

The task file should use placeholder values like:
- `<REPO_URL>`
- `<BASE_REF>`
- `<WORKING_DIRECTORY>`

Keep this pilot strictly read-only.
```

## Prompt 6B—Set up agent-eval-harness

```markdown
Set up agent-eval-harness for systematic evaluation of pilot results.

Install agent-eval-harness as a Claude Code skills plugin:
  claude plugin install agent-eval-harness@opendatahub-skills
Or clone locally and install:
  git clone https://github.com/opendatahub-io/agent-eval-harness
  pip install -e ./agent-eval-harness

Then:
1. Run `/eval-setup` to verify dependencies and configure MLflow (local).
2. Run `/eval-analyze` against the `skills/codebase-map/` skill from Phase 5.
   This auto-generates an `eval.yaml` with dataset schema and judge configuration.
3. Run `/eval-dataset` to bootstrap 5 initial test cases from the analysis.
4. Document the setup in `docs/evaluation.md`.

The eval.yaml becomes the single source of truth for how we measure skill quality.
Baseline results from this pilot feed into Phase 9 multi-agent comparison later.

Do not build custom scoring scripts—agent-eval-harness provides multi-judge
scoring, regression detection, and baseline comparison out of the box.
```

## Prompt 6C—Local Fullsend CLI evaluation

```markdown
Run a local Fullsend evaluation against the same pilot repository.

Prerequisites:
- Fullsend CLI installed locally (see https://github.com/fullsend-ai/fullsend)
- A cloned copy of the pilot repo (reuse the harness workspace)

Steps:
1. Run Fullsend locally against the pilot repo in read-only/review mode.
   Use `--no-post-script` and minimum token permissions.
2. Compare the Fullsend output with the harness-driven Claude Code output
   from Prompt 6A.
3. Document differences in `docs/pilot/fullsend-local-evaluation.md`:
   - What Fullsend assembled (skills, context, prompts) vs what the harness assembled
   - Quality of output compared to direct Claude Code invocation
   - Gaps or features Fullsend provides that the harness doesn't
   - Anything Fullsend assumed that didn't apply to our setup

This is the first exercise of the "local Fullsend evaluation" lane from lab-strategy.md.
Keep it observational—do not enrol the repo or set up GitHub triggers.
```

## Prompt 6D—Add pilot result template

```markdown
Create a reusable pilot result template.

Create:
- `templates/reports/pilot-result-template.md`
- `docs/pilot/evaluation-rubric.md`

The result template should capture:
- repo
- agent
- task type
- time spent
- commands run
- files read
- files changed, if any
- verification result
- usefulness rating
- correctness rating
- reviewer burden
- risks observed
- prompts that worked
- prompts that failed
- recommendation: continue | revise | stop

The rubric should help a small engineering team compare Codex, Claude Code, Gemini, and later OpenCode fairly.
```
