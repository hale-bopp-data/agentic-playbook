---
title: "RAG Pipeline Basics"
status: active
created: 2026-03-10
tags: [guide, rag, pipeline, architecture]
---

# RAG Pipeline Basics

> How to build a documentation retrieval system that actually helps your agents find the right information.

## What is RAG?

Retrieval-Augmented Generation (RAG) connects your LLM to your documentation. Instead of relying on the model training data, you feed it relevant context from your own knowledge base.

## The Pipeline

```
User Query -> Embed Query -> Vector Search -> Rank Results -> Feed to LLM -> Response
```

### 1. Ingest (Offline)

Convert your documents into vectors:

```
Markdown files -> Chunker -> Embedder -> Vector Store (Qdrant)
```

Each chunk becomes a point in vector space. Similar concepts land near each other.

### 2. Query (Online)

When a user or agent asks a question:

1. **Embed** the query using the same model
2. **Search** for nearest vectors in the store
3. **Rank** results by cosine similarity
4. **Filter** below minimum score threshold
5. **Return** top-K results with source metadata

### 3. Augment (Optional)

Feed the retrieved chunks as context to your LLM:

```
System: You are a helpful assistant. Use the following context to answer.
Context: [retrieved chunks]
User: [original question]
```

## Our Stack

| Component | Tool | Why |
|-----------|------|-----|
| Vector Store | Qdrant | Open-source, self-hosted, fast |
| Embedder | MiniLM-L6-v2 | Local, free, 384 dimensions |
| Chunker | Paragraph-based | Simple, works for structured markdown |
| Evaluator | Marginalia | Before/after quality measurement |

## Key Decisions

1. **Chunk size**: Too small = no context. Too big = noise. We use paragraph splits filtered at 50 chars minimum.
2. **Top-K**: We return 5 results. More gives better recall but worse precision.
3. **Min score**: We filter at 0.1. Lower catches more but adds noise.
4. **Re-indexing**: After wiki changes, re-ingest. Our 363-file wiki takes about 2 minutes.

## Common Failure Modes

- **Stale index**: Wiki updated but not re-ingested, agents get outdated answers
- **Wrong chunking**: A how-to guide split mid-step, agent gets half the procedure
- **Embedding mismatch**: Query embedded with different model than docs, garbage results
- **No evaluation**: No way to know if RAG quality is degrading over time

## Related

- [Choosing an Embedding Model](choosing-embedding-model.md)
- [Documentation Strategy](documentation-strategy.md)
