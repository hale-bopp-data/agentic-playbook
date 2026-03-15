---
title: "Use Cases — Real-World Scenarios"
status: active
created: 2026-03-15
tags: [guide, use-cases, onboarding, governance, real-world]
---

# Use Cases — Real-World Scenarios

> Three developers, three situations, one pattern. Find yours and start there.

---

## Scenario 1: "I just installed my first AI coding agent"

### Who you are
- You installed Claude Code, Cursor, or Copilot yesterday
- You've done a few sessions — it feels like magic
- You haven't thought about what the agent writes to disk
- Your `.cursorrules` is empty or you don't know it exists

### What you don't know yet

Your agent is already writing files. After 10 sessions:

```
~/.claude/           50 MB    (session transcripts, memory, cache)
~/.cursor/rules/      2 KB    (global rules, if any)
.cursorrules           0 KB    (you haven't created one)
```

This is fine. But in 3 months, without governance:

```
~/.claude/           600 MB   (5000+ files, growing daily)
.cursorrules          15 KB   (copy-pasted from Stack Overflow, never reviewed)
```

And your conversations will get shorter. Your agent will be slower. You won't know why.

### What to do now (15 minutes)

**Step 1: Create a `.cursorrules` file** in your project root.

Start with 10 lines, not 100. Tell your agent:
- What this project is
- What language/framework you use
- One rule you care about (e.g., "always write tests")

```markdown
# Project: my-app
# Stack: Node.js + React + PostgreSQL
# Rule: every new function needs a test
# Rule: never commit .env files
```

That's it. Your agent reads this at session start. You just gave it context that persists across sessions.

**Step 2: Run the Agent Census scan** (5 min)

```bash
for d in ~/.claude ~/.cursor ~/.copilot ~/.codex ~/.codeium; do
  if [ -d "$d" ]; then
    size=$(du -sh "$d" 2>/dev/null | cut -f1)
    echo "$d  $size"
  fi
done
```

Write down the numbers. This is Day 1. In a month, run it again. If something tripled in size, you'll want to know why.

**Step 3: Bookmark this page.** Come back when you hit Scenario 2.

### What NOT to do
- Don't copy a 200-line `.cursorrules` from the internet
- Don't install 5 agents at once
- Don't ignore the files your agent creates — they're your agent's memory

---

## Scenario 2: "I've been using AI agents for a few months"

### Who you are
- You have Claude Code + Copilot, maybe Cursor too
- Your `.cursorrules` has grown to 50-80 lines
- You've noticed conversations sometimes "forget" things
- You have a nagging feeling that something is accumulating

### What's probably happening

```
~/.claude/projects/your-project/memory/
├── MEMORY.md              180 lines  (started at 20, grew every session)
├── some_old_note.md        40 lines  (you forgot this exists)
└── another_note.md         60 lines  (duplicate of info in MEMORY.md)

~/.cursor/rules/
├── global.md               90 lines  (mix of useful rules and stale ones)

.cursorrules               120 lines  (half is outdated, you're not sure which half)
```

**Total context loaded per session: ~15,000 tokens.**
Of which maybe 8,000 are useful. The rest is noise your agent processes every time.

### The symptoms
- "Didn't I tell you this already?" — yes, but it's buried in 180 lines
- Conversations feel shorter than they used to
- You copy-paste the same instructions at the start of sessions
- You have rules that contradict each other

### What to do now (1 hour)

**Step 1: Agent Census** — find everything ([recipe](../recipes/agent-census.md))

```bash
# How many agents? How big?
for d in ~/.claude ~/.cursor ~/.copilot ~/.codex; do
  [ -d "$d" ] && echo "$d  $(du -sh "$d" | cut -f1)  $(find "$d" -type f | wc -l) files"
done
```

**Step 2: Context Diet** — compress your memory ([recipe](../recipes/context-diet-matrioska.md))

Read every line in your memory/rules files. For each one, ask:
- Do I need this every session? → Keep it
- Can I learn this from the code? → Delete it
- Is this already in a wiki/doc? → Replace with a link
- Is this from 3 months ago and irrelevant? → Delete it

Target: **cut 30-50%** of your context files.

**Step 3: Split by frequency** (Matrioska pattern)

```
MEMORY.md (L0)     — Index only. "Where do I look?" Max 100 lines.
├── rules.md (L1)  — The rules I need most sessions. ~50 lines.
├── tools.md (L1)  — Connections, APIs, commands. ~50 lines.
└── history/ (L2)  — Session history, old decisions. Read on demand.
```

**Step 4: Measure the difference**

Before diet: `wc -c memory/*.md` → X bytes → X/4 tokens
After diet: same command → Y bytes → Y/4 tokens

If you saved 30%+, you'll notice longer conversations within a day.

### What NOT to do
- Don't delete everything and start over (you'll lose useful context)
- Don't add "improvements" while doing the diet (diet only, no new features)
- Don't skip the measurement — the numbers prove it works

---

## Scenario 3: "I have multiple agents, a server, and it's getting out of control"

### Who you are
- You have 3-5 AI agents on your workstation (Claude, Copilot, Cursor, Codex, company tools)
- You run agents on a server too (n8n, CI/CD, Docker containers)
- Your total agent footprint is measured in **gigabytes**
- You've done diets before but the context grows back
- You feel like you're fighting entropy

### What we found when we were in your shoes

We scanned our workstation and found:

| Agent | Disk | What we discovered |
|-------|-----:|--------------------|
| Claude Code | 611 MB | 21 memory files, well-organized after diet |
| OpenAI Codex | 1,011 MB | 116 KB rules file with SQL DDL inlined in auto-approve patterns |
| "Gemini agent" | 621 MB | Not an agent at all — a VS Code fork with extensions |
| GitHub Copilot | 5 KB | Just a lock file |
| Company tool | 43 MB | Cache with git objects, rules dir empty |
| Misc | 12 KB | Skill lock, minimal |

**Total: 2.3 GB** across 6 directories. One wasn't even an AI agent. One had 145 auto-approve rules of which 139 were one-shot commands that would never match again.

On the server:
- **12.6 GB** of Docker images were obsolete (old versions superseded by newer ones)
- **5 GB** of build cache never cleaned
- No monitoring of what was growing

### The three problems at scale

1. **Cross-agent blindness**: each agent has its own memory, rules, context. None knows about the others. You're the only integration point.

2. **Context regrowth**: you do a diet, it works. Three weeks later, you're back to where you started. Without active governance, context rot wins.

3. **Server sprawl**: Docker images, build cache, session transcripts, log files — everything grows. Nobody watches the disk until it's full.

### What to do: The Testuggine (3-Layer Governance)

No single tool solves all three problems. You need overlapping shields:

```
Layer 1: Automated Rules (real-time)
  ↓ Blocks rot before it enters your repos
  ↓ Runs in CI/CD or pre-push hooks
  ↓ Score: 0.00-1.00, quality gate at 0.50

Layer 2: Health Monitoring (periodic)
  ↓ Detects degradation trends over days/weeks
  ↓ Cron job or workflow (n8n, GitHub Actions)
  ↓ Alerts: IMPROVED / NEUTRAL / DEGRADED

Layer 3: Human Review (end of session)
  ↓ Catches what automation misses
  ↓ Qualitative judgment, not rules
  ↓ Safety net, not routine
```

**Week 1: Agent Census** ([recipe](../recipes/agent-census.md))
- Scan all agent dirs on workstation
- Scan server (Docker, repos, agent dirs)
- Write `agent-census.json`
- Discover surprises (we guarantee you'll find at least one)

**Week 2: Context Diet** ([recipe](../recipes/context-diet-matrioska.md))
- Apply Matrioska to your largest agent's memory
- Target: -30% context size
- Measure before/after

**Week 3: Layer 1 — Automated rules**
- Add a pre-push check: does `.cursorrules` exist? Is it under 100 lines?
- Score your repos. Set a quality gate.
- Even a 5-line bash script is better than nothing:

```bash
#!/bin/bash
# pre-push-context-check.sh
if [ ! -f .cursorrules ]; then echo "WARN: .cursorrules missing"; fi
lines=$(wc -l < .cursorrules 2>/dev/null || echo 0)
if [ "$lines" -gt 100 ]; then echo "WARN: .cursorrules has $lines lines (max 100)"; fi
```

**Week 4: Layer 2 — Monitoring**
- Set up a weekly scan (cron, n8n, GitHub Action)
- Check: agent dir sizes, Docker images, stale repos
- Alert if anything grows > 20% in a week

**Layer 3: Just do it**
- At the end of each session, ask: "Did I leave the codebase better than I found it?"
- If you created a capability, does it have docs?
- If you changed architecture, are references updated?

### Results you can expect

| Metric | Before | After 1 month | After 3 months |
|--------|--------|---------------|----------------|
| Agent memory size | Growing 5%/week | Flat | Decreasing (compression) |
| Context tokens/session | 15,000-25,000 | 10,000-12,000 | 8,000-10,000 |
| Conversation length | Getting shorter | Stable | Longer |
| Docker disk waste | Unknown | Visible | Cleaned monthly |
| "Why did we do this?" | Lost | In memory files | In structured docs |
| Merge conflicts on shared files | Frequent | Rare | Eliminated (derived files) |

### What NOT to do
- Don't try to implement all 3 layers in one day
- Don't build a platform — start with scripts, evolve to tools
- Don't govern agents you don't control (company tools: observe and propose, don't enforce)
- Don't skip the census — you can't govern what you can't see

---

## The Pattern Behind All Three Scenarios

Whether you're Day 1 or Year 1, the principle is the same:

```
1. KNOW what you have    (Census)
2. COMPRESS what's bloated (Diet)
3. PREVENT regrowth       (Governance)
```

Start where you are. Do the next step. Come back when you're ready for more.

---

## FAQ

**Q: I only use one agent (Copilot). Do I need any of this?**
A: Start with a `.cursorrules` file. That's it. Come back when you add a second agent.

**Q: My company has its own AI tool. Can I apply this?**
A: The Census and Diet work for any agent. For company tools, observe and propose — don't enforce rules on tools you don't own.

**Q: How long before I see results?**
A: The Census takes 30 minutes and you'll find something surprising. The Diet takes 1 hour and you'll feel the difference in your next session. Layer 1 takes a day and prevents regrowth permanently.

**Q: This seems like a lot of overhead. Is it worth it?**
A: The overhead is front-loaded. Census: 30 min once. Diet: 1 hour once. Layer 1: 1 hour once, then it runs automatically. After that, you spend less time fighting your tools and more time building.

**Q: Can I automate all of this?**
A: Layer 1 and 2, yes. Layer 3 (human review) is intentionally manual. Automation has blind spots — that's why you need the human layer.
