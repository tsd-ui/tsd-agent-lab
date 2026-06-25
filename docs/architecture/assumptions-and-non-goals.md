# Assumptions and Non-Goals

## Assumptions

### Team and Access

1. **Team has Claude Code access**
   - Licensed and available for team use
   - Team members trained or willing to learn
   - Support available from vendor if needed

2. **Superpowers and OpenCode access planned**
   - Evaluation licenses obtainable
   - Tools compatible with our environment
   - Reasonable timeline for access

3. **GitHub access available**
   - Team has GitHub accounts
   - Can create repositories in relevant orgs
   - Personal access tokens manageable

4. **Mac workstations available**
   - Modern macOS version (11.0+)
   - Sufficient resources (8GB+ RAM, 256GB+ disk)
   - Admin access for initial setup

### Team Capabilities

5. **Basic Git proficiency**
   - Team understands branching, PRs, merging
   - Comfortable with command-line Git
   - Existing code review practices in place

6. **Shell scripting capability**
   - Can read and modify bash/zsh scripts
   - Comfortable with command-line tools
   - Understand file permissions and users

7. **Security awareness**
   - Understand credential management
   - Aware of production vs. experimental boundaries
   - Follow existing security policies

### Organizational Context

8. **Small team size**
   - Pragmatic controls appropriate
   - Direct communication possible
   - Informal coordination acceptable

9. **Multi-org reality stable**
   - Multiple GitHub orgs expected to persist
   - Not consolidating to single org soon
   - Cross-org workflows necessary

10. **Experimentation supported**
    - Management supports exploration
    - Time allocated for learning
    - Failure tolerated as learning

### Technical Environment

11. **No immediate production dependency**
    - Lab results not critical path
    - Failures won't block production work
    - Can iterate without pressure

12. **Local development workflows**
    - Team already works locally
    - Clone-edit-commit-push familiar
    - Local testing infrastructure exists

13. **Standard toolchain**
    - Git, editors, terminals available
    - Package managers accessible (brew, etc.)
    - Network access for tool downloads

## Non-Goals

### Scope Boundaries

1. **NOT a production service**
   - No SLA or uptime requirements
   - No on-call rotation
   - No production traffic
   - Can be down for learning/fixes

2. **NOT replacing GitHub Copilot**
   - We can't use Copilot (restriction)
   - Not trying to replicate Copilot features
   - Different use cases and patterns

3. **NOT a single-org solution**
   - Multi-org is a feature, not a bug
   - Not optimizing for single-org workflows
   - Not requiring org consolidation

4. **NOT auto-merge automation**
   - Human review always required
   - No autonomous merging
   - No comment-triggered merges
   - Deliberate human-in-loop

5. **NOT a GCP integration**
   - Avoiding cloud dependencies initially
   - Not building on Cloud Build, Cloud Run, etc.
   - Local-first architecture
   - Cloud optional for future

6. **NOT a long-running daemon (initially)**
   - Deliberate execution, not always-on
   - No background service (phase 0-6)
   - Operator invoked workflows
   - May evolve in later phases

### Feature Exclusions

7. **NOT webhook/comment automation**
   - No GitHub webhook integrations
   - No "magic comment" triggers
   - No automatic issue processing
   - Explicit invocation only

8. **NOT a shared credential system**
   - Each user manages own tokens
   - No service accounts (initially)
   - No shared PAT rotation
   - Individual responsibility

9. **NOT a comprehensive CI/CD**
   - Not replacing existing CI
   - Not deploying to production
   - No artifact management
   - Optional CI experiments in Phase 12 only

10. **NOT a code quality gate**
    - Not blocking production merges
    - Not enforcing team standards
    - Experimental only
    - Separate from main workflow

### Scale and Performance

11. **NOT optimized for high throughput**
    - Manual invocation acceptable
    - Latency not critical
    - Small batch sizes fine
    - Learning over speed

12. **NOT multi-user concurrent**
    - Single dedicated user (phase 0-6)
    - Sequential operation acceptable
    - No concurrency controls needed initially
    - May add later if needed

13. **NOT designed for large repos**
    - Small-to-medium repos expected
    - Large monorepos out of scope initially
    - May test scaling in later phases
    - Pragmatic limits acceptable

### Operational Aspects

14. **NOT formally certified**
    - No SOC2, ISO, or similar certification
    - Pragmatic security over compliance checkboxes
    - Team trust over audit theater
    - Appropriate for prototype

15. **NOT zero-configuration**
    - Setup required (dedicated user, policies)
    - Configuration management needed
    - Documentation and training necessary
    - Deliberate over automatic

16. **NOT supporting all GitHub features**
    - Basic PR workflow sufficient
    - Advanced GitHub features not priority
    - Projects, Actions, Packages not integrated
    - Core workflow focus

### Tool Integration

17. **NOT a unified tool wrapper**
    - Each tool (Claude Code, Superpowers, OpenCode) separate
    - No abstraction layer over tools
    - Direct tool usage
    - Compare, don't homogenize

18. **NOT vendor-locked**
    - Multi-tool evaluation strategy
    - Can switch or add tools
    - Portable patterns where possible
    - Tool-agnostic policies

19. **NOT integrating existing tools**
    - Not connecting to Jira, Slack, etc. (initially)
    - Focused scope
    - Can add integrations in later phases
    - Core workflow first

## Explicit Trade-offs

### Chosen: Safety over Speed
- More manual steps, more review
- Acceptable: Workflows are slower
- Benefit: Production protection

### Chosen: Local over Cloud
- Mac user setup, local execution
- Acceptable: Limited scale, single machine
- Benefit: No cloud costs, simpler ops

### Chosen: Pragmatic over Perfect
- Known gaps, documented weaknesses
- Acceptable: Not comprehensive coverage
- Benefit: Faster learning, iteration

### Chosen: Multi-tool over Single
- Evaluate Claude Code, Superpowers, OpenCode
- Acceptable: More complexity, comparison overhead
- Benefit: Informed decisions, avoid lock-in

### Chosen: Human Review over Automation
- All merges require approval
- Acceptable: Slower iteration
- Benefit: Learning, safety, team confidence

## Validation Criteria

These assumptions should be validated during Phase 0-1:

- [ ] Team confirms Claude Code access
- [ ] Mac workstation identified for dedicated user
- [ ] GitHub access and token creation verified
- [ ] Team capacity for experimentation confirmed
- [ ] Multi-org repository list collected
- [ ] Security policies reviewed and compatible
- [ ] Management support confirmed
- [ ] Timeline expectations aligned

If any assumption proves false, revisit design and scope accordingly.

## Future Relaxation

Some non-goals may become goals in later phases:

- **Daemon mode**: Could add in Phase 6+ if needed
- **Multi-user**: Could scale in Phase 9+ if successful
- **GCP integration**: Could add if value proven
- **CI integration**: Phase 12 explores this
- **Tool abstraction**: If patterns emerge across tools

These would require new ADRs and careful consideration.

## Review Cadence

Review assumptions and non-goals:
- After each major phase completion
- Monthly during active development
- When significant blockers encountered
- Before scaling or team expansion

Update this document as understanding evolves.
