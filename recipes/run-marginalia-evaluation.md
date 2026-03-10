# Recipe: Run Marginalia Evaluation

```bash
# 1. Baseline snapshot
python marginalia/snapshot.py --collection easyway_wiki --output evidence/baseline.json

# 2. Define queries in evidence/queries.yaml

# 3. Run evaluation
python marginalia/evaluate.py --queries evidence/queries.yaml --output evidence/results.json

# 4. Compare
python marginalia/compare.py --before evidence/baseline.json --after evidence/results.json
```

| Metric | Good | Bad |
|--------|------|-----|
| Coverage | >80% | <50% |
| Precision@3 | >0.7 | <0.4 |
