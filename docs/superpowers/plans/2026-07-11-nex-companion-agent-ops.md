# Nex Companion and Agent Ops Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Nex a persistent, workflow-aware student companion and replace fragmented AI administration with one observable, accountable Agent Ops control plane.

**Architecture:** Preserve the existing Nex pipeline and add a validated workflow-context envelope at its boundary. Record each model attempt in append-only telemetry, expose Nex through one companion shell plus embedded workflow triggers, and build canonical Ops and case workflows on a shared server read model.

**Tech Stack:** Next.js 16.2.9 App Router, React 19.2, TypeScript, Zod 4, Supabase/Postgres/RLS, Vitest, Testing Library, Playwright, Tailwind/shadcn.

**Release classification:** V2/post-beta. This plan does not amend or expand the V1 scope lock.

---

## 0. Cursor operating contract

### Authority order

1. `docs/superpowers/specs/2026-07-10-nex-agent-ops-design.md`
2. This plan
3. `docs/product-governance/mvp-feature-scope-lock.md`
4. `docs/phase-2-product-systems/nex-socratic-tutor-engine.md`
5. `docs/phase-2-product-systems/nex-prompting-framework.md`
6. `docs/phase-1-foundation/technical-architecture.md`
7. `docs/phase-1-foundation/api-standards.md`
8. `docs/phase-5-engineering-governance/coding-agent-rules.md`
9. `.planning/agents/HANDOFF-PROTOCOL.md`

If code and an older document disagree, stop and report the exact conflict. Do not silently recreate, delete, or bypass a live system.

### Hard constraints

- Do not create a second chat pipeline. All text interactions continue through `/api/nex/chat` and `src/lib/nex/generateNexResponse.ts`.
- Do not change the Socratic hint ladder, provider order, daily limits, or subscription logic unless a task explicitly requires it.
- Do not expand voice, camera, assessment mode, mock exams, or practice-paper capabilities. Existing live paths are regression surfaces only.
- Do not expose answer keys or protected assessment content through workflow context.
- Do not hardcode pricing, exchange rates, or limits in routes or UI.
- Do not let telemetry failure block tutoring.
- Do not let dashboard query failure render as a legitimate zero.
- Do not contact students automatically. Case communications remain human-reviewed.
- Use migrations under `supabase/migrations/`; enable RLS and add policies in the same migration.
- Read the relevant Next.js 16 guide under `node_modules/next/dist/docs/` before changing layouts, route handlers, redirects, or caching.

### Agent handoff loop

For each phase:

1. Planner approves only that phase and its allowlist.
2. Coder executes only approved tasks and writes `.planning/milestones/nex-agent-ops/phases/phase-N/CODER-CHANGELOG.md`.
3. QA runs focused checks and global gates, then writes `.planning/milestones/nex-agent-ops/phases/phase-N/QA-REPORT.md`.
4. Planner unlocks the next phase only after QA says `PASS`.
5. After two failed QA cycles, return to Architect and Planner instead of widening the patch.

### Governance gate before Phase 1

The active `v2-tier-1` milestone already has Phase 0 approved. Nexus permits only one approved phase at a time unless the Orchestrator explicitly declares parallel workstreams. Before Cursor edits code, the Planner must do one of the following in `.planning/milestones/nex-agent-ops/PHASE-PLAN.md`:

- declare `nex-agent-ops` an explicitly parallel V2 workstream with an isolated allowlist; or
- wait for the currently approved `v2-tier-1` phase to close, then approve Agent Ops Phase 1; or
- supersede the earlier approval with an explicit rationale.

Until that artifact says `APPROVED_TO_BUILD`, Phase 1 is planned but not authorized for coding.

## 1. Criterion registry

| ID | Acceptance criterion |
|---|---|
| NAO-CTX-01 | Workflow context accepts only versioned, allowlisted fields and server-valid identifiers. |
| NAO-CTX-02 | Context cannot cross students, accounts, sessions, or protected assessment boundaries. |
| NAO-CTX-03 | Invalid optional context is dropped safely; protected-context violations are rejected. |
| NAO-TEL-01 | Every provider attempt can be recorded with correlation, provider/model, timing, token, validation, and outcome data. |
| NAO-TEL-02 | Telemetry failure does not block Nex responses and produces an observable gap. |
| NAO-TEL-03 | Pricing comes from one shared configuration source and identifies exact versus estimated usage. |
| NAO-CMP-01 | Nex is available globally without removing the dedicated `/nex` page. |
| NAO-CMP-02 | Lesson and practice triggers open the same companion with visible removable context. |
| NAO-CMP-03 | Desktop uses a side panel; mobile uses an accessible full-height sheet. |
| NAO-ADP-01 | Suggestions use deterministic struggle signals, cooldowns, and persisted preferences. |
| NAO-ADP-02 | Suggestions never insert unsolicited generated Nex messages or reveal protected answers. |
| NAO-OPS-01 | `/admin/nex-ops` is canonical; duplicate AI admin routes redirect to filtered Ops views. |
| NAO-OPS-02 | Overview, Reliability, Quality, and Cost share metric definitions and show freshness/partial failure. |
| NAO-OPS-03 | Review drill-down shows redacted conversation, workflow context, call chain, and validation evidence. |
| NAO-CAS-01 | Escalations create cases with severity, owner, SLA, state, audit history, and resolution category. |
| NAO-CAS-02 | Failed case/communications handoffs remain open and retryable. |
| NAO-CAS-03 | Student contact is human-authored, capability-checked, and audited. |

## 2. Planned file boundaries

### New focused units

| File | Responsibility |
|---|---|
| `src/lib/nex/workflowContext.ts` | Shared workflow-context types, constants, and client-safe builders. |
| `src/schemas/nexWorkflowContextSchemas.ts` | Zod request-boundary validation. |
| `src/server/services/nexWorkflowContextService.ts` | Ownership, curriculum, attempt, and protected-state reconstruction. |
| `src/server/services/nexModelTelemetryService.ts` | Best-effort append-only model-attempt writes. |
| `src/features/nex/components/NexCompanionProvider.tsx` | Global companion state and workflow-context lifecycle. |
| `src/features/nex/components/NexCompanionLauncher.tsx` | Launcher states and adaptive invitation entry. |
| `src/features/nex/components/NexCompanionPanel.tsx` | Responsive panel/sheet containing the existing chat panel. |
| `src/features/nex/components/NexWorkflowTrigger.tsx` | Reusable embedded action entry point. |
| `src/features/nex/lib/nexAdaptiveHelp.ts` | Pure struggle signal, cooldown, and suggestion decisions. |
| `src/server/services/nexAdaptiveHelpService.ts` | Preference persistence and server-side eligibility. |
| `src/server/services/adminNexOpsService.ts` | Canonical operational read model and partial-result contract. |
| `src/features/admin/components/NexOpsWorkspace.tsx` | Canonical Ops view navigation and shared filters. |
| `src/features/admin/components/NexConversationDrawer.tsx` | Redacted conversation and attempt-chain review. |
| `src/server/services/nexOpsCaseService.ts` | Case lifecycle, SLA, audit, and communication handoff. |
| `src/schemas/nexOpsCaseSchemas.ts` | Case mutation validation. |

Do not introduce general-purpose `helpers.ts`, a model router, another Nex context provider, or another admin cost service.

---

## Phase 1 — Context and telemetry foundation

**Verdict:** `PLANNED_PENDING_ORCHESTRATOR_AND_PLANNER_APPROVAL`  
**Criteria:** NAO-CTX-01, NAO-CTX-02, NAO-CTX-03, NAO-TEL-01, NAO-TEL-02, NAO-TEL-03

### Phase 1 allowlist

- `src/lib/nex/workflowContext.ts` (create)
- `src/schemas/nexWorkflowContextSchemas.ts` (create)
- `src/schemas/nexSchemas.ts`
- `src/lib/nex/types.ts`
- `src/lib/nex/assemblePrompt.ts`
- `src/lib/nex/callNexModel.ts`
- `src/lib/nex/geminiClient.ts`
- `src/lib/nex/openaiClient.ts`
- `src/lib/nex/generateNexResponse.ts`
- `src/server/services/nexWorkflowContextService.ts` (create)
- `src/server/services/nexModelTelemetryService.ts` (create)
- `src/server/services/nexOpsService.ts`
- `src/app/api/nex/chat/route.ts`
- `supabase/migrations/<timestamp>_nex_model_calls.sql` (create)
- `src/types/database.ts`
- `tests/nex/workflowContext.test.ts` (create)
- `tests/nex/nexModelTelemetryService.test.ts` (create)
- `tests/nex/callNexModel.test.ts`
- `tests/nex/nexChatStream.test.ts`
- `tests/nexOpsService.test.ts`
- `.env.example`

### Task 1: Define the workflow-context boundary

- [ ] **Step 1: Write failing schema and isolation tests**

Create `tests/nex/workflowContext.test.ts` covering valid lesson/practice contexts, unknown keys, invalid UUIDs, protected state, optional-context downgrade, and ownership mismatch.

```ts
it("rejects client-supplied protected answer material", () => {
  const result = nexWorkflowContextSchema.safeParse({
    version: 1,
    source: "practice",
    questionId: crypto.randomUUID(),
    answerKey: "B",
  });
  expect(result.success).toBe(false);
});
```

- [ ] **Step 2: Verify the test fails**

Run: `npx vitest run tests/nex/workflowContext.test.ts`  
Expected: FAIL because the schema/module does not exist.

- [ ] **Step 3: Implement the shared type and strict Zod schema**

Use this public shape; do not add raw prompt or answer fields:

```ts
export const NEX_WORKFLOW_SOURCES = [
  "global", "lesson", "practice", "revision", "exam_review", "results",
] as const;

export interface NexWorkflowContext {
  version: 1;
  source: (typeof NEX_WORKFLOW_SOURCES)[number];
  label: string;
  subjectId?: string;
  topicId?: string;
  subtopicId?: string;
  lessonId?: string;
  sessionId?: string;
  questionId?: string;
  attemptId?: string;
  misconceptionId?: string;
  allowedActions: Array<"explain" | "simplify" | "hint" | "review" | "similar_question">;
  protectedAssessment: boolean;
}
```

Make the Zod object strict and cap `label` at 120 characters.

- [ ] **Step 4: Extend `nexChatRequestSchema` with optional `workflowContext`**

The route input remains backward compatible. Infer the TypeScript request type from Zod.

- [ ] **Step 5: Implement server reconstruction**

`resolveNexWorkflowContext({ studentId, context })` must verify ownership and load authoritative labels/content. Return a discriminated result:

```ts
type ResolvedWorkflowContextResult =
  | { status: "none" }
  | { status: "resolved"; context: ResolvedNexWorkflowContext }
  | { status: "dropped"; reason: "not_found" | "stale" | "not_owned" }
  | { status: "rejected"; reason: "protected_assessment" };
```

- [ ] **Step 6: Run focused tests**

Run: `npx vitest run tests/nex/workflowContext.test.ts tests/nexSchemas.test.ts`  
Expected: PASS.

- [ ] **Step 7: Commit**

```powershell
git add src/lib/nex/workflowContext.ts src/schemas/nexWorkflowContextSchemas.ts src/schemas/nexSchemas.ts src/server/services/nexWorkflowContextService.ts tests/nex/workflowContext.test.ts tests/nexSchemas.test.ts
git commit -m "feat(nex): validate workflow context"
```

### Task 2: Add append-only provider-attempt telemetry

- [ ] **Step 1: Write the migration**

Create `nex_model_calls` with UUID primary key, correlation/session/message/student references, workflow source, provider, model, attempt number, outcome/reason codes, exact/estimated token fields, latency, streaming/validation fields, regeneration count, timestamps, indexes, and RLS. Students must not select this table; service-role writes and privileged admin reads happen server-side.

- [ ] **Step 2: Add a migration contract test**

Create a test in `tests/nex/nexModelTelemetryService.test.ts` that checks the insert payload never includes prompts, response content, credentials, or answer keys.

- [ ] **Step 3: Verify the test fails**

Run: `npx vitest run tests/nex/nexModelTelemetryService.test.ts`  
Expected: FAIL because the service does not exist.

- [ ] **Step 4: Implement best-effort telemetry**

```ts
export interface NexModelAttemptEvent {
  correlationId: string;
  sessionId: string | null;
  messageId: string | null;
  studentId: string;
  workflowSource: NexWorkflowContext["source"];
  provider: "gemini" | "openai" | "mock" | "cache";
  model: string;
  attemptNumber: number;
  outcome: "success" | "error" | "fallback" | "cache_hit";
  reasonCode: string | null;
  inputTokens: number | null;
  outputTokens: number | null;
  tokenSource: "provider" | "estimated" | "none";
  latencyMs: number;
  streamed: boolean;
  validationStatus: "pass" | "fail" | "ambiguous" | "not_run";
  regenerationCount: number;
}
```

`recordNexModelAttempt()` catches insert failures, reports them through the existing server observability path, and returns `{ recorded: false }` instead of throwing into tutoring.

- [ ] **Step 5: Thread correlation and attempt metadata through the existing pipeline**

Extend existing result types; do not create a parallel model client. Provider clients should return provider-reported usage when available. `callNexModel` owns attempt timing and fallback reason. `generateNexResponse` owns validation/regeneration outcome.

- [ ] **Step 6: Instrument the text-chat path**

Create a correlation ID at the chat request boundary and pass the validated workflow context through the existing text pipeline. Do not edit or instrument voice/camera in this phase; they remain owned by their existing V2 workstreams.

- [ ] **Step 7: Run focused tests**

Run: `npx vitest run tests/nex/nexModelTelemetryService.test.ts tests/nex/callNexModel.test.ts tests/nex/nexChatStream.test.ts`  
Expected: PASS with primary, fallback, cache, validation, and telemetry-failure cases.

- [ ] **Step 8: Commit**

```powershell
git add supabase/migrations src/lib/nex src/server/services/nexModelTelemetryService.ts src/app/api/nex tests/nex src/types/database.ts
git commit -m "feat(nex): record model attempt telemetry"
```

### Task 3: Make pricing and Ops aggregation canonical

- [ ] **Step 1: Add failing exact-versus-estimated pricing tests**

Extend `tests/nexOpsService.test.ts` to prove provider token counts win over estimates and all conversions use `getNexOpsPricingConfigFromPlatformSettings()`.

- [ ] **Step 2: Verify failure**

Run: `npx vitest run tests/nexOpsService.test.ts`  
Expected: FAIL against the message-scan implementation.

- [ ] **Step 3: Update `nexOpsService.ts` to aggregate `nex_model_calls`**

Keep estimation only for legacy rows and label the token source. Remove competing calculation responsibility from `adminNexOpsReadService.ts` in Phase 4, not now.

- [ ] **Step 4: Run Phase 1 checks**

```powershell
npx vitest run tests/nex/workflowContext.test.ts tests/nex/nexModelTelemetryService.test.ts tests/nexOpsService.test.ts tests/nex/callNexModel.test.ts tests/nex/nexChatStream.test.ts
npm run lint
npm run typecheck
npm run test:scope-check
npm run build
```

Expected: all exit 0; migration applies in the local Supabase reset when available.

- [ ] **Step 5: Write handoff artifacts and commit**

Write Phase 1 `CODER-CHANGELOG.md` and `QA-REPORT.md` with criterion evidence. Commit only after QA says PASS.

### Phase 1 out of scope

- Companion UI, embedded triggers, adaptive suggestions, admin redesign, cases, communications, prompt editing, provider changes, and all voice/camera changes.

---

## Phase 2 — Persistent companion, lesson, and practice access

**Verdict:** `LOCKED_PENDING_PHASE_1_QA`  
**Criteria:** NAO-CMP-01, NAO-CMP-02, NAO-CMP-03

### Phase 2 allowlist

- `src/components/student/StudentAppShell.tsx`
- `src/app/(student)/layout.tsx`
- `src/app/(student)/nex/page.tsx`
- `src/features/nex/components/NexCompanionProvider.tsx` (create)
- `src/features/nex/components/NexCompanionLauncher.tsx` (create)
- `src/features/nex/components/NexCompanionPanel.tsx` (create)
- `src/features/nex/components/NexWorkflowTrigger.tsx` (create)
- `src/features/nex/components/NexChatPanel.tsx`
- `src/features/nex/components/NexTutorContext.tsx`
- `src/app/(student)/learn/[topicId]/[lessonId]/page.tsx`
- relevant lesson client component discovered by tracing that page
- `src/features/practice/components/PracticeRunner.tsx`
- `src/features/practice/components/PracticeResults.tsx`
- `tests/nex/NexCompanionProvider.test.tsx` (create)
- `tests/nex/NexCompanionPanel.test.tsx` (create)
- `tests/learn/nexLessonTrigger.test.tsx` (create)
- `tests/practice/nexPracticeTrigger.test.tsx` (create)
- `e2e/nex-companion.spec.ts` (create)

### Task 4: Build one companion state owner

- [ ] Write failing tests for open/close, context attach/remove, suggestion state, dedicated-page compatibility, escape/focus return, and mobile/desktop presentation.
- [ ] Run `npx vitest run tests/nex/NexCompanionProvider.test.tsx tests/nex/NexCompanionPanel.test.tsx`; expect FAIL.
- [ ] Implement provider API:

```ts
interface NexCompanionController {
  isOpen: boolean;
  context: NexWorkflowContext | null;
  open(input?: { context?: NexWorkflowContext; suggestedMessage?: string }): void;
  close(): void;
  clearContext(): void;
}
```

- [ ] Mount the provider inside `StudentAppShell`; render the launcher only for authenticated, diagnostic-complete students.
- [ ] Render the existing `NexChatPanel` inside the companion. Extract shared props if necessary; do not fork chat state or transport.
- [ ] Keep `/nex` as the focused presentation of the same chat implementation.
- [ ] Run focused tests; expect PASS.
- [ ] Commit: `feat(nex): add persistent companion shell`.

### Task 5: Add lesson and practice workflow triggers

- [ ] Trace the server page to its interactive lesson component before editing; amend the allowlist with the exact existing file.
- [ ] Write failing tests for visible labels, allowlisted actions, correct IDs, protected fields absent, and “return to workflow”.
- [ ] Add lesson actions: explain, simplify, example, check understanding.
- [ ] Add practice actions: clarify, progressive hint, explain incorrect attempt, similar question.
- [ ] Send workflow context and a short suggested student message through the companion controller; do not send hidden solution material.
- [ ] Run focused tests and `npx playwright test e2e/nex-companion.spec.ts --project=chromium`; expect PASS at 375px and desktop.
- [ ] Commit: `feat(nex): embed companion in learning workflows`.

### Phase 2 global gates

Run lint, typecheck, focused tests, `npm test`, scope check, build, and the companion e2e. QA must verify keyboard focus, screen-reader labels, ≥48px touch targets, and that the active workflow does not remount when the panel opens.

### Phase 2 out of scope

- Adaptive prompts, revision/results triggers, admin Ops, cases, and changes to tutor pedagogy.

---

## Phase 3 — Revision/results integration and bounded adaptive help

**Verdict:** `LOCKED_PENDING_PHASE_2_QA`  
**Criteria:** NAO-ADP-01, NAO-ADP-02, plus NAO-CMP-02 for revision/results.

### Phase 3 allowlist

- `src/features/nex/lib/nexAdaptiveHelp.ts` (create)
- `src/server/services/nexAdaptiveHelpService.ts` (create)
- `src/features/nex/components/NexCompanionLauncher.tsx`
- `src/features/revision/components/KcseMathRevisionHub.tsx`
- `src/features/practice/components/PracticeResults.tsx`
- `src/app/(student)/practice-papers/attempts/[attemptId]/results/page.tsx`
- `src/app/(student)/practice-papers/[id]/attempt/page.tsx`
- `src/features/practice-papers/components/PracticePaperAttemptSimulator.tsx`
- `src/schemas/profileSchemas.ts` or a dedicated preference schema approved by Planner
- `supabase/migrations/<timestamp>_nex_companion_preferences.sql` (create)
- `tests/nex/nexAdaptiveHelp.test.ts` (create)
- `tests/revision/nexRevisionTrigger.test.tsx` (create)
- `tests/practice/nexResultsTrigger.test.tsx` (create)
- `e2e/nex-adaptive-help.spec.ts` (create)

### Task 6: Implement deterministic suggestion decisions

- [ ] Write table-driven failing tests for repeated incorrect attempts, known misconception recurrence, inactivity after engagement, cooldown, `show fewer`, and protected-state denial.
- [ ] Implement a pure function:

```ts
export function decideNexHelpSuggestion(input: {
  consecutiveIncorrect: number;
  recurringMisconception: boolean;
  inactiveMs: number;
  hasMeaningfulEngagement: boolean;
  protectedAssessment: boolean;
  dismissedUntil: string | null;
  frequency: "normal" | "reduced" | "off";
  now: string;
}): { show: false } | { show: true; reason: "repeated_errors" | "misconception" | "inactivity" };
```

- [ ] Put initial thresholds in one named configuration object and test boundary values.
- [ ] Persist preference and cooldown with RLS ownership; no service-role client access.
- [ ] Render `Help me`, `Not now`, and `Show fewer suggestions`; only `Help me` opens the companion.
- [ ] Run focused tests and commit: `feat(nex): add bounded adaptive help`.

### Task 7: Integrate revision and completed-results surfaces

- [ ] Write failing trigger and protected-state tests.
- [ ] Add revision actions and completed-results recovery actions.
- [ ] On active protected practice-paper attempts, suppress answer-revealing actions. Do not introduce assessment-mode chat or AI mock exam behavior.
- [ ] Run e2e for help suppression during attempts and help availability after results.
- [ ] Commit: `feat(nex): add revision and results context`.

### Phase 3 out of scope

- Autonomous path changes, unsolicited assistant messages, automatic question answering, and new exam generation.

---

## Phase 4 — Canonical Agent Ops workspace

**Verdict:** `LOCKED_PENDING_PHASE_3_QA`  
**Criteria:** NAO-OPS-01, NAO-OPS-02, NAO-OPS-03

### Phase 4 allowlist

- `src/server/services/adminNexOpsService.ts` (create)
- `src/server/services/adminNexOpsReadService.ts` (remove after callers migrate)
- `src/server/services/nexOpsService.ts`
- `src/server/services/adminNexReviewService.ts`
- `src/app/(super-admin)/admin/nex-ops/page.tsx`
- `src/app/(super-admin)/admin/ai-quality/page.tsx`
- `src/app/(super-admin)/admin/usage-stats/page.tsx`
- `src/features/admin/components/AdminNav.tsx`
- `src/features/admin/components/NexOpsWorkspace.tsx` (create)
- `src/features/admin/components/NexConversationDrawer.tsx` (create)
- existing Nex review panels, consolidated or removed after caller migration
- `src/app/api/admin/nex-ops/route.ts`
- `src/app/api/admin/nex-ops/flags/route.ts`
- `src/app/api/admin/nex-ops/flags/[id]/route.ts`
- `src/schemas/adminSchemas.ts`
- `tests/admin/adminNexOpsService.test.ts` (create)
- `tests/admin/NexOpsWorkspace.test.tsx` (create)
- `tests/admin/nexConversationRedaction.test.ts` (create)
- `e2e/admin-nex-ops.spec.ts` (create)

### Task 8: Build a partial-result canonical read model

- [ ] Write failing tests proving equal metrics across views, explicit freshness, exact/estimated distinction, redaction, and partial-query failure.
- [ ] Implement section results as `{ status: "ok", data, refreshedAt } | { status: "unavailable", reason, lastSuccessfulAt }`.
- [ ] Aggregate from `nex_model_calls`, sessions, messages, flags, and platform pricing through one service.
- [ ] Delete competing hardcoded pricing and message-scan logic only after all callers use the canonical service.
- [ ] Run tests and commit: `refactor(admin): unify Nex Ops data`.

### Task 9: Build the canonical workspace and redirects

- [ ] Read Next.js redirect/navigation docs from `node_modules/next/dist/docs/`.
- [ ] Write failing UI and route tests for tabs, filters, URL persistence, duplicate-route redirects, unavailable states, and role restrictions.
- [ ] Implement Overview, Reliability, Quality, and Cost views.
- [ ] Implement the redacted conversation drawer with context, call chain, validation, latency, feedback, and audit link.
- [ ] Redirect `/admin/ai-quality` to `/admin/nex-ops?view=quality` and `/admin/usage-stats` to `/admin/nex-ops?view=cost`; keep one sidebar item named `Nex Ops`.
- [ ] Run e2e and commit: `feat(admin): consolidate Nex operations`.

### Phase 4 out of scope

- Case lifecycle, student communications, raw prompt display/editing, model switching, and automatic remediation.

---

## Phase 5 — Owned cases, human communications, and hardening

**Verdict:** `LOCKED_PENDING_PHASE_4_QA`  
**Criteria:** NAO-CAS-01, NAO-CAS-02, NAO-CAS-03

### Phase 5 allowlist

- `supabase/migrations/<timestamp>_nex_ops_cases.sql` (create)
- `src/schemas/nexOpsCaseSchemas.ts` (create)
- `src/server/services/nexOpsCaseService.ts` (create)
- `src/server/services/adminAuditService.ts`
- `src/server/services/adminCommunicationsService.ts`
- `src/server/services/superAdminGuard.ts`
- `src/app/api/admin/nex-ops/cases/route.ts` (create)
- `src/app/api/admin/nex-ops/cases/[id]/route.ts` (create)
- `src/app/api/admin/nex-ops/cases/[id]/communications/route.ts` (create)
- `src/features/admin/components/NexOpsWorkspace.tsx`
- `src/features/admin/components/NexOpsCasePanel.tsx` (create)
- `src/app/(super-admin)/admin/nex-ops/page.tsx`
- `tests/admin/nexOpsCaseService.test.ts` (create)
- `tests/admin/nexOpsCaseRoutes.test.ts` (create)
- `tests/admin/nexOpsCasePermissions.test.ts` (create)
- `e2e/admin-nex-cases.spec.ts` (create)

### Task 10: Implement the audited case lifecycle

- [ ] Write failing transition, SLA, resolution-category, assignment, RLS, and idempotency tests.
- [ ] Create tables for cases and append-only case events. Use enums/check constraints for status, severity, and resolution categories.
- [ ] Implement allowed transitions; reject resolution without a category.
- [ ] Calculate due time from one severity/SLA configuration source.
- [ ] Audit create, view-unredacted, assign, change status, add note, resolve, close, and reopen events.
- [ ] Run tests and commit: `feat(admin): add Nex Ops cases`.

### Task 11: Add human-reviewed communications handoff

- [ ] Write failing tests proving drafts exclude raw prompts, credentials, internal notes, and unrelated student data.
- [ ] Require the existing communications capability and same-origin/CSRF protections used by current admin mutation routes.
- [ ] Create a communication draft linked to the case; do not send automatically.
- [ ] Record handoff outcome. On failure, keep the case open and expose a retry action.
- [ ] Run tests and commit: `feat(admin): hand off Nex cases to support`.

### Task 12: Final end-to-end verification

- [ ] Run all focused tests from Phases 1–5.
- [ ] Run `npm run lint`, `npm run typecheck`, `npm test`, `npm run test:scope-check`, and `npm run build`.
- [ ] Run Playwright for companion, adaptive help, Ops, and cases at desktop and 375px.
- [ ] Verify a real trace: lesson trigger → chat request → provider attempts → persisted response → Ops drill-down → case → communications draft.
- [ ] Verify negative traces: cross-student context, active protected attempt, telemetry outage, partial Ops query outage, unauthorized unredacted access, and failed communications handoff.
- [ ] Write final QA criteria matrix and update architecture/database/API docs to reflect only shipped behavior.
- [ ] Commit: `docs: complete Nex companion and Ops rollout`.

## 3. Cursor kickoff prompt

Paste this into Cursor from the repository root:

```text
You are the Coder in the Nexus Agent Orchestra. Prepare to execute only Phase 1 of:
docs/superpowers/plans/2026-07-11-nex-companion-agent-ops.md

Required read order:
1. AGENTS.md
2. .planning/agents/CODER.md
3. .planning/agents/HANDOFF-PROTOCOL.md
4. docs/superpowers/specs/2026-07-10-nex-agent-ops-design.md
5. docs/superpowers/plans/2026-07-11-nex-companion-agent-ops.md
6. docs/product-governance/mvp-feature-scope-lock.md
7. docs/phase-2-product-systems/nex-socratic-tutor-engine.md
8. docs/phase-2-product-systems/nex-prompting-framework.md
9. docs/phase-1-foundation/technical-architecture.md
10. docs/phase-1-foundation/api-standards.md
11. docs/phase-5-engineering-governance/coding-agent-rules.md

Before editing, confirm `.planning/milestones/nex-agent-ops/PHASE-PLAN.md` exists and says `APPROVED_TO_BUILD` for Phase 1. If it does not, stop and run the Planner approval prompt below. Do not code from this plan alone.

After approval, read the relevant Next.js 16 documentation in node_modules/next/dist/docs/ and inspect every existing file in the Phase 1 allowlist.

Rules:
- Phase 1 only. Do not begin companion UI or admin redesign.
- Touch only the Phase 1 allowlist. If another file is required, stop and request a Planner amendment.
- Use TDD: failing test, minimal implementation, passing test, then commit.
- Preserve the existing Nex pipeline, Socratic behavior, provider order, and limits.
- Do not touch voice or camera in Phase 1; they are owned by separate V2 workstreams.
- Do not put prompt or response content in nex_model_calls.
- Telemetry failure must not block tutoring.
- Do not hardcode pricing or exchange rates.
- Do not modify or delete unrelated working-tree files.

Deliverables:
1. Phase 1 code and migration.
2. Focused tests and command evidence.
3. .planning/milestones/nex-agent-ops/phases/phase-1/CODER-CHANGELOG.md using the handoff protocol.
4. Stop after coding and ask QA to run the phase gates. Do not self-unlock Phase 2.

Start by reporting:
- the exact Phase 1 files you found,
- any missing/renamed allowlist paths,
- the tests you will add first,
- whether the current scope lock conflicts with live code.
Then execute Phase 1.
```

## 4. Planner and QA prompts

### Planner approval prompt

```text
Act as Planner. Review Phase 1 of docs/superpowers/plans/2026-07-11-nex-companion-agent-ops.md against the approved design, scope lock, coding rules, and current repository. Confirm or amend its allowlist and criteria. Only Phase 1 may be APPROVED_TO_BUILD. Write the decision to .planning/milestones/nex-agent-ops/PHASE-PLAN.md using the handoff header.
```

### QA prompt

```text
Act as QA for Nex Agent Ops Phase 1. Read the approved Phase 1 plan and CODER-CHANGELOG.md. Inspect the diff for allowlist violations and regressions. Run every focused Phase 1 test, then lint, typecheck, full test suite, scope check, and build. Verify telemetry failure cannot block tutoring and no prompt/response content is stored in nex_model_calls. Write .planning/milestones/nex-agent-ops/phases/phase-1/QA-REPORT.md with a criterion matrix and PASS or FAIL. Do not unlock Phase 2.
```
