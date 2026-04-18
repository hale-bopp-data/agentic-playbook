---
title: "Agents Master"
tags: []
---

# AGENTS.md — agentic-playbook

> Guide, pattern, ricette e principi per lo sviluppo agentico — knowledge sharing pubblico.
> Guardrails e regole: vedi `.cursorrules` nello stesso repo.
> Workspace map: vedi `factory.yml` nella root workspace (mappa completa repos, stack, deploy).

## Identità
| Campo | Valore |
|---|---|
| Cosa | Guide operative, pattern agentic, ricette, FAQ, evidence, principi |
| Linguaggio | Markdown |
| Branch | `feat→main` o `docs/→main` — PR target: `main` |
- **Circle**: 1 (GitHub-primary, NO ADO)
- **Visibilita**: pubblico

## Comandi rapidi
```bash
ewctl commit
# Push
git push origin <branch>
# PR (GitHub — NON ADO)
gh pr create --title "titolo" --body "descrizione"
```

## Struttura
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

## Regole specifiche agentic-playbook
| Regola | Dettaglio |
|---|---|
| Linguaggio | divulgativo, accessibile, no gergo interno EasyWay |
| Self-contained | ogni guida deve essere autonoma |
| Sicurezza | MAI secrets, PAT, URL interni, o riferimenti infra EasyWay |
| Formato | Markdown puro — no frontmatter YAML (diverso dalla wiki interna) |

## Workflow & Connessioni
| Cosa | Dove |
|---|---|
| ADO operations (WI, PR) | → vedi `easyway-wiki/guides/agents/agent-ado-operations.md` |
| PR flusso standard | → vedi `easyway-wiki/guides/polyrepo-git-workflow.md` |
| PAT/secrets/gateway | → vedi `easyway-wiki/guides/connection-registry.md` |
| Branch strategy | → vedi `easyway-wiki/guides/branch-strategy-config.md` |
| Tool unico | `bash /c/old/easyway/agents/scripts/connections/ado.sh` — MAI curl inline, MAI az login |


---
> Context Sync Engine | Master: `easyway-wiki/templates/agents-master.md`
> Override: `easyway-wiki/templates/repo-overrides.yml` | Sync: 2026-04-18T09:00:07Z
