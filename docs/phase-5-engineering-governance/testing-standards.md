# Testing Standards

**Version:** 1.0  
**Team size:** 2–5 developers — pragmatic coverage, not 100% vanity metrics

---

## 1. Testing Pyramid (V1)

| Layer | Target | Tools |
|-------|--------|-------|
| Unit | Business logic, scoring engines | Vitest |
| Integration | API routes, Supabase queries | Vitest + test DB |
| E2E | Critical user journeys | Playwright (optional V1) |

**Priority:** Test engines and payment logic first.

---

## 2. Must-Test (V1)

| Domain | Tests |
|--------|-------|
| Health Score calculation | Weighted diagnostic scoring |
| Mastery update formula | Practice completion updates |
| M-Pesa callback handler | Idempotency, status mapping |
| Subscription activation | Payment → active transition |
| Diagnostic scoring | Topic strong/weak classification |
| Free tier rate limit | Nex message count gate |
| RLS policies | Student cannot read other student data |

---

## 3. Test Naming

```ts
describe('calculateHealthScore', () => {
  it('returns weighted score from diagnostic answers', () => {});
  it('classifies topics below 50 as weak', () => {});
});

describe('POST /api/mpesa/callback', () => {
  it('activates subscription on successful callback', () => {});
  it('ignores duplicate callback without double activation', () => {});
});
```

---

## 4. Test Data

- Use factory functions, not copy-pasted JSON
- Seed test curriculum in `supabase/seed/test/`
- Never test against production Supabase

---

## 5. CI Requirements (When Configured)

```bash
npm run lint
npm run typecheck
npm test
```

PRs blocked on lint/type errors. Test failures block merge for covered domains.

---

## 6. Manual QA Checklist (Pre-Release)

- [ ] Student signup → diagnostic → dashboard
- [ ] Practice session → mastery update
- [ ] Nex chat all 4 modes
- [ ] M-Pesa sandbox payment → subscription active
- [ ] Parent link → dashboard data visible
- [ ] Mobile 375px all screens
- [ ] Free tier Nex limit enforced

---

## 7. What Not to Test (V1)

- shadcn component internals
- Supabase Auth SDK itself
- Third-party API reliability (mock in tests)

---

## 8. Coverage Target

- **Engines & payments:** ≥80% line coverage
- **UI components:** smoke tests only unless complex logic
- **Overall:** ≥60% — quality over number
