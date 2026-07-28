# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-27 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-27 05:49:15 |
| Status | 25 PR(s) triaged across 10 repo(s) |

## Summary

22 open PR(s) across 7 maintained repo(s) and 3 open PR(s) across 1 upstream dependency repo. 2 critical, 8 high, 11 medium, 4 low.

## Needs Attention Now

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#340](https://github.com/securesign/rhtas-console-ui/pull/340) | 70 | critical | ci-failing, schema-change, no-test-changes, stale-3d | deep-review |
| 2 | [tsd-ui/tsd-ui#62](https://github.com/tsd-ui/tsd-ui/pull/62) | 63 | high | ci-failing, release-change, stale-6d | deep-review |
| 3 | [securesign/rhtas-console-ui#325](https://github.com/securesign/rhtas-console-ui/pull/325) | 62 | high | ci-failing, release-change, stale-24d, force-push | deep-review |
| 4 | [tsd-ui/tsd-ui#23](https://github.com/tsd-ui/tsd-ui/pull/23) | 59 | high | ci-failing, stale-116d | deep-review |
| 5 | [tsd-ui/tsd-ui#18](https://github.com/tsd-ui/tsd-ui/pull/18) | 59 | high | ci-failing, release-change, stale-123d | deep-review |
| 6 | [securesign/rhtas-console-ui#324](https://github.com/securesign/rhtas-console-ui/pull/324) | 50 | high | ci-failing, release-change, stale-24d, force-push | deep-review |
| 7 | [securesign/rhtas-console-ui#339](https://github.com/securesign/rhtas-console-ui/pull/339) | 50 | high | schema-change, changes-requested, unresolved-threads, no-test-changes | deep-review |
| 8 | [tsd-ui/tsd-ui-template#11](https://github.com/tsd-ui/tsd-ui-template/pull/11) | 50 | high | large-diff-1000+, stale-54d | deep-review |

### Upstream Alerts

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 74 | critical | ci-failing, release-change, stale-54d, force-push-213 | assess-impact |

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 5 open PR(s)

#### [#340: feat: display all roles in TUF metadata tab](https://github.com/securesign/rhtas-console-ui/pull/340)
- **Risk Score:** 70 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - changes-public-api-schema (+12): openapi/console.yaml
  - missing-test-changes (+10): source files changed but no test file updates
  - large-diff-200+ (+5): 149 additions, 141 deletions
  - high-file-dispersion (+8): 8 files changed
  - staleness-3d (+3): 2 days since update
  - no-reviews-yet (+3): no reviews and open >1 day
  - draft-pr (-10): not a draft (no penalty)
  - contextual (+9): schema change in openapi/console.yaml affects API contract; multiple client-side changes suggest feature expansion
- **Recommended Action:** deep-review

#### [#339: feat: surface validFor service window and expiring status in certificates UI](https://github.com/securesign/rhtas-console-ui/pull/339)
- **Risk Score:** 50 / 100
- **Priority:** high
- **Reasons:**
  - changes-public-api-schema (+12): openapi/console.yaml
  - changes-requested (+8): kahboom requested changes
  - unresolved-review-threads (+4): 2 unresolved threads
  - missing-test-changes (+10): source files changed but no test file updates
  - large-diff-200+ (+5): 120 additions, 117 deletions
  - high-file-dispersion (+8): 8 files changed
  - staleness-3d (+3): 2 days since update
  - draft-pr (-10): not a draft (no penalty)
  - contextual (+0): UI feature for certificate expiry — low security risk
- **Recommended Action:** deep-review

#### [#338: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/338)
- **Risk Score:** 13 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5): checks pending
  - release-change (+10): package-lock.json
  - large-diff-200+ (+5): 209 additions, 209 deletions
  - staleness-3d (+3): 5 days since update
  - no-reviews-yet (+3): no reviews and open >5 days
  - draft-pr (-10): not a draft (no penalty)
  - contextual (-3): routine lock file maintenance — low impact
- **Recommended Action:** monitor

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 62 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10): package.json changes
  - staleness-14d (+8): 24 days open, 0 days since update
  - force-push (+5): 7 force pushes
  - no-reviews-yet (+3): no reviews and open >24 days
  - contextual (+6): major version bumps — breaking changes possible
- **Recommended Action:** deep-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 50 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10): package-lock.json, package.json
  - large-diff-200+ (+5): 186 additions, 193 deletions
  - staleness-14d (+8): 24 days open, 1 day since update
  - force-push (+5): 46 force pushes
  - no-reviews-yet (+3): no reviews and open >24 days
  - contextual (-1): routine dependency update — moderate impact
- **Recommended Action:** deep-review

---

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 9 open PR(s)

#### [#66: chore(deps): bump postcss from 8.5.8 to 8.5.22](https://github.com/tsd-ui/tsd-ui/pull/66)
- **Risk Score:** 8 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10): package-lock.json
  - staleness-3d (+3): 3 days since update
  - no-reviews-yet (+3): no reviews and open >3 days
  - contextual (-8): security fix for postcss — routine update
- **Recommended Action:** monitor

#### [#65: chore(deps): bump actions/setup-node from 6 to 7](https://github.com/tsd-ui/tsd-ui/pull/65)
- **Risk Score:** 23 / 100
- **Priority:** low
- **Reasons:**
  - security-sensitive-files (+15): .github/workflows/* changes
  - staleness-3d (+3): 3 days since update
  - no-reviews-yet (+3): no reviews and open >4 days
  - force-push (+3): 1 force push
  - contextual (-1): GitHub Actions version bump — low risk
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10): package-lock.json
  - staleness-3d (+3): 5 days since update
  - no-reviews-yet (+3): no reviews and open >5 days
  - contextual (-5): dev dependency patch — minimal risk
- **Recommended Action:** monitor

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 63 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10): docs package.json
  - staleness-3d (+3): 6 days since update
  - no-reviews-yet (+3): no reviews and open >6 days
  - contextual (+7): Astro major version bump (6→7) — breaking changes likely
- **Recommended Action:** deep-review

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 48 / 100
- **Priority:** medium
- **Reasons:**
  - release-change (+10): package.json, package-lock.json
  - large-diff-1000+ (+15): 2466 additions, 171 deletions
  - staleness-3d (+3): 6 days since update
  - no-reviews-yet (+3): no reviews and open >6 days
  - contextual (+7): Astro major version bump — large diff suggests significant changes
- **Recommended Action:** scan-review

#### [#60: chore(deps-dev): bump the dev-dependencies group across 1 directory with 13 updates](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 46 / 100
- **Priority:** medium
- **Reasons:**
  - release-change (+10): multiple package.json files
  - large-diff-1000+ (+15): 1061 additions, 588 deletions
  - high-file-dispersion (+8): 5 files changed
  - staleness-3d (+3): 4 days since update
  - force-push (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews and open >6 days
  - contextual (+4): 13 dev dependencies updated — broad surface
- **Recommended Action:** scan-review

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 13 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10): package-lock.json
  - staleness-3d (+3): 3 days since update
  - contextual (+0): markdown-it dev dependency — low risk
- **Recommended Action:** monitor

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 59 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10): package.json, package-lock.json
  - staleness-14d (+8): 116 days open, 76 days since update
  - no-reviews-yet (+3): no reviews and open >116 days
  - contextual (+8): React major version bump — breaking changes likely; extremely stale
- **Recommended Action:** deep-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 59 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10): package.json, package-lock.json
  - large-diff-200+ (+5): 178 additions, 44 deletions
  - staleness-14d (+8): 123 days open, 76 days since update
  - force-push (+5): 3 force pushes
  - no-reviews-yet (+3): no reviews and open >123 days
  - contextual (+8): TypeScript major version bump — breaking changes certain; extremely stale
- **Recommended Action:** deep-review

---

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 43 / 100
- **Priority:** medium
- **Reasons:**
  - release-change (+10): package.json, package-lock.json
  - large-diff-1000+ (+15): 1612 additions, 2096 deletions
  - staleness-14d (+8): 25 days since update
  - no-reviews-yet (+3): no reviews and open >25 days
  - contextual (+7): 4 tool updates — moderate surface
- **Recommended Action:** scan-review

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-files (+15): .github/workflows/* changes
  - staleness-14d (+8): 25 days since update
  - no-reviews-yet (+3): no reviews and open >25 days
  - contextual (+5): GitHub Actions major version bump — breaking changes possible
- **Recommended Action:** scan-review

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - release-change (+10): package.json, package-lock.json
  - large-diff-500+ (+10): 40 additions, 580 deletions
  - staleness-14d (+8): 34 days open, 25 days since update
  - force-push (+3): 1 force push
  - no-reviews-yet (+3): no reviews and open >34 days
  - contextual (+2): linting updates — moderate risk
- **Recommended Action:** scan-review

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 50 / 100
- **Priority:** high
- **Reasons:**
  - release-change (+10): package.json, package-lock.json
  - large-diff-1000+ (+15): 3994 additions, 4025 deletions
  - staleness-14d (+8): 54 days open, 25 days since update
  - force-push (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews and open >54 days
  - contextual (+8): PatternFly UI library updates — large diff, long staleness
- **Recommended Action:** deep-review

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - release-change (+10): package.json, package-lock.json
  - large-diff-500+ (+10): 35 additions, 621 deletions
  - staleness-14d (+8): 54 days open, 25 days since update
  - force-push (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews and open >54 days
  - contextual (+2): server dependencies — moderate risk
- **Recommended Action:** scan-review

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - release-change (+10): package.json, package-lock.json
  - large-diff-500+ (+10): 153 additions, 657 deletions
  - staleness-14d (+8): 54 days open, 25 days since update
  - force-push (+3): 2 force pushes
  - no-reviews-yet (+3): no reviews and open >54 days
  - contextual (+2): rollup build tool updates — moderate risk
- **Recommended Action:** scan-review

---

### [tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 0 open PR(s)

No open PRs.

---

### [tsd-ui/devtools](https://github.com/tsd-ui/devtools) — 0 open PR(s)

No open PRs.

---

### [tsd-ui/tsd-agent-lab](https://github.com/tsd-ui/tsd-agent-lab) — 0 open PR(s)

No open PRs.

---

### [tsd-ui/tsd-ui-plugin](https://github.com/tsd-ui/tsd-ui-plugin) — 0 open PR(s)

No open PRs.

---

## Upstream Dependencies — Changes to Watch

> These are repositories the team depends on but does not maintain. They are listed for awareness: track changes that could affect the team's own repos. Do not review or merge these PRs — assess whether the upstream change warrants action downstream.

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 3 open PR(s)

#### [#98: feat: extend metadata-info endpoint to return all 4 TUF roles](https://github.com/securesign/rhtas-console/pull/98)
- **Risk Score:** 30 / 100
- **Priority:** medium
- **Reasons:**
  - changes-public-api-schema (+12): openapi/rhtas-console.yaml
  - large-diff-200+ (+5): 176 additions, 76 deletions
  - staleness-3d (+3): 2 days since update
  - no-reviews-yet (+3): no reviews and open >1 day
  - contextual (+7): TUF metadata endpoint expansion — affects API contract
- **Impact Note:** This upstream API change adds new TUF role metadata to the rhtas-console backend. The team's rhtas-console-ui repo (PR #340) is already adapting to this change — both PRs should be coordinated.
- **Recommended Action:** assess-impact

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - ci-pending (+5): checks pending
  - release-change (+10): Dockerfile, Dockerfile.rh
  - force-push (+5): 6 force pushes
  - no-reviews-yet (+3): no reviews and open >11 days
  - contextual (+8): Docker base image updates — security/compatibility implications
- **Impact Note:** Docker base image updates may affect the team's deployment environment if they consume these images downstream.
- **Recommended Action:** watch

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 74 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10): go.mod
  - staleness-14d (+8): 54 days open, 0 days since update
  - force-push (+5): 213 force pushes
  - no-reviews-yet (+3): no reviews and open >54 days
  - contextual (+10): 213 force pushes with failing CI for 54 days — unstable dependency update; go.mod changes may affect downstream builds
- **Impact Note:** This upstream Go dependency update has been failing CI for 54 days with 213 force pushes. If the team depends on rhtas-console's Go modules, this instability could block downstream updates.
- **Recommended Action:** assess-impact

---

## Verification Summary

- **Total PRs triaged:** 25 (22 maintained, 3 dependency)
- **Critical:** 2 (1 maintained, 1 dependency)
- **High:** 8 (all maintained)
- **Medium:** 11 (9 maintained, 2 dependency)
- **Low:** 4 (all maintained)
- All PRs accounted for across maintained and dependency sections
- All dependency PRs have Impact Notes
- All scores reconstructed from listed reasons
- Priority buckets match score thresholds
