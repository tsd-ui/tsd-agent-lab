# Implementation Plan: TSD Agent Lab

## Overview

Phased implementation of a local agentic SDLC lab for safe experimentation with AI coding assistants.

## Phase 0: Discovery and Safety Boundaries

**Status**: In Progress (0A complete)

### Phase 0A: Initial Lab Plan ✓

**Deliverables**:
- [x] Repository structure
- [x] README.md
- [x] ADR 0001
- [x] Implementation plan (this document)
- [x] Safety model overview
- [x] Assumptions and non-goals documentation

### Phase 0B: Threat Model Hardening

**Deliverables**:
- [ ] `docs/threat-model.md` - Comprehensive threat analysis
- [ ] `policies/default-policy.yaml` - Default safety policy
- [ ] `policies/repo-allowlist.example.yaml` - Repository allowlist template
- [ ] `policies/command-allowlist.yaml` - Approved command list
- [ ] `docs/operator-rules.md` - Lab operator guidelines

**Focus Areas**:
- Credential isolation mechanisms
- Command execution boundaries
- Repository access controls
- Audit and logging requirements
- Known weaknesses documentation

## Phase 1: Dedicated Local User Setup

**Goal**: Create isolated execution environment

**Tasks**:
- Create dedicated non-admin Mac user (`tsd-agent` or similar)
- Configure credential isolation
- Set up minimal environment
- Document user setup process
- Test isolation boundaries

**Deliverables**:
- User creation script/guide
- Environment configuration
- Isolation verification tests
- ADR documenting user setup decisions

## Phase 2: Global and Repo Instructions

**Goal**: Configure Claude Code and prepare for other tools

**Tasks**:
- Create `.claude/` configuration
- Write `CLAUDE.md` with lab-specific instructions
- Configure memory and settings
- Prepare for Superpowers integration
- Document instruction patterns

**Deliverables**:
- `.claude/settings.json`
- `CLAUDE.md` (repository-level)
- `docs/claude-code-config.md`
- Superpowers preparation notes

## Phase 3: Local Harness v0

**Goal**: Build minimal orchestration layer

**Tasks**:
- Create basic runner script
- Implement policy enforcement
- Add logging infrastructure
- Build command allowlist checker
- Test with simple workflows

**Deliverables**:
- `bin/agent-run` - Main runner script
- `lib/policy-enforcer.sh` - Policy checker
- `lib/logger.sh` - Logging utilities
- `docs/harness-design.md`
- ADR for harness architecture

## Phase 4: Runner Mode

**Goal**: Enable agent-driven workflows with safety rails

**Tasks**:
- Implement task queue mechanism
- Add workflow templates
- Build result capture system
- Create status reporting
- Test with Claude Code

**Deliverables**:
- Workflow templates
- Task queue implementation
- Result storage format
- Status dashboard/reporter
- Example workflows

## Phase 5: Skills and Workflow Experiments

**Goal**: Explore Superpowers-style capabilities

**Tasks**:
- Test Claude Code skills
- Experiment with workflow patterns
- Document useful patterns
- Compare with Superpowers
- Build reusable workflows

**Deliverables**:
- `experiments/skills/` - Skill experiments
- `experiments/workflows/` - Workflow patterns
- Comparison matrix (Claude Code vs Superpowers)
- Best practices guide

## Phase 6: First Real Pilot Task

**Goal**: Validate lab with actual work

**Tasks**:
- Select appropriate pilot task
- Run complete workflow
- Document everything
- Capture lessons learned
- Refine based on experience

**Deliverables**:
- Pilot task results
- Detailed retrospective
- Process improvements
- Updated policies based on learnings

## Phase 7: Patch-Only Mode

**Goal**: Enable safe code generation without PR creation

**Tasks**:
- Implement patch generation
- Add patch review workflow
- Create patch application tools
- Test safety boundaries
- Document patch workflow

**Deliverables**:
- Patch generation workflow
- Review tooling
- Safety verification tests
- Patch workflow guide

## Phase 8: Draft PR Mode (Manual, Explicit)

**Goal**: Controlled PR creation with human approval

**Tasks**:
- Build PR creation workflow
- Implement pre-flight checks
- Add human approval gate
- Configure PR templates
- Test across multiple repos

**Deliverables**:
- PR creation workflow
- Approval gate implementation
- PR templates
- Multi-repo test results
- PR workflow documentation

## Phase 9: Multi-Agent Comparison

**Goal**: Evaluate different agent approaches

**Tasks**:
- Set up OpenCode (if available)
- Run comparison experiments
- Document strengths/weaknesses
- Create decision matrix
- Make tool recommendations

**Deliverables**:
- Tool comparison matrix
- Experiment results
- Recommendation guide
- Cost/benefit analysis

## Phase 10: Protocol Playground

**Goal**: Experiment with advanced patterns

**Tasks**:
- Test multi-agent workflows
- Explore agent collaboration
- Experiment with verification patterns
- Test adversarial approaches
- Document novel patterns

**Deliverables**:
- Protocol experiments
- Pattern library
- Collaboration patterns
- Verification workflows

## Phase 11: Team Documentation and Operating Model

**Goal**: Prepare for team adoption

**Tasks**:
- Write comprehensive guides
- Create training materials
- Document operating procedures
- Build troubleshooting guides
- Establish support model

**Deliverables**:
- Team onboarding guide
- Operating procedures
- Troubleshooting runbook
- FAQ
- Support process

## Phase 12: GitHub Actions Experiment (Optional)

**Goal**: Explore CI integration possibilities

**Tasks**:
- Design safe CI integration
- Build read-only workflows
- Test in isolated repos
- Document risks and controls
- Make recommendation

**Deliverables**:
- CI integration design
- Example workflows
- Risk assessment
- Recommendation report

## Success Criteria

### Phase 0-3 (Foundation)
- Isolated environment operational
- Policies enforced automatically
- Basic workflows execute safely
- Audit trail captured

### Phase 4-6 (Validation)
- Real work completed successfully
- No production incidents
- Team confidence building
- Clear lessons learned

### Phase 7-9 (Expansion)
- Multiple workflow patterns validated
- Tool comparison complete
- Team practices documented
- Scaling path identified

### Phase 10-12 (Maturity)
- Advanced patterns proven
- Team self-sufficient
- Operating model established
- Future roadmap clear

## Risk Register

| Phase | Risk | Mitigation |
|-------|------|------------|
| 0-1 | Incomplete isolation | Thorough testing, security review |
| 2-3 | Policy gaps | Iterative hardening, known weaknesses doc |
| 4-5 | Tool limitations | Multi-tool strategy, realistic expectations |
| 6 | Pilot failure | Careful task selection, fallback plan |
| 7-8 | PR abuse | Strong approval gates, audit logging |
| 9-10 | Complexity creep | Clear non-goals, pragmatic scope |
| 11-12 | Premature scaling | Maintain prototype mindset |

## Timeline Expectations

- **Phase 0**: 1-2 days (planning and documentation)
- **Phase 1**: 2-3 days (user setup and testing)
- **Phase 2**: 1-2 days (configuration)
- **Phase 3**: 3-5 days (harness development)
- **Phase 4**: 2-3 days (runner mode)
- **Phase 5**: 1 week (experimentation)
- **Phase 6**: 1 week (pilot + retrospective)
- **Phase 7-8**: 1 week each (controlled workflows)
- **Phase 9-10**: 2 weeks (comparison and experiments)
- **Phase 11**: 1 week (documentation)
- **Phase 12**: 1 week (optional CI experiment)

**Total estimated time**: 6-8 weeks for core phases (0-11)

Note: These are estimates assuming part-time work alongside regular duties. Adjust based on team capacity and priorities.
