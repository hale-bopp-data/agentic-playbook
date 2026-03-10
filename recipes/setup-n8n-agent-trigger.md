# Recipe: Set Up n8n Agent Trigger

## Architecture

```
n8n (WHEN) -> POST http://runner:8400/task -> Runner (HOW) -> MinIO (WHERE)
```

## Steps

1. Create Schedule Trigger in n8n (cron expression)
2. Add HTTP Request node pointing to runner
3. Register task type in `task-server.py`
4. Test with curl
