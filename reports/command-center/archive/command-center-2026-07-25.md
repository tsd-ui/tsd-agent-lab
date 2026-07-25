# Daily Command Center — 2026-07-25

## Status: 🟡

### Summary

- 0 CI failure(s) across 0 repo(s)
- 23 stale docs finding(s)
- 8 PRs reviewed, 5 open across monitored repos
- 18 PR(s) triaged: 1 critical, 5 high

### Changes Since Yesterday
- 4 new stale doc finding(s)
- Status changed: red -> yellow

### CI / Builds

unknown


### Documentation Health

**Summary:** 7 stale findings, 16 for review

Affected files:
- `docs/draft-pr-mode.md`
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/admin/command-center.md`
- `docs/admin/schedule.md`
- `docs/admin/stale-docs-check.md`
- `docs/draft-pr-mode.md`
- `docs/pilot/fullsend-local-evaluation.md`
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `scripts/macos/README.md`
- `skills/stale-docs-check/SKILL.md`

### PR Activity

- **8** PRs reviewed (lifetime)
- **5** PRs currently open across monitored repos

Recent reviews:
- tsd-ui/tsd-ui#53 (reviewed 2026-07-21)
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)

### PR Risk Triage

18 PR(s) triaged: 1 critical, 5 high, 9 medium, 5 low.

**Needs Attention (maintained repos):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#340: feat: display all roles in TUF metadata tab](https://github.com/securesign/rhtas-console-ui/pull/340) | 60 | high | ci-failing (+20), schema-change (+12), medium-diff (+10), changes-public-api-schema (+12), no-review-1d+ (+3), dispersion (+8) | deep-review |

**Upstream Alerts (dependency repos — awareness only, no deep-review):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 84 | critical | ci-failing (+20), release-change (+10), large-diff-1000+ (+15), stale-14d+ (+8), force-push-2+ (+5), very-stale-52d (+8), excessive-force-pushes (+10), missing-tests (+10) | assess-impact |

### Action Items

- [ ] Fix 7 stale doc link(s)
- [ ] Triage 1 critical/high-risk PR(s) in maintained repos
- [ ] Assess impact of 1 high-impact upstream dependency PR(s) — awareness only, no deep-review needed

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
