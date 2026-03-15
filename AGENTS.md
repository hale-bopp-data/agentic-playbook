---
title: "Agents Master"
tags: []
---

# AGENTS.md — agentic-playbook

> Guide, pattern, ricette e principi per lo sviluppo agentico — knowledge sharing pubblico.
> Guardrails e regole: vedi `.cursorrules` nello stesso repo.

## Identità
| Campo | Valore |
|---|---|
| Cosa | Guide operative, pattern agentic, ricette, FAQ, evidence, principi |
| Linguaggio | Markdown |
| Branch | `feat→main` o `docs/→main` — PR target: `main` |
| Circle | 1 (GitHub-primary, NO ADO) |
| Visibilita | pubblico |

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

## ADO Workflow
```bash
# Tool UNICO — MAI curl inline, MAI az login
bash /c/old/easyway/ado/scripts/ado-remote.sh wi-create "titolo" "PBI" "tag1;tag2"
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-create agentic-playbook <src> main "AB#NNN titolo" NNN
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-autolink-wi <pr_id> agentic-playbook
bash /c/old/easyway/ado/scripts/ado-remote.sh pat-health-check
```
Repo ADO: `easyway-portal`, `easyway-wiki`, `easyway-agents`, `easyway-infra`, `easyway-ado`, `easyway-n8n`

## PR — Flusso standard
```bash
cd /c/old/easyway/agentic-playbook && git push -u origin feat/nome-descrittivo
bash /c/old/easyway/ado/scripts/ado-remote.sh pr-create agentic-playbook feat/nome-descrittivo main "AB#NNN titolo" NNN
```

## Connessioni
- **PAT/secrets**: SOLO su server `/opt/easyway/.env.secrets` — MAI in locale
- **Guida**: `easyway-wiki/guides/connection-registry.md`
- **`.env.local`**: solo OPENROUTER_API_KEY e QDRANT

---
> Context Sync Engine | Master: `easyway-wiki/templates/agents-master.md`
> Override: `easyway-wiki/templates/repo-overrides.yml` | Sync: 2026-03-14T16:00:00.000Z
