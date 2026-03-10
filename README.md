---
title: "Agentic Playbook"
status: active
created: 2026-03-10
tags: [agentic-playbook, open-source, ai-agents, governance]
---

# Agentic Playbook

> This is what we use every day to build software with AI agents.
> Take it. Use it. Improve it. Pass it on.

---

## Why This Exists

We build software with AI agents. Over 120+ sessions, we learned the hard way what goes wrong without guardrails:

- **Secrets leak into git** — an agent commits a `.env` file, and your API key is in git history forever
- **PRs appear with no context** — nobody knows why a change was made, or which requirement it fulfills
- **Two agents edit the same file** — one overwrites the other, silently
- **Feature code lands on main** — bypassing your integration branch and review process
- **Fixes create new bugs** — a quick patch addresses the symptom, not the cause, and the bug returns next week in a different form

These all happened to us. We wrote down what we learned so you don't have to learn it the same way.

## How It Works

A `.cursorrules` file in your project root. Your AI agent reads it at the start of every session. The file contains **patterns** (rules that prevent specific problems) and **principles** (questions to ask before acting).

```
┌─────────────────────────────────────────────────┐
│                YOUR PROJECT                     │
│                                                 │
│  .cursorrules  ← agent reads this at session    │
│       │            start                        │
│       ▼                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │Traceabil.│  │ Branch   │  │Pre-commit│      │
│  │  Gate    │  │  Flow    │  │  Safety  │      │
│  │         │  │  Guard   │  │   Net    │      │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘      │
│       │              │              │            │
│       ▼              ▼              ▼            │
│  PR linked to    PR targets     Secrets          │
│  work item       correct branch  caught before   │
│                                  commit          │
└─────────────────────────────────────────────────┘
```

## Quick Start

```bash
# Clone the playbook
git clone https://github.com/hale-bopp-data/agentic-playbook.git

# Copy the template to your project
cp agentic-playbook/templates/cursorrules.template.md your-project/.cursorrules

# Edit it — keep what fits, remove what doesn't
# Your AI agent will read it automatically
```

No install. No dependencies. No account. Just a file in your project.

---

## What's Inside

### [Patterns](patterns/) — Rules that prevent specific problems

Each one: **Problem → Solution → Why it works → Real example → How to customize.**

| Pattern | What it prevents | Setup |
|---------|-----------------|-------|
| [Traceability Gate](patterns/traceability-gate.md) | PRs without context, untraceable changes | 5 min |
| [Structural Fix](patterns/structural-fix.md) | Patches that break again next week | Mindset |
| [Repo Lock](patterns/repo-lock.md) | Two agents editing the same file | 2 min |
| [Branch Flow Guard](patterns/branch-flow-guard.md) | Feature code on main, bypassing review | 10 min |
| [Pre-commit Safety Net](patterns/pre-commit-safety.md) | Secrets leaked in git history | 5 min |

### [Principles](principles/index.md) — 19 questions to ask before you act

Not commandments — reasoning tools. Organized in 5 themes:

```
CRAFT & QUALITY          ACTION & PRAGMATISM
  Measure Twice            Pragmatic Action
  Quality Over Speed       Quality Leap
  The Way of the Code      Adapt & Overcome
  Tangible Legacy          Revolutionary Minute

RISK & RESILIENCE        SECURITY & DEFENSE
  Absence of Evidence      Testudo Formation
  Black Swan Resilience    Victory Before Battle
  Known Bug Over Chaos     The Invisible Shield
  Start Small, Scale

VISION & COURAGE
  Electrical Socket Pattern
  Aim High, No Fear
  The Magnificent Fool
  The Island That Isn't
```

Each principle comes with **diagnostic questions** — the real value. Example:

> **Principle: Absence of Evidence** (Nassim Taleb)
>
> *"Are we confusing 'no problems found' with 'no problems exist'?"*
> *"Are our tests strong enough to find the black swans?"*

### [Templates](templates/) — Copy and go

| File | Purpose |
|------|---------|
| [cursorrules.template.md](templates/cursorrules.template.md) | Starter `.cursorrules` — copy, edit, done |
| [semaphore.schema.json](templates/semaphore.schema.json) | Repo lock file schema |
| [gedi-manifest.template.json](templates/gedi-manifest.template.json) | Ethics advisor manifest — fork with your own principles |

### [Evidence](evidence/case-studies.md) — Real case studies from our 70+ documented interventions

---

## Our Numbers

These are real measurements from our environment, not projections:

### Before & After

| Metric | Before Playbook | After Playbook |
|--------|:-:|:-:|
| Orphan PRs (no work item) | ~30% of all PRs | **0** |
| Secret leaks caught post-commit | 2 incidents | **0** (caught pre-commit) |
| Merge conflicts from agent overlap | Weekly | **0** (repo lock) |
| Fixes that broke something else | ~1 per sprint | **0** (structural fix rule) |
| Deploy during active development | 3 incidents | **0** (semaphore) |

### What we run with this playbook
- **9 repositories** (monorepo → polyrepo migration at session 53)
- **11 containers** in production
- **10 AI agents** with different roles (review, security, infrastructure, UX, ethics)
- **35 skills** in the agent platform
- **70+ documented ethical reviews** (GEDI casebook)
- All running on a **free ARM server** (4 cores, 24GB, $0/month)

### The OODA Decision Loop

When facing any non-trivial decision, we run this loop:

```
         ┌──────────┐
         │ OBSERVE  │ ← What's actually happening?
         └────┬─────┘   Read the error. Reproduce the bug.
              │         Don't guess.
              ▼
         ┌──────────┐
         │  ORIENT  │ ← Which principles apply?
         └────┬─────┘   Scan the 19 principles.
              │         Usually 2-3 are relevant.
              ▼
         ┌──────────┐
         │  DECIDE  │ ← What's the best action?
         └────┬─────┘   Consider alternatives.
              │         Document why this one.
              ▼
         ┌──────────┐
         │   ACT    │ ← Do it.
         └──────────┘   Then verify it worked.
```

This loop takes 2 minutes. It prevents hours of rework.

---

## Use Cases

### Case 1: Solo Developer + AI Agent

You're building a side project with Claude Code or Cursor. You want the agent to create PRs, fix bugs, and deploy.

**Use**: Traceability Gate + Pre-commit Safety Net + Branch Flow Guard

```bash
cp templates/cursorrules.template.md .cursorrules
# Remove the Repo Lock section (you're alone)
# Keep everything else
```

**Result**: Your agent creates linked PRs, never leaks secrets, and respects your branch strategy. You review and merge.

### Case 2: Team with Multiple AI Tools

Three developers using Cursor, Claude Code, and Copilot on the same monorepo. Agents sometimes work on the same files.

**Use**: All 5 patterns, especially Repo Lock

```bash
cp templates/cursorrules.template.md .cursorrules
cp templates/semaphore.schema.json .
echo ".semaphore.json" >> .gitignore
```

**Result**: Each agent checks the semaphore before starting. No more silent overwrites. Deploy is protected.

### Case 3: Platform with Autonomous Agents

Multiple AI agents running autonomously (code review, security scanning, infrastructure management). Agents create PRs and interact with your project management tool.

**Use**: All patterns + GEDI principles + custom rules

You'll want to:
1. Add the OODA loop to your agent's system prompt
2. Customize the Traceability Gate for your project management tool (Jira, Linear, ADO)
3. Add the Structural Fix rule so agents don't just patch symptoms
4. Add domain-specific rules at the bottom of `.cursorrules`

**Result**: Agents make traceable, reviewable, safe changes. Fixes are structural. The system gets more robust over time, not more fragile.

### Case 4: Open Source Project with Contributors

External contributors use their own AI agents to submit PRs. You can't control their tools, but you can set expectations.

**Use**: Traceability Gate + Branch Flow Guard as CI checks

Add the patterns as automated checks in your CI pipeline:
- PR without linked issue? → blocked
- Feature branch targeting main when develop exists? → blocked
- Secrets in diff? → blocked

Contributors (human or AI) get clear feedback on what to fix.

---

## How We Think About This

Every rule exists because we broke something without it. No rule is added "just in case." If it doesn't have a story behind it, it doesn't belong here.

AI doesn't replace judgment — it amplifies it. A good rule makes a good agent better. A bad rule makes any agent worse.

This is yours now. Fork it. Delete what doesn't apply. Add what you learn. The best playbook is the one your team actually uses.

### The Antifragile Rule

> *"If an error happens once and you had checked what you knew, it's not serious.*
> *If it happens twice, you weren't paying attention.*
> *If it happens three times, you're someone who shouldn't be given work."*

When an error happens the FIRST time, build the guardrail immediately. Don't wait for the second time.

---

## Where This Comes From

We built [EasyWay](https://github.com/easyway-data) — a data platform, one person + AI agents, 120+ sessions over 8 months. This playbook is what survived. The principles are formalized in **GEDI** (Governance & Ethical Decision Intelligence), which costs ~$0.10/month to run using DeepSeek.

**[Read the full story](THE-JOURNEY.md)** — from ChatGPT in a browser to a governed platform with 9 repos and 19 principles. How we learned git the hard way, why our first deploy broke production, and how every mistake became a rule.

### What We Got Wrong

We share our failures because they're more useful than our successes:

| What we believed | What actually happened |
|---|---|
| Monorepo is best | Split into 9 repos at session 53 — coupling was killing us |
| One database is enough | Needed 3 specialized engines (schema, ETL, policy) |
| "AI writes code" — just let it run | Hallucinations cost weeks — guardrails are mandatory |
| "Governance slows you down" | It prevents crashes. Every time we skipped it, we paid. |
| "We'll document later" | You can't reconstruct decisions without documentation. Later never comes. |

---

## Project Structure

```
agentic-playbook/
├── README.md                         # You are here
├── THE-JOURNEY.md                    # The full story — start here if you like stories
├── patterns/                         # Reusable rules
│   ├── traceability-gate.md          # Every PR needs a work item
│   ├── structural-fix.md             # Fix the cause, not the symptom
│   ├── repo-lock.md                  # Coordinate multi-agent access
│   ├── branch-flow-guard.md          # Enforce correct PR flow
│   └── pre-commit-safety.md          # Catch secrets before commit
├── principles/
│   └── index.md                      # 19 reasoning tools (GEDI)
├── templates/
│   ├── cursorrules.template.md       # Starter .cursorrules
│   ├── semaphore.schema.json         # Repo lock schema
│   └── gedi-manifest.template.json   # Ethics advisor (fork with your principles)
├── evidence/
│   └── case-studies.md               # Real cases (anonymized)
└── reddit/
    └── draft-posts.md                # Community posts (GEDI voice)
```

## License

Apache 2.0 — do whatever you want with it.

## Contributing

If you found a pattern that works, share it. Open a PR with:
1. **Problem** — what went wrong
2. **Solution** — what you do now
3. **Why it works** — the reasoning
4. **Real example** — what actually happened
5. **How to customize** — how others can adapt it

The best patterns come from real experience, not best-practice articles.

---

*We use this every day. Now it's yours too.*
