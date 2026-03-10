# Pattern: Provider Chain

## Problem

External services have downtime. Single provider = single point of failure.

## Solution

Chain providers with automatic fallback:

```
Provider 1 -> success? -> return
           -> fail?    -> Provider 2 -> success? -> return
                                      -> fail?    -> error
```

Define providers in manifest with env_var references.
