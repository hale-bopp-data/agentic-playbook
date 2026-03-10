# CI/CD for Agent Systems

## Pipeline Design

```
Push -> Lint (shellcheck, pylint) -> Manifest Validate -> Test -> Mirror -> Deploy
```

## Manifest Validation

CI must verify: required fields present, action script exists,
dependencies resolvable, principles reference valid IDs.

## Pre-commit Hooks (Iron Dome)

1. Secrets scan — no API keys in code
2. Shellcheck — bash syntax validation
3. Schema check — manifest.json against schema

## Deployment

Agent deployment follows a pull model:
push to main, server pulls latest, health checks run, rollback if fails.
