#!/usr/bin/env bash
#
# setup-command-center-agent-lab.sh
# One-time setup to enable the command center under the agent-lab user.
# Run as: sudo -u agent-lab ./scripts/macos/setup-command-center-agent-lab.sh
#
set -euo pipefail

if [[ "$(whoami)" != "agent-lab" ]]; then
  echo "Error: this script must run as agent-lab" >&2
  echo "Usage: sudo -u agent-lab $0" >&2
  exit 1
fi

AGENT_HOME=$(dscl . -read /Users/agent-lab NFSHomeDirectory | awk '{print $2}')

# 1. Symlink PR review state so the command center can read it
PR_STATE_SRC="/Users/ryordan/workspaces/runs/.pr-review-state.json"
PR_STATE_DST="${AGENT_HOME}/workspaces/runs/.pr-review-state.json"
if [[ -f "$PR_STATE_SRC" ]] && [[ ! -e "$PR_STATE_DST" ]]; then
  ln -s "$PR_STATE_SRC" "$PR_STATE_DST"
  echo "Symlinked PR state: ${PR_STATE_DST} -> ${PR_STATE_SRC}"
else
  if [[ -e "$PR_STATE_DST" ]]; then
    echo "PR state already exists at ${PR_STATE_DST}, skipping"
  else
    echo "Warning: source PR state not found at ${PR_STATE_SRC}" >&2
  fi
fi

# 2. Create Slack webhook config (template)
CONFIG_DIR="${AGENT_HOME}/.config/tsd-agent-lab"
WEBHOOK_CFG="${CONFIG_DIR}/slack-webhook.env"
mkdir -p "$CONFIG_DIR"
if [[ ! -f "$WEBHOOK_CFG" ]]; then
  cat > "$WEBHOOK_CFG" <<'EOF'
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
SLACK_CHANNEL=#tsd-agent-lab
EOF
  echo "Created webhook config template at ${WEBHOOK_CFG}"
  echo "  -> Edit this file with your real webhook URL before enabling --post-slack"
else
  echo "Webhook config already exists at ${WEBHOOK_CFG}, skipping"
fi

# 3. Verify the command center script is accessible
CC_SCRIPT="${AGENT_HOME}/tsd-agent-lab/scripts/macos/daily-command-center.sh"
if [[ -x "$CC_SCRIPT" ]]; then
  echo "Command center script accessible at ${CC_SCRIPT}"
else
  echo "Warning: command center script not found or not executable at ${CC_SCRIPT}" >&2
fi

echo ""
echo "Setup complete. Test with:"
echo "  sudo -u agent-lab ${CC_SCRIPT} --dry-run"
