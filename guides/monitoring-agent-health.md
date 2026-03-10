# Monitoring Agent Health

## Health Check Pattern

Every connector implements a `healthcheck` command:

```bash
bash scripts/connections/gedi.sh healthcheck
bash scripts/connections/qdrant.sh healthcheck
```

## System Health Report

Present results as a table:

| Component | Status | Notes |
|-----------|--------|-------|
| GEDI | OK | OpenRouter responding |
| Qdrant | OK | 14,158 chunks |
| ADO | OK | PAT valid until 2026-06 |
