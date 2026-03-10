# Pattern: Wiki-Driven Agents

## Problem

Agent behavior needs to change without code deploys.

## Solution

Store agent knowledge in the wiki, serve through RAG:

```
Wiki (human-editable) -> Qdrant (vector store) -> RAG (agent reads)
```

Wiki quality directly determines agent quality.
