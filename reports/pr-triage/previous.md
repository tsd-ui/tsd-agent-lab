# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-26 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-26 05:48:18 |
| Status | 23 PR(s) triaged across 11 repo(s) |

## Summary

20 open PR(s) across 7 maintained repo(s) and 3 upstream dependency repo(s). 1 critical, 2 high, 11 medium, 9 low.

## Needs Attention Now

| # | PR | Score | Priority | Action |
|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#340](https://github.com/securesign/rhtas-console-ui/pull/340) | 70 | critical | deep-review |

### Upstream Alerts

| # | PR | Score | Priority | Action |
|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 74 | critical | assess-impact |
| 2 | [securesign/rhtas-console#95](https://github.com/securesign/rhtas-console/pull/95) | 53 | high | assess-impact |

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 5 open PR(s)

#### [#340: feat: display all roles in TUF metadata tab](https://github.com/securesign/rhtas-console-ui/pull/340)
- **Risk Score:** 70 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - changes-public-api-schema (+12, changed: `client/openapi/console.yaml`)
  - large-diff-over-200-lines (+5, 290 lines total)
  - missing-disproportionate-tests (+10, no test files changed, source files modified)
  - stale-1-day (+3)
- **Recommended Action:** deep-review

#### [#339: feat: surface validFor service window and expiring status in certificates UI](https://github.com/securesign/rhtas-console-ui/pull/339)
- **Risk Score:** 48 / 100
- **Priority:** medium
- **Reasons:**
  - changes-public-api-schema (+12, changed: `client/openapi/console.yaml`)
  - large-diff-over-200-lines (+5, 237 lines total)
  - changes-requested (+8)
  - unresolved-review-threads-1-2 (+4, 2 unresolved)
  - force-pushes-2+ (+5, 2 force pushes)
  - stale-1-day (+3)
  - missing-disproportionate-tests (+10, test files are e2e only)
  - contextual-bonus (+1, test files changed but worth deeper review of certificate expiry logic)
- **Recommended Action:** scan-review

#### [#338: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/338)
- **Risk Score:** 18 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - large-diff-over-200-lines (+5, 418 lines total)
  - stale-4-days (+5)
  - no-reviews-yet (+3, open > 1 day)
- **Recommended Action:** monitor

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 48 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - ci-pending (+5)
  - release-deployment-changes (+10, changed: `client/package.json`, `package.json`)
  - force-pushes-2+ (+5, 7 force pushes)
  - stale-23-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+0, major version updates are inherently risky but no specific signals in diff)
- **Recommended Action:** scan-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 48 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - ci-pending (+5)
  - release-deployment-changes (+10, changed: `package-lock.json`, `package.json`)
  - force-pushes-2+ (+5, 46 force pushes)
  - stale-23-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+0)
- **Recommended Action:** scan-review

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 9 open PR(s)

#### [#66: chore(deps): bump postcss from 8.5.8 to 8.5.22](https://github.com/tsd-ui/tsd-ui/pull/66)
- **Risk Score:** 8 / 100
- **Priority:** low
- **Reasons:**
  - stale-2-days (+3)
  - no-reviews-yet (+3)
  - release-deployment-changes (+10, changed: `package-lock.json`)
  - contextual-bonus (-8, dependency bump is straightforward and CI passing, reducing risk)
- **Recommended Action:** monitor

#### [#65: chore(deps): bump actions/setup-node from 6 to 7](https://github.com/tsd-ui/tsd-ui/pull/65)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-changes (+10, changed: workflow files)
  - stale-3-days (+3)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - contextual-bonus (-3, CI passing, workflow update is low risk)
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 18 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-changes (+10, changed: `package-lock.json`)
  - stale-4-days (+5)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 38 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - stale-5-days (+5)
  - no-reviews-yet (+3)
  - release-deployment-changes (+10, changed: `apps/docs/package.json`)
- **Recommended Action:** scan-review

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 28 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-1000-lines (+15, 2637 lines total)
  - release-deployment-changes (+10, changed: `apps/docs/package.json`, `package-lock.json`)
  - stale-5-days (+5)
  - no-reviews-yet (+3)
  - contextual-bonus (-5, major version bump but CI passing)
- **Recommended Action:** monitor

#### [#60: chore(deps-dev): bump the dev-dependencies group across 1 directory with 13 updates](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 33 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-1000-lines (+15, 1649 lines total)
  - release-deployment-changes (+10, changed: multiple `package.json` files)
  - stale-5-days (+5)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - contextual-bonus (-3, grouped dependency updates, CI passing)
- **Recommended Action:** scan-review

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-changes (+10, changed: `package-lock.json`)
  - stale-5-days (+5)
  - no-reviews-yet (+3)
  - contextual-bonus (+1, markdown-it has had security issues in the past, worth a quick check)
- **Recommended Action:** monitor

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 51 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-deployment-changes (+10, changed: `package-lock.json`, `packages/core/package.json`)
  - stale-115-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+10, 115-day-old PR with failing CI suggests merge conflicts or breaking changes)
- **Recommended Action:** scan-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 56 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-deployment-changes (+10, changed: `package-lock.json`, `package.json`)
  - force-pushes-2+ (+5, 3 force pushes)
  - stale-122-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+10, major TypeScript version bump with failing CI and 122-day staleness indicates likely breaking changes)
- **Recommended Action:** scan-review

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 33 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-1000-lines (+15, 3708 lines total)
  - release-deployment-changes (+10, changed: `client/package.json`, `package-lock.json`)
  - stale-24-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (-3, CI passing despite large diff)
- **Recommended Action:** scan-review

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-changes (+10, changed: workflow files)
  - stale-24-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (-5, workflow update with passing CI)
- **Recommended Action:** monitor

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+10, 620 lines total)
  - release-deployment-changes (+10, changed: `package-lock.json`, `package.json`)
  - stale-33-days (+8)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - contextual-bonus (-3, linting updates with CI passing)
- **Recommended Action:** scan-review

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 43 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-1000-lines (+15, 8019 lines total)
  - release-deployment-changes (+10, changed: `client/package.json`, `package-lock.json`)
  - force-pushes-1 (+3)
  - stale-53-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+4, PatternFly updates can have UI breaking changes, worth closer review)
- **Recommended Action:** scan-review

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+10, 656 lines total)
  - release-deployment-changes (+10, changed: multiple `package.json` files)
  - force-pushes-1 (+3)
  - stale-53-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+10, 810 lines total)
  - release-deployment-changes (+10, changed: `package-lock.json`, `package.json`)
  - force-pushes-1 (+3)
  - stale-53-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

### [tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 0 open PR(s)

No open PRs.

### [tsd-ui/devtools](https://github.com/tsd-ui/devtools) — 0 open PR(s)

No open PRs.

### [tsd-ui/tsd-agent-lab](https://github.com/tsd-ui/tsd-agent-lab) — 0 open PR(s)

No open PRs.

### [tsd-ui/tsd-ui-plugin](https://github.com/tsd-ui/tsd-ui-plugin) — 0 open PR(s)

No open PRs.

## Upstream Dependencies — Changes to Watch

> These are repositories the team depends on but does not maintain. They are listed for awareness: track changes that could affect the team's own repos. Do not review or merge these PRs — assess whether the upstream change warrants action downstream.

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 3 open PR(s)

#### [#98: feat: extend metadata-info endpoint to return all 4 TUF roles](https://github.com/securesign/rhtas-console/pull/98)
- **Risk Score:** 29 / 100
- **Priority:** low
- **Reasons:**
  - changes-public-api-schema (+12, changed: `internal/api/openapi/rhtas-console.yaml`)
  - large-diff-over-200-lines (+5, 252 lines total)
  - missing-disproportionate-tests (+10, source files changed but test file `internal/services/trust_test.go` is present, reducing penalty)
  - stale-1-day (+3)
  - contextual-bonus (-1, API schema extension aligns with rhtas-console-ui#340, coordinated change)
- **Impact Note:** This upstream API schema change extends the metadata-info endpoint to return all 4 TUF roles; rhtas-console-ui#340 consumes this change.
- **Recommended Action:** watch

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 53 / 100
- **Priority:** high
- **Reasons:**
  - ci-pending (+5)
  - release-deployment-changes (+10, changed: `Dockerfile`, `Dockerfile.rh`)
  - force-pushes-2+ (+5, 6 force pushes)
  - stale-10-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+22, 6 force pushes over 10 days with pending CI indicates instability; Dockerfile changes affect container builds)
- **Impact Note:** Dockerfile updates may require rebuilding downstream images or adjusting base image references in rhtas-console-ui's deployment manifests.
- **Recommended Action:** assess-impact

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 74 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - ci-pending (+5)
  - release-deployment-changes (+10, changed: `go.mod`)
  - force-pushes-2+ (+5, 208 force pushes)
  - stale-53-days (+8)
  - no-reviews-yet (+3)
  - contextual-bonus (+23, 208 force pushes over 53 days with failing CI indicates severe dependency conflict; go.mod changes may break API contracts)
- **Impact Note:** Go dependency updates with failing CI over 53 days and 208 force pushes indicate a critical dependency issue that could affect API stability; any downstream services consuming this API should monitor for breaking changes.
- **Recommended Action:** assess-impact

---

**Report complete.** 1 critical maintained-repo PR requires deep review; 1 critical and 1 high upstream PR warrant impact assessment for downstream effects.
