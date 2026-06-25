---
aliases: []
tags: []
---
# README

This section is under construction. Ideally I would like to codify our repos and environments.

A reasonable initial structure would be:

```text
tsd-agent-lab/
├── README.md
├── docs/
│   ├── architecture.md
│   ├── operating-model.md
│   ├── security-boundaries.md
│   └── repo-onboarding.md
├── catalog/
│   └── repositories.yaml
├── evaluations/
├── experiments/
├── environments/
│   ├── local-mac/
│   │   ├── bootstrap/
│   │   ├── services/
│   │   └── runbooks/
│   └── gcp/
│       ├── mint/
│       ├── inference/
│       └── runbooks/
└── scripts/
    ├── onboard-repo
    ├── run-agent
    └── check-lab
```

Do not commit GCP credentials, mint PEM files, GitHub tokens, generated runtime state or locally cloned target repositories into it.
