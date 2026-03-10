---
title: "Branch Flow Guard"
status: active
created: 2026-03-10
tags: [agentic-playbook, pattern, git, branch-protection]
---

# Branch Flow Guard

> Auto-detect your branch strategy and enforce the correct PR flow.

## Problem

Your repository has a `develop` branch for integration testing. The rule is clear: feature branches go to `develop`, only `develop` goes to `main`.

But the AI agent doesn't know this. It creates a PR from `feat/new-feature` directly to `main`, bypassing `develop` entirely. The PR looks fine, passes CI, gets merged. Now `main` has untested code and `develop` is out of sync.

Or the opposite: your repo doesn't have `develop` (it's a simple repo with just `main`). The agent tries to target `develop` because it learned that pattern from another repo. The PR fails because the branch doesn't exist.

Without branch flow enforcement:
- Feature code lands on `main` without integration testing
- `develop` and `main` diverge, causing painful merges later
- Agents apply patterns from one repo to another where they don't fit
- Hotfixes get blocked by rules meant for features

## Solution

The guard auto-detects the branch strategy and enforces the correct flow:

### Detection Logic

```
Does the repo have a 'develop' branch?
  YES → enforce: feat/* → develop → main
  NO  → allow:   feat/* → main (direct)
```

### Rules When `develop` Exists

| Source Branch | Target | Allowed? |
|---------------|--------|----------|
| `feat/*` | `develop` | Yes (default) |
| `feat/*` | `main` | **Blocked** |
| `develop` | `main` | Yes (release) |
| `release/*` | `main` | Yes |
| `hotfix/*` | `main` | Yes (emergency) |

### Rules When `develop` Does Not Exist

| Source Branch | Target | Allowed? |
|---------------|--------|----------|
| `feat/*` | `main` | Yes (default) |
| Any | `main` | Yes |

### Implementation

```
# In your .cursorrules or agent instructions:
Before creating a PR, check if the repo has a 'develop' branch.
If yes: feature branches MUST target develop, not main.
If no: feature branches target main directly.
Exceptions: release/*, hotfix/* can always target main.
```

**For automated enforcement** (API-level):

```typescript
// Check if develop exists
const hasDevelop = await checkBranchExists(repo, 'develop');

// Set default target
const target = hasDevelop ? 'develop' : 'main';

// Guard: block feat→main when develop exists
if (isFeatureBranch(source) && target === 'main' && hasDevelop) {
  throw new Error(
    `Feature branches cannot target main directly. Use develop.`
  );
}
```

## Why It Works

The guard follows a principle: **convention over configuration**.

Instead of maintaining a config file per repo that says "this repo uses develop," the guard looks at the repo itself. If `develop` exists, the convention is enforced. If it doesn't, there's nothing to enforce.

This means:
- Zero configuration needed
- New repos work automatically
- If you add `develop` later, the guard activates immediately
- If you remove `develop`, the guard deactivates — no config to update

The emergency escapes (`hotfix/*`, `release/*`) exist because real emergencies happen. A production outage shouldn't be blocked by a flow rule meant for features.

## Real Example

A platform with 9 repositories — only 1 had a `develop` branch. The PR creation tool was hardcoded to always route through `develop`, making it unusable for the other 8 repos.

After implementing the auto-detect guard:
- The tool works correctly for all 9 repos
- The one repo with `develop` enforces the two-step flow
- The other 8 allow direct `feat→main` (which is correct for their simpler workflow)

**Result**: 27 automated tests verify all branch combinations. Zero misconfigured PRs since adoption.

## How to Customize

**Minimum**: Add the detection rule to your agent instructions. The agent will check before creating PRs.

**Moderate**: Add it as a CI check on PR creation. Use your platform's API to verify the branch exists.

**Advanced**: Build it into your PR creation tool/script so it's impossible to bypass.

**Additional branch patterns you might add:**
- `bugfix/*` → same rules as `feat/*`
- `docs/*` → allowed directly to `main` (low risk)
- `chore/*` → depends on your preference

## Related Patterns

- [Traceability Gate](traceability-gate.md) — what must be linked before the PR
- [Repo Lock](repo-lock.md) — who's working on the repo right now
