# QA Report Template

**Wave:** {N}  
**Date:** {YYYY-MM-DD}  
**Verdict:** PASS | FAIL

## Commands run

| Command | Exit code | Notes |
|---------|-----------|-------|
| `npm run lint` | | |
| `npm run typecheck` | | |
| `npm test` | | |
| `npm run test:scope-check` | | |
| `npm run build` | | |

## Overseer criteria verification

| Criterion | Expected | Actual | Pass |
|-----------|----------|--------|------|
| | | | |

## Nex golden cases (Wave 3+)

| Case | Result |
|------|--------|
| homework-linear-equation-first-turn | |
| explain-fractions | |

## RLS / security checks

- [ ] Student cannot read other student data
- [ ] Parent cannot mutate student data
- [ ] No service role in client bundles

## Failures (if any)

{Describe failures and required fixes}

## Verdict rationale

{PASS or FAIL with evidence}
