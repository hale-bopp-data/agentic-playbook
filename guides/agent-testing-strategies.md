# Agent Testing Strategies

## The Testing Pyramid for Agents

```
        /  E2E  \        Few: full agent flow tests
       /  Integ  \       Some: agent + real services
      / Unit Tests\      Many: individual functions
     /--------------\
```

## Unit Testing Agent Logic

Test decision logic independently of LLM calls:
mock LLM responses, verify OODA loop transitions, check principle matching.

## RAG Quality Testing

Use Marginalia or similar tools to measure:
- Coverage: what percentage of queries get useful results?
- Precision@K: are the top K results relevant?
- Recall@K: are all relevant docs found?
