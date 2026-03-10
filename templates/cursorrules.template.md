# [Your Project Name] — AI Agent Rules

<!-- Licensed under Apache 2.0 — https://github.com/hale-bopp-data/agentic-playbook -->

> Copy this file to your project root as `.cursorrules` (Cursor) or include
> it in your agent's system prompt (Claude Code, Copilot, etc.).
> Delete sections you don't need. Add your own rules at the bottom.

# ---- SOURCE OF TRUTH ----
# Primary remote: [Your Git provider]
# PR flow: [feat → main] or [feat → develop → main]
# Merge strategy: [merge / squash / rebase]

# ---- REPO LOCK (optional) ----
# Check `.semaphore.json` BEFORE starting work.
# If status=yellow/red and it's not your session → STOP, ask.
# Start of session: set yellow. End of session: set green.

# ---- TRACEABILITY GATE ----
# NEVER create a PR without a linked work item / issue.
# FIRST find or create the issue, THEN create the PR.
# Include the reference in commit messages (e.g., Fixes #123, AB#456).

# ---- STRUCTURAL FIX ----
# Before applying ANY fix:
# 1. Identify the ROOT CAUSE, not just the symptom
# 2. The fix MUST create a guardrail so it never happens again
# 3. After the fix, the system must be MORE robust than before
# If the fix doesn't improve the system, it's not a fix — it's a band-aid.

# ---- BRANCH FLOW GUARD ----
# Before creating a PR, check if this repo has a 'develop' branch.
# If yes: feature branches MUST target develop, not main.
# If no: feature branches target main directly.
# Exceptions: release/*, hotfix/* can always target main.

# ---- PRE-COMMIT SAFETY ----
# NEVER commit files that likely contain secrets (.env, *.key, credentials.*).
# If a pre-commit hook blocks your commit, DO NOT bypass with --no-verify.
# Investigate why it was blocked and fix the issue.

# ---- ABSOLUTE RULES ----
# NEVER push directly to main
# NEVER force-push to protected branches
# NEVER bypass security policies
# MAX 2 retries on any API call — if it fails twice, STOP and ask

# ---- DEPLOY WORKFLOW ----
# 1. Commit on feature branch
# 2. Push to remote
# 3. Create PR (with work item linked)
# 4. After merge: fetch + reset on server (NEVER git pull)
# 5. Test in production environment

# ---- YOUR RULES BELOW ----
# Add project-specific rules here.
# Good rules have a "why" — explain the reasoning, not just the rule.
#
# Example:
# NEVER use ORM for batch operations — our dataset is 10M+ rows
# and ORM generates N+1 queries that timeout the connection pool.
