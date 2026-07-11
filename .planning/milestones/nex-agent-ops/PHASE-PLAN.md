---
milestone: nex-agent-ops
phase: 1
agent: planner
version: 1
status: APPROVED
supersedes: null
inputs:
  - docs/superpowers/specs/2026-07-10-nex-agent-ops-design.md
  - docs/superpowers/plans/2026-07-11-nex-companion-agent-ops.md
  - docs/product-governance/mvp-feature-scope-lock.md
  - docs/phase-5-engineering-governance/coding-agent-rules.md
  - .planning/agents/HANDOFF-PROTOCOL.md
  - .planning/milestones/v2-tier-1/STATUS.md
outputs:
  - .planning/milestones/nex-agent-ops/PHASE-PLAN.md
---

# PHASE-PLAN — Nex Companion and Agent Ops

**Architect input:** [docs/superpowers/specs/2026-07-10-nex-agent-ops-design.md](../../docs/superpowers/specs/2026-07-10-nex-agent-ops-design.md) (approved design; no separate ARCHITECT-BRIEF yet)  
**Implementation plan:** [docs/superpowers/plans/2026-07-11-nex-companion-agent-ops.md](../../docs/superpowers/plans/2026-07-11-nex-companion-agent-ops.md)  
**Overall verdict:** `APPROVED_TO_BUILD` (Phase 1 only)

## Milestone exit criteria

- [ ] Workflow context validated and server-reconstructed (NAO-CTX-*)
- [ ] Append-only model-attempt telemetry without blocking tutoring (NAO-TEL-*)
- [ ] Persistent companion shell + lesson/practice triggers (NAO-CMP-*)
- [ ] Bounded adaptive help (NAO-ADP-*)
- [ ] Canonical Agent Ops control plane (NAO-OPS-*)
- [ ] Escalation cases with human-authored student contact (NAO-CAS-*)

## Parallel workstream declaration

**Orchestrator/Planner decision:** `nex-agent-ops` is an **explicitly parallel V2 workstream** with an isolated Phase 1 allowlist.

Rationale:

- Release classification is V2/post-beta; this plan does not amend the V1 scope lock.
- `v2-tier-1` is `PHASE_2_5_VERIFIED` (no active product-code build phase).
- `production-readiness` is `PHASE_05_VERIFIED` / `NOT_READY` for later phases; historical `APPROVED_TO_BUILD` markers are not an active Coder assignment on this branch.
- Phase 1 allowlist is disjoint from companion UI, admin redesign, voice, and camera workstreams.
- Only Phase 1 of this milestone may be `APPROVED_TO_BUILD`. Phases 2–5 remain locked until QA PASS unlocks them.

| Stream | Phases | Notes |
|--------|--------|-------|
| nex-agent-ops | Phase 1 only | Isolated allowlist below; no voice/camera/companion UI |
| v2-tier-1 | closed for build | Verified; do not reopen |
| production-readiness | later phases | Separate track; do not edit its allowlists |

---

## Phase 1 — Context and telemetry foundation

**Status:** `APPROVED_TO_BUILD`  
**Depends on:** none  
**Criteria:** NAO-CTX-01, NAO-CTX-02, NAO-CTX-03, NAO-TEL-01, NAO-TEL-02, NAO-TEL-03

### Goal

Add a validated workflow-context envelope at the Nex chat boundary and append-only provider-attempt telemetry, without changing Socratic behavior, provider order, limits, voice, or camera.

### Criterion IDs

| ID | Description |
|----|-------------|
| NAO-CTX-01 | Workflow context accepts only versioned, allowlisted fields and server-valid identifiers. |
| NAO-CTX-02 | Context cannot cross students, accounts, sessions, or protected assessment boundaries. |
| NAO-CTX-03 | Invalid optional context is dropped safely; protected-context violations are rejected. |
| NAO-TEL-01 | Every provider attempt can be recorded with correlation, provider/model, timing, token, validation, and outcome data. |
| NAO-TEL-02 | Telemetry failure does not block Nex responses and produces an observable gap. |
| NAO-TEL-03 | Pricing comes from one shared configuration source and identifies exact versus estimated usage. |

### Tasks

1. Define workflow-context types, strict Zod schema, optional `workflowContext` on `nexChatRequestSchema`, and `resolveNexWorkflowContext` ownership reconstruction.
2. Add `nex_model_calls` migration (RLS), best-effort `recordNexModelAttempt`, and thread correlation/attempt metadata through the existing text pipeline only.
3. Update `nexOpsService` to aggregate `nex_model_calls` with exact-versus-estimated labeling via `getNexOpsPricingConfigFromPlatformSettings()`.

### File allowlist

```
src/lib/nex/workflowContext.ts                          (create)
src/schemas/nexWorkflowContextSchemas.ts                 (create)
src/schemas/nexSchemas.ts
src/lib/nex/types.ts
src/lib/nex/assemblePrompt.ts
src/lib/nex/callNexModel.ts
src/lib/nex/geminiClient.ts
src/lib/nex/openaiClient.ts
src/lib/nex/generateNexResponse.ts
src/server/services/nexWorkflowContextService.ts         (create)
src/server/services/nexModelTelemetryService.ts          (create)
src/server/services/nexOpsService.ts
src/app/api/nex/chat/route.ts
supabase/migrations/<timestamp>_nex_model_calls.sql      (create)
src/types/database.ts
tests/nex/workflowContext.test.ts                        (create)
tests/nex/nexModelTelemetryService.test.ts               (create)
tests/nexSchemas.test.ts                                 (amend — plan Task 1 Step 6)
tests/nex/callNexModel.test.ts
tests/nex/nexChatStream.test.ts
tests/nexOpsService.test.ts
.env.example
.planning/milestones/nex-agent-ops/phases/phase-1/CODER-CHANGELOG.md
.planning/milestones/nex-agent-ops/STATUS.md
```

### Allowlist path audit (2026-07-11)

| Path | State |
|------|-------|
| Existing modify targets | Present and named as planned |
| Create targets | Missing as expected (greenfield) |
| Migration | New timestamped file under `supabase/migrations/` |
| `tests/nexSchemas.test.ts` | **Amended into allowlist** — exists; required for optional `workflowContext` on chat schema |

No renamed paths found. Do not touch voice/camera routes or companion UI files.

### Out of scope

- Companion UI, embedded triggers, adaptive suggestions
- Admin Ops redesign, cases, communications
- Prompt editing, provider order/limit changes
- Voice and camera instrumentation (owned by separate V2 workstreams)
- Phases 2–5 of this plan

### Hard constraints (Coder)

- All text interactions continue through `/api/nex/chat` and `generateNexResponse`
- Telemetry failure must not block tutoring
- No prompt/response content in `nex_model_calls`
- No hardcoded pricing or exchange rates
- Use TDD; commit after each green task per plan

### Verification

```powershell
npx vitest run tests/nex/workflowContext.test.ts tests/nex/nexModelTelemetryService.test.ts tests/nexSchemas.test.ts tests/nexOpsService.test.ts tests/nex/callNexModel.test.ts tests/nex/nexChatStream.test.ts
npm run lint
npm run typecheck
npm run test:scope-check
npm run build
```

### Planner verdict

`APPROVED_TO_BUILD`

---

## Phase 2 — Persistent companion, lesson, and practice access

**Status:** `LOCKED_PENDING_PHASE_1_QA`  
**Planner verdict:** `PENDING`

## Phase 3 — Revision/results integration and bounded adaptive help

**Status:** `LOCKED_PENDING_PHASE_2_QA`  
**Planner verdict:** `PENDING`

## Phase 4 — Canonical Agent Ops control plane

**Status:** `LOCKED_PENDING_PHASE_3_QA`  
**Planner verdict:** `PENDING`

## Phase 5 — Cases and human-reviewed communications

**Status:** `LOCKED_PENDING_PHASE_4_QA`  
**Planner verdict:** `PENDING`

---

## Verdict rationale

Phase 1 is approved because:

1. It matches the approved design (§4.1 workflow context, §4.4 telemetry) without expanding V1-banned surfaces.
2. Scope lock conflict check: Phase 1 does not ship camera, assessment-mode UI, mock exams, or companion shell — those remain later phases or other workstreams. Live code already has V2 assessment/camera/voice paths; Phase 1 must preserve them as regression surfaces only.
3. Allowlist is isolated and sufficient for context + telemetry + Ops pricing aggregation.
4. Parallel workstream is explicitly declared so Coder may proceed without waiting for other milestones to close.

Coder may begin Phase 1 only. Do not self-unlock Phase 2.
