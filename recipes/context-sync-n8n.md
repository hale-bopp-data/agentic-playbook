---
title: "Recipe: Context Sync with n8n (Keep Agent Context Fresh)"
status: active
created: 2026-03-15
tags: [recipe, n8n, context-sync, automation, testuggine]
difficulty: intermediate
time: 1-2 hours (full setup)
origin: "EasyWay S109-S149 — 40+ sessions of iteration on context drift across 14 repos"
---

# Recipe: Context Sync with n8n

> If you have more than one repo and more than one AI agent, your context files
> (.cursorrules, AGENTS.md, CLAUDE.md) WILL drift. It's not a matter of if, but when.

## The Problem

Every AI agent reads context files to understand your project. When you have multiple repos:

- Each repo has its own `.cursorrules` / `AGENTS.md`
- Updates to one repo don't propagate to others
- Agents in different repos operate on stale instructions
- Manual sync is tedious and error-prone

We learned this on EasyWay (14 repos, 6 agents): after 3 days without sync,
repos had diverged so much that agents were following outdated rules.

## The Pattern: Template + Overrides + Automation

```
Master Template (1 file)
  + Per-Repo Overrides (1 YAML)
  = Rendered context files (N repos)
  → Distributed via branch + PR (automated)
```

This is the **Electrical Socket Pattern**: one standard interface (the template),
pluggable per-repo customization (overrides), automated distribution (n8n + scripts).

## Architecture

```
n8n (scheduler)
  │
  ├─ Schedule: every 3 hours (or daily)
  │
  └─ Triggers: context-sync-cycle.sh
       │
       ├─ Step 1: REPO SYNC — git fetch + reset all repos
       ├─ Step 2: HARVEST — detect drift (bidirectional)
       ├─ Step 2b: MERGE — auto-apply safe additions
       ├─ Step 3: RENDER — master + overrides → per-repo files
       └─ Step 4: DISTRIBUTE — branch + PR per repo
```

## Prerequisites

- n8n instance (self-hosted or cloud)
- Git access to all target repos (PAT or SSH key)
- Server or CI runner that can execute bash scripts

## Step 1: Create Master Template

Create a single template file that all repos share. Use placeholders for per-repo values:

```markdown
# AGENTS.md — {{REPO_NAME}}

> {{REPO_DESCRIPTION}}

## Identity
| Field | Value |
|---|---|
| Stack | {{REPO_STACK}} |
| Branch | {{REPO_BRANCH_STRATEGY}} — PR target: `{{REPO_PR_TARGET}}` |

## Quick Commands
```bash
{{REPO_COMMANDS}}
`` `

## Structure
```text
{{REPO_STRUCTURE}}
`` `

{{REPO_SPECIFIC_RULES}}
```

**Best practice**: Keep the template under 60 lines. Use pointers ("see wiki guide X")
instead of inlining content. This is the [Context Diet pattern](context-diet-matrioska.md).

## Step 2: Create Overrides File

A YAML file with per-repo values for each placeholder:

```yaml
# repo-overrides.yml
my-backend:
  REPO_NAME: "my-backend"
  REPO_DESCRIPTION: "REST API + business logic"
  REPO_STACK: "Node.js / Express"
  REPO_BRANCH_STRATEGY: "feat -> main"
  REPO_PR_TARGET: "main"
  REPO_COMMANDS: |
    npm test
    npm run build
  REPO_STRUCTURE: |
    src/           # Application code
    tests/         # Test suites
    docs/          # API docs
  REPO_SPECIFIC_RULES: |
    - Always run tests before PR
    - Use conventional commits

my-frontend:
  REPO_NAME: "my-frontend"
  REPO_DESCRIPTION: "React SPA"
  REPO_STACK: "TypeScript / React / Next.js"
  REPO_BRANCH_STRATEGY: "feat -> main"
  REPO_PR_TARGET: "main"
  REPO_COMMANDS: |
    npm run dev
    npm run lint
  REPO_STRUCTURE: |
    app/           # Next.js app router
    components/    # Shared components
    lib/           # Utilities
  REPO_SPECIFIC_RULES: ""
```

## Step 3: Create the Render Script

The render script reads the template, substitutes placeholders with override values,
and writes the result to a staging directory:

```bash
#!/bin/bash
# render-context-files.sh — Render master + overrides → per-repo files

TEMPLATE="path/to/agents-master.md"
OVERRIDES="path/to/repo-overrides.yml"
OUTPUT_DIR="/opt/context-sync"

# Parse overrides (simple Python helper)
python3 -c "
import re, os, sys

# Read template
with open('$TEMPLATE') as f:
    template = f.read()

# Parse YAML-like overrides (or use PyYAML if available)
# ... render per-repo files to OUTPUT_DIR
"

echo "Rendered files to $OUTPUT_DIR"
```

**EasyWay implementation**: We use a full Python-based parser that handles multiline
values, nested structures, and timestamp injection. See our
[context-sync-governance guide](https://github.com/hale-bopp-data/agentic-playbook)
for the production version.

## Step 4: Create the Distribution Script

The distribution script takes rendered files and creates branch + PR per repo:

```bash
#!/bin/bash
# sync-context-files.sh — Distribute rendered files to repos

SYNC_DIR="/opt/context-sync"
BRANCH_NAME="context-sync/$(date -u +%Y-%m-%d)"

for repo_dir in "$SYNC_DIR"/*/; do
    repo=$(basename "$repo_dir")
    REPO_PATH="$HOME/$repo"

    [ ! -d "$REPO_PATH/.git" ] && continue

    cd "$REPO_PATH"
    git fetch origin main
    git checkout -b "$BRANCH_NAME" origin/main

    # Copy rendered files
    cp "$repo_dir/.cursorrules" .cursorrules 2>/dev/null
    cp "$repo_dir/AGENTS.md" AGENTS.md 2>/dev/null

    git add .cursorrules AGENTS.md
    git diff --cached --quiet && continue  # No changes

    git commit -m "chore: sync context files ($BRANCH_NAME)"
    git push -u origin "$BRANCH_NAME"

    # Create PR (GitHub example)
    curl -s -X POST "https://api.github.com/repos/ORG/$repo/pulls" \
        -H "Authorization: Bearer $GITHUB_PAT" \
        -d "{\"head\":\"$BRANCH_NAME\",\"base\":\"main\",\"title\":\"chore: sync context files\"}"

    git checkout main
done
```

**Key decisions from our experience:**

| Decision | Why |
|----------|-----|
| Branch + PR, not direct push | Respects branch policies, allows review |
| One branch per day, not per run | Avoids branch pollution on frequent runs |
| Delete old branch before creating new | Prevents "already exists" errors |
| Restore original remote URL after push | Don't leave PATs in git config |

## Step 5: Create n8n Workflow

Create a workflow in n8n with:

1. **Schedule Trigger**: every 3 hours (or daily at 06:00)
2. **Execute Command node**: runs `context-sync-cycle.sh`
3. **Error Handler**: sends alert on failure (webhook, email, Slack)

```json
{
  "name": "Context Sync Engine",
  "nodes": [
    {
      "name": "Every 3 Hours",
      "type": "n8n-nodes-base.scheduleTrigger",
      "parameters": {
        "rule": {
          "interval": [{ "triggerAtMinute": 0, "field": "hours", "hoursInterval": 3 }]
        }
      }
    },
    {
      "name": "Run Sync Cycle",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "/usr/bin/bash /path/to/context-sync-cycle.sh"
      }
    }
  ]
}
```

## Step 6: Bidirectional Harvest (Advanced)

The killer feature: if someone edits `.cursorrules` directly in a repo,
the harvest step detects it and proposes merging it back into the master template.

This prevents the "someone fixed a rule in one repo but it didn't propagate" problem.

```
Harvest Flow:
1. For each repo, diff rendered vs actual .cursorrules
2. Classify additions:
   - Global (applies to all repos) → merge into master template
   - Repo-specific → merge into overrides YAML
3. Auto-merge safe additions (pure additions, no conflicts)
4. Flag modifications for human review
```

**Our experience**: ~80% of drift is safe additions that can be auto-merged.
The remaining 20% are modifications that need human judgment (Layer 3 of Testuggine).

## Measuring Success

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| Days between syncs | 3-7 | 0 (automated) | < 1 day |
| Repos in sync | 60-80% | 100% | 100% |
| Agent orientation time | 30-75s | < 5s | < 10s |
| Manual sync effort | 30 min/week | 0 | 0 |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Template too large (200+ lines) | Apply [Context Diet](context-diet-matrioska.md) first |
| No overrides (all repos identical) | Even 2 repos differ — start with overrides from day 1 |
| Direct push instead of PR | Breaks branch policies, no review trail |
| No harvest (one-way sync only) | You'll lose repo-specific additions — add bidirectional |
| Running sync on every commit | Too noisy — every 3 hours or daily is enough |
| Forgetting to handle GitHub + ADO | If you use both, route by repo (Circle pattern) |

## From EasyWay's Experience

- **S109**: First version — n8n + sync script, one-way, 6 repos
- **S119**: Added bidirectional harvest + cycle orchestrator
- **S131**: AGENTS.md support + auto-merge safe additions
- **S147**: 13 repos synced, webhook-triggered
- **S149**: Fixed GitHub Circle 1 support — the sync was failing silently
  for 3 days because agentic-playbook used GitHub, not ADO

The key lesson: **context sync is infrastructure, not a nice-to-have**.
Without it, every agent session starts with stale information, and every
fix you make in one repo stays trapped there.

## See Also

- [Workspace Onboarding](workspace-onboarding.md) — generate the workspace map that sync distributes
- [Governance Testuggine](governance-testuggine.md) — the 3-layer system that includes sync as Layer 1
- [Context Diet (Matrioska)](context-diet-matrioska.md) — compress what gets synced
