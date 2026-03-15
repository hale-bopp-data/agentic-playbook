---
title: "Recipe: Governance Testuggine (3-Layer Anti Context Rot)"
status: active
created: 2026-03-15
tags: [recipe, governance, context-rot, automation, monitoring]
difficulty: intermediate
time: 2-4 hours (full setup)
---

# Recipe: Governance Testuggine

> Context rot is a force of nature. If you don't actively fight it, it wins.
> The Testudo formation doesn't use a single shield — it uses overlapping shields at different levels.

## The Problem

Every session with an AI agent adds context: guides, rules, memory, workflows, documentation. Without active governance:

- Pointers break (files renamed, paths changed)
- Content duplicates (same info in wiki + repo + memory)
- Agents accumulate independent context (each agent has its own memory)
- Guides become obsolete and nobody notices

No single tool catches all of this. You need **3 layers**, each covering the blind spot of the others.

## The Pattern

```
Layer 1: Automated Rules (real-time)     ← Blocks rot before it enters
Layer 2: Health Monitoring (periodic)    ← Detects degradation trends
Layer 3: Human Review (manual)           ← Catches what automation misses
```

| Layer | Frequency | Type | What it protects |
|-------|-----------|------|-----------------|
| 1 | Every push / CI | Deterministic rules | Repo governance files, pointer density |
| 2 | Weekly / daily | Trend analysis | Wiki, agent memory, Docker images, stale repos |
| 3 | End of session | Human judgment | Exceptions, architecture decisions, qualitative gaps |

## Prerequisites

- [Workspace Onboarding](workspace-onboarding.md) completed (workspace-map.yml exists — agents orient in 0s, not 75s)
- [Agent Census](agent-census.md) completed (you need to know where your agents live)
- [Context Diet](context-diet-matrioska.md) applied at least once (establishes baseline)
- CI/CD pipeline or cron jobs available

## Setup: Layer 1 — Automated Rules

**Goal**: block context rot in real-time, before it enters your repos.

### What to check

| Rule | What it validates | Example tool |
|------|-------------------|-------------|
| Governance files exist | `.cursorrules` + `AGENTS.md` in every repo | Custom linter, CI check |
| Pointer density | Context files use pointers, not duplicated content | `grep -c "see wiki\|see guide" .cursorrules` |
| Max files per directory | Wiki guides don't grow unbounded | `find guides/ -type f \| wc -l` |
| Max lines per file | Workflow files stay readable | `wc -l workflow.json` |
| Agent instructions coverage | Every enabled agent has its instructions file | `agent-home-sync.sh --check` |
| Agent instructions freshness | Instructions are < 30 days old | `stat` on each file |

### Minimal implementation

```bash
#!/bin/bash
# context-guard-lite.sh — run in CI/CD or pre-push hook
errors=0

# Rule 1: .cursorrules exists
if [ ! -f .cursorrules ]; then
  echo "FAIL: .cursorrules missing"
  errors=$((errors + 1))
fi

# Rule 2: AGENTS.md exists
if [ ! -f AGENTS.md ]; then
  echo "FAIL: AGENTS.md missing"
  errors=$((errors + 1))
fi

# Rule 3: pointer density > 20%
if [ -f .cursorrules ]; then
  total_lines=$(wc -l < .cursorrules)
  pointer_lines=$(grep -ci "see \|refer to \|guide:\|wiki/" .cursorrules || echo 0)
  if [ "$total_lines" -gt 0 ]; then
    density=$((pointer_lines * 100 / total_lines))
    if [ "$density" -lt 20 ]; then
      echo "WARN: pointer density ${density}% (target: >20%)"
    fi
  fi
fi

exit $errors
```

### Score

Define a simple 0.00–1.00 score:
- Each rule passed = +1
- Score = rules_passed / total_rules
- Quality gate: 0.50 (below = warning in CI)

## Setup: Layer 2 — Health Monitoring

**Goal**: detect degradation trends before they become emergencies.

### What to monitor

| Source | Metric | Alert threshold |
|--------|--------|----------------|
| Docker images | Superseded versions (old tag + new tag same repo) | Any superseded image |
| Build cache | Size | > 5 GB |
| Agent context dirs | File count growth | > 10 files on server |
| Repos | Days since last update | > 30 days |
| Wiki guides | File count per directory | > 50 files |
| Agent memory | Total bytes | > 100 KB (growing) |
| Agent instructions | Stale (> 30 days) or missing | Any agent without instructions |
| Agent sync config | Agents enabled but not synced | `agent-home-sync.sh --check` |

### Implementation options

1. **n8n workflow** (recommended if you have n8n): scheduled daily/weekly, collects stats, sends alerts
2. **Cron script**: `agent-census-scan.sh` on a schedule, pipe to email/webhook
3. **CI/CD job**: run weekly, fail if thresholds exceeded

### Deprecation detection logic

```javascript
// For Docker images: find superseded versions
const imagesByRepo = {};
for (const img of allImages) {
  if (!imagesByRepo[img.repo]) imagesByRepo[img.repo] = [];
  imagesByRepo[img.repo].push(img);
}
// If a repo has 2+ tags and only one is used by running containers,
// the others are deprecated
```

## Setup: Layer 3 — Human Review

**Goal**: catch what automation can't see.

### End-of-session checklist

At the end of each working session, verify:

1. Did I create a new capability? → Does it have a guide?
2. Did I change architecture? → Are cross-repo references updated?
3. Did I add a new tool/connection? → Is it in the connection registry?
4. Did I leave temporary files? → Clean up or document why they stay

### When Layer 3 triggers

Layer 3 is the safety net, not the routine:
- New capability that no rule covers yet
- Cross-repo changes that need coordinated updates
- Qualitative judgment: "is this guide still useful?"

## Measuring Success

Track these metrics over time:

| Metric | Healthy | Degrading | Action |
|--------|---------|-----------|--------|
| Layer 1 score | > 0.80 | < 0.50 | Fix failing rules |
| Deprecation items | 0-2 | > 5 | Run diet or cleanup |
| Memory size trend | Flat/decreasing | Growing > 5%/week | Apply Matrioska diet |
| Stale repos | 0 | > 3 repos > 30 days | Fetch or archive |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Only Layer 1 (rules but no monitoring) | Rot happens between checks — add Layer 2 |
| Only Layer 2 (monitoring but no enforcement) | You see the problem but can't prevent it — add Layer 1 |
| Skipping Layer 3 (no human review) | Automation has blind spots — keep the checklist |
| Over-automating Layer 3 | Human judgment can't be scripted — keep it manual |

## See Also

- [Agent Census](agent-census.md) — prerequisite: discover your agent footprint
- [Context Sync with n8n](context-sync-n8n.md) — keep repo context files fresh automatically
- [Workspace Onboarding](workspace-onboarding.md) — bootstrap the workspace map + multi-agent instructions
- [Context Diet (Matrioska)](context-diet-matrioska.md) — the diet that Testuggine protects
