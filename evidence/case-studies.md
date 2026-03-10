---
title: "Case Studies"
status: active
created: 2026-03-10
tags: [agentic-playbook, evidence, cases]
---

# Case Studies

> Real incidents from our 120+ sessions, anonymized.
> Every pattern in this playbook exists because one of these happened.

---

## Case 1: The Ghost PRs

**Session**: ~S95 | **Pattern born**: [Traceability Gate](../patterns/traceability-gate.md)

**What happened**: An AI agent (Gemini, running autonomously) created two PRs on a repository. The code was valid. The PRs had clear titles. But there was no linked work item — no issue, no task, no PBI. The reviewer opened them and had no idea *why* these changes were made or *who* requested them.

**Impact**: Both PRs sat in review for days. Nobody wanted to approve changes they couldn't trace to a requirement. The sprint board showed no record of the work. When the PRs were finally reviewed, one of them conflicted with planned work in the next sprint.

**Fix**: Added the Traceability Gate rule to all 6 repository configurations. The agent now refuses to create PRs without a work item. If one doesn't exist, the agent creates it first with context from the code changes, then links it.

**Since then**: Zero orphan PRs across all repositories.

---

## Case 2: The Curl That Wasn't There

**Session**: S118 | **Pattern born**: [Structural Fix](../patterns/structural-fix.md)

**What happened**: The n8n container healthcheck failed in production. Error: `curl: command not found`. The container's base image didn't include `curl`, which the healthcheck script relied on.

**The obvious fix**: Replace `curl localhost:5678/healthz` with `wget -q -O- localhost:5678/healthz`. This would have worked. The healthcheck would pass. But the same class of problem (hardcoded tool assumptions) existed in other healthcheck scripts across other containers.

**The structural fix**:
1. Replaced `curl` with `wget` (immediate fix)
2. Created a wrapper script (`easyway-compose.sh`) that validates environment dependencies before starting any container
3. Documented all healthcheck dependencies in a central file
4. The wrapper now catches this class of error for ALL containers, not just n8n

**Since then**: The wrapper caught 2 more missing-tool issues before they reached production. The problem class is eliminated, not just the single instance.

---

## Case 3: The Silent Overwrite

**Session**: ~S110 | **Pattern born**: [Repo Lock](../patterns/repo-lock.md)

**What happened**: Two AI agents (Claude Code and Gemini) were configured on the same repository. Developer A was working with Claude on a feature branch, editing `.cursorrules`. Meanwhile, Gemini (running in a different IDE window) also started modifying `.cursorrules` for a different task.

Both agents pushed to different branches. Both created PRs. The PRs touched the same file with incompatible changes. The second merge would have silently overwritten the first.

**Impact**: Caught during review, but only because the reviewer noticed both PRs existed. Without that catch, one developer's work would have been lost.

**Fix**: Added `.semaphore.json` (repo lock) to all repositories. Each agent checks the semaphore at session start. If another session is active, the agent reports it and waits for human decision.

**Since then**: Zero file conflicts between agents or sessions.

---

## Case 4: Feature on Main

**Session**: S119 | **Pattern born**: [Branch Flow Guard](../patterns/branch-flow-guard.md)

**What happened**: A PR creation tool was hardcoded to target `main` branch for all PRs. This was correct for 8 of the 9 repositories (they don't have a `develop` branch). But the 1 repository that had `develop` — the main portal — was getting feature branches merged directly to `main`, bypassing the integration branch entirely.

In the opposite direction: when someone tried to use the tool on a repo without `develop`, it would default to targeting `develop` (because it learned the pattern from the portal), and fail because the branch didn't exist.

**Impact**: Untested feature code on `main`. The `develop` branch diverged from `main`, causing painful merge conflicts when someone finally noticed.

**Fix**: Implemented auto-detection: the tool queries the repository for a `develop` branch. If it exists, feature branches must target `develop`. If not, feature branches target `main` directly. Emergency paths (`hotfix/*`, `release/*`) always target `main`.

**Since then**: 27 automated tests verify all branch combinations. Zero misconfigured PRs.

---

## Case 5: The Leaked Key

**Session**: ~S49 | **Pattern born**: [Pre-commit Safety Net](../patterns/pre-commit-safety.md)

**What happened**: During a routine configuration change, an agent generated a `.env` file template that accidentally included a real database password from the environment. The agent staged the file for commit.

**Impact**: Caught by a teammate during code review — but after the commit had already been pushed to the remote branch. The password was in git history. Had to rotate the credential, audit access logs, and rewrite git history to remove it.

**Fix**: Built a pre-commit scanner (part of a governance CLI wrapper) that runs automatically on every commit. It scans staged files for patterns matching API keys, passwords, connection strings, and private keys. The commit is blocked if anything suspicious is found.

The critical design decision: the scanner runs as part of the commit command wrapper, not as a git hook that can be bypassed with `--no-verify`. The agent is instructed to never bypass the wrapper.

**Since then**: 4 potential secret leaks caught pre-commit. Zero secrets in git history. Zero false positives requiring hook bypass.

---

## Case 6: The Monorepo Split

**Session**: S53 | **Principle applied**: Start Small, Scale When Needed + Revolutionary Minute

**What happened**: The project started as a monorepo (one repository for everything). As it grew to include a portal, wiki, agents, infrastructure, n8n workflows, and an ADO SDK, the monorepo became unmanageable. CI took too long. Agents working on infrastructure would trigger portal tests. Merge conflicts were constant.

**The decision**: Split into 9 repositories. This was a "revolutionary minute" — a decision that changed everything. It was scary (CI/CD for 9 repos, cross-repo coordination, deploy synchronization), but the monorepo was actively blocking progress.

**The process**:
1. Created a factory map (`factory.yml`) documenting all repositories and their relationships
2. Migrated one repo at a time over 10 sessions (S53-S62)
3. Built deploy scripts that coordinate across repos
4. Added the Repo Lock pattern to prevent cross-session conflicts

**Result**: Deleted 1,420 files from the monorepo. Each repo now has independent CI, independent ownership, and independent deploy. The factory map became the source of truth for the entire platform.

---

## Lessons Across All Cases

1. **The first time is free** — if you checked what you knew, an error the first time is just learning. But build the guardrail immediately. Don't wait for the second time.

2. **Agents don't share context** — two agents on the same repo don't know about each other. You need explicit coordination (Repo Lock).

3. **Convention beats configuration** — the Branch Flow Guard works because it detects the convention (does `develop` exist?) rather than requiring a config file per repo.

4. **Prevention costs minutes, remediation costs hours** — the pre-commit scanner adds 2-3 seconds per commit. Rotating a leaked credential takes hours.

5. **Structural fixes compound** — the compose wrapper from Case 2 has prevented problems we didn't even anticipate. Band-aids don't compound. Infrastructure does.
