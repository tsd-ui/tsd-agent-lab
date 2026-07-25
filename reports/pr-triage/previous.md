I'll process this PR inventory data and generate a risk triage report following the prescribed scoring formula.

Reading the JSON data bundle and scoring each PR:

# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-24 |
| Host | agent-lab |
| User | ryordan |
| Generated | 2026-07-24 04:45:05 |
| Status | 21 PR(s) triaged across 8 repo(s) |

## Summary

19 open PR(s) across 3 maintained repo(s) and 2 open PR(s) across 1 upstream dependency repo. 0 critical, 1 high, 10 medium, 8 low (maintained); 0 critical, 1 high, 0 medium, 1 low (dependencies).

## Needs Attention Now

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui#18](https://github.com/tsd-ui/tsd-ui/pull/18) | 54 | high | ci-failing, stale-73-days, root-package-json-change | deep-review |

### Upstream Alerts

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 56 | high | ci-failing, missing-tests, stale-51-days, excessive-force-pushes | assess-impact |

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 4 open PR(s)

#### [#339: feat: surface validFor service window and expiring status in certificates UI](https://github.com/securesign/rhtas-console-ui/pull/339)
- **Risk Score:** 37 / 100
- **Priority:** medium
- **Reasons:**
  - changes-public-api-schema (+12): openapi schema change
  - large-diff-200-500-lines (+10): 237 lines changed
  - unresolved-review-threads-1-2 (+4): 2 unresolved threads
  - changes-requested (+8): review changes requested
  - force-pushes-1 (+3): 2 force pushes
- **Recommended Action:** scan-review

#### [#338: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/338)
- **Risk Score:** 28 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending-unknown (+5): CI checks pending
  - release-deployment-change (+10): root package-lock.json
  - large-diff-200-500-lines (+10): 418 lines changed
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 46 / 100
- **Priority:** medium
- **Reasons:**
  - ci-pending-unknown (+5): CI checks pending with failures
  - release-deployment-change (+10): root package.json
  - staleness-14-plus-days (+8): 73 days since last update
  - force-pushes-1 (+3): 7 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - ci-pending-unknown (+5): CI checks pending with e2e failures
  - release-deployment-change (+10): root package.json
  - large-diff-200-500-lines (+10): 372 lines changed
  - staleness-14-plus-days (+8): 21 days open
  - force-pushes-2-plus (+5): 42 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 9 open PR(s)

#### [#66: chore(deps): bump postcss from 8.5.8 to 8.5.22](https://github.com/tsd-ui/tsd-ui/pull/66)
- **Risk Score:** 10 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-change (+10): package-lock.json update
- **Recommended Action:** monitor

#### [#65: chore(deps): bump actions/setup-node from 6 to 7](https://github.com/tsd-ui/tsd-ui/pull/65)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - security-sensitive-files (+15): GitHub workflow changes
  - force-pushes-1 (+3): 1 force push
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 13 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-change (+10): package-lock.json update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 26 / 100
- **Priority:** low
- **Reasons:**
  - ci-failing (+20): CI tests failed
  - staleness-3-7-days (+3): 3 days since update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-change (+10): root package-lock.json
  - large-diff-over-1000-lines (+15): 2637 lines changed
  - staleness-3-7-days (+3): 3 days since update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#60: chore(deps-dev): bump the dev-dependencies group across 1 directory with 13 updates](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-change (+10): root package.json
  - large-diff-over-1000-lines (+15): 1649 lines changed
  - staleness-3-7-days (+3): 3 days since update
  - force-pushes-1 (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-change (+10): package-lock.json update
  - staleness-3-7-days (+3): 3 days since update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20): CI tests failed
  - release-deployment-change (+10): package.json changes
  - staleness-14-plus-days (+8): 73 days since update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 54 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20): CI tests failed
  - release-deployment-change (+10): root package.json
  - large-diff-200-500-lines (+10): 222 lines changed
  - staleness-14-plus-days (+8): 73 days since update
  - force-pushes-1 (+3): 3 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** deep-review

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-change (+10): client/package.json
  - large-diff-over-1000-lines (+15): 3708 lines changed
  - staleness-14-plus-days (+8): 22 days since update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 26 / 100
- **Priority:** low
- **Reasons:**
  - security-sensitive-files (+15): GitHub workflow changes
  - staleness-14-plus-days (+8): 22 days since update
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-change (+10): root package.json
  - large-diff-500-1000-lines (+15): 620 lines changed
  - staleness-14-plus-days (+8): 22 days since update
  - force-pushes-1 (+3): 1 force push
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 29 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-1000-lines (+15): 8019 lines changed
  - staleness-14-plus-days (+8): 22 days since update
  - force-pushes-1 (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** monitor

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-change (+10): root package.json + server/package.json
  - large-diff-500-1000-lines (+15): 656 lines changed
  - staleness-14-plus-days (+8): 22 days since update
  - force-pushes-1 (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-change (+10): root package.json
  - large-diff-500-1000-lines (+15): 810 lines changed
  - staleness-14-plus-days (+8): 22 days since update
  - force-pushes-1 (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Recommended Action:** scan-review

## Upstream Dependencies — Changes to Watch

> These are repositories the team depends on but does not maintain. They are listed
> for awareness: track changes that could affect the team's own repos. Do not review
> or merge these PRs — assess whether the upstream change warrants action downstream.

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 2 open PR(s)

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 23 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending-unknown (+5): CI checks pending
  - release-deployment-change (+10): Dockerfile updates
  - force-pushes-2-plus (+5): 6 force pushes
  - no-reviews-yet (+3): no reviews, open > 1 day
- **Impact Note:** Docker base image updates in the backend console; may require image refresh in dependent deployment configs if pinned versions are used.
- **Recommended Action:** watch

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 56 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20): coverage and golangci checks failing
  - release-deployment-change (+10): go.mod update
  - missing-disproportionate-tests (+10): dependency update with no test changes
  - staleness-14-plus-days (+8): 51 days open, failing since June
  - force-pushes-2-plus (+5): 199 force pushes (automated dependency bot)
  - no-reviews-yet (+3): no reviews submitted
- **Impact Note:** Long-stale Go dependency update with persistent CI failures; if merged, may introduce breaking changes to rhtas-console API that could affect rhtas-console-ui integration.
- **Recommended Action:** assess-impact

---

**End of Report**
