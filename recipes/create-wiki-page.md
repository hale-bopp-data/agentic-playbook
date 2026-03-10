# Recipe: Create a Wiki Page

Use frontmatter template:

```yaml
---
id: unique-page-id
title: Page Title
summary: One-line description
status: active
owner: team-name
tags: [domain/area, audience/dev]
llm:
  include: true
  chunk_hint: 300
---
```

After creating: add to index, re-index Qdrant, test RAG search.
