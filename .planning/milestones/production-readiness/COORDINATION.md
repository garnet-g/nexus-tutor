---
milestone: production-readiness
phase: null
agent: orchestrator
version: 1
status: ACTIVE
supersedes: null
inputs:
  - .planning/milestones/production-readiness/PHASE-PLAN.md
  - .planning/milestones/production-readiness/AUTH-ACCOUNT-PHASE-PLAN.md (codex/auth-account-hardening branch)
  - git worktree list; git log main..codex/auth-account-hardening
outputs:
  - .planning/milestones/production-readiness/COORDINATION.md
---

# Track Coordination — Production Readiness

Two workstreams are active in this milestone. This file is the **single source
of truth** for how they divide work, own shared files, and integrate. Both
tracks read this before editing shared state.

## The two tracks

| Track | Branch / worktree | Owns | Status (2026-07-03) |
|-------|-------------------|------|---------------------|
| **Program spine** (numbered phases 00–12) | `main` (this worktree) | PHASE-PLAN.md, STATUS.md, RELEASE-EVIDENCE.md, REMEDIATION-LEDGER.md, all non-auth product code | Phases 00–05 **PASS**; 06 next |
| **Auth & Account Hardening** (Phases A–E, `AA-###`) | `codex/auth-account-hardening` (`C:/tmp/nexus-auth-account`) | AUTH-ACCOUNT-*.md, phases/phase-A…E/, auth/account/session/recovery/deletion product code + `tests/auth/*` | Phase A `READY_FOR_QA`; B–E `PENDING` |

The Auth track is **not** a competing numbering scheme. It is a focused,
cross-cutting deep-dive on the auth/account slice that the numbered phases
touch only shallowly. It is nested inside this milestone, on its own branch.

## Concern-ownership split (prevents double-building)

The Auth track owns the auth/account concern **end to end**. Where a numbered
phase would otherwise re-build the same surface, it **defers to the Auth track**:

| Concern | Owner | Numbered phase defers |
|---------|-------|-----------------------|
| Login, Google OAuth, confirmation, password recovery, session logout/revoke | Auth B | — |
| Student/parent account center, profile/email invariant, 30-day deletion, account RLS | Auth C | **Phase 08** (parent/family/privacy) cedes the account-lifecycle slice |
| Admin account control: ban/revoke, role mutation, fail-closed critical audit | Auth D | **Phase 06** (admin authZ/audit) cedes the account-control slice |
| Journey matrix + contract tests (`account-lifecycle.contract.json`) | Auth A | — |
| Atomic DB ops, quotas, durable rate limiting, CSRF/body limits | **Phase 05** (done) | Auth track consumes as-is |
| Admin rollouts, non-account audit, admin operational workflows | **Phases 06/09** | — |

If a task touches both an account concern and a non-account concern, the Auth
track lands the account part; the spine wires the rest.

## Shared-file ownership (the actual collision fix)

Both tracks were editing `STATUS.md`, `RELEASE-EVIDENCE.md`, and
`phase-04/QA-REPORT.md` — that is what produced the merge risk.

**Rule:** the program-spine files below are **authored only on `main`**. The
Auth track treats them as read-only inputs and records its own state in its
namespaced files, handing evidence to the orchestrator to fold into the spine.

| File | Author | Auth track action |
|------|--------|-------------------|
| `STATUS.md` | main / orchestrator | read-only; report state via AUTH-ACCOUNT docs |
| `RELEASE-EVIDENCE.md` | main / orchestrator | read-only |
| `REMEDIATION-LEDGER.md` | main / orchestrator | propose rows; orchestrator writes |
| `phases/phase-04/QA-REPORT.md` | main (Phase 04 is closed PASS) | do not re-litigate; add AUTH findings to `phase-A/QA-REPORT.md` |
| `AUTH-ACCOUNT-*.md`, `phases/phase-A…E/*`, `tests/auth/*` | Auth track | authoritative |

## Sequencing correction

The Auth `AUTH-ACCOUNT-PHASE-PLAN.md` states "Phase 05 remains locked." **That is
now stale.** Phase 05 (atomic DB + rate limiting) shipped on `main` (`8ee628a`,
migration `20260702090000` pushed + smoke-verified) and is orthogonal to the
auth/account concern — no shared product code. The Auth track is unblocked and
should update that line to: *Phase 05 landed on main; auth contract tests must
re-run green against the Phase 05 tree at integration.*

## Environment / evidence timeline (reconciles the Docker discrepancy)

Both Docker accounts in the evidence are true at their timestamps — record the
timeline rather than treating them as contradictory:

- **During Phase 04 fix-cycle 2 and Phase 05 active work:** local Docker Desktop
  backend had crashed (stale `dockerInference` socket). Those phases were
  verified against the **linked remote** Supabase (`db push --linked`, live RPC
  smoke).
- **Later same day (2026-07-03):** Docker recovered; local Supabase stack came
  up healthy; the Auth track's `npm run db:reset` + CI-mode support-login E2E ran
  green locally. Both are valid; neither supersedes the other.

## Integration protocol

1. Auth track reaches a safe stopping point and **commits** its worktree edits.
2. Auth branch **rebases onto `main@8ee628a`** (or later), taking `main`'s
   version of every program-spine file; it re-applies only its own namespaced
   additions.
3. Run **both** suites on the rebased tree: `tests/auth/*` (Auth) and
   `tests/concurrency|security|rateLimit/*` (Phase 05). Both must stay green.
4. Orchestrator merges Auth Phase A to `main` after independent QA, then folds
   its ledger rows (AA-###) into `REMEDIATION-LEDGER.md`.
5. Repeat per Auth phase (B–E), rebasing onto the latest spine each time.

**Do not** merge branches or edit the other track's worktree while its changes
are uncommitted.
