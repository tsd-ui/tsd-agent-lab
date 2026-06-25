# Operator Checklist

Pre-flight and post-execution checklists for every agent workflow execution.

## Pre-Flight Checklist

**Complete this checklist before EVERY workflow execution:**

### 1. Environment Verification

- [ ] **Logged in as agent user** (not your primary account)

  ```bash
  whoami  # Should output: agent-lab (or your agent username)
  ```

- [ ] **No production credentials in environment**

  ```bash
  env | grep -E '(AWS|GCP|AZURE|DATABASE|PROD)'  # Should be empty
  ```

- [ ] **Working directory is appropriate**

  ```bash
  pwd  # Should be in ~/workspaces/repos/tsd-agent-lab or an allowlisted repo
  ```

### 2. Repository Verification

- [ ] **Target repository is in allowlist**
  - Check `policies/repo-allowlist.yaml`
  - Confirm organization and repository name match exactly
  - Verify access level (read-only vs read-write)

- [ ] **Repository is not production**
  - Name does not contain: `production`, `prod`, `customer`, `pii`
  - Confirmed with team that repo is safe for experimentation

- [ ] **Correct organization context**
  - If working across multiple orgs, confirm you're in the right one
  - No cross-org work unless explicitly approved

### 3. Policy Verification

- [ ] **Policies are up to date**

  ```bash
  cd ~/workspaces/repos/tsd-agent-lab
  git pull origin main
  ```

- [ ] **Policy files exist**
  - `policies/default-policy.yaml`
  - `policies/repo-allowlist.yaml`
  - `policies/command-allowlist.yaml`

- [ ] **Organization-specific policies reviewed**
  - If applicable, check org-specific sections in allowlists

### 4. Workflow Planning

- [ ] **Workflow purpose documented**
  - Write a one-sentence description in workflow log
  - Example: "Testing agent's ability to add unit tests to demo-app"

- [ ] **Expected outcome defined**
  - What should the workflow produce?
  - How will you verify success?

- [ ] **Time budget set**
  - How long should this take?
  - When will you abort if stuck?

- [ ] **Review plan ready**
  - Who will review the PR?
  - What should they look for?

### 5. Tool Verification

- [ ] **Tool version confirmed**

  ```bash
  claude --version
  ```

- [ ] **Tool configuration reviewed**
  - Check `~/.claude/` config directory
  - Verify API keys are lab-scoped (not production)

### 6. Ready to Start

- [ ] All checklist items above completed
- [ ] You have 30+ minutes of uninterrupted time
- [ ] You know how to stop the workflow if needed

**If any item is unchecked or uncertain, STOP and resolve before proceeding.**

---

## During Execution

**Do:** Watch command execution in real-time, review file modifications as they happen, check for unexpected repository access, monitor resource usage.

**Don't:** Walk away from an active workflow, ignore warnings or confirmation prompts, approve operations you don't understand, skip reading command outputs.

### Emergency Stop

Stop the workflow immediately if: agent attempts to access a production repository, unexpected credential prompts appear, large-scale destructive operations are proposed, system becomes unresponsive, credential leakage is detected.

```bash
# 1. Interrupt the agent
Ctrl+C

# 2. Kill all agent processes
killall -u agent-lab

# 3. Review logs, document incident before cleanup
```

---

## Post-Execution Review

**Complete within 30 minutes of workflow completion:**

### 1. Process Review

- [ ] **Workflow completed or aborted cleanly**

  ```bash
  ps aux | grep agent-lab   # No hanging processes
  ```

- [ ] **Logs captured**
  - Workflow log exists in run directory
  - Timestamp and outcome recorded

### 2. Output Review

- [ ] **Files modified are expected**

  ```bash
  git status
  git diff
  ```

- [ ] **No sensitive files created**
  - Check for `.env`, `.pem`, `.key`, `credentials.*` files

- [ ] **File sizes are reasonable** — no unexpectedly large files, no binary blobs

### 3. Code Review (Before Creating PR)

- [ ] **Read every line of changed code** — understand what it does, verify it solves the intended problem

- [ ] **Security check**
  - No hardcoded secrets or tokens
  - No SQL injection or command injection opportunities
  - No XSS vulnerabilities
  - Input validation present where needed

- [ ] **Quality check** — follows project conventions, tests added if applicable, no obvious bugs

- [ ] **Diff review** — only intended files changed, no unrelated changes, commit messages are clear

### 4. Allowlist Compliance

- [ ] **No allowlist violations in logs**

  ```bash
  grep -i "violation" "$RUN_DIR/verification.log"
  ```

- [ ] **All repository access was authorized**
- [ ] **All commands were authorized**

### 5. Incident Check

- [ ] **No security events occurred** — no credential access attempts, no production system contact
- [ ] **If issues occurred, documented** — what happened, why, how resolved, how to prevent recurrence

See [incident-response.md](incident-response.md) if an incident occurred.
