# Secrets Management

## Principle: Secrets Stay on Server

Never store API keys, PATs, or passwords on developer machines.
The gateway pattern ensures secrets live only on the server.

## Architecture

```
Developer Machine          Server
+------------------+      +------------------+
| connector.sh     | SSH  | .env.secrets     |
| (no secrets)     |----->| (all secrets)    |
+------------------+      +------------------+
```

## Rotation Procedure

1. Generate new secret in the provider console
2. SSH to server, update `.env.secrets`
3. Run healthcheck for affected connectors
4. Update wiki connection registry with new expiry date
