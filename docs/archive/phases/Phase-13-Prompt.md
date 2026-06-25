# Phase 13—Fullsend hosted lane and GitHub Actions

Only do this once the local lab has proved useful AND Fullsend's authorization
guardrails for public repositories have shipped and been verified. This phase
transitions from local-only evaluation to the hosted Fullsend lane described
in `docs/lab-strategy.md`.

## Prerequisites

Before starting this phase, verify:
- Fullsend authorization guardrails are implemented (external/first-time/bot
  commenters cannot trigger runs on public repos)
- Each Fullsend command has a role-based allowlist
- Concurrency and spend limits exist
- Emergency kill switch works
- You have completed local Fullsend evaluation (Phase 6C) and have learnings
  to inform the hosted setup

## Prompt 13A—Stand up GCP mint infrastructure

```markdown
Set up the Fullsend mint service on GCP for the hosted lane.

This is the credential infrastructure that safely provisions short-lived,
scoped access tokens to agents without exposing long-lived secrets.

Steps:
1. Create a GCP project for the Fullsend mint service.
2. Set up Workload Identity Federation for GitHub OIDC token exchange.
3. Deploy the mint as a Cloud Function.
4. Create per-role GitHub Apps (code, review, triage) with scoped permissions.
5. Store app keys in Secret Manager as `fullsend-{role}-app-pem`.
6. Document the setup in `docs/infrastructure/gcp-mint-setup.md`.

Create:
- `docs/infrastructure/gcp-mint-setup.md` — step-by-step guide
- `docs/infrastructure/credential-flow.md` — diagrams of token flow

Do not enrol any repositories yet.
Do not store GCP credentials in this repository.
```

## Prompt 13B—Enrol private test repository

```markdown
Enrol one dedicated private test repository in the hosted Fullsend lane.

Steps:
1. Run `fullsend admin install ORG/REPO` for the private test repo.
2. Configure `.fullsend/` in the target repo with:
   - Agent roles and permissions
   - Skills from Phase 5 (already Fullsend-compatible)
   - Branch protection and CODEOWNERS
   - Concurrency and spend limits
3. Set `mint-url` to point at the GCP mint from Prompt 13A.
4. Run one complete issue-to-agent-to-PR lifecycle.
5. Document the experience in `docs/pilot/fullsend-hosted-pilot.md`.

Start with the review agent role only. Add code and triage roles after
the review lifecycle is validated.

Do not enrol public repositories yet.
Do not enable comment triggers.
```

## Prompt 13C—Design workflow_dispatch-only GitHub Action

```markdown
Design, but do not enable by default, a GitHub Actions experiment for Claude Code
as an alternative to Fullsend for repos where Fullsend enrollment is not appropriate.

Constraints:
- No comment triggers
- No issue_comment triggers
- No pull_request_target
- Use workflow_dispatch only
- Read-only review mode first
- Minimal permissions
- No auto-commit
- No auto-merge
- No production secrets
- Must be opt-in per repo
- Must clearly warn that repo owners need to approve use

Create:
- `.github/workflows/claude-read-only-review.example.yml`
- `.github/claude/prompts/review.md`
- `docs/github-actions-experiment.md`

The workflow file should be an example/template, not something we expect to run
automatically in this lab repo.

Include a section comparing this approach with Fullsend enrollment—when to use
which, and the tradeoffs between standalone GitHub Actions and the Fullsend lifecycle.

Include a security notes section explaining why comment triggers are intentionally
excluded and why we're starting with workflow_dispatch.
```
