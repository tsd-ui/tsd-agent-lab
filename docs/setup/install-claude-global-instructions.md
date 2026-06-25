# Installing Global Claude Instructions

This guide explains how to install the global `CLAUDE.md` template for the `agent-lab` user.

## What This Does

Claude Code reads `~/.claude/CLAUDE.md` before every session. The global instructions set baseline safety defaults and work habits that apply across all repositories.

## Prerequisites

- Logged in as the `agent-lab` user
- Claude Code installed
- The `tsd-agent-lab` repository cloned locally

## Install

From the `tsd-agent-lab` repo directory, run:

```bash
# Create the directory if it doesn't exist
mkdir -p ~/.claude

# Back up any existing global CLAUDE.md
if [ -f ~/.claude/CLAUDE.md ]; then
  cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)
  echo "Backed up existing CLAUDE.md"
fi

# Copy the template
cp docs/setup/global-CLAUDE.md ~/.claude/CLAUDE.md
echo "Installed global CLAUDE.md"
```

## Verify

```bash
cat ~/.claude/CLAUDE.md
```

You should see the safety defaults and work habits from the template.

## Customizing

Edit `~/.claude/CLAUDE.md` directly to add user-specific preferences. The template provides a starting point; tailor it to your workflow.

If you update the template in this repo, re-run the install snippet above to pick up changes. The backup step ensures you don't lose local customizations.

## Notes

- The install snippet backs up any existing file before overwriting.
- Do not automate this with a script that runs unattended -- the user should review what gets installed.
- The global instructions complement the repo-level `CLAUDE.md`, not replace it. Both are read by Claude Code.
