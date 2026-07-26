Now I'll produce the complete triage report.

# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-25 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-25 05:48:09 |
| Status | 21 PR(s) triaged across 11 repo(s) |

## Summary

18 open PR(s) across 8 maintained repo(s) and 3 upstream dependency repo(s). 1 critical, 5 high, 9 medium, 5 low.

## Needs Attention Now

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#340](https://github.com/securesign/rhtas-console-ui/pull/340) | 60 | high | ci-failing (+20), schema-change (+12), medium-diff (+10), changes-public-api-schema (+12), no-review-1d+ (+3), dispersion (+8) | deep-review |

### Upstream Alerts

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 84 | critical | ci-failing (+20), release-change (+10), large-diff-1000+ (+15), stale-14d+ (+8), force-push-2+ (+5), very-stale-52d (+8), excessive-force-pushes (+10), missing-tests (+10) | assess-impact |

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 5 open PR(s)

#### [#340: feat: display all roles in TUF metadata tab](https://github.com/securesign/rhtas-console-ui/pull/340)
- **Risk Score:** 60 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - changes-public-api-schema (+12)
  - medium-diff-200-lines (+10)
  - high-file-dispersion-8-files (+8)
  - no-review-yet-1d+ (+3)
  - changed-files-includes-schema (+12)
- **Recommended Action:** deep-review

#### [#339: feat: surface validFor service window and expiring status in certificates UI](https://github.com/securesign/rhtas-console-ui/pull/339)
- **Risk Score:** 54 / 100
- **Priority:** high
- **Reasons:**
  - changes-public-api-schema (+12)
  - medium-diff-200-lines (+10)
  - high-file-dispersion-8-files (+8)
  - changes-requested (+8)
  - unresolved-threads-2 (+4)
  - force-push-2 (+3)
  - staleness-1d (+3)
- **Recommended Action:** deep-review

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 55 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-2+ (+5)
  - staleness-22d (+8)
  - missing-tests (+10)
- **Recommended Action:** deep-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-2+ (+5)
  - staleness-22d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#338: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/338)
- **Risk Score:** 13 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - release-change-package-lock (+10)
  - staleness-3d (+3)
  - missing-tests (+10)
  - Draft penalty (N/A)
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 9 open PR(s)

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 33 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - staleness-4d (+5)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 48 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - staleness-74d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 51 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-2+ (+5)
  - staleness-74d (+8)
  - missing-tests (+10)
- **Recommended Action:** deep-review

#### [#66: chore(deps): bump postcss from 8.5.8 to 8.5.22](https://github.com/tsd-ui/tsd-ui/pull/66)
- **Risk Score:** 13 / 100
- **Priority:** low
- **Reasons:**
  - release-change-package-lock (+10)
  - staleness-1d (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#65: chore(deps): bump actions/setup-node from 6 to 7](https://github.com/tsd-ui/tsd-ui/pull/65)
- **Risk Score:** 23 / 100
- **Priority:** low
- **Reasons:**
  - workflow-change (+15)
  - staleness-1d (+3)
  - force-push-1 (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 13 / 100
- **Priority:** low
- **Reasons:**
  - release-change-package-lock (+10)
  - staleness-3d (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 38 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-1000+ (+15)
  - release-change-package.json (+10)
  - staleness-4d (+5)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#60: chore(deps-dev): bump the dev-dependencies group across 1 directory with 13 updates](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 33 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-500+ (+10)
  - release-change-package.json (+10)
  - staleness-2d (+3)
  - force-push-2 (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - release-change-package-lock (+10)
  - staleness-1d (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 38 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-1000+ (+15)
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - staleness-23d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - workflow-change (+15)
  - stale-14d+ (+8)
  - staleness-23d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-1 (+3)
  - staleness-23d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 49 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-1000+ (+15)
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-2 (+3)
  - staleness-23d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-2 (+3)
  - staleness-23d (+8)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - release-change-package.json (+10)
  - stale-14d+ (+8)
  - force-push-2 (+3)
  - staleness-23d (+8)
  - missing-tests (+10)
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

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 84 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - release-change-go.mod (+10)
  - large-diff-500+ (+10)
  - stale-14d+ (+8)
  - force-push-2+ (+5)
  - staleness-52d (+8)
  - excessive-force-pushes-203 (+10)
  - missing-tests (+10)
- **Impact Note:** Go dependency updates may require go.mod/go.sum changes in downstream repos that import rhtas-console packages; failing CI suggests breaking changes.
- **Recommended Action:** assess-impact

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 28 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - dockerfile-change (+15)
  - stale-7d (+5)
  - force-push-2+ (+5)
  - staleness-9d (+5)
  - missing-tests (+10)
- **Impact Note:** Dockerfile base image updates may affect container builds or runtime behavior in environments deploying rhtas-console.
- **Recommended Action:** watch

#### [#98: feat: extend metadata-info endpoint to return all 4 TUF roles](https://github.com/securesign/rhtas-console/pull/98)
- **Risk Score:** 35 / 100
- **Priority:** medium
- **Reasons:**
  - changes-public-api-schema (+12)
  - medium-diff-200-lines (+10)
  - high-file-dispersion-7-files (+8)
  - no-review-yet-0d (+0)
  - openapi-schema-change (+12)
- **Impact Note:** The metadata-info endpoint schema change may require client updates in rhtas-console-ui or other consumers of this API.
- **Recommended Action:** watch

---

**Report End**
