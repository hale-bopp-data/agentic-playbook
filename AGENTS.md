---
title: "Agents Master"
tags: []
---

# AGENTS.md — agentic-playbook

Istruzioni operative per agenti AI (Codex, Claude Code, Copilot Workspace, ecc.)
che lavorano in questo repository.

---

## Identita

**agentic-playbook** — Agentic Development Playbook
- Remote primario: **GitHub** (`github.com/hale-bopp-data/agentic-playbook`). Circle 1 — GitHub-only.
- Repo pubblico di knowledge sharing. NO Azure DevOps, NO mirror.
- PR e issue: su GitHub. CI: GitHub Actions (se presente).
- Branch strategy: feat→main` o `docs/→main
- Merge strategy: Merge (no fast-forward)
- Linguaggi: Markdown
- **Circle**: 1 (GitHub-primary, NO ADO)
- **Visibilita**: pubblico

---

## Comandi rapidi

```bash
# Commit con Iron Dome
ewctl commit

git push origin <branch>


gh pr create --title "titolo" --body "descrizione"
```

## Struttura directory

```text
guides/              # Guide operative per agentic development
patterns/            # Design pattern agentic
principles/          # Principi fondamentali
recipes/             # Ricette copia-incolla
faq/                 # Domande frequenti
evidence/            # Evidenze e case study
reddit/              # Contenuti per community
templates/           # Template riusabili
THE-JOURNEY.md       # Il viaggio narrativo
```

- Contenuto divulgativo — linguaggio accessibile, no gergo interno EasyWay
- Ogni guida deve essere self-contained
- MAI includere secrets, PAT, URL interni, o riferimenti a infrastruttura EasyWay
- Markdown puro — no frontmatter YAML (diverso dalla wiki interna)

---

## Connessioni & PAT

- Guida completa: `C:\old\easyway\wiki\guides\connection-registry.md`
- Gateway S88: PAT e secrets vivono SOLO su server `/opt/easyway/.env.secrets`
- `.env.local` locale: solo OPENROUTER/QDRANT, nessun PAT

### Comandi ADO — Ordine di preferenza OBBLIGATORIO (S107)

**MAI usare `az login` o `az boards`**. MAI creare PR con `curl` inline o quoting improvvisato.

```bash
bash /c/old/easyway/ado/scripts/ado-remote.sh wi-create "titolo" "PBI" "tag1;tag2"
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-create <repo> <src> <tgt> "titolo" [wi_id]
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-autolink-wi <pr_id> [repo]
bash /c/old/easyway/ado/scripts/ado-remote.sh wi-link-pr <wi_id> <pr_id> [repo]
bash /c/old/easyway/ado/scripts/ado-remote.sh pat-health-check
```

**Repo names ADO**: `easyway-portal`, `easyway-wiki`, `easyway-agents`, `easyway-infra`, `easyway-ado`, `easyway-n8n`

### PR creation — metodo canonico

```bash
git push -u origin feat/nome-descrittivo
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-create agentic-playbook feat/nome-descrittivo main "AB#NNN titolo" NNN
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-autolink-wi <pr_id> agentic-playbook
```



---

## Regole assolute

- MAI hardcodare PAT o secrets
- MAI aprire PR senza Work Item ADO
- MAI pushare direttamente a `main`
- MAX 2 tentativi sulla stessa API call ADO, poi STOP
- Se il repo ha `develop`, le feature passano da li, non vanno a `main`
- In dubbio architetturale: consultare GEDI prima di procedere
- Ogni capability creata/modificata DEVE essere documentata in `easyway-wiki/guides/` con: **Cosa** (tabella path), **Come** (flusso/comandi), **Perché** (decisione architetturale), **Q&A**. Senza guida wiki il lavoro è incompleto. Ref: `wiki/standards/agent-architecture-standard.md` §10

---

> Generato automaticamente dal Context Sync Engine (n8n workflow `context-sync`).
> Master template: `easyway-wiki/templates/agents-master.md`
> Override: `easyway-wiki/templates/repo-overrides.yml`
> Ultima sincronizzazione: 2026-03-14T03:01:59.214Z
