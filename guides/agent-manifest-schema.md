# Agent Manifest Schema

## Required Fields

```json
{
  "name": "agent_example",
  "version": "1.0.0",
  "level": 3,
  "description": "What this agent does",
  "action": {
    "script": "path/to/script.sh",
    "allowed_tools": ["bash", "git"]
  },
  "principles": ["P01", "P02"],
  "dependencies": []
}
```

## Level Classification

| Level | Description | LLM Required |
|-------|------------|-------------|
| L1 | Simple automation | No |
| L2 | Pattern matching | Optional |
| L3 | Decision making | Yes |
