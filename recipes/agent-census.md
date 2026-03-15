---
title: "Recipe: Agent Census"
status: active
created: 2026-03-15
tags: [recipe, governance, multi-agent, token-optimization]
difficulty: beginner
time: 30 min
---

# Recipe: Agent Census

> You have more AI agents on your machine than you think. This recipe finds them all.

## The Problem

A modern developer typically has 3-5 AI agents installed: Claude Code, GitHub Copilot, Cursor, Codex, IDE-specific tools. Each one writes files to disk — memory, rules, sessions, cache. Nobody tracks the total footprint.

**Real numbers from our workstation:**
- 6 agent directories found
- 2.3 GB total disk usage
- One "agent" turned out to be a VS Code fork (not AI at all)
- One agent had 116 KB of auto-approve rules (99% were one-shot commands, never reused)

## When To Use This

- You have multiple AI coding tools installed
- You want to know your total agent context cost
- You suspect old/stale agent data is wasting disk or tokens
- You're setting up governance for a team

## Step by Step

### Step 1 — Scan (5 min)

```bash
# Find all agent directories in your home folder
for d in ~/.claude ~/.codex ~/.cursor ~/.copilot ~/.codeium \
         ~/.antigravity ~/.agents ~/.axetplugincache ~/.easyway; do
  if [ -d "$d" ]; then
    files=$(find "$d" -type f 2>/dev/null | wc -l)
    size=$(du -sh "$d" 2>/dev/null | cut -f1)
    echo "$d  $size  $files files"
  fi
done
```

### Step 2 — Classify (10 min)

For each directory found, determine:

| Question | Answer |
|----------|--------|
| Is this actually an AI agent? | Check for memory/rules/sessions, not just IDE extensions |
| What gets loaded per session? | Find the context/rules/memory files |
| How big are those files? | `wc -c <file>` — divide by 4 for token estimate |
| Is the content current or stale? | Check dates, look for duplicates |

Common agent context files:

| Agent | Context files | Type |
|-------|--------------|------|
| Claude Code | `~/.claude/projects/*/memory/*.md` | LLM context (loaded per session) |
| Cursor | `.cursorrules` + `~/.cursor/rules/` | LLM context |
| Codex | `~/.codex/rules/default.rules` | Local auto-approve (NOT LLM context) |
| Copilot | `~/.copilot/` | Usually just lock files |

**Important distinction**: not all agent files are LLM context. Auto-approve rules (like Codex `default.rules`) are used locally by the CLI and never sent to the model. Only count files that actually enter the token window.

### Step 3 — Record (10 min)

Write the census to a JSON file:

```json
{
  "$schema": "agent-census/v1",
  "generated": "2026-03-15",
  "summary": {
    "total_agents": 3,
    "total_disk_mb": 1622
  },
  "agents": [
    {
      "id": "claude",
      "name": "Claude Code",
      "path": "~/.claude",
      "disk_mb": 611,
      "files": 5608,
      "governance": { "status": "governed" },
      "context_per_session": {
        "bytes": 50279,
        "estimated_tokens": 12570,
        "type": "llm-context"
      }
    }
  ]
}
```

Save it somewhere persistent: `~/.easyway/agent-census.json` or `~/.config/agent-census.json`.

### Step 4 — Act on Findings (5 min)

Common actions after a census:

| Finding | Action |
|---------|--------|
| Agent X has huge rules file | Apply [Context Diet](context-diet-matrioska.md) |
| Agent Y has stale copy of Agent X's memory | Delete or set up sync |
| Directory Z is not an AI agent | Reclassify (IDE, cache, etc.) |
| Agent has empty memory dir | No action needed — minimal footprint |
| Sensitive data in rules (SSH keys, PATs) | Clean immediately |

## Server Level

The same census applies to servers where agents run in production, but the focus shifts from tokens to disk:

```bash
# Server scan: Docker images, build cache, agent dirs
echo "=== Docker ===" && docker system df
echo "=== Agent dirs ===" && du -sh ~/.claude ~/.codex 2>/dev/null
echo "=== Repos ===" && du -sh ~/project-* 2>/dev/null
echo "=== Stale repos ===" && for d in ~/project-*; do
  if [ -d "$d/.git" ]; then
    days=$(( ($(date +%s) - $(git -C "$d" log -1 --format='%ct')) / 86400 ))
    [ $days -gt 30 ] && echo "$d: $days days stale"
  fi
done
```

## Maintenance

- Re-run after installing/removing an AI tool
- Monthly scan for growth
- Automate with cron or CI/CD (see `agent-census-scan.sh`)

## See Also

- [Context Diet (Matrioska)](context-diet-matrioska.md) — reduce context file size
- [Governance Testuggine](governance-testuggine.md) — 3-layer anti-context-rot system
