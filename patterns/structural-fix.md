---
title: "Structural Fix"
status: active
created: 2026-03-10
tags: [agentic-playbook, pattern, antifragile, fix]
---

# Structural Fix

> Every fix must solve the root cause and create a guardrail so the problem never happens again.

## Problem

A healthcheck fails because `curl` isn't installed in the container. The agent fixes it by replacing `curl` with `wget`. The healthcheck passes. Problem solved?

No. Next month, someone rebuilds the container from a different base image and the same problem returns — because the fix addressed the *symptom* (missing tool) not the *cause* (environment assumptions baked into scripts).

Without structural fixes:
- The same bug returns in different forms
- The team builds a growing pile of patches on patches
- Every fix makes the system more fragile, not more robust
- Debugging becomes archaeology through layers of workarounds

## Solution

Before applying any fix, follow this loop:

### 1. Observe — What actually broke?
Don't just read the error message. Reproduce it. Understand the chain of events.

### 2. Orient — What's the root cause?
Ask "why?" at least twice:
- *Why did the healthcheck fail?* → `curl` is not installed
- *Why does the script need `curl`?* → It's hardcoded, no fallback
- *Why is there no fallback?* → Nobody planned for different base images

Now you've found the structural problem: **environment coupling**.

### 3. Decide — What's the antifragile fix?
The fix must pass this test: **after applying it, is the system more robust than before the bug existed?**

- **Patch** (don't do this): replace `curl` with `wget`
- **Fix** (better): replace `curl` with `wget`, add a wrapper script that auto-detects available tools
- **Structural fix** (do this): wrapper script + document the requirement + add a CI check that validates the healthcheck works in a clean container

### 4. Act — Apply and verify

```
# In your .cursorrules or agent instructions:
Every fix MUST:
1. Solve the root cause, not the symptom
2. Create a guardrail so it never happens again
3. Leave the system MORE robust than before
If the fix doesn't improve the system, it's not a fix — it's a band-aid.
```

## Why It Works

Software systems are like immune systems. A good fix is like a vaccination — it doesn't just cure the disease, it prevents reinfection.

A patch is like taking painkillers for a broken bone. The pain goes away, but the bone is still broken. And now you can't feel it, so you keep walking on it until it shatters.

The extra 15 minutes spent on a structural fix saves the hours you'd spend fixing the same thing again in a different disguise.

## Real Example

**The bug**: n8n container healthcheck failed in production. Error: `curl: command not found`.

**The patch** (rejected): Change `curl localhost:5678/healthz` to `wget -q -O- localhost:5678/healthz`.

**The structural fix** (applied):
1. `curl` → `wget` replacement (immediate fix)
2. Created `easyway-compose.sh` wrapper that validates environment before starting containers
3. Added documentation listing all healthcheck dependencies
4. The wrapper now catches this class of error for ALL containers, not just n8n

**Result**: The wrapper has since caught 2 other missing-tool issues before they reached production.

## How to Customize

**For solo developers**: Before committing a fix, ask yourself: "Will this same class of problem happen again?" If yes, add a check/test/guard.

**For teams**: Add "root cause" as a required field in bug reports. The fix PR must reference it.

**For AI agents**: Add the OODA loop (Observe-Orient-Decide-Act) to your agent instructions. The agent will analyze before coding.

The key mindset shift: **a fix is not complete when the test passes. A fix is complete when the test can never fail for the same reason again.**

## Related Patterns

- [Pre-commit Safety Net](pre-commit-safety.md) — a structural fix for secret leaks
- [Traceability Gate](traceability-gate.md) — ensures fixes are tracked
