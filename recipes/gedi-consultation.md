# Recipe: Consult GEDI

## When to Consult

Architectural decisions, process trade-offs, quality gates, risk assessment.

## Usage

```bash
# Simple
bash scripts/connections/gedi.sh consult "Should we skip tests?"

# With context
bash scripts/connections/gedi.sh consult --context "production down" "Deploy without regression?"
```

## After Consultation

Document the case in GEDI_CASEBOOK.md immediately.
