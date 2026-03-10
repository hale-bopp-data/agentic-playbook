---
title: "Your First Agent Project"
status: active
created: 2026-03-10
tags: [guide, getting-started, agents, beginner]
---

# Your First Agent Project

> From zero to a governed AI agent in one afternoon.

## The Problem

You want to use AI agents for development but you've heard the horror stories: leaked secrets, force-pushed to main, deleted production data. How do you start safely?

## The Approach: Start Small, Scale When Needed

Don't build a 10-agent platform on day one. Start with one agent, one repo, one task.

### Step 1: Choose a Bounded Task

Pick something that:
- Has clear success criteria
- Is reversible if it goes wrong
- Doesn't require production access
- Can be validated by a human in <5 minutes

**Good first tasks**: code review, documentation generation, test writing, dependency updates.
**Bad first tasks**: database migrations, production deploys, security configuration.

### Step 2: Set Up Guardrails First

Before giving the agent any capability:

1. **Pre-commit hook** — Scan for secrets (see [Pre-commit Safety](../patterns/pre-commit-safety.md))
2. **Branch protection** — Agent can't push to main (see [Branch Flow Guard](../patterns/branch-flow-guard.md))
3. **Semaphore file** — Signal when the agent is working (see [Repo Lock](../patterns/repo-lock.md))

### Step 3: Write Clear Instructions

In `.cursorrules` or your agent system prompt:

```
You are working on [repo-name].
Your task is [specific task].
You MUST NOT: push to main, delete files, modify CI/CD.
You MUST: create feature branches, link PRs to work items, run tests before committing.
```

### Step 4: Run and Observe

Let the agent work on one task. Watch what it does. Check:
- Did it follow the instructions?
- Did it try to do more than asked?
- Did the guardrails catch anything?

### Step 5: Document What You Learned

Add to your casebook:
- What worked
- What surprised you
- What guardrail you wish you'd had

## Scaling Up

Once you're comfortable with one agent on one task:
1. Add GEDI for decision quality (see [Setting Up GEDI](setting-up-gedi.md))
2. Add a second agent with a different role
3. Use the [Repo Lock](../patterns/repo-lock.md) pattern for coordination

## The Key Insight

**Guardrails before capabilities.** The order matters. If you give an agent power before setting boundaries, you'll spend more time fixing damage than you saved.
