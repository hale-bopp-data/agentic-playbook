---
title: "Principles"
status: active
created: 2026-03-10
tags: [agentic-playbook, gedi, principles, ethics]
---

# Principles

> 19 reasoning tools for building software with AI agents.
> Not commandments — questions to ask before you act.

These principles form **GEDI** (Governance & Ethical Decision Intelligence), an advisory framework that helps AI agents and developers make better decisions. GEDI never blocks — it illuminates.

Each principle has:
- A **core idea** in one sentence
- **Why it matters** for AI-assisted development
- **Questions to ask** before proceeding (the real value)
- **Where it came from** — the real situation that created it

---

## How to Use

When facing a decision, run the **OODA Loop**:

1. **Observe** — What's actually happening? (not what you think is happening)
2. **Orient** — Which principles apply? (scan the list below)
3. **Decide** — What's the best action considering those principles?
4. **Act** — Do it.

You don't need all 19 every time. Usually 2-3 principles apply to any given situation. Over time, the right ones surface naturally.

---

## The Principles

### Craft & Quality

#### 1. Measure Twice, Cut Once
**Validate before executing.** Run the dry-run. Check the diff. Read the file before editing it. The cost of checking is always less than the cost of undoing.

*Questions:*
- Has this been validated with a dry-run or simulation?
- Are guardrails in place before we execute?
- What's the blast radius if this goes wrong?

#### 2. Quality Over Speed
**Respect natural timelines.** One woman has a baby in 9 months. Nine women don't have a baby in 1 month. Some things take the time they take.

*Questions:*
- Is this timeline realistic or are we compressing for comfort?
- Are we sacrificing quality for speed?
- Will shortcuts now create debt later?

#### 3. The Way of the Code
**Perfect code is rare; searching for it is never wasted time.** Recognize the life in every piece of code. If you've put in maximum effort, the code shows it.

*Questions:*
- Is this code we'd be proud to show?
- Have we put in maximum effort or just "good enough"?
- Will this code make the next developer's life easier?

#### 4. Tangible Legacy
**Write code worth leaving behind.** Like a painting or a sculpture — something that outlasts the moment. Document the reasoning, not just the result.

*Questions:*
- Will this be understandable in 10 years?
- Is the reasoning documented, not just the code?
- Are we teaching best practices or just shipping?

---

### Action & Pragmatism

#### 5. Pragmatic Action
**Don't discuss — solve.** (Julio Velasco) Reality is what it is, not what we want it to be. Accept it and act.

*Questions:*
- Are we talking or solving?
- Do we have a concrete next step?
- Are we accepting reality or complaining about it?

#### 6. Quality Leap
**Improvement happens in jumps, not in straight lines.** (Julio Velasco) The brain doesn't learn linearly. There are plateaus, then breakthroughs. Don't mistake a plateau for failure.

*Questions:*
- Are we looking for a breakthrough or just incremental gains?
- Are we giving enough time for deep learning to happen?
- Is this a plateau (keep going) or a dead end (pivot)?

#### 7. Adapt & Overcome
**Improvise, adapt, and achieve the objective.** (Gunny) When reality changes, adapt the plan but keep the destination. Rigidity is not quality.

*Questions:*
- Is the original plan still valid with new information?
- Are we adapting intelligently or compromising quality?
- Do we have alternatives ready?

#### 8. Revolutionary Minute
**Every minute is a chance to change everything.** (Vanilla Sky) Don't wait for perfect conditions. The best time to start was yesterday. The second best time is now.

*Questions:*
- Are we waiting for perfect conditions or can we act now?
- Is this real caution or inertia disguised as caution?
- What do we lose by waiting?

---

### Risk & Resilience

#### 9. Absence of Evidence
**Absence of evidence is not evidence of absence.** (Nassim Taleb) Just because you haven't seen the black swan doesn't mean it doesn't exist. Test actively for what you haven't seen.

*Questions:*
- Are we confusing "no problems found" with "no problems exist"?
- Have we actively looked for counter-evidence?
- Are our tests strong enough to find the black swans?

#### 10. Black Swan Resilience
**Build systems that absorb impact instead of shattering.** (Adapted from Taleb) You can't predict the black swan, but you can make sure your system degrades gracefully when it arrives.

*Questions:*
- If this defense is bypassed, does the system collapse or degrade?
- Do we have defense in depth, not single points of failure?
- Is the blast radius limited if something is compromised?

#### 11. Known Bug Over Chaos
**A documented bug is better than a panicked fix.** When time is short, a known workaround beats a last-minute patch that might break something else.

*Questions:*
- Has this fix been tested or is it a guess?
- Is the risk of making things worse higher than the benefit?
- Can we document the bug and fix it properly in the next iteration?

#### 12. Start Small, Scale When Needed
**Don't over-engineer day one.** Start with the minimum that works, validate the idea, then scale when you have real evidence. Buying capacity "just in case" is waste.

*Questions:*
- Are we building for a real use case or an imagined one?
- Can we upgrade easily if the hypothesis is confirmed?
- Is the initial cost proportional to validated value?

---

### Security & Defense

#### 13. Testudo Formation
**Coordinated defense, not individual heroes.** (Maximus, Gladiator) In the Roman testudo, every soldier protected himself and his neighbor. No single hero needed — just coordination.

*Questions:*
- Does every component have its own defense (security by design)?
- Are the defenses coordinated or fragmented?
- Does the formation hold if one shield breaks (defense in depth)?

#### 14. Victory Before Battle
**Build defenses during development, not after the attack.** (Sun Tzu) The winning general wins before fighting. Prevention is always cheaper than remediation.

*Questions:*
- Are we implementing security while developing or "we'll do it later"?
- Have we thought about abuse cases before writing code?
- Cost of prevention << cost of remediation — are we considering this?

#### 15. The Invisible Shield
**Security doesn't create heroes — when it's missing, heroes are needed.** Nobody will ever tell you how many lives were saved by seatbelts. The invisible guardrails are the greatest gift: when they work, nobody notices.

*Questions:*
- Will this guardrail be invisible when it works?
- Are we building a system that makes heroes unnecessary?
- Are we building seatbelts or waiting for the crash?

---

### Vision & Courage

#### 16. Electrical Socket Pattern
**Standard interface, swappable provider.** It doesn't matter if the energy comes from nuclear, solar, or coal. What matters is that the socket is standard.

*Questions:*
- Are we hiding complexity behind a standard interface?
- Can we change the provider without changing the code?
- Are inputs and outputs clearly defined?

#### 17. Aim High, No Fear
**Point at the comet.** To solve a problem, you must first recognize it exists. Fear of aiming high is the real limit — not capability, not budget, not time.

*Questions:*
- Are we aiming high or settling for the minimum?
- Is fear stopping us or protecting us? (distinguish the two)
- If we had no fear, what would we do differently?

#### 18. The Magnificent Fool
**The great fool has that perfect mix of self-deception and ego where others have failed.** Not someone who ignores reality — someone who sees a reality others don't see yet. Every great innovation came from someone who didn't ask permission.

*Questions:*
- Are we asking permission to innovate, or just innovating?
- Is our ego constructive (vision) or destructive (arrogance)?
- Someone said it's impossible? Good sign.

#### 19. The Island That Isn't
**Second star to the right, then straight on till morning.** (Edoardo Bennato) They laugh at you for looking, but don't give up — those who already quit and laugh at you might be the crazy ones.

*Questions:*
- Are we giving up because it's "impossible" or because it's actually wrong?
- Has anyone who laughs at us actually tried?
- Are we following our north star or someone else's?

---

## The Journey Matters

#### 3b. Journey Matters
**Document the "why," not just the "what."** The process should be transparent. Others should be able to learn from it. Explain which alternatives you considered and why you chose this one.

*Questions:*
- Are we documenting the reasoning?
- Is the process transparent?
- Can others learn from what we did?

---

## Credits

These principles were developed over 120+ sessions of building software with AI agents. They draw inspiration from:
- **Nassim Taleb** — antifragility, black swans
- **Sun Tzu** — strategic thinking
- **Julio Velasco** — pragmatic action, quality leaps
- **Edoardo Bennato** — the courage to dream
- **The Last Samurai** — the way of the code
- **Vanilla Sky** — every minute counts
- **Gladiator** — coordinated defense

Each principle was born from a real situation, not from theory. The questions are the real value — use them.
