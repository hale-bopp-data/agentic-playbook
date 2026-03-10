---
title: "Multi-Agent Coordination"
status: active
created: 2026-03-10
tags: [guide, agents, coordination, multi-agent]
---

# Multi-Agent Coordination

> How to prevent chaos when multiple AI agents work on the same codebase.

## The Problem

Two agents open the same file. Both make changes. Both try to commit. One overwrites the other work silently. No error, no warning, just lost changes.

This is not hypothetical. We experienced it in Session 110 when Claude Code and Gemini both edited .cursorrules simultaneously.

## Coordination Strategies

### 1. Repo Lock (Pessimistic)

Only one agent works on a repo at a time. Simple but limits parallelism.

**How**: Use a .semaphore.json file in the repo root.

See [Repo Lock pattern](../patterns/repo-lock.md) for details.

### 2. File-Level Locking (Optimistic)

Agents claim specific files. Others can work on different files in the same repo.

### 3. Branch Isolation

Each agent works on its own branch. Merge conflicts are resolved at PR time.

**Pros**: Maximum parallelism.
**Cons**: Merge conflicts can be complex. Agents may duplicate work.

### 4. Task Queue

A coordinator (n8n, cron, or human) assigns tasks sequentially. Agents never overlap.

**Pros**: Zero conflicts.
**Cons**: Slow. Bottleneck at the coordinator.

## Our Approach: Semaphore + Branch Isolation

We combine strategies 1 and 3:
- Semaphore prevents two agents from working on the same repo simultaneously
- Each agent creates feature branches
- PRs are reviewed before merge
- Branch Flow Guard ensures correct target branch

## Rules of Engagement

1. **Check semaphore before starting** - If yellow/red, wait or pick another repo
2. **Set semaphore when working** - Declare your agent, branch, and files
3. **Clear semaphore when done** - Do not leave stale locks
4. **TTL as safety net** - Locks expire after 1 hour if agent crashes
5. **Never force through** - If locked, ask the coordinator

## Related

- [Repo Lock](../patterns/repo-lock.md)
- [Semaphore Schema](../templates/semaphore.schema.json)
