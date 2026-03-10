---
title: "The Journey"
status: active
created: 2026-03-10
tags: [agentic-playbook, journey, story, devops]
---

# The Journey

> The experience of the voyage is more important than the destination.

This story is extracted from 642 wiki pages, 39 narrative chronicles, and 70+ ethical review cases — all written in real-time as the events happened. Nothing here is reconstructed from memory. It was documented while we lived it.

---

## Month 0 — The Browser Window

It started with ChatGPT in a browser. Mid-2025. No server, no repository, no pipeline. Just a person typing questions.

*Can I build a data platform? What stack should I use? How do I handle multi-tenancy? Is it possible without a budget?*

The AI answered. The answers sounded smart. Most of them turned out to be wrong — but we didn't know that yet.

## Months 1-7 — Antigravity

Seven months of what we now call *Antigravity*: pure philosophy. Vision documents, architecture diagrams, naming conventions, governance frameworks, database models, security policies. Hundreds of pages. Zero deployable code.

We were drawing the route of a comet we hadn't yet found.

It felt productive. Looking back, most of those documents were wrong. But they weren't wasted — they forced us to think about *why* before *how*. That habit would save us later.

**Lesson**: thinking before coding is good. Thinking *instead of* coding is procrastination with extra steps.

## The Two Gifts

Two things changed everything.

**Oracle Cloud** gave us a free ARM server. 4 cores, 24GB RAM, $0/month forever.

**Azure DevOps** gave us project management, pipelines, and branch protection for free.

The first time we SSH'd into that server, it was just a blinking cursor on a black screen. No Docker, no Node, no database. Just Ubuntu and possibility.

Within a week: containers running.
Within two weeks: a portal serving pages.
Within a month: our first pull request rejected by a pipeline we'd built ourselves.

**That rejection was the best thing that happened to us.** It meant the system was working. Philosophy had to meet reality. Reality was unforgiving.

## Learning Git — The Hard Way

We didn't come from a DevOps background. We came from data, from business logic, from spreadsheets. Git was a foreign language.

The first commits were disasters. No branches — everything on `main`. No commit messages worth reading. Files with names like `test2_final_FINAL.js`. The AI agent was happy to commit anything, anytime, anywhere. It didn't know better. Neither did we.

Then we learned about branches. Feature branches, develop branches, release branches. At first it felt like overhead. Why can't I just push to `main`? The answer came when we broke production for the first time by pushing untested code directly.

Then we learned about pull requests. The first one felt ceremonial — reviewing our own code, approving our own PR. But even solo, the PR forced a pause. "Do I actually want this on main?" That question saved us dozens of times.

Then we learned about pipelines. Azure DevOps Pipelines were free and magical. The pipeline ran our tests, checked our code, and — for the first time — said "no." A robot telling us our code wasn't good enough. It was humbling. It was exactly what we needed.

**The evolution went like this:**

```
Stage 0: edit files, pray, deploy
Stage 1: git add ., git commit -m "stuff", git push
Stage 2: feature branches, but merge to main manually
Stage 3: PRs with review (even solo — the pause matters)
Stage 4: pipelines that test and block bad code
Stage 5: branch protection — main is sacred, nobody pushes directly
Stage 6: polyrepo — 9 repos, each with its own pipeline
Stage 7: governed by rules — the playbook IS the process
```

Each stage felt unnecessary until we skipped it and paid the price. Every rule was written in the blood of a broken deploy.

**The `git pull` lesson**: on session 55, we did `git pull` during a deploy. It introduced a merge commit that conflicted with in-flight changes. After that, the rule became absolute: `git fetch + git reset --hard`. Never `git pull` in deploy. Sounds simple. Took a production incident to learn.

**The commit message lesson**: early commit messages were useless (`fix`, `update`, `stuff`). We couldn't reconstruct what changed or why. Now every commit references a work item (`AB#123`), which links to a PBI, which links to a Feature, which links to an Epic. The chain is: *why (Epic) → what (Feature) → how (PBI) → code (commit)*. It took us 60 sessions to get there.

**Lesson**: DevOps isn't a role. It's a journey from chaos to discipline. You don't need to hire a DevOps team. You need to make the mistakes yourself, feel the pain, and build the guardrails. AI agents accelerate the journey — they make the mistakes faster. Which means you learn faster, if you're paying attention.

## Sessions 1-20 — Building

We built the portal. Learned Node.js, Docker, SQL Edge, API design — all with AI agents. The agent wrote the code. We reviewed it. Most of the time it was good. Sometimes it was silently wrong in ways that took days to find.

**Lesson**: AI-generated code that *looks* right is the most dangerous kind. It passes the eye test. It even passes simple tests. The bugs are architectural — wrong abstractions, hidden coupling, assumptions the AI copied from a training example that doesn't apply to your project.

This is where we started writing rules.

## Sessions 20-40 — The Agents Arrive

We started building AI agents — not one, but many. A review agent, a security scanner, an infrastructure agent, a frontend governor (Valentino), an ethics advisor (GEDI).

The idea was simple: specialized agents do better work than one general agent. A security agent that only thinks about security finds things a general agent misses.

But multiple agents created a new problem: **coordination**. Who's working on what? Which agent can modify which files? What happens when two agents create conflicting PRs?

**Lesson**: AI agents need governance the same way human teams need governance. Maybe more, because agents don't gossip at the coffee machine — they have zero ambient awareness of what others are doing.

## Session 42 — The First Principle

During session 42, an agent rushed a fix that broke production. The fix was correct in isolation but conflicted with another agent's recent changes. Nobody had checked.

We wrote our first principle: **Measure Twice, Cut Once**. Validate before executing. Always.

Then we wrote a second one: **Quality Over Speed**. One woman has a baby in 9 months. Nine women don't have a baby in 1 month.

Then a third: **The Journey Matters**. Document the *why*, not just the *what*.

We didn't know it yet, but we were building GEDI.

## Session 49 — The Leaked Key

An agent committed a `.env` file with a real database password. Caught in code review — but the password was already in git history. We had to rotate credentials and audit access logs.

That day, we built **Iron Dome** — a pre-commit scanner that blocks secrets before they reach the repository. Not as a git hook (those can be bypassed with `--no-verify`), but as part of the commit command itself.

**Lesson**: agents are more likely than humans to leak secrets. They work with environment variables constantly. They don't recognize "this looks like a real key." You must catch it mechanically, not rely on judgment.

## Session 53 — The Big Split

The monorepo was dying. CI took too long. An infrastructure change triggered portal tests. Merge conflicts were constant. Three agents working on different parts of the same repository couldn't avoid stepping on each other.

Over 10 sessions (53-62), we split into 9 repositories. It was painful, surgical, and necessary. We deleted 1,420 files in the process.

**Lesson**: monorepos work until they don't. The split is inevitable — do it when you're ready, not when you're desperate. And document the migration rigorously, because "which file went where" becomes impossible to reconstruct after a few days.

## Session 75 — The Pause

We stopped coding and looked at what we'd built.

We had expected to build a data portal. Instead, we had built:
- A portal (yes)
- An agent platform with 10 agents and 35 skills
- A governance framework (GEDI) with 47+ documented ethical reviews
- A pre-commit security system (Iron Dome)
- A schema governance engine (hale-bopp-db)
- An ETL runner (hale-bopp-etl)
- A policy gating engine (hale-bopp-argos)
- A CLI for governance (ewctl)
- A maturity checklist for open-source readiness
- And this — the methodology itself

We wrote the first manifesto that day. The portal was the excuse. The methodology was the product.

**Lesson**: sometimes you don't know what you're building until you stop and look. The destination is not what you planned. The journey took you somewhere better.

## Session 105 — Zero Lines of Code

The most important session in the project produced zero lines of code.

We spent the entire session thinking about databases. Not writing SQL — thinking about *why* databases exist, what schema governance actually means, why the doctrine (the rules) needs to live separately from the engine (the code that enforces them).

This session created the "Brain vs Muscles" architecture: AI provides intelligence, deterministic engines provide precision. They don't mix. They collaborate.

**Lesson**: the sessions that feel unproductive (no commits, no PRs, no deploys) are sometimes the ones that define everything that follows. Quality leaps don't happen linearly. There are plateaus, then breakthroughs.

## Session 118 — The Antifragile Rule

The n8n container healthcheck failed. `curl: command not found`. Easy fix: replace `curl` with `wget`.

But we'd learned by now. The easy fix is usually the wrong fix. So we asked: why did this happen? Because the healthcheck script assumed `curl` would exist. Why? Because nobody validated environment dependencies.

The structural fix: a wrapper script that validates ALL dependencies before ANY container starts. That wrapper has since caught 2 more issues we didn't anticipate.

This session formalized the rule:
> Every fix must solve the root cause and create a guardrail so the problem never happens again. If the system isn't more robust after the fix, it's not a fix — it's a band-aid.

## Session 119 — 19 Principles

GEDI reached 19 principles. From "Measure Twice" (session 42) to "The Invisible Shield" (session 119). Each one born from a real situation, not from a textbook.

We looked at the principles and realized: these aren't just for us. Anyone building software with AI agents faces the same problems. The principles are universal. The implementation is ours.

## Session 120 — This Document

We decided to give it away.

Not because we're generous — because the principles only get better when more people use them, test them, break them, and add their own. Open source isn't charity. It's a multiplier.

This playbook is what survived 120 sessions of building real software with real AI agents. Everything that didn't work was cut. Everything that's here earned its place.

---

## The Numbers

Just so you know this is real:

| What | Number |
|------|--------|
| Working sessions documented | 120+ |
| Ethical reviews (GEDI casebook) | 70+ |
| Repositories governed | 9 |
| Containers in production | 11 |
| AI agents with different roles | 10 |
| Skills in the agent platform | 35 |
| Monthly infrastructure cost | $0 |
| People on the team | 1 + AI |

## What We Got Wrong

We share failures because they're more useful than successes.

| What we believed | What actually happened |
|---|---|
| Monorepo is best | Split into 9 repos — coupling was killing us |
| One database is enough | Needed 3 specialized engines |
| "AI writes code" — just let it run | Hallucinations cost weeks |
| "Governance slows you down" | It prevents the crash that costs you the month |
| "We'll document later" | Later never comes |
| Seven months of planning is productive | Most of those documents were wrong |
| The portal is the product | The methodology is the product |

## What's Next

We don't know. That's the point.

The plan was a portal. We got a methodology. The plan was a methodology. We got a community (maybe). The plan is never the destination — it's the compass heading. The journey decides where you actually end up.

What we know: the principles work. The patterns prevent real problems. The playbook makes our agents better every day.

We're sharing the what, the how, and the why. Our tribe will follow if they want. If not, that's fine — we'll have had fun regardless.

> *"The great fool has that perfect mix of self-deception and ego where others have failed."*
> Not arrogance. Vision. The kind that makes you build something on a free server
> when everyone tells you it requires an enterprise license.

Now it's yours too.

---

## Further Reading

This story is backed by real documentation:
- **39 narrative chronicles** — session-by-session diary of the project
- **642 wiki pages** — guides, standards, runbooks, architecture decisions
- **70+ GEDI cases** — ethical reviews with OODA analysis
- **120+ session logs** — what was done, why, and what we learned

All of it lives in our wiki. All of it was written while it happened, not after.

---

*"The experience of the voyage is more important than the destination."*

*Started with ChatGPT in a browser. One person, asking questions.*
*Still asking. Still building. Still riding the comet.*
