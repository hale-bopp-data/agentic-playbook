# Recipe: Ingest Wiki into Qdrant

```bash
export QDRANT_URL=http://localhost:6333
export WIKI_PATH=../wiki
npm install @qdrant/js-client-rest @xenova/transformers glob uuid
node scripts/ingest_wiki.js
```

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| UND_ERR_SOCKET | Connection timeout | Reduce batch size, add retry |
| ECONNREFUSED | Qdrant not running | Start container |
| No files found | Wrong WIKI_PATH | Check path |
