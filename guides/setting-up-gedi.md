---
title: "Setting Up GEDI"
status: active
created: 2026-03-10
tags: [guide, gedi, setup, getting-started]
---

# Setting Up GEDI

> How to add an ethical decision advisor to your AI agent workflow in under 30 minutes.

## What is GEDI?

GEDI (Governance & Ethical Decision Intelligence) is a lightweight advisory framework. It's not a permissions system — it never blocks. It illuminates decisions by asking the right questions at the right time.

Think of GEDI as the wise grandparent sitting in the corner of every meeting. They don't run the company, but when they speak, everyone listens.

## Prerequisites

- An LLM that can process JSON instructions (any model works)
- A `gedi-manifest.json` file (use the template in `templates/`)
- Agent instructions that reference the GEDI loop

## Step 1: Fork the Manifest

Copy `templates/gedi-manifest.template.json` to your project root:

```bash
cp templates/gedi-manifest.template.json .gedi-manifest.json
```

The manifest defines:
- The 19 principles (diagnostic questions)
- The OODA loop (Observe → Orient → Decide → Act)
- Intervention modes (proactive, reactive, on-demand)
- Output format for GEDI assessments

## Step 2: Add GEDI to Agent Instructions

In your `.cursorrules`, agent system prompt, or equivalent:

```
When facing a non-trivial decision:
1. Run the GEDI OODA loop
2. Identify which principles apply (usually 2-3)
3. Present the assessment before proceeding
4. Document the decision in the casebook
```

## Step 3: Create a Casebook

Create `GEDI_CASEBOOK.md` to track decisions:

```markdown
# GEDI Casebook

## Case #1 — [Date] — [Title]
**Trigger**: What happened
**Principles**: Which ones applied
**Assessment**: GEDI's recommendation
**Decision**: What was actually done
**Outcome**: What happened next
```

## Step 4: Calibrate

Run GEDI for 5-10 decisions. Review the casebook. Adjust:
- Are the right principles surfacing?
- Is the assessment useful or noise?
- Does the team trust GEDI's input?

## Common Pitfalls

1. **Making GEDI a gate** — It should advise, never block
2. **Ignoring GEDI** — If you always override it, recalibrate
3. **Too many principles** — Start with 5-7, expand as needed
4. **No casebook** — Without documentation, patterns don't emerge

## Cost

GEDI runs on any LLM. On DeepSeek, it costs approximately $0.10/month for typical usage (50-100 consultations). The manifest is ~2KB of JSON.

## Related

- [GEDI Principles](../principles/index.md)
- [Manifest Template](../templates/gedi-manifest.template.json)
