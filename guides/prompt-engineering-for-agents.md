# Prompt Engineering for Agents

## System Prompt Structure

```
ROLE: Who is the agent
CONTEXT: What it knows (wiki, principles, history)
TASK: What to do with the input
FORMAT: How to structure the output
CONSTRAINTS: What NOT to do
```

## RAG-Enhanced Prompts

Inject wiki context before the query:

```
=== RELEVANT WIKI CONTEXT ===
- [chunk 1 from RAG search]
- [chunk 2 from RAG search]

Based on the above context, evaluate: {user_query}
```

## Anti-Patterns

- Do not stuff the entire wiki into the prompt
- Do not use temperature > 0.3 for governance decisions
- Do not ignore system prompt in favor of user input
