# Getting Started with Testuggine 🐢

## What is this?

If you use AI coding assistants (Claude, Copilot, Cursor, Codex, Gemini...),
you've probably noticed they sometimes:

- Don't know your project structure
- Use the wrong commands
- Ignore your team's rules
- Waste time figuring out what's what

**Testuggine fixes this.** One command, and every AI agent on your machine
knows your project, follows your rules, and stays up to date.

## Quick Start (2 minutes)

### Option A: One command

```bash
curl -sL https://raw.githubusercontent.com/hale-bopp-data/agentic-playbook/main/testuggine-init.sh | bash
```

### Option B: Step by step

```bash
# 1. Download the script
curl -sLO https://raw.githubusercontent.com/hale-bopp-data/agentic-playbook/main/testuggine-init.sh

# 2. See what it will do (no changes)
bash testuggine-init.sh --scan-only

# 3. Run it for real
bash testuggine-init.sh
```

### What happens

The script will:

1. **Find** which AI agents you have installed (Claude, Codex, Cursor, etc.)
2. **Ask** 5 simple questions about your project
3. **Write** instructions for each agent in the right place

That's it. No installs. No accounts. No config files to edit.

## What does it create?

| File | What it does |
|------|-------------|
| `workspace-map.yml` | Tells agents about your project (repos, stack, branches) |
| Agent instructions | Tells each agent your rules (one file per agent, in the right location) |

## After Setup

Your AI agents will immediately:
- Know your project structure
- Use the right branch strategy
- Follow your team's rules
- Use the right prefix for branches

## Want more?

Once you're comfortable, explore these recipes:

| Recipe | What it does | Time |
|--------|-------------|------|
| [Agent Census](recipes/agent-census.md) | Find all AI agents on your machine | 30 min |
| [Context Diet](recipes/context-diet-matrioska.md) | Reduce AI context bloat | 1 hour |
| [Context Sync](recipes/context-sync-n8n.md) | Auto-sync rules across repos | 2 hours |
| [Governance Testuggine](recipes/governance-testuggine.md) | Full 3-layer governance | 4 hours |

## FAQ

**Q: Will it break anything?**
No. It only creates new files. It never deletes or overwrites existing files
unless you explicitly ask.

**Q: Do I need to install anything?**
No. Just `bash` and `python3` (which you already have if you're coding).

**Q: Does it work on Windows?**
Yes, via Git Bash or WSL.

**Q: What if I only use one AI agent?**
That's fine! The script adapts to what you have.

**Q: What if I add a new agent later?**
Run `testuggine-init.sh` again. It will find the new agent and set it up
without touching your existing config.

**Q: Is this from a real project?**
Yes. This was built during 149 sessions of multi-agent development on the
[EasyWay](https://github.com/hale-bopp-data) platform. Everything here
comes from real problems we solved.

---

*"Nessuno dovrebbe pagare un prezzo enterprise per fare bene cose semplici."*
