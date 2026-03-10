---
title: "Repo Lock"
status: active
created: 2026-03-10
tags: [agentic-playbook, pattern, coordination, semaphore]
---

# Repo Lock

> A simple file that tells other agents "I'm working here — don't touch."

## Problem

You have two AI agents (or two developers, or an agent and a developer) working on the same repository. Agent A starts editing `config.yaml`. Agent B, in a different session, also edits `config.yaml`. Both push. Merge conflict — or worse, one silently overwrites the other.

This isn't hypothetical. With AI agents that can autonomously create branches and PRs, it happens more often than you'd think. Agents don't check Slack. They don't see the other terminal window. They just code.

Without coordination:
- Silent overwrites destroy work
- Merge conflicts multiply
- Two agents create PRs that touch the same files
- Deploy during active development causes production issues

## Solution

A simple JSON file in the repo root: `.semaphore.json`

```json
{
  "status": "yellow",
  "session": "S120",
  "branch": "feat/new-dashboard",
  "agent": "claude-code",
  "timestamp": "2026-03-10T08:30:00Z",
  "note": "Working on dashboard components"
}
```

### States

| Status | Meaning | Action |
|--------|---------|--------|
| `green` | Repo is free | You can start working |
| `yellow` | Someone is working | Check who — coordinate or wait |
| `red` | Deploy in progress | DO NOT touch. Wait for green. |

### Protocol

**Start of session:**
1. Check `.semaphore.json` — if it exists and is yellow/red, STOP
2. If green or missing, create it with your session info and set to `yellow`

**End of session:**
1. Set status back to `green` (or delete the file)

**Before deploy:**
1. Set to `red` — nobody touches anything during deploy
2. After deploy verification, set back to `green`

```
# In your .cursorrules or agent instructions:
Check `.semaphore.json` BEFORE starting work.
If status is yellow/red and it's not your session → STOP and ask.
Set yellow at start of session, green at end.
```

### The file is gitignored

`.semaphore.json` lives in `.gitignore`. It's local coordination, not version-controlled state. Each environment (your laptop, the server, CI) has its own semaphore.

## Why It Works

It's the software equivalent of a "wet floor" sign. Simple, obvious, zero-tech, effective.

Complex locking systems (database locks, distributed mutexes) are overkill for this problem. You don't need consensus algorithms — you need a sticky note that says "I'm here."

The key insight: **agents can read files.** If you put coordination information in a file the agent reads at session start, the agent will respect it. No API needed. No service to run. Just a JSON file.

## Real Example

Two agents (Claude Code and Gemini) were configured to work on the same repository. Without coordination, Gemini created PR #413 and #414 modifying `.cursorrules` while Claude was mid-session on the same file.

After adding the repo lock:
- Each agent checks the semaphore at session start
- If another agent is active, it reports to the user and waits
- Zero file conflicts since adoption

## How to Customize

**Single developer**: You might not need this. But if you use multiple AI tools (Cursor + Claude Code + Copilot), add it — they don't talk to each other.

**Small team**: Add the developer's name instead of agent name. Same protocol.

**CI/CD integration**: Your deploy script sets `red` before deploying and `green` after. Any agent that starts a session during deploy sees `red` and stops.

**Expiry**: Add a `ttl_minutes` field. If the semaphore is older than the TTL, treat it as stale and take over (the previous session probably crashed without cleanup).

```json
{
  "status": "yellow",
  "session": "S120",
  "agent": "claude-code",
  "timestamp": "2026-03-10T08:30:00Z",
  "ttl_minutes": 120
}
```

## Related Patterns

- [Branch Flow Guard](branch-flow-guard.md) — prevents wrong merge targets
- [Traceability Gate](traceability-gate.md) — prevents orphan PRs
