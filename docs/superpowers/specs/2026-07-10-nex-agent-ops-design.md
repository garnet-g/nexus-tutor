# Nex Companion and Agent Ops Design

**Date:** 2026-07-10  
**Status:** Approved design, pending written-spec review  
**Product priority:** Student experience first, supported by accountable internal operations

## 1. Objective

Optimize how Nex functions, is accessed, is used, and communicates across Nexus. Nex becomes a persistent, workflow-aware learning companion backed by one canonical internal Agent Ops control plane.

The design preserves the existing Nex tutor engine and improves the boundaries around it: context acquisition, student access, bounded intervention, telemetry, quality review, escalation, and support communication.

## 2. Current-state problems

### Student experience

- Nex is primarily perceived as a destination instead of a companion within learning.
- Lessons, practice, revision, and results do not share a single explicit workflow-context contract with Nex.
- Students must translate the learning context into chat themselves or leave the active workflow.
- Help is mostly reactive and does not use deterministic struggle signals to offer timely support.
- Context attachment and removal are not visible enough for students to understand what Nex knows.

### Internal operations

- AI operations are fragmented across `/admin/ai-quality`, `/admin/usage-stats`, and `/admin/nex-ops`.
- Cost and usage services use different estimation and pricing logic, so equivalent metrics can disagree.
- Current reporting is descriptive rather than operational: it lacks reliable latency, error, fallback, validation, quota, and workflow-context telemetry.
- Flag escalation is a status change rather than an owned case with severity, assignee, SLA, resolution, and communications handoff.
- Silent read failures can appear as zero activity rather than unavailable data.
- Conversation access, redaction, and role capabilities are insufficiently explicit.

## 3. Product decisions

1. The scope is end to end, but implementation is divided into independently releasable phases.
2. Student experience is the leading priority.
3. Nex is globally accessible through the student shell and embedded inside learning workflows.
4. Nex is student-triggered by default. It may offer help after deterministic struggle signals, but does not autonomously interrupt with generated messages.
5. Escalated AI issues create owned internal cases. Human operators author any student-facing follow-up in the first release.
6. Existing tutor behavior, validation, limits, memory, provider fallback, and persistence remain authoritative unless a phase explicitly changes them.

## 4. Architecture

### 4.1 Shared workflow context

Introduce a versioned `NexWorkflowContext` contract shared by student workflow surfaces and Nex request handlers. It contains only validated identifiers and bounded presentation context:

- context version;
- source workflow: global, lesson, practice, revision, exam-review, or results;
- subject, topic, subtopic, lesson, session, question, and attempt identifiers where applicable;
- a human-readable context label;
- misconception or struggle signal identifiers;
- allowed Nex actions for the current workflow;
- protected-assessment state;
- correlation ID.

The server reconstructs authoritative curriculum and attempt data from identifiers. It must not trust client-supplied answer keys, marks, protected content, student identity, or prompt text.

Invalid or stale optional context is dropped without preventing general Nex access. Protected-assessment violations are rejected rather than downgraded.

### 4.2 Companion presentation

A single companion shell owns the global Nex launcher and panel state.

- Desktop and tablet: a side panel that preserves the active learning surface.
- Mobile: a full-height sheet with an explicit return to the workflow.
- Dedicated `/nex` page: retained for focused, long-form sessions and backward-compatible links.
- Embedded triggers: invoke the same companion with a workflow context and suggested action.

The launcher exposes three states: available, context attached, and help suggested. It must not display an unread badge for a suggestion the student has already dismissed.

### 4.3 Existing tutor engine

The companion calls the current Nex request pipeline. Authentication, plan limits, burst controls, prompt assembly, curriculum grounding, memory, Socratic behavior, provider selection, validation, fallback, persistence, and streaming remain server-owned.

Workflow context is an additional validated input to prompt assembly, not an alternate prompt pipeline.

### 4.4 Operational telemetry

Add an append-only model-call record for every provider attempt, including failed attempts. Each record includes:

- correlation, session, message, student, and workflow references;
- provider and model identifier;
- attempt order and outcome;
- fallback or failure reason code;
- input and output token counts when supplied by the provider;
- clearly marked estimates only when exact counts are unavailable;
- latency and streaming outcome;
- validation result and regeneration count;
- timestamps.

Pricing is read from one server-side configuration source. Dashboard services must not hardcode competing exchange rates or provider prices.

### 4.5 Canonical Agent Ops control plane

`/admin/nex-ops` is the canonical route. Existing AI Quality and Usage Stats routes redirect to the corresponding Nex Ops view while preserving safe query filters.

The workspace contains:

- **Overview:** health, usage, cost, latency, fallback, quota pressure, cases, and freshness.
- **Reliability:** provider/model attempts, errors, timeouts, fallbacks, streaming failures, and validation outcomes.
- **Quality:** flags, sampled conversations, validator failures, misconceptions, and curriculum/workflow filters.
- **Cases:** severity, ownership, SLA, conversation context, notes, communications handoff, and resolution.
- **Cost:** exact versus estimated usage, configured pricing, trends, successful-interaction cost, and workflow breakdown.

All views consume one shared operational read layer so identical metrics have identical definitions.

## 5. Student interaction design

### 5.1 Workflow actions

- **Lessons:** explain selected content, simplify a concept, provide an example, or check understanding.
- **Practice:** clarify wording, give a progressive hint, explain an incorrect attempt, or generate a similar question.
- **Revision:** diagnose weak concepts, explain completed work, and recommend a next revision activity.
- **Protected exams:** no answer revelation, hidden-solution access, or context that bypasses assessment rules. Nex help is limited or disabled according to the assessment state.
- **Results:** connect errors to concepts and launch targeted recovery practice.
- **Global Nex:** ask a general curriculum-grounded question or intentionally resume a prior workflow conversation.

### 5.2 Communication model

Nex communicates in short, progressive turns:

1. establish what the student understands;
2. provide the smallest useful prompt or hint;
3. ask the student to reason or attempt;
4. expand only when needed;
5. summarize the recovered concept and next action.

The panel displays its attached context, for example `Using: Quadratic equations · Question 4`, and allows the student to remove optional context. Removing it affects subsequent messages, not the audit record of prior messages.

### 5.3 Adaptive help suggestions

Adaptive suggestions are generated from deterministic application signals, initially:

- repeated incorrect attempts on the same question or concept;
- recurrence of an already-recorded misconception;
- inactivity within an active learning task after meaningful engagement.

The exact thresholds are configurable and covered by tests. A suggestion offers `Help me`, `Not now`, and `Show fewer suggestions`. It does not insert a generated assistant message or change the learning path without student action.

Dismissal preferences are persisted per student. The system applies cooldowns to prevent repeated suggestions for the same context.

### 5.4 Conversation continuity

Workflow conversations retain their originating context. Global Nex may resume them only after an explicit student action. Context cannot cross accounts, students, or unrelated protected assessment sessions.

## 6. Agent Ops workflow

### 6.1 Review

A reviewer can inspect a redacted full conversation with:

- workflow and curriculum context;
- provider attempt chain and model identifiers;
- token use and latency;
- validation and regeneration results;
- flag source and reason taxonomy;
- student feedback;
- related cases and audit history.

The interface defaults to redaction. Access to unredacted content requires a defined capability and is audited.

### 6.2 Case lifecycle

An escalation creates a case with:

- status: open, investigating, waiting, resolved, or closed;
- severity: low, medium, high, or critical;
- assignee and optional team;
- due time derived from severity;
- structured reason and resolution category;
- internal notes and audit history;
- linked conversation, student, workflow, and operational incident where applicable;
- communications handoff state.

Cases cannot be marked resolved without a resolution category. Failed handoffs remain visible and retryable.

### 6.3 Human communication

Support may create a student communication from a case through the existing communications system. The draft includes safe case context but never raw hidden prompts, provider credentials, internal notes, or other students' information.

A human reviews and sends the message. Nex does not automatically apologize, correct a prior answer, or contact a student in the first release.

### 6.4 Roles and privacy

- Support and admin roles receive only the review and case capabilities required for their duties.
- Cost configuration, model configuration, and unredacted access are super-admin capabilities.
- Every conversation view, redaction override, case mutation, assignment, and communication handoff is audited.
- Parent access to Nex conversations is out of scope.

## 7. Data flow

1. A learning surface builds a client-safe workflow-context envelope.
2. The server authenticates the student and validates identifiers, ownership, workflow state, and allowed actions.
3. The route creates or resumes a Nex session and stores the student message.
4. Prompt assembly loads authoritative curriculum, memory, recent messages, and validated workflow context.
5. Each provider attempt emits an append-only model-call record with the shared correlation ID.
6. Validation accepts, regenerates, or safely rejects the response within a fixed retry budget.
7. The final Nex message is persisted before or alongside delivery and references the call chain.
8. Usage limits and study activity are updated through existing server services.
9. Agent Ops reads canonical aggregates and case data through one shared service boundary.

## 8. Failure handling

- **Invalid optional context:** continue without it and notify the student that the attachment could not be used.
- **Protected-context violation:** reject the action with a safe assessment-specific explanation.
- **Primary provider failure:** use the existing fallback policy and record a structured reason.
- **Validation exhaustion:** return a safe recovery response and create observable quality telemetry.
- **Streaming interruption:** recover from persisted output when available and allow an explicit retry otherwise.
- **Telemetry write failure:** tutoring continues; the failure is logged and the Ops UI reports an observability gap.
- **Partial dashboard failure:** successful panels remain visible; failed panels show unavailable state, cause class, and last successful refresh.
- **Case or communications failure:** preserve the open case and expose a retryable failed step.

No error path may present unavailable data as a valid zero.

## 9. Delivery phases

### Phase 1: Context and telemetry foundation

- Define and validate `NexWorkflowContext`.
- Add model-call telemetry and a single pricing/configuration source.
- Instrument chat, voice, and camera paths without changing student UX.
- Establish canonical metric definitions and privacy capabilities.

### Phase 2: Persistent companion and initial integrations

- Add the global companion shell.
- Retain the dedicated Nex route.
- Integrate lesson and practice triggers.
- Display and remove attached context.

### Phase 3: Adaptive learning integration

- Integrate revision and results.
- Enforce protected-assessment behavior.
- Add deterministic struggle suggestions, cooldowns, and preferences.

### Phase 4: Canonical Agent Ops

- Build Overview, Reliability, Quality, and Cost views on the canonical read layer.
- Add full conversation drill-down and explicit freshness/error states.
- Redirect duplicate admin destinations and simplify navigation.

### Phase 5: Owned cases and communication handoff

- Add case lifecycle, severity, assignment, SLA, notes, resolution, and audit behavior.
- Connect cases to support communications.
- Complete role, redaction, accessibility, and rollout hardening.

Each phase requires Planner approval and a file allowlist before coding. A phase may be divided further if its acceptance criteria cannot be verified in one safe change set.

## 10. Verification

### Focused coverage

- workflow-context schema validation and server reconstruction;
- account, student, session, and protected-assessment isolation;
- prompt assembly with and without optional context;
- chat, voice, and camera regression;
- provider attempt and fallback telemetry;
- exact-versus-estimated token and pricing calculations;
- streaming recovery and validation retry limits;
- adaptive signal thresholds, cooldowns, dismissals, and preferences;
- lesson, practice, revision, results, and global entry points;
- mobile sheet and desktop panel accessibility;
- role capability and redaction enforcement;
- metric consistency, freshness, zero-versus-unavailable behavior;
- case state transitions, assignment, SLA, audit, resolution, and handoff retry.

### Required gates per phase

- focused unit and integration tests;
- `npm run lint`;
- `npm run typecheck`;
- `npm test`;
- `npm run test:scope-check`;
- `npm run build`;
- relevant browser/e2e checks for changed student or admin workflows.

## 11. Success criteria

- Students can open Nex globally and from every named learning workflow without losing their place.
- Nex visibly uses validated workflow context and never leaks protected assessment content.
- Adaptive suggestions occur only from configured struggle signals and respect dismissals and cooldowns.
- Existing chat, voice, camera, memory, validation, fallback, and limit behavior remains functional.
- Admin users have one canonical Agent Ops destination.
- Reliability, quality, cost, and workflow metrics share one definition and expose freshness and failure states.
- Every provider attempt is traceable through a correlation ID.
- Every escalation has ownership, severity, a due time, an audit history, and a structured resolution.
- Student-facing incident communication is human-reviewed and auditable.

## 12. Explicit exclusions

- autonomous learning-path changes;
- unsolicited generated Nex messages;
- automatic student apologies or corrections;
- raw prompt editing from Agent Ops;
- live model switching from Agent Ops;
- parent access to conversation logs;
- new AI providers;
- replacing the current Nex tutor pipeline.
