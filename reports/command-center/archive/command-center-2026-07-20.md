# Daily Command Center — 2026-07-20

## Status: 🔴

### Summary

- 11 CI failure(s) across 3 repo(s)
- 21 stale docs finding(s)
- 7 PRs reviewed, 3 open across monitored repos
- 30 PR(s) triaged: 1 critical, 1 high

### CI / Builds

11 failure(s) across 3 repo(s)

**[securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 🆕 new**
- Deploy to GH Pages / gh-pages / Deploy to GitHub Pages
- Deploy to GH Pages / gh-pages / Deploy to GitHub Pages
- CI (e2e) / run-e2e-ci / e2e-integration-tests / Run Playwright tests
- CI (e2e) / run-e2e-coverage / coverage / Tests with coverage
- CI (e2e) / run-e2e-coverage / check-images / Check server_db_image image exists
- CI (e2e) / run-e2e-ci / e2e-integration-tests / Run Playwright tests
**[tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 🆕 new**
- fullsend / dispatch / Triage / Triage / Mint triage token
- fullsend / dispatch / Triage / Triage / Mint triage token
- fullsend / dispatch / Triage / Triage / Mint triage token
- fullsend / dispatch / Triage / Triage / Mint triage token
**[tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 🆕 new**
- Release / release / Publish to npm
- Release / release / Update package versions

### Documentation Health

**Summary:** 3 stale findings, 18 for review (mechanical pass only)

Affected files:
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/admin/command-center.md`
- `docs/admin/schedule.md`
- `docs/admin/stale-docs-check.md`
- `docs/pilot/fullsend-local-evaluation.md`
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `scripts/macos/README.md`
- `skills/stale-docs-check/SKILL.md`

### PR Activity

- **7** PRs reviewed (lifetime)
- **3** PRs currently open across monitored repos

Recent reviews:
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/324 (reviewed 2026-07-06)

### PR Risk Triage

30 PR(s) triaged: 1 critical, 1 high, 11 medium, 17 low.

**Needs Attention:**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 73 | critical | ci-failing, release-change, stale-45d, excessive-force-pushes | deep-review |
| 2 | [securesign/rhtas-console-ui#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325) | 50 | high | ci-failing, release-change, stale-15d | deep-review |

### Action Items

- [ ] Review 11 CI failure(s) across 3 repo(s)
- [ ] Fix 3 stale doc link(s)
- [ ] Triage 1 critical and 1 high-risk PR(s)

### Next Steps

- **View broken-builds report:** `cat reports/broken-builds/current.md`
- **Re-run CI diagnosis:** `./scripts/macos/broken-builds-skill-run.sh --force-rediagnose`
- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
