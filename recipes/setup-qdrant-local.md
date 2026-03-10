# Recipe: Set Up Qdrant Locally

```bash
# Create Docker network
docker network create easyway-net 2>/dev/null || true

# Start Qdrant
docker run -d \
  --name easyway-memory \
  --network easyway-net \
  -p 6333:6333 \
  -v qdrant_data:/qdrant/storage \
  qdrant/qdrant:latest

# Verify
curl http://localhost:6333/collections
```
