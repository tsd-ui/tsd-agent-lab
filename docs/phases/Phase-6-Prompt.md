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

## Prompt 6B—Add pilot result template

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
