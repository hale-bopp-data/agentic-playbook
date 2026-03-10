# Semaphore Protocol

## Purpose

Prevent concurrent modifications when multiple sessions work on the same repo.

## States

| Status | Meaning | Action |
|--------|---------|--------|
| green | Free | Safe to start work |
| yellow | In progress | Another session is active |
| red | Deploy | DO NOT touch |

## Implementation

```json
{
  "status": "yellow",
  "session": "S121",
  "branch": "feat/s121-cleanup",
  "agent": "claude-code",
  "timestamp": "2026-03-10T14:30:00Z"
}
```

Place `.semaphore.json` (gitignored) in each repo root.
