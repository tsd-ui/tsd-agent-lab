# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-25 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-25 06:00:32 |
| Status | 0 CI failures, 8 collection errors |

## Summary

All monitored repos report **collection errors** (failed API queries). No CI failure data available.

This represents a systemic issue with the data collector, not actual build failures. All 8 repos encountered the same error: "Failed to query repo API".

## Findings

### Collection Errors

The following repos could not be queried:

| Repo | Error |
|---|---|
| [securesign/rhtas-console dependency](https://github.com/securesign/rhtas-console) | Failed to query repo API |
| [securesign/rhtas-console-ui maintained](https://github.com/securesign/rhtas-console-ui) | Failed to query repo API |
| [tsd-ui/conforma-policy-test maintained](https://github.com/tsd-ui/conforma-policy-test) | Failed to query repo API |
| [tsd-ui/devtools maintained](https://github.com/tsd-ui/devtools) | Failed to query repo API |
| [tsd-ui/tsd-agent-lab maintained](https://github.com/tsd-ui/tsd-agent-lab) | Failed to query repo API |
| [tsd-ui/tsd-ui maintained](https://github.com/tsd-ui/tsd-ui) | Failed to query repo API |
| [tsd-ui/tsd-ui-plugin maintained](https://github.com/tsd-ui/tsd-ui-plugin) | Failed to query repo API |
| [tsd-ui/tsd-ui-template maintained](https://github.com/tsd-ui/tsd-ui-template) | Failed to query repo API |

**Diagnosis** (model assessment)

- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** The data collector failed to authenticate or connect to the GitHub API for all monitored repositories. Possible causes include:
  - Missing or expired GitHub authentication token
  - Network connectivity issues
  - GitHub API rate limiting or service disruption
  - Incorrect API endpoint configuration
- **Suggested next step:** Verify the collector's GitHub token is valid and has appropriate permissions (likely needs `repo` or at minimum `public_repo` scope). Check collector logs for detailed error messages. Confirm network access to api.github.com.

---

**Note:** This report reflects a collector infrastructure issue, not repository build health. Once the collection error is resolved, actual CI failure data will be available for analysis.
