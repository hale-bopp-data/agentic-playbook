---
title: "Recipe: Context Diet (Matrioska Pattern)"
status: active
created: 2026-03-15
tags: [recipe, context-management, memory, token-optimization]
difficulty: beginner
time: 30-60 min
---

# Recipe: Context Diet (Matrioska Pattern)

> Your agent's memory is eating your token budget. This recipe shows you how to fix it.

## The Problem

Every AI agent accumulates context files over time: memory, rules, session history, project notes. Left unchecked, these files grow until they consume a significant portion of your token window — leaving less room for actual work.

**Real numbers from our project:**
- Before diet: 1,342 lines of memory loaded every session
- After diet: 728 lines (-46%), organized in 3 levels
- Result: longer conversations, faster responses, same information available

## When To Use This

- Your agent's memory/context files are over 500 lines
- You notice conversations getting shorter or slower
- You have duplicate information across memory files
- You're paying for tokens that carry no useful context

## The Pattern: Matrioska (3 Levels)

Like Russian nesting dolls, information lives at the level that matches its access frequency:

```
L0: Index (MEMORY.md / .cursorrules)     ← Always loaded, <200 lines
    │   Contains: pointers to L1 files
    │
    ├── L1: Category Files                ← Loaded on demand, ~50 lines each
    │   │   rules.md, tooling.md, etc.
    │   │   Contains: operational rules, pointers to L2
    │   │
    │   └── L2: Detail Folders            ← Rarely loaded, deep reference
    │       architecture/, history/
    │       Contains: full context when needed
```

**Rule of thumb:**
- L0 answers: "where do I look?"
- L1 answers: "what are the rules?"
- L2 answers: "what's the full story?"

## Step by Step

### Step 1 — Measure (5 min)

Count your current context cost:

```bash
# Claude Code
find ~/.claude/projects/*/memory -name "*.md" -exec wc -c {} + 2>/dev/null

# Cursor
wc -c .cursorrules

# Codex
wc -c ~/.codex/rules/default.rules

# Generic: estimate tokens
total_bytes=$(find <context-dir> -name "*.md" -exec cat {} + | wc -c)
echo "Estimated tokens: $((total_bytes / 4))"
```

Write down the number. This is your baseline.

### Step 2 — Classify (10 min)

Read every context file. For each piece of information, ask:

| Question | If yes → | Level |
|----------|----------|-------|
| Is this a pointer to another file? | Index | L0 |
| Do I need this in every session? | Keep in L0 (max 200 lines) | L0 |
| Do I need this in most sessions? | Category file | L1 |
| Do I need this only sometimes? | Detail folder | L2 |
| Can I derive this from the code? | **Delete it** | — |
| Is this in git history? | **Delete it** | — |
| Is this already in a wiki/doc? | **Replace with pointer** | L0/L1 |

### Step 3 — Restructure (15 min)

Create the 3-level structure:

```
memory/
├── MEMORY.md              # L0: index only, <200 lines
├── rules.md               # L1: operational rules
├── tooling.md              # L1: tools and connections
├── feedback.md             # L1: user corrections
├── architecture/           # L2: deep reference
│   └── system-design.md
└── history/                # L2: session history
    └── sessions.md
```

**L0 (MEMORY.md)** should contain ONLY:
- Links to L1 files with one-line descriptions
- Nothing else. No rules, no history, no details.

**L1 files** should contain:
- The actual rules, connections, tools
- Pointers to L2 for deep details
- Max ~50-80 lines each

**L2 folders** should contain:
- Full history, architecture details, archived decisions
- Anything that's valuable but rarely needed

### Step 4 — Compress (10 min)

Apply these compression rules to each file:

1. **Pointers over content**: replace duplicated text with a link to the source
   - Before: 40 lines explaining the deploy process
   - After: `Deploy process: see wiki/guides/deploy.md`

2. **Tables over prose**: convert narrative descriptions to tables
   - Before: "The server is at 80.225.86.168, you access it via SSH..."
   - After: `| Server | 80.225.86.168 | SSH key: ~/.ssh/key |`

3. **Delete derivable info**: remove anything you can learn by reading the code
   - File structure descriptions (use `ls`)
   - Function signatures (use the code)
   - Git history summaries (use `git log`)

### Step 5 — Measure Again (2 min)

```bash
# Same command as Step 1
find <context-dir> -name "*.md" -exec wc -c {} + 2>/dev/null
```

Compare with your baseline. Target: **30-50% reduction**.

## Maintenance

The diet is not a one-time event. Context grows back. To prevent regression:

- **Weekly**: check if L0 is still under 200 lines
- **Per session**: when adding info, ask "which level?" before writing
- **Monthly**: re-run Step 1 to check for growth
- **Automate**: use [context-guard](../patterns/documentation-diet.md) to enforce rules in CI/CD

## Anti-Patterns

| Don't | Do Instead |
|-------|-----------|
| Put everything in one file | Split by access frequency (L0/L1/L2) |
| Duplicate wiki content in memory | Write a pointer: "see wiki/guides/X.md" |
| Keep session-by-session history | Compress to a table: date, topic, outcome |
| Store code patterns in memory | Let the agent read the actual code |
| Delete useful context to save space | Move it to L2, don't lose it |

## Real Results

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Memory lines | 1,342 | 728 | -46% |
| Files | 8 (flat) | 21 (3 levels) | Organized |
| Pointer density | 12% | 42% | 3.5x |
| Token cost/session | ~18,000 | ~12,570 | -30% |
| Conversation length | Shorter | Longer | Noticeable |

## See Also

- [Agent Census](agent-census.md) — discover all agent context on your machine
- [Governance Testuggine](governance-testuggine.md) — 3-layer system to prevent context rot
