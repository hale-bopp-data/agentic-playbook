---
title: "Agents Master"
tags: []
---

# AGENTS.md — agentic-playbook

> Guide, pattern, ricette e principi per lo sviluppo agentico — knowledge sharing pubblico.
> Guardrails e regole: vedi `.cursorrules` nello stesso repo.

## Identità
- **Cosa**: Guide operative, pattern agentic, ricette, FAQ, evidence, principi
- **Linguaggio**: Markdown
- **Branch**: feat→main` o `docs/→main | PR target: `main`
- **Circle**: 1 (GitHub-primary, NO ADO)
- **Visibilita**: pubblico

## Comandi rapidi
```bash
ewctl commit
git push origin <branch>


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

- Contenuto divulgativo — linguaggio accessibile, no gergo interno EasyWay
- Ogni guida deve essere self-contained
- MAI includere secrets, PAT, URL interni, o riferimenti a infrastruttura EasyWay
- Markdown puro — no frontmatter YAML (diverso dalla wiki interna)

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
> Override: `easyway-wiki/templates/repo-overrides.yml` | Sync: 2026-03-14T12:31:02.323Z
