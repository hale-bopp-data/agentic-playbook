# FAQ: Troubleshooting Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| SSH connection failed | Server unreachable | Check SSH key and network |
| GEDI consultation failed | Script missing or LLM down | Run healthcheck |
| ECONNREFUSED :6333 | Qdrant not running | `docker start easyway-memory` |
| UND_ERR_SOCKET | Too many vectors too fast | Reduce batch, add retry |
| No RAG results | Empty collection | Re-index wiki |
