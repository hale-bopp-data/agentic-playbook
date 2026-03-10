# Error Handling Patterns

## Retry with Exponential Backoff

```javascript
async function withRetry(fn, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try { return await fn(); }
        catch (e) {
            if (attempt === maxRetries) throw e;
            await sleep(1000 * attempt);
        }
    }
}
```

## Graceful Degradation

- RAG unavailable -> proceed without context (warn user)
- LLM provider 1 down -> fallback to provider 2
- Git push fails -> save locally, retry later

## Error Logging

```bash
_log_error "service_name" "action" "error_message"
```
