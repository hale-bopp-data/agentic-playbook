# Recipe: Set Up Iron Dome Pre-commit

Iron Dome scans staged files for secrets before every commit.

## Patterns Scanned

| Pattern | Service |
|---------|---------|
| `sk-*` | DeepSeek, OpenAI |
| `ghp_*` | GitHub PAT |
| `AKIA*` | AWS Access Key |
| `xoxb-*` | Slack Bot Token |

## Setup

Add a pre-commit hook that greps staged files for these patterns.
Block the commit if any match is found.
