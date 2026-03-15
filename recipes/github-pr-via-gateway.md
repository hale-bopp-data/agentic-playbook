---
title: "Recipe: GitHub PR via Gateway (Automated PR for AI Agents)"
status: active
created: 2026-03-15
tags: [recipe, github, pr, automation, gateway, multi-agent]
difficulty: beginner
time: 15 min (setup), 0 min (per PR after setup)
origin: "EasyWay S149 — agents couldn't create GitHub PRs because PATs live on the server, not on workstations"
---

# Recipe: GitHub PR via Gateway

> Your AI agent just committed and pushed. Now it needs to create a PR.
> But the GitHub PAT lives on the server, not on the workstation.
> This recipe solves that in one SSH call.

## The Problem

In a secure setup:
- **PATs/secrets live on the server** (not on developer machines)
- **AI agents run on workstations** (where there's no PAT)
- **GitHub API requires authentication** to create PRs

Result: the agent pushes the branch but can't create the PR. The human
has to open GitHub UI manually. Every. Single. Time.

We hit this on EasyWay with 14 repos and 6 agents. Session S149: Codex
pushed a branch but couldn't create a PR because `gh` wasn't installed
and the PAT wasn't available locally.

## The Solution: SSH Gateway

```
Workstation (agent)          Server (gateway)
  │                            │
  │ git push origin branch     │
  │ ─────────────────────────► │ (repo already cloned)
  │                            │
  │ ssh server "create PR"     │
  │ ─────────────────────────► │ curl GitHub API with PAT
  │                            │ ◄── PR #N created
  │ ◄───────────────────────── │
  │ "PR #7 created"            │
```

One SSH call. Zero secrets on the workstation.

## Prerequisites

- SSH access to a server (key-based, no password)
- `GITHUB_PAT` stored on the server (e.g., `/opt/secrets/.env`)
- Repository cloned on the server (for push, or just use the API)

## Setup (one-time, 15 minutes)

### 1. Store PAT on server

```bash
# On the server:
echo 'GITHUB_PAT=ghp_your_token_here' >> /opt/secrets/.env
chmod 600 /opt/secrets/.env
```

### 2. Create the gateway script

Save this on the server as `~/scripts/github-pr-create.sh`:

```bash
#!/usr/bin/env bash
# github-pr-create.sh — Create GitHub PR via API
# Usage: github-pr-create.sh <org> <repo> <head> <base> <title> [body]

set -euo pipefail

ORG="${1:?Usage: github-pr-create.sh <org> <repo> <head> <base> <title> [body]}"
REPO="$2"
HEAD="$3"
BASE="${4:-main}"
TITLE="$5"
BODY="${6:-Auto-generated PR}"

# Load PAT from secrets
source /opt/secrets/.env 2>/dev/null || { echo "ERROR: secrets not found"; exit 1; }

if [ -z "${GITHUB_PAT:-}" ]; then
    echo "ERROR: GITHUB_PAT not set"
    exit 1
fi

# Create PR via GitHub REST API
RESPONSE=$(curl -s -X POST "https://api.github.com/repos/${ORG}/${REPO}/pulls" \
    -H "Authorization: Bearer $GITHUB_PAT" \
    -H "Accept: application/vnd.github+json" \
    -d "$(python3 -c "
import json, sys
print(json.dumps({
    'head': sys.argv[1],
    'base': sys.argv[2],
    'title': sys.argv[3],
    'body': sys.argv[4]
}))
" "$HEAD" "$BASE" "$TITLE" "$BODY")")

# Extract PR number and URL
PR_NUM=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('number',''))" 2>/dev/null)
PR_URL=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('html_url',''))" 2>/dev/null)

if [ -n "$PR_NUM" ] && [ "$PR_NUM" != "None" ]; then
    echo "PR #${PR_NUM}: ${PR_URL}"
else
    ERR=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message','unknown error'))" 2>/dev/null)
    echo "ERROR: $ERR"
    exit 1
fi
```

```bash
chmod +x ~/scripts/github-pr-create.sh
```

### 3. Test from workstation

```bash
ssh your-server "bash ~/scripts/github-pr-create.sh \
    your-org your-repo feat/my-branch main 'feat: my change'"
```

## Usage: From Any AI Agent

### Claude Code / Cursor / Codex

Add this to your agent's instructions file:

```markdown
## GitHub PR (Circle 1 repos)
To create a PR on GitHub, use the SSH gateway:
ssh server "bash ~/scripts/github-pr-create.sh <org> <repo> <branch> main 'title'"
```

### From a script (Context Sync, CI/CD)

```bash
# In sync-context-files.sh or any automation:
if is_github_repo "$repo"; then
    ssh "$SERVER" "bash ~/scripts/github-pr-create.sh $ORG $repo $BRANCH main '$TITLE'"
fi
```

### From n8n

Use an "Execute Command" node:
```
ssh -i /path/to/key user@server "bash ~/scripts/github-pr-create.sh org repo branch main 'title'"
```

## Integration with Context Sync

The [Context Sync Engine](context-sync-n8n.md) already uses this pattern (S149):

```bash
# In sync-context-files.sh — Circle 1 handler:
if is_github_repo "$repo"; then
    # Push via GITHUB_PAT
    GH_URL="https://x-access-token:${GITHUB_PAT}@github.com/${ORG}/${repo}.git"
    git remote set-url origin "$GH_URL"
    git push -u origin "$BRANCH_NAME"
    git remote set-url origin "$ORIGINAL_URL"  # Restore

    # Create PR via GitHub API
    curl -s -X POST "https://api.github.com/repos/${ORG}/${repo}/pulls" \
        -H "Authorization: Bearer $GITHUB_PAT" ...
fi
```

## Security Model

| Aspect | How it's handled |
|--------|-----------------|
| PAT storage | Server only — never on workstation |
| SSH auth | Key-based, no password |
| PAT scope | `repo` scope (read/write repos) — minimum needed |
| PAT rotation | Update on server, all agents get it automatically |
| Audit trail | SSH logs + GitHub API audit log |

## EasyWay Implementation

On our setup:
- **Server**: Ubuntu on OCI (`80.225.86.168`)
- **PAT location**: `/opt/easyway/.env.secrets` (contains `GITHUB_PAT`)
- **SSH key**: `C:\old\Virtual-machine\ssh-key-2026-01-25.key`
- **Repos using this**: `agentic-playbook` (Circle 1, GitHub-only)
- **Integrated in**: `sync-context-files.sh` (Context Sync Engine)

Example from S149:
```bash
ssh server "source /opt/easyway/.env.secrets && \
    curl -s -X POST 'https://api.github.com/repos/hale-bopp-data/agentic-playbook/pulls' \
    -H \"Authorization: Bearer \$GITHUB_PAT\" \
    -H 'Accept: application/vnd.github+json' \
    -d '{...}'"
# → PR #7 created
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| PAT on workstation | Move to server — agents use SSH gateway |
| Using `gh` CLI on server | `gh` requires login/auth flow — use direct API instead |
| Hardcoding PAT in scripts | Always `source` from secrets file |
| Not restoring git remote URL after PAT push | Always save/restore `ORIGINAL_URL` |
| PR already exists error | Check first, or catch the error gracefully |

## Want to Help? Use This!

If you're contributing to any repo that uses this pattern:

1. **Push your branch** normally (`git push origin feat/your-branch`)
2. **PR creation is automated** — the Context Sync or agent handles it
3. If you need a PR manually: ask your AI agent, it knows the SSH gateway command

No PATs needed on your machine. No GitHub UI required. Just push and go.

## See Also

- [Context Sync with n8n](context-sync-n8n.md) — the sync engine that uses this for Circle 1 repos
- [Workspace Onboarding](workspace-onboarding.md) — sets up instructions for all agents
- [Governance Testuggine](governance-testuggine.md) — verifies everything stays in sync
