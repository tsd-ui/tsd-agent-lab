# Slack Integration

The daily command center can post its digest to a Slack channel via an incoming webhook. This is a one-way push — no bot interaction, no commands.

## Setup

### 1. Create a Slack App

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Click **Create New App** > **From scratch**
3. Name it something like `tsd-agent-lab` and select your workspace
4. Click **Create App**

### 2. Enable Incoming Webhooks

1. In the app settings sidebar, click **Incoming Webhooks**
2. Toggle **Activate Incoming Webhooks** to On

### 3. Add a Webhook to a Channel

1. Click **Add New Webhook to Workspace**
2. Select the channel (e.g., `#tsd-agent-lab`)
3. Click **Allow**
4. Copy the webhook URL — it looks like `https://hooks.slack.com/services/T.../B.../...`

### 4. Save the Webhook URL

Create the config file (not committed to the repo):

```bash
cat > ~/.config/tsd-agent-lab/slack-webhook.env <<'EOF'
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/T.../B.../...
SLACK_CHANNEL=#tsd-agent-lab
EOF
```

The `SLACK_CHANNEL` line is for reference only — the webhook is bound to the channel you selected in step 3.

### 5. Test with Dry Run

```bash
# Generate a command center report first
./scripts/macos/daily-command-center.sh

# Preview the Slack payload without posting
./scripts/macos/post-to-slack.sh --dry-run reports/command-center-$(date +%Y-%m-%d).json
```

This prints the Block Kit JSON payload to stdout so you can verify formatting.

### 6. Post for Real

```bash
./scripts/macos/post-to-slack.sh reports/command-center-$(date +%Y-%m-%d).json
```

You should see the message appear in your Slack channel.

### 7. Enable Automatic Posting

Once you're confident the messages look right, add `--post-slack` to the command center's launchd invocation:

```xml
<key>ProgramArguments</key>
<array>
    <string>/Users/agent-lab/tsd-agent-lab/scripts/macos/daily-command-center.sh</string>
    <string>--post-slack</string>
</array>
```

Update the plist and reload:

```bash
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
```

## Message Format

The Slack message uses Block Kit and includes:

- **Header** with status emoji and date
- **Summary fields** — CI failures, stale docs, system health, PR activity
- **Action items** — what needs human attention
- **Top CI failures** (if any)
- **Health warnings** (if any)
- **Context footer** with generation timestamp

## Activation Checklist

Before enabling automated Slack posting:

1. **All 5 launchd jobs loaded** — verify with `launchctl list | grep tsd-agent-lab`
2. **Command center reviewed for 2+ days** — check `ls reports/command-center-*.md` for at least 2 reports
3. **Webhook configured** — create a Slack app, obtain an Incoming Webhook URL, and save it to `~/.config/tsd-agent-lab/slack-webhook.env`
4. **Dry-run verified** — run `./scripts/macos/post-to-slack.sh --dry-run reports/command-center-$(date +%Y-%m-%d).json | jq .` and confirm the payload looks correct
5. **Test post** — run `./scripts/macos/post-to-slack.sh reports/command-center-$(date +%Y-%m-%d).json` to send a real message

### Enabling Automated Posting

Once all prerequisites are met:
1. Update the command-center plist `ProgramArguments` to add `--post-slack`
2. Copy updated plist to `~/Library/LaunchAgents/`
3. Reload: `launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist && launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist`

### Rollback

To disable automated posting:
1. Remove `--post-slack` from the plist `ProgramArguments`
2. Copy updated plist to `~/Library/LaunchAgents/`
3. Reload the plist as above

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `SLACK_WEBHOOK_URL not configured` | Create `~/.config/tsd-agent-lab/slack-webhook.env` per step 4 |
| `jq is required but not found` | Install jq: `brew install jq` |
| HTTP 403 from Slack | Webhook URL may be revoked — regenerate in app settings |
| HTTP 404 from Slack | Channel may have been deleted or webhook disabled |
| Message not appearing | Check the webhook is still active in the Slack app settings |

## Activation Checklist

Before enabling automated Slack posting:

1. **All 5 launchd jobs loaded** — verify with `launchctl list | grep tsd-agent-lab`
2. **Command center reviewed for 2+ days** — check `ls reports/command-center-*.md` for at least 2 reports
3. **Webhook configured** — create a Slack app, obtain an Incoming Webhook URL, and save it to `~/.config/tsd-agent-lab/slack-webhook.env`
4. **Dry-run verified** — run `./scripts/macos/post-to-slack.sh --dry-run reports/command-center-$(date +%Y-%m-%d).json | jq .` and confirm the payload looks correct
5. **Test post** — run `./scripts/macos/post-to-slack.sh reports/command-center-$(date +%Y-%m-%d).json` to send a real message

### Enabling Automated Posting

Once all prerequisites are met:
1. Update the command-center plist `ProgramArguments` to add `--post-slack`
2. Copy updated plist to `~/Library/LaunchAgents/`
3. Reload: `launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist && launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist`

### Rollback

To disable automated posting:
1. Remove `--post-slack` from the plist `ProgramArguments`
2. Copy updated plist to `~/Library/LaunchAgents/`
3. Reload the plist as above
