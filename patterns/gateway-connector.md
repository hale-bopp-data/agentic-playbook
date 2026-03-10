# Pattern: Gateway Connector

## Problem

Scripts need external services, but credentials vary between environments.

## Solution

Connector script abstracts the gateway:

```
Local call -> connector.sh -> SSH -> Server -> service
```

All connectors implement: healthcheck, action, errors.
Secrets never leave the server.
