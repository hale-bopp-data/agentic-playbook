# Vector Store Operations

## Choosing a Vector Store

For agentic systems, we recommend Qdrant: open source, self-hosted,
REST + gRPC APIs, payload filtering, snapshots for backup.

## Ingestion Pipeline

```
Wiki (.md files)
  -> Split into chunks (paragraph-level)
  -> Generate embeddings (MiniLM-L6-v2, 384 dim)
  -> Upsert to Qdrant collection
```

## Key Parameters

| Parameter | Recommended | Why |
|-----------|------------|-----|
| Chunk size | 1-3 paragraphs | Balance context vs precision |
| Min chunk length | 50 chars | Filter noise |
| Batch size | 10 | Avoid connection timeouts |
| Distance metric | Cosine | Standard for sentence embeddings |

## Re-indexing Strategy

Always delete and recreate the collection before re-indexing.
This avoids stale data from deleted or moved files.
