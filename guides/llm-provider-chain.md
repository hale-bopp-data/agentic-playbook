# LLM Provider Chain

## Why Provider Chains?

No single LLM provider has 100% uptime. A provider chain ensures
your agents keep working even when the primary provider is down.

## Chain Architecture

```
Request -> Provider 1 (OpenRouter) -> Success? -> Return
                                   -> Fail?   -> Provider 2 (DeepSeek)
                                                 -> Fail? -> Error
```

## Choosing Providers

| Provider | Pros | Cons |
|----------|------|------|
| OpenRouter | Many models, single API | Extra hop |
| DeepSeek | Fast, cheap | Single model |
| Ollama | Local, no cost | Needs GPU, slower |
