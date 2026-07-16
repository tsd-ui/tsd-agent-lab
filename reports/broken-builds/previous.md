# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-16 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-16 11:50:06 |
| Status | 10 failure(s) across 3 repo(s) |

## Summary

10 failure(s) across 3 repo(s).

6 unique failure signatures identified. All failures are recurring from the prior report (2026-07-13). Notable patterns: GitHub Pages deployment timeouts and flaky Playwright e2e tests (rhtas-console-ui), persistent triage token minting failures with truncated logs (conforma-policy-test), and npm publishing auth/registry issues (tsd-ui). Previously failing repos securesign/rhtas-console and tsd-ui/tsd-ui-team-docs are now clear.

## Top Actions

| # | Repo | Issue | Confidence | Next Step |
|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) | npm publish blocked by 2FA / granular token requirement | confirmed | Update the npm automation token to a granular access token with 2FA bypass enabled |
| 2 | [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) | npm install fails — @tsd-ui/core not published to registry | confirmed | Publish @tsd-ui/core to npm first, or switch to workspace protocol references |
| 3 | [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) | Docker Hub registry connection timeout during image check | confirmed | Re-run the workflow; if recurring, add retry or use a registry mirror |
| 4 | [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) | GitHub Pages deployment stuck in deployment_queued until timeout | probable | Check Pages environment settings and deployment queue for stuck deployments |
| 5 | [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) | Flaky Playwright e2e tests (Rekor Search, Artifacts accessibility) | probable | Stabilize timing-sensitive test assertions; add explicit waits |

## Findings

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 🔁 recurring

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
  npm notice Publishing to https://registry.npmjs.org/ with tag latest and public access
  npm error code E403
  npm error 403 403 Forbidden - PUT https://registry.npmjs.org/@tsd-ui%2fcore - Two-factor authentication or granular access token with bypass 2fa enabled is required to publish packages.
  npm error 403 In most cases, you or one of your dependencies are requesting
  npm error 403 a package version that is forbidden by your security policy, or
  npm error 403 on a server you do not have access to.
  npm error A complete log of this run can be found in: /home/runner/.npm/_logs/2026-05-27T08_49_28_733Z-debug-0.log
  ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** The npm automation token used in CI does not have the "bypass 2FA" permission required by npm's publish policy. npm enforces that packages published by automation tokens must use granular access tokens with 2FA bypass enabled. The git tag `v0.3.0` and GitHub release were successfully created earlier in the same workflow run, so those may need cleanup if re-attempting the release.
- **Suggested next step:** Generate a new granular access token on npmjs.com with the "bypass 2FA for automation" option enabled, then update the `NODE_AUTH_TOKEN` secret in the repository settings.

**Reproduction Status**
- Recurring (1 prior occurrence, first observed 2026-07-13)
- Signature: `tsd-ui/tsd-ui::Release::release::Publish to npm::Cleaning up orphan processes`

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
  npm version "$VERSION" --workspaces --no-git-tag-version
  @tsd-ui/core
  v0.3.0
  @tsd-ui/forms
  v0.3.0
  @tsd-ui/table-controls
  v0.3.0
  @tsd-ui/docs
  v0.3.0
  @tsd-ui/storybook
  v0.3.0
  npm error code E404
  npm error 404 Not Found - GET https://registry.npmjs.org/@tsd-ui%2fcore - Not found
  npm error 404
  npm error 404  '@tsd-ui/core@^0.2.0' is not in this registry.
  npm error 404
  npm error 404 Note that you can also install from a
  npm error 404 tarball, folder, http url, or git url.
  ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** After bumping workspace package versions to 0.3.0, npm tries to resolve inter-workspace dependencies from the registry. The packages reference each other via registry version ranges (e.g., `@tsd-ui/core@^0.2.0`) rather than workspace protocol references. Since `@tsd-ui/core` has never been published to npm (blocked by the 2FA token issue above), the registry lookup returns 404. This is a cascading consequence of the publish failure.
- **Suggested next step:** Fix the npm publish token issue first, then publish the initial package versions. Alternatively, switch internal workspace dependencies to use `workspace:*` protocol references so they resolve locally during builds.

**Reproduction Status**
- Recurring (1 prior occurrence, first observed 2026-07-13)
- Signature: `tsd-ui/tsd-ui::Release::release::Update package versions::Cleaning up orphan processes`

---

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 🔁 recurring

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
  Image does not exist locally
  failed to configure transport: error pinging v2 registry: Get "https://registry-1.docker.io/v2/": context deadline exceeded
  ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** The CI runner could not reach Docker Hub (`registry-1.docker.io`) within the connection timeout. The step attempted to inspect the `mariadb:10.5` image, which was not cached locally, so it fell back to `docker manifest inspect` against the remote registry. The connection timed out after 30 seconds, indicating a transient network issue between the GitHub Actions runner and Docker Hub.
- **Suggested next step:** Re-run the workflow to confirm it was transient. If it recurs, consider pre-pulling required images in an earlier step with retries, or caching the image in a private registry (e.g., GHCR) to avoid Docker Hub connectivity issues.

**Reproduction Status**
- Recurring (1 prior occurrence, first observed 2026-07-13)
- Signature: `securesign/rhtas-console-ui::CI (e2e)::run-e2e-coverage / check-images::Check server_db_image image exists::Cleaning up orphan processes`

---

#### Failure: Deploy to GH Pages / gh-pages / Deploy to GitHub Pages

**Observed Evidence** (verbatim from CI)
- Run: [28604785882](https://github.com/securesign/rhtas-console-ui/actions/runs/28604785882) (also [28603472215](https://github.com/securesign/rhtas-console-ui/actions/runs/28603472215))
- Workflow: Deploy to GH Pages
- Job: gh-pages
- Step: Deploy to GitHub Pages
- SHA: c6e69bd881886fd298008b957acc939e2802874b (also be33e9da0002ee3062edc9ae5f03d6402fcaed54)
- Started: 2026-07-02T16:14:27Z (also 2026-07-02T15:53:38Z)
- Log excerpt (from run 28604785882):
  ```
  Current status: deployment_queued
  Getting Pages deployment status...
  Current status: deployment_queued
  ...
  ##[error]Timeout reached, aborting!
  ##[error]Timeout reached, aborting!
  Canceling Pages deployment...
  Canceled deployment with ID c6e69bd881886fd298008b957acc939e2802874b
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** probable
- **Root cause:** The GitHub Pages deployment action polls for deployment status but the deployment never leaves the `deployment_queued` state. After approximately 10 minutes of polling every 5 seconds, the action times out and aborts. Both runs on 2026-07-02 hit the same issue within ~20 minutes of each other, suggesting a GitHub Pages infrastructure problem or a stuck deployment queue for this repository. Possible causes include a prior deployment blocking the queue, GitHub Pages service degradation, or the Pages environment not being properly configured.
- **Suggested next step:** Check the GitHub Pages settings for the repository (Settings > Pages) and verify the environment is correctly configured. Check the Environments tab for stuck deployments. If the issue persists, try manually triggering a Pages deployment or contacting GitHub support.

**Reproduction Status**
- Recurring (1 prior occurrence, first observed 2026-07-13) — 2 runs affected
- Signature: `securesign/rhtas-console-ui::Deploy to GH Pages::gh-pages::Deploy to GitHub Pages::Cleaning up orphan processes`

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
       await expect(page.locator('[aria-label="Rekor Entries toolbar"]')).toBeVisible();
       ...
       at verify_search_page_has_main_sections (/home/runner/work/rhtas-console-ui/rhtas-console-ui/e2e/tests/pages/rekor-search/search.spec.ts:10:73)
       at /home/runner/work/rhtas-console-ui/rhtas-console-ui/e2e/tests/pages/rekor-search/search.spec.ts:19:11

     1 failed
       [chromium] › tests/pages/rekor-search/search.spec.ts:15:7 › Rekor Search UI › Search by email ──
     41 passed (9.8m)
  ```
- Run: [28176356788](https://github.com/securesign/rhtas-console-ui/actions/runs/28176356788)
- SHA: 9adad7a2ee3039bf94edebd4f62f559de245cb72
- Started: 2026-06-25T14:11:41Z
- Log excerpt:
  ```
     2 failed
       [chromium] › tests/pages/artifacts/accessibility.spec.ts:13:7 › Artifacts page Accessibility › Page view after search
       [chromium] › tests/pages/artifacts/accessibility.spec.ts:20:7 › Artifacts page Accessibility › Page view after expanding signature
     3 flaky
       [chromium] › tests/pages/artifacts/accessibility.spec.ts:35:7 › Artifacts page Accessibility › Page view after expanding attestation
       [chromium] › tests/pages/artifacts/verification.spec.ts:67:7 › Artifacts Verification Flow › User has clear indicator of verification status per signature
       [chromium] › tests/pages/trust-root/certificates.spec.ts:13:7 › Trust Root - Certificates › Pagination
     37 passed (9.2m)
  ```

Additionally, run 28577442879 also failed the coverage job:
- Job: run-e2e-coverage / coverage
- Step: Tests with coverage
- Log excerpt:
  ```
     [chromium] › tests/pages/rekor-search/search.spec.ts:22:7 › Rekor Search UI › Search by hash ───
     39 passed (27.3m)
  ```

**Diagnosis** (model assessment)
- **Category:** flaky-test
- **Confidence:** probable
- **Root cause:** Different Playwright e2e tests fail on different runs — `Search by email` on 07-02, `Artifacts accessibility` tests on 06-25, `Search by hash` in the coverage run. The 06-25 run also reported 3 explicitly "flaky" tests. The `verify_search_page_has_main_sections` helper expects an `[aria-label="Rekor Entries toolbar"]` element to be visible, which is a timing-sensitive assertion. The pattern of different tests failing each run with a high overall pass rate (37–41 out of 42) is characteristic of test flakiness from race conditions, not a consistent code bug. The coverage run's longer duration (27.3m vs 9.8m) amplifies timing issues.
- **Suggested next step:** Review the failing test helpers (especially `verify_search_page_has_main_sections` in `search.spec.ts`) for missing `waitFor` calls or insufficient timeouts. Consider adding explicit waits for network requests to complete before asserting on UI elements. Adding retry configuration in the Playwright config may reduce false negatives.

**Reproduction Status**
- Recurring (1 prior occurrence, first observed 2026-07-13) — 2 runs affected, plus 1 coverage job
- Signature: `securesign/rhtas-console-ui::CI (e2e)::run-e2e-ci / e2e-integration-tests::Run Playwright tests::Cleaning up orphan processes`

---

### [tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 🔁 recurring

#### Failure: fullsend / dispatch / Triage / Triage / Mint triage token

**Observed Evidence** (verbatim from CI)
- Runs: [28162819107](https://github.com/tsd-ui/conforma-policy-test/actions/runs/28162819107), [27759860180](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27759860180), [27625553481](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27625553481), [27623488109](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27623488109)
- Workflow: fullsend
- Job: dispatch / Triage / Triage
- Step: Mint triage token
- SHAs: a47c9eec (2 runs), d40b0706, 54fabe16
- Date range: 2026-06-16 through 2026-06-25
- Log excerpt (all 4 runs show only post-job cleanup — the actual failure output was not captured):
  ```
  /home/runner/work/conforma-policy-test/conforma-policy-test/.defaults
  Removing SSH command configuration
  [command]/usr/bin/git config --local --name-only --get-regexp core\.sshCommand
  ...
  Cleaning up orphan processes
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** The log excerpts for all 4 runs are truncated and only show post-job cleanup (git credential removal, orphan process cleanup). The actual error from the "Mint triage token" step is not captured in the available log data. The step name suggests it creates a GitHub App installation token or similar credential for triage operations. With 4 consecutive failures across 3 different commits spanning 9 days, this is a persistent issue rather than a transient one — likely a misconfigured GitHub App, missing secret, or permissions problem — but the root cause cannot be confirmed without the actual error output.
- **Suggested next step:** Manually inspect the full CI logs for any of these runs to retrieve the actual error message from the "Mint triage token" step. Check that the GitHub App installation used for token minting is still installed on the repository and that the required secrets are present and have not expired.

**Reproduction Status**
- Recurring (1 prior occurrence, first observed 2026-07-13) — 4 runs affected
- Signature: `tsd-ui/conforma-policy-test::fullsend::dispatch / Triage / Triage::Mint triage token::Cleaning up orphan processes`
