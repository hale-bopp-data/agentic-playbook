# Recipe: Debug RAG Search Results

1. Check collection stats: `curl http://localhost:6333/collections/easyway_wiki`
2. Test direct vector search with manual embedding
3. Check chunk quality (length, relevance, freshness)
4. Re-index if needed: `node scripts/ingest_wiki.js`

Common issues:
- Chunks too short (<50 chars) = noise
- Chunks too long (>2000 chars) = diluted embeddings
- Stale data = need re-index after wiki changes
