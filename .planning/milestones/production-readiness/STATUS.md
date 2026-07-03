---
milestone: production-readiness
phase: 00
agent: orchestrator
version: 1
status: DRAFT
supersedes: null
inputs:
  - nexus-map.md
  - docs/cursor/nexus-production-remediation-master-prompt.md
outputs:
  - .planning/milestones/production-readiness/STATUS.md
---

# Production Readiness — Program Status

**Orchestrator state:** `PHASE_05_PLANNING`

**Active branch:** `main` (`feat/kcse-math-f4-b2` was merged and is an ancestor)

**Program verdict:** `NOT_READY` (Phases 00–04 PASS; 05–12 not started)

## Worktree capture (2026-06-29)

Captured at program start. Preserve dirty worktree; do not reset/stash/discard.

### Branch

```
feat/kcse-math-f4-b2
```

### `git status --short`

```
?? docs/cursor/nexus-production-remediation-master-prompt.md
?? nexus-map.md
```

### `git diff --stat`

```
(empty — no unstaged tracked changes)
```

### `git diff --staged --stat`

```
(empty — nothing staged)
```

### `git log -10 --oneline`

```
5790235 docs(roadmap): mark Form 4 Batch 2 complete — all 66 topics done
0bcedb0 test(content): validate KCSE Form 4 Batch 2 migration lessons
652ae3b feat(content): author KCSE Form 4 Integration
6fdb19a feat(content): author KCSE Form 4 Area Approximation
d73b993 feat(content): author KCSE Form 4 Differentiation
42a3cf1 feat(content): author KCSE Form 4 Linear Programming
7f65aea feat(content): author KCSE Form 4 Longitudes and Latitudes
15068dc Merge feat/kcse-math-f4-b1: KCSE Form 4 Batch 1 (matrices-transf/stats II/loci/trig III/3D geometry)
c03d026 docs(roadmap): mark Form 4 Batch 1 complete
6e891ac test(content): validate KCSE Form 4 Batch 1 migration lessons
```

### Ownership notes

- Untracked `nexus-map.md` and remediation master prompt are program inputs; not owned by concurrent F4 B2 content commits.
- F4 B2 migration `supabase/migrations/20260625240000_kcse_math_f4_b2.sql` **exists** on current branch (map section 11 stale on missing migration).
- Prior audit observed staged `tests/content/kcseMathSeedContent.test.ts` and `.gen_f4_b2.mjs` that later landed as commits `0bcedb0` / content migrations — treat as concurrency evidence only.

## Baseline gate evidence (fresh run 2026-06-29)

| Gate | Result | Notes |
|------|--------|-------|
| `npm run orchestrator:status` | PASS | v2-tier-1 `PHASE_2_5_CODE_COMPLETE` |
| `npm run lint` | PASS (4 warnings) | unused vars in scripts + kcseMathSeedContent.test.ts |
| `npm run typecheck` | **PASS** | dotAll regex rewritten (DEC-012) |
| `npm test` | PASS | 497 passed, 14 skipped (2026-06-29 Phase 04) |
| `npm run test:scope-check` | PASS | |
| `npm run build` | PASS | Next 16.2.9 production build, all routes emitted |
| `npm audit --audit-level=moderate` | **PASS** | undici fix + postcss override (DEC-004) |
| `npm run env:check` | PASS (stub) | exits 0; strict validation Phase 02 |
| `npm run deploy:check` | PASS | lint + typecheck + test + scope-check + build + audit |
| `npm run test:e2e:ci` | PASS | 8 passed, 10 skipped; prod server :3000 |
| `npx lhci autorun` | NOT_PRESENT | Phase 11 |
| `npm run db:reset` | NOT_RUN | Phase 01+ |
| `npx supabase migration list` | NOT_RUN | Phase 00 rescan |

### Repository counts (verified 2026-06-29)

| Surface | Count |
|---------|------:|
| Page routes (`src/app/**/page.tsx`) | 69 |
| API route files | 73 |
| SQL migrations | 39 |
| Unit/integration test files | 71+ (82 vitest files per run) |
| Playwright E2E specs | 5 files |

## Phase status

| Phase | Title | Coder | QA | Ledger rows owned |
|-------|-------|-------|-----|-------------------|
| 00 | Ground truth, ledger, authority reset | DONE | PASS | PR-121, PR-122 closed |
| 01 | Green baseline and release harness | DONE | PASS (fix cycle 1) | PR-011–PR-012, PR-017–PR-020, PR-116–PR-120 |
| 02 | Production environment policy | DONE | PASS (fix cycle 1) | PR-005–PR-010, PR-044, PR-110, PR-120 |
| 03 | Payment trust, callbacks, reconciliation | DONE | PASS (production repair v4) | PR-001–004, PR-056, PR-094–096, PR-111–115, PR-124, … |
| 04 | AuthZ and account consistency | DONE | PASS (fix cycle 2) | PR-013, PR-054–055, PR-088, PR-127, PR-142 VERIFIED_COMPLETE |
| 05 | Atomic DB + rate limiting | — | — | P1.3, P1.11 |
| 06 | Admin authZ, rollouts, audit | — | — | P1.6, P1.7 |
| 07 | Student utilities | — | — | P1.8 utilities |
| 08 | Parent, family, notifications | — | — | parent/privacy |
| 09 | Admin operational workflows | — | — | admin shells |
| 10 | Content coverage and product truth | — | — | P1.9, P1.12 |
| 11 | Browser security, a11y, perf | — | — | P1.5, observability |
| 12 | Full-system release proof | — | — | E2E, staging, signoff |

## Next action

**Phase 05 — atomic database operations and durable rate limiting.** Plan section exists in PHASE-PLAN.md (verdict `PENDING`); Planner approval, then Coder per file allowlist. Environment note: local Docker unavailable — work runs against the linked remote Supabase project (migrations via `supabase db push --linked`; remote in sync 43/43 as of 2026-07-03).

## Phase 04 evidence (2026-07-03 fix cycle 2)

- Remote migration push: `20260701100000_beta_invite_reservation.sql` applied; `supabase migration list --linked` fully in sync.
- `support@nexus.local` seeded on remote (`npm run db:seed-dev-users`).
- `e2e/support-admin-login.spec.ts` → **PASS** (assertion corrected: authenticated support user is 307-chained `/admin/usage-stats` → `/login` → `/admin/support`, so the spec now asserts landing on `/admin/support`, not the uncommittable `/login` hop).
- `npm run lint` PASS · `npm run typecheck` PASS.

## Phase 04 evidence (2026-06-30 fix cycle 1)

- `npx vitest run tests/auth/` → 29 passed, 0 skipped
- `npm test` → 513 passed; `deploy:check` PASS
- Session freshness: JWT `sessionVersion` + `auth.sessions` via `is_auth_session_active`
- Support routing: `/admin/support` (support), `/admin` (super_admin)
- Role matrix: committed `role-matrix.contract.json` (143 routes) + server-action contract
- E2E `support-admin-login.spec.ts` → **FAIL** (redirect timeout; seed + server restart required)
