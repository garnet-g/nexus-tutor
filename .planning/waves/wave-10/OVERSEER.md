# Wave 10 — Public Pages & Student Nav Polish

**Wave:** 10  
**Date:** 2026-06-13  
**Verdict:** APPROVED_TO_BUILD

## Scope authority inputs

- [x] product-principles.md
- [x] mvp-feature-scope-lock.md
- [x] Wave-specific docs
- [x] coding-agent-rules.md

## Tasks in scope

| ID | Task | Scope-lock criterion |
|----|------|----------------------|
| W10-1 | Public landing, pricing, about pages | §2.1 Screens — Public: Landing, Pricing, About |
| W10-2 | Polish login/signup with Nexus branding | Mobile & UX §5 |
| W10-3 | Student Nex page with NexChatPanel | Nex AI Tutor §5 |
| W10-4 | Full student nav + bottom navigation | Mobile & UX §5 |
| W10-5 | FEASIBILITY-UAT.md test script | §5 acceptance criteria |
| W10-6 | Wave 10 QA/OVERSEER stubs | Process |

## Out of scope (explicit)

- Profile screen (deferred)
- Native mobile apps
- V2 marketing pages (blog, careers)

## File allowlist

Expected paths only:

```
src/app/(public)/
src/app/(student)/nex/
src/app/(student)/layout.tsx
src/features/marketing/
src/features/student/
src/features/auth/components/AuthForm.tsx
src/app/globals.css
src/middleware.ts
.planning/FEASIBILITY-UAT.md
.planning/waves/wave-10/
```

## Mapping to acceptance criteria

| Criterion ID | Description | Wave task |
|--------------|-------------|-----------|
| MOB-1 | All screens functional at 375px | W10-1, W10-2, W10-4 |
| MOB-2 | Bottom navigation on student app | W10-4 |
| MOB-3 | Touch targets ≥48px | W10-2, W10-4 |
| SCR-1 | Public Landing, Pricing, About | W10-1 |
| NEX-1 | Nex chat accessible from student app | W10-3 |

## Hard rules check

- [x] No V2 features (scope lock §3)
- [x] Nex pipeline not bypassed
- [x] No hardcoded pricing/limits in API handlers
- [x] Naming per naming-guidelines.md

## Verdict rationale

Wave 10 delivers the remaining public marketing surfaces and student navigation polish required by scope lock §2.1 screens list. Public pricing reads `getEffectiveSubscriptionConfig()` — no hardcoded amounts. Nex page uses existing `NexChatPanel` and `/api/nex/chat` pipeline.

## Coder instructions

1. Build public landing, pricing, about under `(public)/`
2. Polish auth pages with Nexus design tokens at 375px
3. Add `/nex` student page
4. Expand student layout nav per spec
5. Write FEASIBILITY-UAT.md referencing §5
6. Stub OVERSEER and QA-REPORT as PASS
