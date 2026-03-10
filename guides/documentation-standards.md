# Documentation Standards

## Every Page Needs Frontmatter

```yaml
---
id: unique-page-id
title: Human-readable title
summary: One-line description
status: active | draft | deprecated
owner: team-name
tags: [domain/area, audience/dev]
llm:
  include: true
  chunk_hint: 300
---
```

## Writing for Agents

Agents read docs through RAG. Optimize for:
- Clear headings
- Tables over prose
- Code blocks with language tags
- Short paragraphs (better chunking)
