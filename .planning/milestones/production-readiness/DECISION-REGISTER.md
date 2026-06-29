---
milestone: production-readiness
phase: null
agent: planner
version: 1
status: DRAFT
supersedes: null
inputs:
  - nexus-map.md
  - docs/cursor/nexus-production-remediation-master-prompt.md
  - .planning/milestones/production-readiness/REMEDIATION-LEDGER.md
outputs:
  - .planning/milestones/production-readiness/DECISION-REGISTER.md
---

# Decision Register — Production Readiness

Material choices that affect implementation, verification, or release verdict. Orchestrator records final selected outcomes after authority review.

| Decision ID | Date | Question | Affected ledger IDs | Evidence inspected | Options | Selected outcome | Authority type |
|---|---|---|---|---|---|---|---|
| DEC-001 | 2026-06-29 | What is the deterministic rollout precedence order when multiple rollouts, experiments, entitlements, and platform defaults could conflict? | PR-029, PR-068, PR-125 | `nexus-map.md` §6.4 `/admin/rollouts`; `adminOpsService`; master prompt Phase 06 | (A) Rollout → experiment → entitlement → default; (B) Entitlement → rollout → experiment → default; (C) Emergency-off overrides all; product-defined pair matrix | **PENDING** — Architect must inventory current targeting semantics in Phase 06; Orchestrator obtains explicit product authority before Phase 06 `APPROVED_TO_BUILD` | explicit user decision |
| DEC-002 | 2026-06-29 | What does `PROD_READY` mean vs session-startable in product copy and gates? | PR-042, PR-043, PR-135, PR-136 | `src/lib/curriculum/contentModel.ts`; `nexus-map.md` §P1.9; master prompt Phase 10 | (A) Adopt master prompt rule: 21 questions/topic (7/7/7) + published lesson per subtopic; keep separate “can start” at 5/band; (B) Lower production target; (C) Rename labels only | **PENDING** — code-derived default is (A) per master prompt; confirm product/marketing alignment before Phase 10 approval | legal/product decision |
| DEC-003 | 2026-06-29 | May beta OAuth bypass the invite gate while email signup cannot? | PR-055, PR-054 | `nexus-map.md` §5.2–5.3; `signupAction`; `/auth/callback` | (A) Enforce identical beta policy on OAuth and email; (B) Allow OAuth without invite in beta; (C) Disable OAuth in beta | **PENDING** — security/product policy; default recommendation (A) fail-closed parity | explicit user decision |
| DEC-004 | 2026-06-29 | How resolve `undici` high and PostCSS moderate advisories without forced Next.js downgrade? | PR-017, PR-018 | `npm audit --audit-level=moderate` (STATUS baseline); `package.json` Next 16.2.9 | (A) `npm audit fix` + lockfile; (B) `overrides`/`resolutions` for `undici`/postcss chain; (C) Document reviewed exception with regression proof | **PENDING** — Phase 01 Coder tests each path; select first green path with documented evidence | code-derived + security constraint |
| DEC-005 | 2026-06-29 | Replace or waive performance thresholds if lab environment cannot measure reliably? | PR-087, PR-138, PR-139 | Master prompt Phase 11 budgets; no `lhci` script yet | (A) Keep LCP ≤2.5s, TBT ≤200ms, perf ≥90, a11y/SEO/BP ≥95 on Slow 3G profile; (B) Substitute metric with recorded rationale; (C) Waive category | **PENDING** — must resolve before Phase 11 `APPROVED_TO_BUILD`; no silent waiver | explicit user decision |
| DEC-006 | 2026-06-29 | Notification log retention: keep repository 90-day requirement or change for legal/product? | PR-057, PR-058, PR-107 | `nexus-map.md` §P2; billing/notification migrations; master prompt Phase 08 | (A) Keep 90 days; (B) Extend/shrink with documented policy; (C) Per-channel retention | **PENDING** — legal/product authority required before Phase 08 retention implementation | legal/product decision |
| DEC-007 | 2026-06-29 | Mock exam language: remove “past paper” claims or pursue licensed official archive? | PR-106 | `nexus-map.md` §5.9; `/exam-prep` copy | (A) Accurate mock-practice wording only; (B) Licensed official past-paper product | **PENDING** — default (A) per master prompt; (B) requires licensing authority | explicit user decision |
| DEC-008 | 2026-06-29 | Canonical runtime role claim: unify `app_metadata.userRole`, profile roles, and `admin_role_assignments`? | PR-028, PR-075, PR-127 | `superAdminGuard.ts`; `nexus-map.md` §4, §P1.6; master prompt Phase 06 | Architect selects backward-compatible model in `ARCHITECT-BRIEF.md` before Phase 06 coding | **PENDING** — Architect deliverable gates Phase 06 | code-derived |
| DEC-009 | 2026-06-29 | Which privileged admin mutations must fail closed when audit write fails? | PR-031, PR-032 | `recordAdminAudit()`; `nexus-map.md` §P1.7 | (A) Critical mutations transactional with audit/outbox; (B) All mutations fail closed; (C) Best-effort audit with visible retry | **PENDING** — Architect classifies criticality in Phase 06 brief | security constraint |
| DEC-010 | 2026-06-29 | Daraja callback trust when provider does not sign webhooks? | PR-001, PR-002, PR-003, PR-112, PR-124 | `/api/mpesa/callback`; Safaricom Daraja docs (Phase 03 Architect cite); master prompt Phase 03 | (A) Opaque callback token + STK Query reconciliation; (B) IP allowlist only (insufficient alone); (C) Delay activation until manual ops | **PENDING** — Phase 03 Architect cites primary contract; default (A) | provider contract |
| DEC-011 | 2026-06-29 | Screen reader gate browser/AT pair for Phase 11 manual a11y? | PR-137, PR-138 | Master prompt Phase 11: Windows Narrator + Edge default | (A) Narrator + Edge; (B) NVDA/JAWS + Chrome; (C) axe-only | **PENDING** — QA records installed pair before Phase 11 approval if not (A) | explicit user decision |
| DEC-012 | 2026-06-29 | Fix typecheck dotAll: raise TS `target` vs rewrite regex in test? | PR-011 | `tsconfig.json` ES2017; `tests/content/kcseMathSeedContent.test.ts:68,115` | (A) Rewrite regex without `s` flag; (B) Raise `target` with browser compat proof; (C) Separate test tsconfig | **PENDING** — Phase 01 prefers (A) or (C) unless compat proof for (B) | code-derived |
| DEC-013 | 2026-06-29 | Communications admin page scope: full campaign sender vs rename/narrow UI? | PR-067 | `nexus-map.md` §6.4 `/admin/communications` Partial | (A) Implement sender workflow; (B) Rename to templates/logs only | **PENDING** — product scope; default implement if UI promises campaigns | explicit user decision |
| DEC-014 | 2026-06-29 | `APP_ENV` vs `NODE_ENV` for mock permission and deployment safety? | PR-006–PR-010, PR-110, PR-120 | Master prompt Phase 02; no `env:check` today | Adopt explicit `APP_ENV=test\|development\|staging\|production` + provider modes; never infer from `NODE_ENV` alone | **SELECTED: explicit `APP_ENV` policy** (master prompt §Phase 02) — implementation in Phase 02 | code-derived |
| DEC-015 | 2026-06-29 | Stale `nexus-map.md` §11 F4 B2 migration missing claim vs branch truth? | PR-012, PR-121 | STATUS.md worktree capture; `supabase/migrations/20260625240000_kcse_math_f4_b2.sql` exists | (A) Reconcile test to migration on branch; (B) Regenerate migration | **SELECTED: reconcile test to existing migration** — map/STATUS stale; Phase 01 owns verification | code-derived |

## Open decisions blocking phase approval

| Phase | Blocking decision IDs |
|---|---|
| 06 | DEC-001, DEC-008, DEC-009 |
| 08 | DEC-006 |
| 10 | DEC-002, DEC-007 |
| 11 | DEC-005, DEC-011 |
| 03 | DEC-010 (Architect contract cite before build) |
| 01 | DEC-004, DEC-012 (resolve during implementation) |
| 04 | DEC-003 |
