# Task: Code Review (Review-Only)

Review the codebase area described in the task specification. Produce a structured review as your final response.

## Review structure

Organize findings by severity:

### Critical
Issues that could cause data loss, security vulnerabilities, or production outages.

### High
Bugs, missing error handling, or logic errors that will affect users.

### Medium
Code quality issues, missing edge cases, or maintainability concerns.

### Low
Style inconsistencies, minor improvements, or documentation gaps.

## For each finding, include

- **Location:** file path and line range
- **Issue:** what is wrong or risky
- **Recommendation:** how to fix it
- **Confidence:** high, medium, or low

## Constraints

- **Review-only.** Do not modify any files.
- Write all output to `agent-output.md`.
- Focus on the area described in the task notes. Do not review the entire codebase unless asked.
- If you find no issues in a severity category, say so.
