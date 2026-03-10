---
title: "Traceability Gate"
status: active
created: 2026-03-10
tags: [agentic-playbook, pattern, governance, pr]
---

# Traceability Gate

> Every pull request must be linked to a work item. No exceptions.

## Problem

An AI agent creates a PR with a clear title and good code. The reviewer opens it and sees... code. But *why* was this change made? What requirement does it fulfill? Is it part of a larger feature or a standalone fix?

Without traceability:
- Reviewers approve changes they don't fully understand
- Completed work can't be tracked back to business requirements
- Sprint boards become fiction — work happens but isn't reflected
- When something breaks in production, nobody knows which requirement caused it

## Solution

Before creating any PR, the agent must:

1. **Find or create a work item** (PBI, task, bug — whatever your system uses)
2. **Link the PR to the work item** in the PR description or via API
3. **Refuse to create the PR** if no work item exists

```
# In your .cursorrules or agent instructions:
NEVER create a PR without a linked work item.
FIRST find or create the work item, THEN create the PR.
```

### Implementation Examples

**Azure DevOps**: Include `AB#123` in commit messages — ADO auto-links them.

**GitHub**: Reference issues with `Fixes #123` or `Closes #123` in PR body.

**Jira**: Include the ticket key `PROJ-123` in the branch name or PR title.

## Why It Works

This is not bureaucracy — it's **context preservation**.

A PR without a work item is like a receipt without a purchase. The receipt is real, but you can't return the item because nobody knows what transaction it belongs to.

The 30 seconds it takes to link a work item saves hours of archaeology later when someone asks "why did we change this?" six months from now.

It also forces the agent (and the developer) to think: *"What am I actually trying to accomplish?"* before writing code. That question alone prevents a surprising number of unnecessary changes.

## Real Example

An AI agent created two PRs (#413, #414) for a repository without linking any work item. Both PRs were valid code changes, but the reviewer couldn't determine:
- Whether these changes were requested
- Which sprint they belonged to
- Whether they conflicted with other planned work

After this incident, the traceability gate was added to all 6 repository configurations. The agent now refuses to create PRs without a work item, and auto-links them via API after creation.

**Result**: Zero orphan PRs since adoption. Every change is traceable from code to requirement.

## How to Customize

**Minimum viable version**: Just add the rule to your `.cursorrules`. The agent will ask for a work item ID before creating PRs.

**Automated version**: Add a pre-PR hook or CI check that verifies the link exists. Block merge if it doesn't.

**Strict version**: The agent creates the work item automatically if one doesn't exist, populating it with context from the code changes.

Choose the level that matches your team's discipline. Start with minimum viable and tighten when you see the value.

## Related Patterns

- [Branch Flow Guard](branch-flow-guard.md) — controls *where* PRs go
- [Structural Fix](structural-fix.md) — controls *how* fixes are made
