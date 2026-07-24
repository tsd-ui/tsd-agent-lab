# Daily Command Center — 2026-07-23

## Status: 🔴

### Summary

- 0 CI failure(s) across 0 repo(s)
- 19 stale docs finding(s)
- 8 PRs reviewed, 3 open across monitored repos
- 21 PR(s) triaged: 1 critical, 3 high

### Changes Since Yesterday
- 5 new stale doc finding(s)

### CI / Builds

unknown


### Documentation Health

**Summary:** 9 stale findings, 10 for review

Affected files:
- `docs/draft-pr-mode.md`
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

- **8** PRs reviewed (lifetime)
- **3** PRs currently open across monitored repos

Recent reviews:
- tsd-ui/tsd-ui#53 (reviewed 2026-07-21)
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)

### PR Risk Triage

21 PR(s) triaged: 1 critical, 3 high, 8 medium, 11 low.

**Needs Attention (maintained repos):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23) | 70 | critical | deep-review |
| 2 | [tsd-ui/tsd-ui#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18) | 58 | high | deep-review |
| 3 | [tsd-ui/tsd-ui#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62) | 50 | high | deep-review |
| 4 | [securesign/rhtas-console-ui#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325) | 50 | high | deep-review |

**Upstream Alerts (dependency repos — awareness only, no deep-review):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 71 | critical | assess-impact |

### Action Items

- [ ] Fix 9 stale doc link(s)
- [ ] Triage 4 critical/high-risk PR(s) in maintained repos
- [ ] Assess impact of 1 high-impact upstream dependency PR(s) — awareness only, no deep-review needed

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
