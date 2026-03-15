---
title: "Recipe: Session Telemetry — Measure Your AI Agent Sessions"
status: active
created: 2026-03-15
tags: [recipe, telemetry, governance, multi-agent, metrics]
difficulty: beginner
time: 5 min per session
---

# Recipe: Session Telemetry

> You can't improve what you don't measure. This recipe tracks every AI agent session in one file.

## The Problem

You use AI coding agents daily. But you don't know:
- How long your sessions actually last
- How many times the context window was compressed (compacting)
- Whether your productivity per session is improving or declining
- How different agents compare on the same tasks

Without data, "it feels faster" is the best you can say. With telemetry, you can prove it.

## Real Numbers (EasyWay Project)

Before context diet (pre-S146):

| Session | Agent | Duration | Items | Compacting | Notes |
|---------|-------|----------|-------|-----------|-------|
| S127 | Claude | 559 min | 4 | ~3-4 | Auto-Deploy Webhook |
| S140 | Claude | 802 min | 5 | ~5+ | Magic Cards, OpenRouter |
| S143 | Claude | 206 min | 3 | ~2 | Benchmark Testudo |

After context diet + Testuggine (S146+):

| Session | Agent | Duration | Items | Compacting | Score | Notes |
|---------|-------|----------|-------|-----------|-------|-------|
| S146 | Claude | 103 min | 3 | 0 | 0.18→0.18 | context-guard created |
| S147 | Claude | 616 min | 12 | ~1 | 0.18→1.00 | Diet score perfect |
| S148 | Claude | 150 min | 8+3 fix | 0 | 0.94→0.87 | Testuggine launch, 8 PR, wiki reorg |

**Key insight**: S148 produced more deliverables (8 items + 3 structural fixes + 8 PRs) with **zero compacting** than S143 (3 items, ~2 compacting). Less context noise = more productive work per minute.

## How It Works

One JSONL file. Every agent appends one line at the end of each session.

```
~/.easyway/session-telemetry.jsonl     (or any shared path)
```

### The Format

```jsonl
{"session":"S148","agent":"claude","date":"2026-03-15","start":"03:14","duration_min":150,"items_completed":8,"commits":9,"prs":8,"context_held":true,"compacting_count":0,"score_before":0.94,"score_after":0.87,"notes":"Testuggine launch, agent census, wiki reorg"}
```

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| session | string | yes | Session identifier (e.g., "S149", "sprint-3-day-2") |
| agent | string | yes | Agent name: "claude", "cursor", "copilot", "codex", "gemini", etc. |
| date | string | yes | ISO date (YYYY-MM-DD) |
| start | string | yes | Start time (HH:MM) |
| duration_min | number | yes | Duration in minutes |
| items_completed | number | no | Backlog items completed |
| commits | number | no | Commits made |
| prs | number | no | Pull requests created |
| context_held | boolean | no | Did the context last until session end? |
| compacting_count | number | no | How many times the context window was compressed. 0 = context held without cuts |
| score_before | number | no | Quality score at session start (0.00-1.00) |
| score_after | number | no | Quality score at session end |
| notes | string | yes | What was done (1-2 lines) |

## Setup: Add to Your Agent's Rules

Copy the appropriate block into your agent's configuration file.

### Claude Code (`~/.claude/projects/*/memory/` or `CLAUDE.md`)

```markdown
## Session Telemetry (MANDATORY)
At the end of every session, append a line to ~/.easyway/session-telemetry.jsonl:

{"session":"SXXX","agent":"claude","date":"YYYY-MM-DD","start":"HH:MM","duration_min":N,"items_completed":N,"commits":N,"prs":N,"context_held":true/false,"compacting_count":N,"notes":"brief description"}

Full instructions: ~/.easyway/session-telemetry-instructions.md
```

### Cursor (`.cursorrules` in project root)

```markdown
## Session Telemetry (MANDATORY)
At the end of every session, append a line to ~/.easyway/session-telemetry.jsonl:

{"session":"SXXX","agent":"cursor","date":"YYYY-MM-DD","start":"HH:MM","duration_min":N,"items_completed":N,"commits":N,"prs":N,"context_held":true/false,"compacting_count":N,"notes":"brief description"}

Full instructions: ~/.easyway/session-telemetry-instructions.md
```

### Gemini / Antigravity (`GEMINI.md` or rules file)

```markdown
## Session Telemetry (MANDATORY)
At the end of every session, append a line to ~/.easyway/session-telemetry.jsonl:

{"session":"SXXX","agent":"gemini","date":"YYYY-MM-DD","start":"HH:MM","duration_min":N,"items_completed":N,"commits":N,"prs":N,"context_held":true/false,"compacting_count":N,"notes":"brief description"}

Full instructions: ~/.easyway/session-telemetry-instructions.md
```

### OpenAI Codex (`~/.codex/instructions.md` or config)

```markdown
## Session Telemetry (MANDATORY)
At the end of every session, append a line to ~/.easyway/session-telemetry.jsonl:

{"session":"SXXX","agent":"codex","date":"YYYY-MM-DD","start":"HH:MM","duration_min":N,"items_completed":N,"commits":N,"prs":N,"context_held":true/false,"compacting_count":N,"notes":"brief description"}

Full instructions: ~/.easyway/session-telemetry-instructions.md
```

### GitHub Copilot

Copilot doesn't have persistent instructions. Track manually or via a wrapper script.

### Company/Enterprise Tools (Axet, etc.)

```markdown
## Session Telemetry (RECOMMENDED)
At the end of every session, append a line to ~/.easyway/session-telemetry.jsonl:

{"session":"SXXX","agent":"axet","date":"YYYY-MM-DD","start":"HH:MM","duration_min":N,"items_completed":N,"commits":N,"prs":N,"context_held":true/false,"compacting_count":N,"notes":"brief description"}
```

Note: "RECOMMENDED" not "MANDATORY" for tools you don't fully control.

### Generic Template (any agent)

```markdown
## Session Telemetry
At the end of every session, append one JSONL line to ~/.easyway/session-telemetry.jsonl:

{"session":"ID","agent":"AGENT_NAME","date":"YYYY-MM-DD","start":"HH:MM","duration_min":N,"items_completed":N,"commits":N,"prs":N,"context_held":true/false,"compacting_count":N,"notes":"what was done"}

Fields: session (ID), agent (name), date, start time, duration (minutes), items completed, commits, PRs, context_held (did context last?), compacting_count (0=no compression), notes.
```

## What to Measure: Before vs After

Run your agents for 1-2 weeks without changes (baseline). Then apply the [Context Diet](context-diet-matrioska.md) and [Governance Testuggine](governance-testuggine.md). Compare:

| Metric | Before | After | What it means |
|--------|--------|-------|---------------|
| duration_min (avg) | Track it | Compare | Longer = context lasts more |
| items_completed/session | Track it | Compare | Higher = more productive |
| compacting_count (avg) | Track it | Compare | Lower = less context wasted |
| context_held (% true) | Track it | Compare | Higher = sessions complete naturally |
| items/minute | Calculate | Calculate | The real productivity metric |

### Calculating items/minute

```python
# From session-telemetry.jsonl
import json

with open("~/.easyway/session-telemetry.jsonl") as f:
    sessions = [json.loads(line) for line in f if line.strip()]

for s in sessions:
    items = s.get("items_completed", 0)
    mins = s.get("duration_min", 1)
    rate = items / mins * 60  # items per hour
    print(f"{s['session']} ({s['agent']}): {rate:.1f} items/hour")
```

## Anti-Patterns

| Don't | Do Instead |
|-------|-----------|
| Skip telemetry on "small" sessions | Every session counts — small sessions reveal patterns too |
| Edit previous entries | Append only — history is sacred |
| Guess the compacting count | Ask your agent, or note "unknown" |
| Compare agents on duration alone | Compare items/minute — a 30-min focused session beats a 300-min unfocused one |
| Wait for "enough data" to start | Start now. 5 sessions is enough for a first comparison |

## See Also

- [Agent Census](agent-census.md) — know your agents before measuring them
- [Context Diet (Matrioska)](context-diet-matrioska.md) — the diet that improves your metrics
- [Governance Testuggine](governance-testuggine.md) — prevent metric regression
- [Use Cases — Real World](../guides/use-cases-real-world.md) — find your scenario
