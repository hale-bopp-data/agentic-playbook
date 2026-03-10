# Connection Registry Design

## Why a Registry?

Every agent system needs a standard way to connect to external services.
Hardcoding credentials, endpoints, or auth methods in scripts leads to:

- **Secret sprawl** — credentials duplicated across files
- **Brittle scripts** — endpoint changes break everything
- **No auditability** — who connected where and when?

## The Registry Pattern

A central `connections.yaml` defines all external services:

```yaml
services:
  ado:
    type: rest_api
    gateway: {mode: server, connector: ado.sh}
    env_var: ADO_PAT
  qdrant:
    type: vector_db
    gateway: {mode: server, connector: qdrant.sh}
    env_var: QDRANT_API_KEY
```

Each connector script implements authentication, routing, and error handling.

## Implementation Checklist

- [ ] Create `connections.yaml` with all services
- [ ] Write connector scripts per service
- [ ] Add `_common.sh` with shared gateway logic
- [ ] Document in wiki
- [ ] Test healthcheck for each connector
