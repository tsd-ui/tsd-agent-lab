# Task: CI Failure Investigation

Investigate the CI failure described in the incident context above. Produce a root-cause analysis in `agent-output.md`.

## Workflow

1. Read the failure details in the incident context.
2. Locate relevant code paths that could cause this failure.
3. Examine test files, CI configuration, and build scripts.
4. Use `gh run view <run_id>` to inspect CI logs if run IDs are provided.
5. Check recent commits for changes that might have introduced the failure.
6. Determine the root cause with confidence levels.
7. Suggest remediation steps.

## Output format

Write your analysis to `agent-output.md` with these sections:

### Summary

One-paragraph description of the failure and its root cause.

### Root Cause Analysis

- **Root cause:** what is broken and why
- **Confidence:** high, medium, or low
- **Evidence:** what you found that supports this conclusion

### Affected Code

- File paths and line ranges
- Relevant functions or components

### Remediation

- **Recommended fix:** step-by-step description
- **Estimated complexity:** trivial, moderate, or complex
- **Risk:** what could go wrong with the fix

### Open Questions

List anything you could not determine or that needs human judgment.

## Constraints

- **Read-only.** Do not modify any files.
- Write all output to `agent-output.md`.
- Focus on the specific failure described. Do not review the entire codebase.
- If you cannot determine the root cause, say so clearly with your best hypothesis.
