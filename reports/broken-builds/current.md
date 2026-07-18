# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-18 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-18 06:02:01 |
| Status | 11 failure(s) across 3 repo(s) |

## Summary

11 failure(s) across 3 repo(s).

## Top Actions

| # | Repo | Issue | Confidence | Next Step |
|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) | npm publish requires 2FA or bypass-enabled granular token | confirmed | Update NPM_TOKEN secret with a granular access token that has 2FA bypass enabled for automation |
| 2 | [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) | Package not found in npm registry during version update | confirmed | Initial package must be published manually first; automation cannot publish v0.3.0 if v0.2.0 was never published |
| 3 | [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) | GitHub Pages deployment timeout | confirmed | Investigate GitHub Pages service capacity limits or consider increasing workflow timeout threshold |
| 4 | [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) | Playwright e2e test failure: Rekor Search by email | probable | Review test assertion logic and check if the backend search API response changed for email queries |
| 5 | [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) | Docker Hub connectivity timeout | probable | Add retry logic to the image check step or pre-cache the mariadb image in a setup step |

## Findings

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 🆕 new

#### Failure: Deploy to GH Pages / gh-pages / Deploy to GitHub Pages

**Observed Evidence** (verbatim from CI)
- Run: [28604785882](https://github.com/securesign/rhtas-console-ui/actions/runs/28604785882)
- Workflow: Deploy to GH Pages
- Job: gh-pages
- Step: Deploy to GitHub Pages
- SHA: c6e69bd881886fd298008b957acc939e2802874b
- Started: 2026-07-02T16:14:27Z
- Log excerpt:
  ```
  2026-07-02T16:25:21.9921413Z ##[error]Timeout reached, aborting!
  2026-07-02T16:25:21.9929645Z ##[error]Timeout reached, aborting!
  2026-07-02T16:25:21.9930496Z Canceling Pages deployment...
  2026-07-02T16:25:22.1339078Z Canceled deployment with ID c6e69bd881886fd298008b957acc939e2802874b
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** The GitHub Pages deployment step polled for deployment status for approximately 10 minutes (16:15-16:25), repeatedly receiving `deployment_queued` status before timing out. The deployment never progressed beyond the queued state, indicating either GitHub Pages service congestion or a stuck deployment queue.
- **Suggested next step:** Investigate GitHub Pages service capacity limits or consider increasing workflow timeout threshold. Check GitHub status page for reported Pages incidents on 2026-07-02. If this is a persistent issue, consider adding a retry mechanism or switching to a different deployment strategy.

**Reproduction Status**
- First seen

**Signature:** `securesign/rhtas-console-ui::Deploy to GH Pages::gh-pages::Deploy to GitHub Pages::Cleaning up orphan processes`

---

#### Failure: Deploy to GH Pages / gh-pages / Deploy to GitHub Pages

**Observed Evidence** (verbatim from CI)
- Run: [28603472215](https://github.com/securesign/rhtas-console-ui/actions/runs/28603472215)
- Workflow: Deploy to GH Pages
- Job: gh-pages
- Step: Deploy to GitHub Pages
- SHA: be33e9da0002ee3062edc9ae5f03d6402fcaed54
- Started: 2026-07-02T15:53:38Z
- Log excerpt:
  ```
  2026-07-02T16:04:32.0144334Z ##[error]Timeout reached, aborting!
  2026-07-02T16:04:32.0149817Z ##[error]Timeout reached, aborting!
  2026-07-02T16:04:32.0150984Z Canceling Pages deployment...
  2026-07-02T16:04:32.2852113Z Canceled deployment with ID be33e9da0002ee3062edc9ae5f03d6402fcaed54
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** Identical pattern to run 28604785882 — deployment stuck in `deployment_queued` state for approximately 10 minutes before timeout. This occurred ~20 minutes earlier than the previous failure, suggesting a sustained GitHub Pages service issue on 2026-07-02.
- **Suggested next step:** Same as above — this is the same issue occurring in a different run on the same day.

**Reproduction Status**
- First seen

**Signature:** `securesign/rhtas-console-ui::Deploy to GH Pages::gh-pages::Deploy to GitHub Pages::Cleaning up orphan processes`

---

#### Failure: CI (e2e) / run-e2e-ci / e2e-integration-tests / Run Playwright tests

**Observed Evidence** (verbatim from CI)
- Run: [28577442879](https://github.com/securesign/rhtas-console-ui/actions/runs/28577442879)
- Workflow: CI (e2e)
- Job: run-e2e-ci / e2e-integration-tests
- Step: Run Playwright tests
- SHA: 6377d57067f11840e30b97551f55068aee425f6e
- Started: 2026-07-02T08:47:37Z
- Log excerpt:
  ```
  2026-07-02T09:01:03.7276667Z   1 failed
  2026-07-02T09:01:03.7277744Z     [chromium] › tests/pages/rekor-search/search.spec.ts:15:7 › Rekor Search UI › Search by email ──
  2026-07-02T09:01:03.7278594Z   41 passed (9.8m)
  2026-07-02T09:01:03.9063972Z npm error Lifecycle script `test` failed with error:
  2026-07-02T09:01:03.9140675Z ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** flaky-test
- **Confidence:** probable
- **Root cause:** The Playwright test "Rekor Search UI › Search by email" failed in the chromium project. The test suite had 41 passing tests but this single test failed after multiple retries (log shows "retry2" in the screenshot path). The failure is isolated to the email search functionality, suggesting either a timing issue, a data dependency, or a change in the backend API response format.
- **Suggested next step:** Review test assertion logic and check if the backend search API response changed for email queries. Examine the screenshot artifact and error-context.md file to understand the actual vs expected state. Consider adding more robust wait conditions if this is a timing issue.

**Reproduction Status**
- First seen

**Signature:** `securesign/rhtas-console-ui::CI (e2e)::run-e2e-ci / e2e-integration-tests::Run Playwright tests::Cleaning up orphan processes`

---

#### Failure: CI (e2e) / run-e2e-coverage / coverage / Tests with coverage

**Observed Evidence** (verbatim from CI)
- Run: [28577442879](https://github.com/securesign/rhtas-console-ui/actions/runs/28577442879)
- Workflow: CI (e2e)
- Job: run-e2e-coverage / coverage
- Step: Tests with coverage
- SHA: 6377d57067f11840e30b97551f55068aee425f6e
- Started: 2026-07-02T08:47:37Z
- Log excerpt:
  ```
  2026-07-02T09:18:54.6580347Z     [chromium] › tests/pages/rekor-search/search.spec.ts:22:7 › Rekor Search UI › Search by hash ───
  2026-07-02T09:18:54.6581239Z   39 passed (27.3m)
  2026-07-02T09:18:54.8471094Z npm error Lifecycle script `test` failed with error:
  2026-07-02T09:18:54.8541158Z ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** flaky-test
- **Confidence:** probable
- **Root cause:** Same test suite as the e2e-integration-tests job, but this time "Search by hash" failed in the coverage run. This suggests instability in the Rekor Search test suite, possibly due to external service dependencies or timing-sensitive assertions. The coverage job took significantly longer (27.3m vs 9.8m), which may exacerbate timing issues.
- **Suggested next step:** Same as the email search failure — investigate the Rekor Search test suite for timing dependencies and external service flakiness. Consider whether coverage instrumentation affects test timing.

**Reproduction Status**
- First seen

**Signature:** `securesign/rhtas-console-ui::CI (e2e)::run-e2e-coverage / coverage::Tests with coverage::Cleaning up orphan processes`

---

#### Failure: CI (e2e) / run-e2e-coverage / check-images / Check server_db_image image exists

**Observed Evidence** (verbatim from CI)
- Run: [28511728347](https://github.com/securesign/rhtas-console-ui/actions/runs/28511728347)
- Workflow: CI (e2e)
- Job: run-e2e-coverage / check-images
- Step: Check server_db_image image exists
- SHA: ebfe3e6ce212155f6a0edfdb7ba9d140ffcbf0d3
- Started: 2026-07-01T10:42:12Z
- Log excerpt:
  ```
  2026-07-01T10:44:32.1796729Z Image does not exist locally
  2026-07-01T10:45:02.1949689Z failed to configure transport: error pinging v2 registry: Get "https://registry-1.docker.io/v2/": context deadline exceeded
  2026-07-01T10:45:02.1977981Z ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** probable
- **Root cause:** The workflow attempted to verify that `docker.io/library/mariadb:10.5` exists by running `docker manifest inspect`. The image was not cached locally, so the command tried to reach Docker Hub's registry. The request to `https://registry-1.docker.io/v2/` timed out after 30 seconds, indicating network connectivity issues or Docker Hub service degradation at that time.
- **Suggested next step:** This is likely a transient network issue. Add retry logic to the image check step, or consider pre-caching the mariadb image in a setup step to avoid registry lookups during the check phase.

**Reproduction Status**
- First seen

**Signature:** `securesign/rhtas-console-ui::CI (e2e)::run-e2e-coverage / check-images::Check server_db_image image exists::Cleaning up orphan processes`

---

#### Failure: CI (e2e) / run-e2e-ci / e2e-integration-tests / Run Playwright tests

**Observed Evidence** (verbatim from CI)
- Run: [28176356788](https://github.com/securesign/rhtas-console-ui/actions/runs/28176356788)
- Workflow: CI (e2e)
- Job: run-e2e-ci / e2e-integration-tests
- Step: Run Playwright tests
- SHA: 9adad7a2ee3039bf94edebd4f62f559de245cb72
- Started: 2026-06-25T14:11:41Z
- Log excerpt:
  ```
  2026-06-25T14:24:42.1863829Z   2 failed
  2026-06-25T14:24:42.1864903Z     [chromium] › tests/pages/artifacts/accessibility.spec.ts:13:7 › Artifacts page Accessibility › Page view after search 
  2026-06-25T14:24:42.1866883Z     [chromium] › tests/pages/artifacts/accessibility.spec.ts:20:7 › Artifacts page Accessibility › Page view after expanding signature 
  2026-06-25T14:24:42.1887283Z   3 flaky
  2026-06-25T14:24:42.1888493Z     [chromium] › tests/pages/artifacts/accessibility.spec.ts:35:7 › Artifacts page Accessibility › Page view after expanding attestation 
  2026-06-25T14:24:42.1890462Z     [chromium] › tests/pages/artifacts/verification.spec.ts:67:7 › Artifacts Verification Flow › User has clear indicator of verification status per signature 
  2026-06-25T14:24:42.1892189Z     [chromium] › tests/pages/trust-root/certificates.spec.ts:13:7 › Trust Root - Certificates › Pagination 
  2026-06-25T14:24:42.1893034Z   37 passed (9.2m)
  ```

**Diagnosis** (model assessment)
- **Category:** flaky-test
- **Confidence:** probable
- **Root cause:** Two accessibility tests failed outright, and three additional tests were marked flaky (passed after retries). The accessibility tests are checking page state after interactions (search, expanding signature, expanding attestation). This pattern suggests timing issues where the DOM updates are not complete before assertions run, or accessibility tree updates lag behind visual rendering.
- **Suggested next step:** Review accessibility test wait conditions. Consider using Playwright's `waitForLoadState('domcontentloaded')` or specific element state waits before running accessibility assertions. Check if axe-core or the accessibility testing library needs time to analyze the updated DOM.

**Reproduction Status**
- First seen

**Signature:** `securesign/rhtas-console-ui::CI (e2e)::run-e2e-ci / e2e-integration-tests::Run Playwright tests::Cleaning up orphan processes`

---

### [tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 🆕 new

#### Failure: fullsend / dispatch / Triage / Triage / Mint triage token

**Observed Evidence** (verbatim from CI)
- Run: [28162819107](https://github.com/tsd-ui/conforma-policy-test/actions/runs/28162819107)
- Workflow: fullsend
- Job: dispatch / Triage / Triage
- Step: Mint triage token
- SHA: a47c9eec25ee1f00d4a785916dcea21d532802c2
- Started: 2026-06-25T10:09:52Z
- Log excerpt:
  ```
  2026-06-25T10:10:35.7424180Z Cleaning up orphan processes
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** The log excerpt only shows post-job cleanup output. The actual error that caused the "Mint triage token" step to fail is not captured in the provided excerpt. The step name suggests it involves obtaining an authentication token, which could fail due to permission issues, network timeouts, or invalid credentials.
- **Suggested next step:** Review the full workflow logs for the "Mint triage token" step to identify the actual error. Verify that the GitHub token used has the required permissions for the triage workflow.

**Reproduction Status**
- First seen

**Signature:** `tsd-ui/conforma-policy-test::fullsend::dispatch / Triage / Triage::Mint triage token::Cleaning up orphan processes`

---

#### Failure: fullsend / dispatch / Triage / Triage / Mint triage token

**Observed Evidence** (verbatim from CI)
- Run: [27759860180](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27759860180)
- Workflow: fullsend
- Job: dispatch / Triage / Triage
- Step: Mint triage token
- SHA: a47c9eec25ee1f00d4a785916dcea21d532802c2
- Started: 2026-06-18T12:36:18Z
- Log excerpt:
  ```
  2026-06-18T12:37:04.2182208Z Cleaning up orphan processes
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** Same as run 28162819107 — log excerpt only contains cleanup output, not the actual failure.
- **Suggested next step:** Same as above.

**Reproduction Status**
- First seen

**Signature:** `tsd-ui/conforma-policy-test::fullsend::dispatch / Triage / Triage::Mint triage token::Cleaning up orphan processes`

---

#### Failure: fullsend / dispatch / Triage / Triage / Mint triage token

**Observed Evidence** (verbatim from CI)
- Run: [27625553481](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27625553481)
- Workflow: fullsend
- Job: dispatch / Triage / Triage
- Step: Mint triage token
- SHA: d40b0706f1884f33d87496fe071cd7060a2ab06b
- Started: 2026-06-16T14:56:54Z
- Log excerpt:
  ```
  2026-06-16T14:57:45.0943381Z Cleaning up orphan processes
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** Same pattern — only cleanup logs provided.
- **Suggested next step:** Same as above.

**Reproduction Status**
- First seen

**Signature:** `tsd-ui/conforma-policy-test::fullsend::dispatch / Triage / Triage::Mint triage token::Cleaning up orphan processes`

---

#### Failure: fullsend / dispatch / Triage / Triage / Mint triage token

**Observed Evidence** (verbatim from CI)
- Run: [27623488109](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27623488109)
- Workflow: fullsend
- Job: dispatch / Triage / Triage
- Step: Mint triage token
- SHA: 54fabe16e78e969ec78a368966b0eaebf93fb74a
- Started: 2026-06-16T14:57:11Z
- Log excerpt:
  ```
  2026-06-16T14:58:00.7906531Z Cleaning up orphan processes
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** Same pattern — only cleanup logs provided. All four triage token failures show the same signature and only cleanup output. The collector should capture more log context to enable diagnosis.
- **Suggested next step:** Recommendation for all four triage token failures: Verify GitHub token permissions and check if the authentication service (likely GitHub Apps token minting endpoint) is accessible. If these failures persist, add explicit error logging to the token minting step.

**Reproduction Status**
- First seen

**Signature:** `tsd-ui/conforma-policy-test::fullsend::dispatch / Triage / Triage::Mint triage token::Cleaning up orphan processes`

---

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 🆕 new

#### Failure: Release / release / Publish to npm

**Observed Evidence** (verbatim from CI)
- Run: [26500983210](https://github.com/tsd-ui/tsd-ui/actions/runs/26500983210)
- Workflow: Release
- Job: release
- Step: Publish to npm
- SHA: a72636152d0c1c30b982e77d7e24965bdc565bb4
- Started: 2026-05-27T08:48:38Z
- Log excerpt:
  ```
  2026-05-27T08:49:29.3971365Z npm error code E403
  2026-05-27T08:49:29.3973164Z npm error 403 403 Forbidden - PUT https://registry.npmjs.org/@tsd-ui%2fcore - Two-factor authentication or granular access token with bypass 2fa enabled is required to publish packages.
  2026-05-27T08:49:29.3974959Z npm error 403 In most cases, you or one of your dependencies are requesting
  2026-05-27T08:49:29.3976063Z npm error 403 a package version that is forbidden by your security policy, or
  2026-05-27T08:49:29.3976992Z npm error 403 on a server you do not have access to.
  ```

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** The npm publish step failed because the NPM_TOKEN secret does not have 2FA bypass enabled, or is not a granular access token with the appropriate permissions. npm now requires either interactive 2FA (not possible in CI) or a granular access token with 2FA bypass for automated publishing.
- **Suggested next step:** Update the NPM_TOKEN secret in GitHub Actions with a granular access token that has 2FA bypass enabled. Generate this from npm account settings → Access Tokens → Generate New Token → Granular Access Token, and enable "Bypass 2FA requirement" when creating it.

**Reproduction Status**
- First seen

**Signature:** `tsd-ui/tsd-ui::Release::release::Publish to npm::Cleaning up orphan processes`

---

#### Failure: Release / release / Update package versions

**Observed Evidence** (verbatim from CI)
- Run: [26445057499](https://github.com/tsd-ui/tsd-ui/actions/runs/26445057499)
- Workflow: Release
- Job: release
- Step: Update package versions
- SHA: b8d24429929be30194655d4c2ee94c1c18554be9
- Started: 2026-05-26T09:48:47Z
- Log excerpt:
  ```
  2026-05-26T09:49:31.0641493Z npm error code E404
  2026-05-26T09:49:31.0642399Z npm error 404 Not Found - GET https://registry.npmjs.org/@tsd-ui%2fcore - Not found
  2026-05-26T09:49:31.0643087Z npm error 404
  2026-05-26T09:49:31.0643767Z npm error 404  '@tsd-ui/core@^0.2.0' is not in this registry.
  ```

**Diagnosis** (model assessment)
- **Category:** dependency-issue
- **Confidence:** confirmed
- **Root cause:** The release workflow attempted to update package versions to 0.3.0, but when running `npm install` to refresh lockfiles, it failed because `@tsd-ui/core@^0.2.0` does not exist in the npm registry. This indicates the package has never been successfully published. The workflow assumes the previous version exists in the registry when preparing for the next release.
- **Suggested next step:** This is a bootstrapping issue. The initial publish of `@tsd-ui/core` must succeed before automated releases can work. First resolve the 2FA/token issue from run 26500983210, then manually publish v0.2.0 (or delete the version constraint and publish 0.3.0 as the first version). After the first successful publish, subsequent automated releases will work.

**Reproduction Status**
- First seen

**Signature:** `tsd-ui/tsd-ui::Release::release::Update package versions::Cleaning up orphan processes`

---
