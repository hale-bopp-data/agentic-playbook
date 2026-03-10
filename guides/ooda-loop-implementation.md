# OODA Loop Implementation

## What is OODA?

OODA (Observe, Orient, Decide, Act) is a decision-making framework
originally developed for military strategy, adapted here for AI agents.

## The Four Phases

### Observe
Gather all relevant context: user query, RAG results, system state, history.

### Orient
Analyze against principles and constraints: which principles apply,
what are the risks, what precedents exist.

### Decide
Formulate a recommendation: verdict (APPROVE/CAUTION/BLOCK),
severity level, supporting reasoning.

### Act
Execute: return structured response, log to casebook, trigger follow-ups.

## Implementation

```json
{
  "ooda": {
    "observe": "Gather context from query + RAG",
    "orient": "Match against 19 principles",
    "decide": "Verdict with confidence score",
    "act": "Return JSON response + log"
  }
}
```
