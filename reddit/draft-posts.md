---
title: "Reddit Draft Posts"
status: active
created: 2026-03-10
tags: [agentic-playbook, reddit, community, gedi-voice]
---

# Reddit Draft Posts — r/ThinkingDeeplyAI

> Voice: GEDI (the wise advisor, not a salesperson)
> Tone: sharing lessons, humble, real stories, no hype
> CTA: "we open-sourced the rules" → link to repo

---

## Post 1: "We let two AI agents work on the same repo. Here's what happened."

**Title**: We let two AI agents work on the same repo. Here's what happened.

**Body**:

We've been building software with AI agents for about 8 months. 120+ sessions. One person, multiple AI agents (Claude, Cursor, Gemini), 9 repositories.

Around session 110, we had Claude Code open in one terminal working on a config file. In another window, Gemini was also modifying the same file for a different task. Neither knew about the other.

Both agents pushed to different branches. Both created pull requests. Both PRs touched the same file with incompatible changes. If the second one merged, it would have silently overwritten the first.

We caught it during review. Luck, not process.

**The fix was embarrassingly simple**: a JSON file in the repo root called `.semaphore.json`.

```json
{
  "status": "yellow",
  "agent": "claude-code",
  "branch": "feat/new-dashboard",
  "timestamp": "2026-03-10T08:30:00Z"
}
```

Each agent checks this file at session start. If someone else is working (yellow) or deploying (red), the agent stops and reports it. That's it. No distributed locks, no service to run, no API. Just a file that agents can read.

Zero conflicts since we added it.

We've been documenting all the rules that came from mistakes like this. 5 patterns, 19 principles, all born from real incidents. We open-sourced the whole thing:

**[Agentic Playbook](https://github.com/hale-bopp-data/agentic-playbook)** — take it, fork it, add your own rules.

The patterns are framework-agnostic. They work with any AI coding agent that reads a `.cursorrules` or system prompt file.

Curious if others have run into similar multi-agent coordination problems. What's your approach?

---

## Post 2: "Our AI agent committed a database password. Here's the guardrail we built."

**Title**: Our AI agent committed a database password. Here's the guardrail we built.

**Body**:

This is a post about prevention, not blame.

During a routine config change, an AI agent generated a `.env` template file. Except it wasn't a template — it pulled real values from the environment. Including a database password.

The agent staged the file. Committed. Pushed.

A teammate caught it in code review. But the password was already in git history. We had to rotate the credential, audit access logs, and deal with the fact that `git rm` doesn't actually remove things from history.

**The lesson**: AI agents are *more likely* than humans to leak secrets. They work with environment variables constantly. They copy from docs. They generate config files. A human might think "wait, is this a real key?" An agent usually won't — unless you tell it to check.

**What we built**: A pre-commit scanner that runs on every commit. Not a git hook (those can be bypassed with `--no-verify`) — a wrapper around the commit command itself. The agent is instructed to never bypass the wrapper.

It scans staged files for patterns: API keys, passwords, connection strings, private keys. If anything matches, the commit is blocked.

Since adoption:
- 4 potential leaks caught before commit
- 0 secrets in git history
- 0 false positives that needed override

The 2-3 seconds it adds per commit is the best ROI in our entire stack.

We documented this and other patterns we've learned over 120+ sessions of AI-assisted development:

**[Agentic Playbook](https://github.com/hale-bopp-data/agentic-playbook)** — open source, Apache 2.0. Copy the template to your project and your agent follows the rules.

What's your experience with AI agents and secrets management?

---

## Post 3: "We built 19 principles for AI agent decision-making. They all came from failures."

**Title**: We built 19 principles for AI agent decision-making. They all came from failures.

**Body**:

8 months ago we started building a data platform with AI coding agents. One person + AI. Over 120 sessions, we kept making the same kinds of mistakes. So we started writing rules.

The rules became principles. The principles became a framework we call GEDI (Governance & Ethical Decision Intelligence). It's an advisory layer — it never blocks the agent, it just asks the right questions.

Here are a few that changed how our agents work:

**"Absence of Evidence is not Evidence of Absence"** (from Taleb)
> Just because your tests pass doesn't mean there are no bugs. Are the tests strong enough to find the black swans?

We caught ourselves saying "the tests pass, ship it" too often. This principle forces the question: are we testing *enough*, or are we testing what's easy?

**"Structural Fix"**
> Every fix must solve the root cause and create a guardrail so the problem never happens again.

Our n8n container healthcheck failed because `curl` wasn't installed. The obvious fix: use `wget` instead. But that's a band-aid — the real problem was hardcoded tool assumptions. The structural fix: a wrapper that validates all dependencies before any container starts. That wrapper has since caught 2 more issues we didn't anticipate.

**"Known Bug Over Chaos"**
> A documented workaround beats a last-minute panic fix that might break something else.

This one is hard for AI agents. They want to fix everything. But sometimes "document the bug and fix it properly next sprint" is the right call. Teaching agents this restraint was a breakthrough.

**"The Magnificent Fool"**
> The great fool has that perfect mix of self-deception and ego where others have failed. Not arrogance — vision.

When everyone told us "one person can't build a platform," this principle was the answer. Sometimes the fact that nobody has done it before is a signal, not a warning.

All 19 principles come with diagnostic questions — the kind you ask before making a decision. We use them daily. They're part of what we call the OODA loop (Observe → Orient → Decide → Act).

We open-sourced the whole framework:

**[Agentic Playbook](https://github.com/hale-bopp-data/agentic-playbook)** — 5 battle-tested patterns, 19 principles, case studies, templates. All from real experience, not theory.

The playbook is a `.cursorrules` file you drop in your project. Your AI agent reads it and follows the rules. No dependencies, no install, no account.

What principles have you developed for working with AI agents?

---

## Posting Schedule (suggested)

| Week | Post | Pattern highlighted |
|------|------|---------------------|
| 1 | Post 1: Two agents, one repo | Repo Lock |
| 2 | Post 2: The leaked password | Pre-commit Safety Net |
| 3 | Post 3: 19 principles | GEDI principles |
| 4+ | New cases from casebook | Rotate patterns |

## Style Rules

- **Never say "we built this product"** — say "we documented what we learned"
- **Never push downloads** — just link at the end, naturally
- **Always end with a question** — invite discussion
- **Always share a real failure** — vulnerability builds trust
- **GEDI's voice**: wise but not preachy, experienced but not arrogant, shares not sells
