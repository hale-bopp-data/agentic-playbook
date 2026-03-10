---
title: "Choosing an Embedding Model for RAG"
status: active
created: 2026-03-10
tags: [guide, rag, embeddings, vector-search]
---

# Choosing an Embedding Model for RAG

> How to pick the right embedding model for your documentation retrieval system.

## Why It Matters

Your embedding model determines how well your RAG system understands user queries. A bad model means users ask good questions and get wrong answers — worse than no RAG at all.

## The Trade-offs

| Factor | Small Model (MiniLM) | Large Model (E5-large) | API Model (OpenAI) |
|--------|----------------------|------------------------|---------------------|
| Dimensions | 384 | 1024 | 1536 |
| Speed | Fast (local) | Slower (local) | Network latency |
| Cost | Free | Free | Per-token |
| Quality | Good for short docs | Better for long docs | Best general |
| Privacy | Full (local) | Full (local) | Data leaves your infra |
| Offline | Yes | Yes | No |

## Our Choice: MiniLM-L6-v2

We chose `all-MiniLM-L6-v2` (384 dimensions) because:

1. **Runs locally** — No API costs, no data leaving the server
2. **Fast enough** — Ingests 363 wiki files in under 2 minutes
3. **Good enough** — 75% coverage on our evaluation queries
4. **Deterministic** — Same text always produces the same vector

## When to Upgrade

Consider a larger model when:
- Coverage drops below 60%
- Users report "I searched for X but got Y"
- Your documents are long (>2000 words per chunk)
- You need multilingual support

## Chunking Strategy

The embedding model is only half the equation. How you split documents matters equally:

- **Paragraph-based** (our approach): Split on `\n\n`. Simple, works for structured docs.
- **Semantic**: Use sentence boundaries. Better for narrative text.
- **Fixed-size**: 512 tokens per chunk. Predictable but may split mid-thought.
- **Hierarchical**: Keep document structure. Best for nested docs (headers → sections).

Filter out chunks smaller than 50 characters — they add noise without value.

## Measuring Quality

Use [Marginalia](https://github.com/hale-bopp-data/marginalia) to evaluate:

```bash
marginalia eval snapshot ./docs queries.yaml before.json
# Make changes...
marginalia eval snapshot ./docs queries.yaml after.json
marginalia eval compare before.json after.json
```

Key metrics:
- **Coverage**: % of queries that return at least one result
- **Precision@K**: % of returned results that are relevant
- **Recall@K**: % of expected results that were found

## Related

- [RAG Pipeline Basics](rag-pipeline-basics.md)
- [Documentation Strategy](documentation-strategy.md)
