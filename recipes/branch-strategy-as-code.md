---
title: "Branch Strategy as Code"
category: recipe
tags: [git, branch-strategy, pr-automation, convention-over-configuration, devops]
created: 2026-03-11
---

# Recipe: Branch Strategy as Code

A centralized, per-repo configuration that auto-corrects PR targets and enforces branch naming conventions. Built to solve a specific problem: when agents create 60% of your PRs, wrong-target mistakes compound fast.

## Problem

In a multi-repo platform with both human and agent contributors, PRs targeting the wrong branch are a recurring source of friction. A portal repo with a 3-tier flow (feat -> develop -> main) will see agents and humans alike send PRs directly to `main` when they should target `develop`. Manual review catches some. Broken deploys catch the rest.

The usual fix is documentation: "remember to target develop for portal repos." Documentation does not scale when your agents are creating 5 PRs per day across 6 repositories.

## Solution Pattern

Define branch strategy as a data structure, not as tribal knowledge. A single associative array declares, per repo, the target branch, merge strategy, valid prefixes, and commit types. A resolver function reads this config at PR creation time and silently corrects the target.

### 1. Declare the strategy

```bash
declare -A BRANCH_STRATEGY

BRANCH_STRATEGY[easyway-portal]="target:develop merge:no-fast-forward prefixes:feat/,fix/,docs/,context-sync/ commits:feat,fix,docs,refactor,chore"
BRANCH_STRATEGY[easyway-wiki]="target:main merge:squash prefixes:docs/,feat/,fix/ commits:docs,feat,fix,chore"
BRANCH_STRATEGY[easyway-agents]="target:main merge:no-fast-forward prefixes:feat/,fix/,docs/ commits:feat,fix,docs,refactor"
```

Each repo gets one line. The format is deliberately flat -- no YAML, no JSON, just key:value pairs in a string. This lives in the central auth script that every PR creation path already sources.

### 2. Auto-correct at PR creation time

```bash
_resolve_target() {
    local repo="$1"
    local source_branch="$2"
    local requested_target="$3"

    local config="${BRANCH_STRATEGY[$repo]}"
    if [[ -z "$config" ]]; then
        echo "${requested_target:-main}"
        return
    fi

    local correct_target
    correct_target=$(echo "$config" | grep -oP 'target:\K[^ ]+')

    # If the source IS the intermediate branch, target main (release flow)
    if [[ "$source_branch" == "$correct_target" ]]; then
        echo "main"
        return
    fi

    # Otherwise, enforce the declared target
    if [[ -n "$requested_target" && "$requested_target" != "$correct_target" ]]; then
        echo "[branch-strategy] Auto-corrected target: $requested_target -> $correct_target" >&2
    fi

    echo "$correct_target"
}
```

The key behavior: this function never fails, never blocks. It corrects silently and logs the correction. An agent that requests `feat/new-thing -> main` on a 3-tier repo gets `feat/new-thing -> develop` without interruption.

### 3. Validate branch prefixes

```bash
_validate_branch_prefix() {
    local repo="$1"
    local branch="$2"

    local config="${BRANCH_STRATEGY[$repo]}"
    [[ -z "$config" ]] && return 0

    local prefixes
    prefixes=$(echo "$config" | grep -oP 'prefixes:\K[^ ]+')

    IFS=',' read -ra valid_prefixes <<< "$prefixes"
    for prefix in "${valid_prefixes[@]}"; do
        [[ "$branch" == ${prefix}* ]] && return 0
    done

    echo "[branch-strategy] Invalid prefix for $repo. Valid: $prefixes" >&2
    return 1
}
```

### 4. Query from CLI

```bash
# Show config for a repo
branch-strategy show easyway-portal

# Output:
#   target:    develop
#   merge:     no-fast-forward
#   prefixes:  feat/, fix/, docs/, context-sync/
#   commits:   feat, fix, docs, refactor, chore
```

### 5. Integration surface

Both the CLI tool (`ado-remote.sh pr-create`) and the MCP tool (`ado_pr_create`) call `_resolve_target()` before creating the PR. There is no code path that bypasses strategy enforcement. This is the critical design choice -- the strategy is enforced at the infrastructure layer, not at the caller layer.

## Production Evidence

These numbers come from the EasyWay platform: 6 repositories, 129 days of operation, mixed human and agent contributors.

| Metric | Value |
|--------|-------|
| Total PRs | 650 |
| Agent-created PRs | 391 (60%) |
| Human-created PRs | 259 (40%) |
| Success rate | 96% |
| Abandoned PRs | 3% |
| Work Items tracked | 221 |
| Average PRs per day | 5 |

**Portal repo (3-tier flow):**

| Flow | Count |
|------|-------|
| feat -> develop | 202 |
| develop -> main (release) | 151 |

**Branch prefix distribution across all repos:**

| Prefix | Count |
|--------|-------|
| feat/ | 272 |
| develop/ | 115 |
| docs/ | 66 |
| fix/ | 60 |
| context-sync/ | 42 |

**Before auto-correct:** PRs targeting the wrong branch were a recurring issue. The most common mistake was portal feature branches targeting `main` directly instead of `develop`. Each one required manual intervention -- close, re-create, or retarget.

**After auto-correct:** Zero wrong-target PRs. The resolver silently corrected the target at creation time. No agent needed to be retrained. No human needed to remember the rule.

## Design Principles

Three principles drove this design:

**Convention over Configuration (G12).** If a repo has a `develop` branch, the system infers a 3-tier flow and enforces it. You do not need to configure this explicitly -- the presence of `develop` is the configuration. New repos without `develop` default to direct-to-main, which is correct for simpler workflows.

**Single Interface, Any Provider (G16).** Whether a PR is created by a human typing a CLI command, an agent calling an MCP tool, or an n8n workflow hitting a webhook, the same `_resolve_target()` function runs. The strategy is defined once and enforced everywhere.

**Eliminate, Don't Document (G8).** The old approach was to document "portal PRs must target develop" and hope everyone read it. The new approach makes it impossible to create a PR with the wrong target. Known bugs are better than unknown chaos, but eliminated bugs are better than known ones.

## When to Use This

- You have multiple repos with different branching models (some direct-to-main, some with develop, some with release branches)
- Agents create a significant share of your PRs and cannot reliably remember per-repo rules
- You want to add new repos or change a repo's branching model without updating every caller
- You already have a central script or service through which all PRs are created

## When Not to Use This

- Single repo, single branching model -- just set branch protection rules and move on
- Your PR creation is distributed across many independent tools with no shared infrastructure
- You need complex branch routing logic (e.g., target depends on file paths changed) -- this pattern handles repo-level config, not file-level routing
- Your team is small enough that a Slack reminder works

## Key Insight

Branch strategy is configuration data, not application logic. The moment you treat it as data -- declared in one place, read by every tool -- a whole class of errors disappears. The 391 agent-created PRs in our dataset never needed to know which repo uses 3-tier flow. They just called `pr-create` and the infrastructure handled the rest.

The auto-correct pattern is deliberately non-blocking. It does not reject a PR with the wrong target; it fixes the target and proceeds. This matters for agent workflows where a rejection means a retry loop, wasted tokens, and potential drift. Silent correction is cheaper than noisy enforcement.
