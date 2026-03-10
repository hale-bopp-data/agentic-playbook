# Git Workflow for Agent Teams

## Branch Strategy

```
main <- (PR, no-ff merge) <- develop <- (PR) <- feat/s{session}-{description}
```

## Rules

1. Never push directly to main
2. No fast-forward merges — preserve branch history
3. Feature branches include session number
4. PR requires work item (Palumbo Rule)
5. Commit messages reference AB#{id}

## Deploy Workflow

```bash
# Never use git pull on server
git fetch origin main && git reset --hard origin/main
```
