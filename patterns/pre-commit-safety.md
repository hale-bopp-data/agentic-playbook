---
title: "Pre-commit Safety Net"
status: active
created: 2026-03-10
tags: [agentic-playbook, pattern, security, secrets]
---

# Pre-commit Safety Net

> Scan every commit for secrets before it reaches the repository. Every time, no exceptions.

## Problem

An AI agent writes code that includes a database connection string. Or it copies an example from documentation that contains an API key placeholder — except it's not a placeholder, it's the real key from the environment. Or it creates a `.env` file and commits it.

Secrets in git are permanent. Even if you delete the file in the next commit, the secret lives forever in git history. Rotating the key is the only option, and by then it may already be compromised.

Without pre-commit scanning:
- API keys, passwords, and tokens end up in git history
- `.env` files get committed accidentally
- Connection strings with credentials appear in config files
- One leaked secret can compromise your entire infrastructure

## Solution

A pre-commit hook that scans staged files for patterns that look like secrets. If it finds anything suspicious, the commit is blocked.

### What to Scan For

```
# High-confidence patterns (block immediately)
- API keys:     /[A-Za-z0-9_]{20,}/ in variables named *_KEY, *_TOKEN, *_SECRET
- Passwords:    /password\s*[:=]\s*['"][^'"]+['"]/i
- Connection strings: /Server=.*Password=/i
- Private keys: /-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----/
- AWS keys:     /AKIA[0-9A-Z]{16}/

# Medium-confidence (warn, don't block)
- .env files being staged
- Files named *credentials*, *secret*, *token*
- Base64 strings longer than 50 chars in config files
```

### Implementation

```bash
#!/bin/bash
# .git/hooks/pre-commit (simplified)

STAGED_FILES=$(git diff --cached --name-only)

for file in $STAGED_FILES; do
  # Skip binary files
  if file "$file" | grep -q "binary"; then continue; fi

  # Check for secret patterns
  if git show ":$file" | grep -qiE \
    '(api[_-]?key|secret|password|token)\s*[:=]\s*["\x27][^\s"]+'; then
    echo "BLOCKED: Potential secret found in $file"
    echo "Review the file and use 'git add -p' to stage selectively."
    exit 1
  fi
done
```

### For AI Agents

```
# In your .cursorrules or agent instructions:
NEVER commit files that likely contain secrets (.env, credentials.json, *.key).
If a pre-commit hook blocks your commit, DO NOT bypass it with --no-verify.
Investigate why it was blocked and fix the issue.
```

The critical rule: **never bypass the hook.** If the agent is told "never use `--no-verify`," it will fix the problem instead of skipping the check. This is the difference between a safety net and a decoration.

## Why It Works

Prevention is cheaper than remediation. Always.

Rotating a leaked API key takes minutes to hours. Scanning git history for other leaked secrets takes longer. Notifying affected users, changing passwords, auditing access logs — that's days.

A pre-commit hook takes 2-3 seconds per commit. That's the best time-to-value ratio in all of software engineering.

The key insight for AI agents: agents are *more likely* than humans to leak secrets because they work with environment variables, copy from docs, and generate config files as part of their workflow. A human developer might recognize "this looks like a real key." An agent often won't — unless you tell it to check.

## Real Example

A pre-commit scanner was added to all repositories after an agent generated a configuration file containing a database password. The password was caught before the commit reached the repository.

Since adoption:
- 4 potential secret leaks caught before commit
- Zero false positives that required disabling the hook
- Agents now report "pre-commit hook blocked my commit" and fix the issue instead of bypassing

The scanner runs as part of a governance CLI that wraps `git commit`, ensuring it can't be accidentally skipped.

## How to Customize

**Minimum**: Add a `.gitignore` entry for `.env`, `.env.*`, `*.key`, `credentials.*`. This alone prevents the most common leaks.

**Moderate**: Install a pre-commit hook (use [pre-commit](https://pre-commit.com/) or write a simple shell script). Add patterns for your specific secrets.

**Advanced**: Wrap your commit command in a governance CLI that runs the scan automatically. Make it the only way to commit.

**Cloud-native**: Use GitHub's secret scanning, GitLab's secret detection, or Azure DevOps credential scanner as a second layer. Belt and suspenders.

**Patterns to add for your stack:**
- AWS: `AKIA[0-9A-Z]{16}`
- Azure: `DefaultEndpointsProtocol=.*AccountKey=`
- GCP: `"type": "service_account"`
- Stripe: `sk_live_[0-9a-zA-Z]{24}`
- OpenAI: `sk-[a-zA-Z0-9]{48}`

## Related Patterns

- [Structural Fix](structural-fix.md) — the pre-commit hook is itself a structural fix
- [Traceability Gate](traceability-gate.md) — ensures the commit belongs to a work item
