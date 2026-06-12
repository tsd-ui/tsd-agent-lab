# Experiments Directory

Safe workspace for testing agent workflows, skills, and patterns.

## Purpose

This directory is for:
- Testing new workflow patterns
- Evaluating agent capabilities
- Proof-of-concept implementations
- Learning and skill development
- Tool comparison experiments

## Structure

```
experiments/
├── skills/           # Individual skill experiments (Phase 5)
├── workflows/        # Multi-step workflow experiments (Phase 5)
└── README.md        # This file
```

## Experiment Guidelines

### Before Starting

1. Create a new subdirectory for each experiment
2. Include a README.md explaining the experiment
3. Document expected outcomes
4. Note any special safety considerations

### During Experiment

1. Follow all lab safety policies
2. Use only allowlisted repositories
3. Log all operations
4. Stay within resource limits
5. Monitor for unexpected behavior

### After Completion

1. Document results in experiment README
2. Capture lessons learned
3. Archive or clean up if disposable
4. Share findings with team
5. Update policies if needed

## Experiment Template

Create each experiment with this structure:

```
experiments/my-experiment/
├── README.md         # Experiment description and results
├── setup.sh          # Setup script (if needed)
├── run.sh            # Execution script
├── cleanup.sh        # Cleanup script
└── output/           # Results (gitignored)
```

### README.md Template

```markdown
# Experiment: [Name]

## Goal
What are you trying to learn or test?

## Hypothesis
What do you expect to happen?

## Setup
What configuration or preparation is needed?

## Procedure
Step-by-step instructions.

## Safety Considerations
What could go wrong? What controls are in place?

## Results
What actually happened?

## Lessons Learned
What did you learn? Would you do anything differently?

## Follow-up
What experiments or changes does this suggest?
```

## Safety Rules

### Always

- Use test repositories only
- Never use production credentials
- Validate before executing
- Log everything
- Clean up after completion

### Never

- Access production repositories
- Use real customer data
- Run untrusted code without review
- Skip safety checks
- Commit secrets to git

## Example Experiments

### Skills Evaluation (Phase 5)

```
experiments/skills/claude-code-skills-test/
├── README.md
├── test-read-skill.sh
├── test-search-skill.sh
└── results.md
```

### Workflow Pattern (Phase 5)

```
experiments/workflows/multi-file-refactor/
├── README.md
├── workflow-definition.yaml
├── run-workflow.sh
└── output/
```

### Tool Comparison (Phase 9)

```
experiments/tool-comparison/
├── README.md
├── claude-code-test.sh
├── superpowers-test.sh
├── opencode-test.sh
└── comparison-matrix.md
```

## Common Pitfalls

### Scope Creep
- Keep experiments focused
- One question per experiment
- Time-box your work

### Insufficient Documentation
- Document as you go
- Don't rely on memory
- Future you will thank you

### Skipping Safety Checks
- Never bypass controls "just this once"
- If controls block you, understand why
- Update policies thoughtfully, don't skip them

### Over-Engineering
- Simple scripts over complex frameworks
- Disposable code is okay
- Learn first, polish later

## Sharing Results

### Internal Sharing

1. Update experiment README with results
2. Mention in team meeting or chat
3. Link from relevant documentation
4. Archive in knowledge base

### External Sharing

Before sharing outside team:
1. Redact sensitive information
2. Use example names/repos
3. Remove internal context
4. Get team review

## Cleanup Policy

### Keep

- Successful experiments with reusable patterns
- Failed experiments with valuable lessons
- Tool comparison results
- Novel workflow patterns

### Archive

- Experiments older than 6 months
- Superseded by better approaches
- One-off learning exercises

### Delete

- Duplicate experiments
- Incomplete with no documentation
- Contains sensitive data that can't be redacted

## Getting Help

If an experiment:
- Violates safety controls: Stop and review
- Produces unexpected results: Document and investigate
- Fails to run: Check policies and allowlists
- Raises questions: Ask team before proceeding

## Best Practices

1. **Start small**: Simplest experiment that tests your hypothesis
2. **Document first**: Write README before coding
3. **Safety first**: Review threat model for new patterns
4. **Iterate**: Multiple small experiments beat one large
5. **Share early**: Don't wait for perfection

## Future Enhancements

Phase 5+ will add:
- Experiment templates
- Automated setup/teardown
- Result comparison tools
- Pattern library
- Workflow catalog

---

Happy experimenting! Remember: this is a lab. Failures are data.
