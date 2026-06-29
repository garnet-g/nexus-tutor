# Nexus zero-deferral production remediation — Cursor master prompt

Paste everything below into Cursor from the repository root.

---

You are the parent Orchestrator for the complete Nexus production-remediation program.

Your job is not to write a review and stop. Use actual Cursor subagents to plan, implement, independently verify, repair, and prove every required correction. Continue through the complete program until Nexus satisfies the final release gate or a genuine external-authority blocker makes honest completion impossible.

## 1. Mission and non-negotiable outcome

Make the checked-out Nexus application genuinely production-ready across security, payments, external providers, authorization, data integrity, all exposed user journeys, all accessible named features, administration, content, privacy, observability, performance, accessibility, tests, deployment, and operational recovery.

`nexus-map.md` is the current-state foundation and coverage manifest. Every P0, P1, P2, Partial feature, Shell feature, coverage gap, journey gap, and operational gap in it must have exactly one remediation-ledger row with an owner phase, acceptance criteria, tests, and final evidence. No confirmed map-gap row may end as `DEFERRED`, `BACKLOG`, `ACCEPTED_RISK`, `ASSUMED`, or `UNKNOWN`.

This is a zero-deferral remediation program:

- Do not leave a mapped problem for a later milestone, launch exception, post-launch list, or unspecified future phase.
- Do not close a gap by changing its label or documentation while the exposed product still makes the same promise.
- Complete every accessible named feature to the capability its UI promises. Removal is permitted only after the user explicitly chooses that product-scope change; hiding a broken feature is not the default solution.
- Do not add placeholders, no-op controls, fake health, mock production success, dead links, hardcoded success states, or tests that merely reproduce the implementation.
- Do not declare success from compilation alone. Every result needs behavior-level evidence.
- Do not silently weaken requirements to make gates pass.

“Nothing left for later” does not authorize fabricated evidence, secret creation, production deployment, payment initiation, real-message delivery, irreversible data operations, or remote database mutation. If real credentials, provider access, licensing, legal policy, or infrastructure are required, ask for that authority immediately and keep the release verdict `NOT_READY` until the real path is verified. Do not turn the blocker into a backlog item or waive it.

## 2. Source-of-truth and conflict rules

Read these in order before dispatching implementation work:

1. `AGENTS.md`
2. `nexus-map.md` in full
3. This prompt in full
4. `.planning/agents/ORCHESTRATOR.md`
5. `.planning/agents/HANDOFF-PROTOCOL.md`
6. `.planning/agents/ARCHITECT.md`
7. `.planning/agents/PLANNER.md`
8. `.planning/agents/CODER.md`
9. `.planning/agents/QA.md`
10. `.planning/milestones/v2-tier-1/STATUS.md`
11. Current code, migrations, tests, package scripts, CI, and deployment configuration
12. Relevant local Next.js 16.2.9 guides under `node_modules/next/dist/docs/`

The existing `PLAN.md`, `docs/PRODUCTION_READINESS_MODULE_AUDIT.md`, V1 scope lock, screen inventory, user-flow documents, and older milestone artifacts are inputs, not unquestioned truth. Revalidate every claim against current code and `nexus-map.md`. Do not implement stale findings such as the already-completed middleware-to-Proxy migration.

This prompt intentionally overrides these stale or incomplete playbook rules for this program:

- The old V1 scope lock does not override live V2 routes and the current map.
- A phase may be narrowly allowlisted, but the complete program may not omit an item as “out of scope.”
- The two-cycle QA rule triggers re-architecture and re-planning; it never permits abandonment.
- Architect and Planner are read-only for product code but may create/update only their assigned planning artifacts.
- Coder must read the approved phase, relevant map sections, decision register, current target files, and relevant local framework guides—not only one isolated plan section.
- `PHASE_2_5_CODE_COMPLETE` means unverified until the deferred terminal checks are executed and recorded.
- Old Next.js 15, 13-screen, math-only, and “banned live feature” statements must be corrected to current verified truth.
- Old release exceptions, Docker deferrals, and post-launch lists do not govern this remediation.

When documents conflict, record the conflict and its evidence in `DECISION-REGISTER.md`, select the outcome supported by current code, security, explicit product intent, and this prompt, then update the stale document in the phase that resolves it.

## 3. Protect the current checkout

Before any edit, capture and put in `STATUS.md`:

```powershell
git branch --show-current
git status --short
git diff --stat
git diff
git diff --staged --stat
git diff --staged
git log -10 --oneline
```

Preserve the current dirty worktree. At final prompt verification, branch `feat/kcse-math-f4-b2` contained untracked `.claude/settings.local.json`, `nexus-map.md`, and this prompt. Earlier during the audit, staged `tests/content/kcseMathSeedContent.test.ts` and untracked `.gen_f4_b2.mjs` were also present, then disappeared after new F4 B2 commits landed. Treat both observations as concurrency evidence, not as current truth: re-check status/log/diffs and do not assume ownership or unchanged files when Cursor starts.

Never reset, stash, discard, overwrite, delete, reformat wholesale, or claim ownership of pre-existing work. Do not edit `.claude/settings.local.json` unless an approved phase explicitly proves it is required. If remediation overlaps concurrent F4 B2 work, inspect the intent and diff first, record ownership, and amend the exact allowlist before editing. Never fabricate the missing content migration merely to satisfy a test; reconcile it with the current branch and intended content source.

Do not create a new branch, commit, push, deploy, apply linked migrations, send real messages, trigger real payments, or mutate production data unless the user explicitly authorizes that action. Local code, tests, new migration files, fixtures, dry runs, and documentation are authorized.

## 4. Required Cursor subagent orchestra

The parent Cursor agent is the Orchestrator. Use actual subagents for the four repository roles. Do not impersonate all four roles in one response.

### Architect subagent

Read `.planning/agents/ARCHITECT.md`. Inspect code and write only `ARCHITECT-BRIEF.md`, architecture revisions, and architecture-specific decision evidence. It must:

- trace every affected journey as page → component/caller → route handler or Server Action → service → provider/schema → table/function/RLS;
- identify trust boundaries, invariants, concurrency requirements, failure states, rollback/forward-fix strategy, and observability;
- read and cite exact relevant local Next.js guides;
- identify migration ordering and compatibility constraints;
- resolve architectural ambiguity with evidence rather than guesses.

### Planner subagent

Read `.planning/agents/PLANNER.md`. Write only `PHASE-PLAN.md`, the remediation ledger, status planning sections, and plan revisions. It must:

- plan all phases before code starts;
- make each approved phase dependency-ready and independently testable;
- provide an exact file allowlist—never broad globs such as `src/**`, `tests/**`, or `supabase/migrations/**`;
- map every acceptance criterion to a test and evidence destination;
- include RED steps, implementation order, migration order, recovery, and full gates;
- issue `APPROVED_TO_BUILD` only when the phase contains no unresolved assumption.

### Coder subagent

Read `.planning/agents/CODER.md`. Edit only the current approved allowlist and its `CODER-CHANGELOG.md`. It must:

- follow TDD for behavior changes;
- record failing RED evidence before implementation when a meaningful failing test is possible;
- make the minimum complete production implementation, not a stub;
- add migrations only through the approved migration workflow;
- update `nexus-map.md` in the same phase when mapped truth changes;
- stop and request a versioned plan amendment if another file is needed.

### QA subagent

Read `.planning/agents/QA.md`. Independently inspect the diff and run the tests itself. It must:

- map every criterion to direct evidence;
- run focused, regression, adversarial, security, role-boundary, RLS, concurrency, accessibility, and browser checks appropriate to the phase;
- inspect actual UI and failure/recovery states when the phase affects a journey;
- rescan the relevant `nexus-map.md` sections for missed gaps;
- write a truthful `QA-REPORT.md` with exact commands, exit codes, counts, and failures.

Use parallel subagents only for genuinely independent read-only investigations. Never let parallel Coders edit overlapping files, migrations, shared types, or the map concurrently.

Maximum two Coder → QA failure cycles per plan revision. Reaching two failures does not permit deferral. Dispatch Architect and Planner to find the root cause, version the architecture and plan, amend the allowlist, and resume with a fresh two-cycle window. Continue until PASS or a genuine external blocker is reported to the user.

Pass artifacts between agents. Do not rely on chat memory or unrecorded conclusions.

## 5. Required program artifacts

Create this new milestone without deleting or rewriting the active Tier 1 history:

```text
.planning/milestones/production-readiness/
  STATUS.md
  ARCHITECT-BRIEF.md
  PHASE-PLAN.md
  REMEDIATION-LEDGER.md
  DECISION-REGISTER.md
  RELEASE-EVIDENCE.md
  FINAL-SIGNOFF.md
  phases/
    phase-00/
      CODER-CHANGELOG.md
      QA-REPORT.md
    phase-01/
      CODER-CHANGELOG.md
      QA-REPORT.md
    phase-02/ through phase-12/, each containing:
      CODER-CHANGELOG.md
      QA-REPORT.md
```

Follow `.planning/agents/HANDOFF-PROTOCOL.md` YAML headers and status markers. The program artifacts are durable handoffs, not narrative summaries.

`REMEDIATION-LEDGER.md` must contain one and only one row for every mapped finding and every new gap discovered during execution. Give each a stable ID. Required columns:

| ID | Source/map anchor | Severity | Role/journey | Current break | Required outcome | Owner phase | Exact acceptance tests | Status | Evidence link |
|---|---|---|---|---|---|---|---|---|---|

Confirmed current-map gaps have one allowed terminal status: `VERIFIED_COMPLETE`. Active nonterminal statuses may be `DISCOVERED`, `PLANNED`, `IN_PROGRESS`, `IN_QA`, or `EXTERNAL_BLOCKER`. A historical-audit claim or newly discovered candidate that current evidence disproves may end as `VERIFIED_NOT_REPRODUCIBLE`; an obsolete historical requirement may end as `SUPERSEDED_WITH_EVIDENCE`. Those two statuses require exact inspected files/tests and may not be used to waive a current `nexus-map.md` gap—the map itself must first be corrected with the same evidence. No duplicate rows and no unowned rows. An `EXTERNAL_BLOCKER` prevents final production readiness and must state the missing authority, responsible party, exact verification command/journey, and what can be completed locally in the meantime.

Artifact ownership is explicit:

- Orchestrator owns `STATUS.md`, coordinates entries in `DECISION-REGISTER.md`, and assembles `RELEASE-EVIDENCE.md` without self-certifying it.
- Architect owns `ARCHITECT-BRIEF.md` and architecture decision proposals.
- Planner owns `PHASE-PLAN.md` and `REMEDIATION-LEDGER.md`.
- Coder owns only the current phase’s `CODER-CHANGELOG.md` plus approved product files.
- QA owns every `QA-REPORT.md` and `FINAL-SIGNOFF.md`; QA independently validates or rejects Orchestrator evidence.
- The agent that discovers a decision writes its evidence/options proposal; Orchestrator records it only after the proper technical or user authority resolves it.

`DECISION-REGISTER.md` must record every material choice with:

- stable decision ID and date;
- question and affected ledger IDs;
- evidence inspected;
- viable options and tradeoffs;
- selected outcome and why;
- authority: code-derived, security constraint, provider contract, legal/product decision, or explicit user decision;
- implementation and verification consequences.

Ask the user only when inspection cannot resolve a choice that changes business policy, legal/provider obligations, irreversible data behavior, or visible product scope. Ask immediately—not at the end of a phase. Do not ask the user to answer a repo-discoverable technical question.

Every phase artifact must include:

- affected roles and journeys;
- full request/data trace;
- ledger IDs closed by the phase;
- exact file allowlist;
- explicit exclusions only for work owned by another named phase—not exclusions from the program;
- RED tests and baseline evidence;
- measurable acceptance criteria;
- security, privacy, billing, provider, and accessibility impacts;
- migrations, data backfill, rollback/forward-fix, and compatibility;
- focused and full verification commands;
- observability and failure recovery;
- map and documentation updates;
- QA gap rescan.

## 6. Rules for implementation and evidence

### No assumptions

Before approving a phase, inspect the current files, callers, schemas, migrations, policies, tests, configuration, and runtime behavior involved. Replace phrases such as “probably,” “should,” “appears,” or “assume” with evidence. If uncertainty remains, create an investigation task inside the current phase and resolve it before `APPROVED_TO_BUILD`.

### TDD

For every behavior change:

1. Add or identify the regression/adversarial test.
2. Run it and record RED output.
3. Implement the complete fix.
4. Run focused tests and record GREEN output.
5. Run phase regression gates.

If a useful test cannot fail first—for example, a documentation-only correction—record why and add a characterization, static assertion, smoke check, or evidence review appropriate to the change.

### Next.js 16.2.9

Before writing Next.js-specific code, read the relevant local guides under `node_modules/next/dist/docs/`. At minimum, the architecture phase must locate and record the installed guides for route handlers, Proxy, authentication/data security, CSP, environment variables, headers, metadata/OG images, production checklist, Playwright, and Vitest. Follow the installed version, not model memory or an older web article.

### Supabase and Postgres

For every Supabase phase:

- inspect the installed CLI with `npx supabase --help` and command-specific `--help`;
- consult current official Supabase documentation when behavior is provider/version dependent;
- create each migration with `npx supabase migration new <descriptive_name>`;
- never edit an applied migration;
- test migrations from a local reset before linked checks;
- keep RLS enabled and add positive and negative policy tests;
- never expose the service role or place privileged `SECURITY DEFINER` functions in an exposed schema;
- pin `search_path`, minimize grants, validate caller identity/role inside privileged functions, and test hostile inputs;
- use constraints/locks/atomic statements for invariants, not client-side check-then-write;
- do not push/apply remote migrations without explicit authorization.

### Security and privacy

- Treat callbacks, cron routes, exports, admin mutations, AI endpoints, uploads, parent links, billing, and service-role reads as hostile trust boundaries.
- Fail closed for production configuration and privileged audit requirements.
- Use constant-time secret comparison where a shared secret is part of a provider-supported design.
- Never log secrets, full tokens, raw payment credentials, or unnecessary PII. Redact provider evidence.
- Define retention, deletion, subject-access, and log-redaction behavior for email, phone, message bodies, uploads, Nex conversations, payment metadata, and view-as activity.
- Do not invent webhook-signature support. Verify official provider capabilities, then design compensating proof/reconciliation when signatures are unavailable.

### User experience

For each journey, verify loading, empty, success, validation, provider-down, unauthorized, expired-session, retry, idempotent-resubmit, mobile, keyboard, and screen-reader behavior as relevant. A database row appearing is not proof that a named user capability works.

### Map maintenance

Update `nexus-map.md` in the same phase whenever a route, role, journey, integration, table, maturity label, test count, or release finding changes. Never erase historical findings without replacing them with a verified resolution and evidence link in the ledger.

### Minimum ledger seed catalog

The Phase 00 rescan may add rows, but it may not produce fewer rows by collapsing independently verifiable failures. At minimum, create individually traceable ledger coverage for:

- P0.1 forged M-Pesa callback activation;
- P0.2 missing M-Pesa configuration granting paid access;
- P0.3 silent AI, camera, voice, SMS, and email mock success;
- P1.1 standalone typecheck/CI and F4 B2 migration-test mismatch;
- P1.2 support access to service-role-backed Usage Stats data;
- P1.3 race-prone Nex/practice quotas and family seats;
- P1.4 `undici`/PostCSS dependency advisories;
- P1.5 missing browser security headers and public SEO/discovery configuration;
- P1.6 admin roles, rollouts, and entitlement debug output disconnected from runtime;
- P1.7 fail-open/unchecked privileged audit writes;
- P1.8 every overstated student feature: Offline, Focus, Concept Library, Mistakes, Saved, parent-visible Weekly Goal, Study Search, Readiness, and Learning Memory;
- P1.9 incorrect content `PROD_READY` threshold;
- P1.10 misleading System Health;
- P1.11 process-local/public and missing AI/payment/admin burst limiting;
- P1.12 conflicting scope, route, framework-version, screen, and governance documentation;
- transactional/recoverable signup, beta invite, profile, and OAuth policy;
- callback uniqueness/idempotency, replay, expiry, query/reconciliation, and polling;
- notification retention, privacy, preferences, delivery truth, retry, dead-letter, and callback trust;
- parent unlink/revoke, settings, shared-goal display, and family lifecycle;
- duplicate student aggregates, session/profile reads, indexes, query/latency instrumentation, and budgets;
- executable approvals, bulk actions, reports, communications, experiments, saved views, content calendar, and payment operations;
- public/admin/provider error states and user recovery;
- admin bootstrap, last-admin/demotion, session revocation, and break-glass runbooks;
- real E2E coverage for parent, admin, Authoring Studio, all student utilities, billing, and multimodal Nex;
- executed RLS, migration, concurrency, performance, accessibility, security-header, and real-provider staging proof;
- broken support login/post-auth redirect;
- missing cookie-mutation CSRF/origin enforcement;
- missing centralized request-body limits;
- non-atomic trial, free-subscription, subscription activation, and family-owner setup;
- payment amount/phone/merchant validation and receipt uniqueness;
- obsolete/unverified client Sentry integration, source maps, alerting, and health telemetry;
- cron error-detail leakage and missing stable client error codes;
- completed Focus sessions being cancellable;
- raw internal metadata/preferences presentation in Nex Memory;
- private-response cache leakage risk, logout/offline cache purge, and account-switch isolation;
- content licensing/product wording around mock exams versus official past papers;
- retention/deletion/access policy for all identified PII and learning records;
- every other Partial, Shell, coverage gap, test gap, trust boundary, and operational gap found by re-reading every section of `nexus-map.md`.

Do not use the catalog as a substitute for reading the map. Catalog entries absent from the map are mandatory discovery candidates, not permission to assert a bug without reproducing it. If one listed line contains multiple independently failing paths or distinct acceptance tests, split it into separate rows. The reconciliation report must state the count of map anchors, known catalog entries, newly discovered entries, ledger rows, duplicates, and missing owners.

## 7. Complete phase plan

Plan every phase now, but approve and implement only one dependency-ready phase at a time. Execute the phases in dependency order. If discovery proves a dependency wrong, version the plan and record the reason; do not lose or omit any ledger row.

### Phase 00 — Ground truth, ledger, and authority reset

Objective: establish a lossless, current program baseline before code changes.

Required work:

- Capture the dirty-worktree evidence and ownership described above.
- Re-enumerate every page route, API route, Server Action, role guard, service-role call, database table/function/policy, migration, external provider, script, CI step, unit/integration test, and Playwright spec.
- Re-run safe baseline commands and record exact current results; do not reuse the map’s recorded counts as fresh evidence.
- Reconcile all `nexus-map.md` P0/P1/P2 items, every Partial/Shell surface, section 11 coverage gaps, journey gaps, and operational gaps into the remediation ledger.
- Reconcile older audit/plan findings, marking stale items as superseded only with code evidence.
- Create all program artifacts, the full dependency graph, and an exact plan for Phases 01–12.
- Record the installed Next.js guide paths and current migration history.
- Treat the current Phase 2.5 as unverified until its tests pass.

Acceptance:

- Every map finding has exactly one ledger ID and owner phase.
- Every accessible route and named feature is either already operational with evidence or assigned a completion row.
- There are zero unowned, duplicate, assumed, or silently dropped findings.
- No product code is changed in this phase.

### Phase 01 — Green baseline and deterministic release harness

Objective: make the repository’s ordinary quality gates reliable before layering further remediation.

Required work:

- Resolve the ES2017/dotAll standalone typecheck failure correctly; do not casually raise the compilation target without checking browser/deployment compatibility.
- Reconcile the F4 B2 test and missing migration with the branch’s real intended content work without overwriting pre-existing edits.
- Complete Tier 1 Phase 2.5 batch verification and fix regressions.
- Eliminate current lint warnings/errors and flaky/non-deterministic tests.
- Safely resolve `undici` and PostCSS advisory chains without forced Next.js downgrade; add direct/resolution updates only when compatibility and tests prove safety.
- Expand `deploy:check` or create one deterministic release command that includes lint, standalone typecheck, tests, scope check, build, dependency audit, migration/static security checks, and the appropriate E2E preconditions.
- Make `test:e2e:ci` self-contained: it must build, start the production server, wait for a deterministic readiness signal, run Playwright against that server, preserve failure artifacts, and always terminate the server it owns. It must not depend on the caller remembering `CI=true`.
- Make CI enforce the same commands rather than relying on a passing Next build to hide standalone failures.

Acceptance:

- Clean installs produce deterministic gates.
- `npm run lint`, `npm run typecheck`, `npm test`, `npm run test:scope-check`, and `npm run build` all pass from current source.
- `npm audit --audit-level=moderate` has no unreviewed high/moderate issue; dependency resolution is documented and regression-tested.
- No pre-existing user work is lost or falsely attributed.

### Phase 02 — Production environment policy and provider truth

Objective: make misconfiguration loud and make mock success impossible outside explicit local/test modes.

Required work:

- Build one typed, server-only environment schema/policy covering Supabase public/server keys, public URL, Gemini/OpenAI text, vision/OCR, speech, M-Pesa, Celcom, Resend, cron secrets, Sentry, and feature-enablement dependencies.
- Define explicit `APP_ENV=test|development|staging|production` behavior. Do not infer deployment safety or mock permission from `NODE_ENV` or a missing key. Use explicit provider modes for Nex, payments, and notifications; production requires live modes, while staging requires real AI/notifications and Daraja sandbox or live verification—never mock success.
- Require a canonical absolute `APP_ORIGIN` and HTTPS in production. Require high-entropy secrets for HMAC rate-limit keys and protected callback channels without printing their values.
- Make production/staging startup or deployment validation fail when an enabled capability lacks complete credentials/configuration.
- Make Gemini/OpenAI, camera, voice, Celcom, Resend, and M-Pesa return an explicit unavailable/configuration error in production rather than a mock result or success record.
- Keep deterministic mocks injectable only through test/local adapters with unmistakable metadata and tests proving production cannot select them.
- Replace misleading `/admin/health` summaries with configuration truth and safe timeout-bounded probes for enabled providers, database, migrations, cron freshness, queues/outbox, and latency. A probe must distinguish configured, reachable, degraded, and not verified; it must not send a chargeable request unless explicitly authorized.
- Add redacted structured diagnostics and deployment documentation.
- Add a standalone `env:check` script used by CI/release checks and call the same validation during server instrumentation before accepting traffic.
- Make ordinary CI explicitly run with `APP_ENV=test` and explicit mock-provider modes. Add separate strict staging/production configuration-validation tests using fixture values so no real secret is required or exposed.

Acceptance:

- A test matrix proves every missing/partial production provider configuration fails closed.
- No production code path records a mock provider operation as delivered, paid, transcribed, analyzed, or answered.
- Health never converts absence of activity into “healthy” and never exposes secrets.
- Valid local/test mocks still work only through explicit mode/injection.
- Environment validation output names only missing/invalid variables and never exposes values.

### Phase 03 — Payment trust, callbacks, and reconciliation

Objective: make subscription activation depend on independently verified money, not user-supplied callback data.

Required work:

- Trace the complete pricing → STK push → provider callback/query → payment transition → subscription/family entitlement → notification journey.
- Verify current official Safaricom Daraja callback and transaction-query capabilities. Cite the primary contract used. Do not invent a signature header.
- Replace callback trust with the strongest provider-supported design. If Daraja does not sign callbacks, use a high-entropy per-payment callback capability/opaque correlation plus server-side transaction-status reconciliation, strict merchant/paybill/account/amount/phone matching, and no trust in the student-visible checkout request ID alone.
- Implement and use Daraja STK Query (or the current official equivalent) as independent payment proof before entitlement activation. A callback may trigger verification; it may not itself be payment proof.
- Never activate from caller-supplied result code, receipt text, or checkout ID without independent provider verification.
- Make transitions atomic and monotonic: initiated → provider-pending → verified-paid or verified-failed/expired. Prevent paid → failed rollback and duplicate activation.
- Add database uniqueness for provider transaction/receipt identifiers and atomic callback-event idempotency; remove check-then-insert races.
- Validate expected plan, amount, account/reference, merchant, currency, initiator, and ownership before activation.
- Make missing credentials fail closed. Delete any production path where `isMock` marks a payment paid.
- Add durable payment attempt limits and abuse controls by authenticated account, phone hash, IP/network signal, and time window with safe privacy handling.
- Add reconciliation jobs/operator actions for lost callbacks, pending expiry, replay, provider mismatch, and disputed/ambiguous results.
- Add a student-owned payment-status polling endpoint, duplicate-pending suppression, and expiry processing so timeout/reload has a recoverable path without exposing another student’s payment.
- Add an audited webhook-event ledger, replay tooling with idempotency, alerting, and a payment incident/reconciliation runbook.
- Apply the same verified-secret/idempotency/replay discipline to Celcom delivery callbacks if they remain exposed.

Adversarial acceptance tests must prove:

- A student can initiate checkout but cannot forge success using the returned checkout ID.
- Unknown, malformed, wrong-token, wrong-amount, wrong-account, wrong-merchant, duplicate, stale, reordered, and replayed callbacks cannot grant or corrupt entitlement.
- Two simultaneous valid deliveries activate once and emit side effects once.
- Twenty simultaneous copies of a verified result still produce one payment transition, subscription, transaction, invoice, billing event, and notification intent.
- Missing/invalid production credentials never create paid state.
- Provider timeout/outage leaves a recoverable pending state with accurate UI.
- Reconciliation can safely converge missed callback state without bypassing proof.

No real charge or production callback test may run without explicit authorization. Real staging/sandbox provider evidence is still mandatory before final readiness.

### Phase 04 — Authentication, authorization, and account consistency

Objective: prove every role boundary and make account creation/recovery coherent.

Required work:

- Add an explicit guard to `/admin/usage-stats` before any service-role data read and audit every page, route, Server Action, cron route, export, and service-role call for equivalent render-path bypasses.
- Build a route/action role matrix for visitor, student, incomplete student, parent, support, content author, and super admin. Test direct HTTP access and server-render access, not navigation visibility only.
- Ensure support never receives super-admin-only Nex message bodies, provider cost/configuration, entitlement mutation, roles, audit-sensitive data, or view-as capabilities unless explicitly intended and documented.
- Make email signup, profile creation, beta invite validation/consumption, onboarding state, and retry/recovery transactional or compensating/idempotent. No orphaned Auth user or consumed invite may strand a user.
- Make Google OAuth independently obey current beta/invite policy and safely resume onboarding after callback/retry.
- Fix support password/OAuth session loading and post-login routing: current session-role handling must recognize support and direct it to the authorized admin surface rather than returning “Unable to load your account.”
- Verify logout, expired session, deleted/disabled account, incomplete profile, diagnostic gate, parent redirect, and admin redirect behavior.
- Add session-revocation behavior for privilege/account changes and tests for stale JWT/app-metadata claims.

Acceptance:

- Executable role-matrix tests cover every protected page/API/action from the map.
- Negative tests prove render paths cannot bypass API guards.
- Signup/OAuth retry and concurrent invite consumption converge without duplicate profiles, lost invites, or bypass.
- All unauthorized responses avoid sensitive existence/data leakage and provide correct user recovery.

### Phase 05 — Atomic database operations and durable rate limiting

Objective: enforce quotas, seats, invites, callbacks, and abuse controls inside the authoritative datastore.

Required work:

- Replace Nex and practice read-then-update/insert usage counters with atomic Postgres functions/statements and uniqueness constraints.
- Make family membership and seat-count updates one transaction with locking/constrained insert; derive or reconcile denormalized counts safely.
- Make invite consumption and other single-use tokens atomic and idempotent.
- Make trial creation, free-subscription creation, family owner group/member setup, and subscription activation atomic or compensating so every multi-row entitlement transition commits completely or leaves no partial access state.
- Complete callback idempotency migrations not already owned by Phase 03.
- Replace teacher-waitlist in-memory `Map` throttling with a distributed durable limiter and expiration/cleanup.
- Add appropriate durable burst/abuse limits for public forms, auth-sensitive actions, AI/camera/voice, payment, export, and privileged admin mutations. Daily product quotas do not replace burst controls.
- Key limiter records with an HMAC of the minimum identifier/action instead of raw IP/email, set expiration/cleanup, and return truthful `Retry-After`/limit headers.
- Add centralized request-body size enforcement before parsing for public forms, webhooks, uploads, AI, and admin mutations.
- Add explicit same-origin enforcement to every cookie-authenticated POST/PUT/PATCH/DELETE Route Handler by comparing `Origin` with canonical `APP_ORIGIN`. Do not trust arbitrary `Host`/forwarded-host values. Only verified provider callbacks and secret-protected cron routes may use documented server-to-server exceptions. Preserve Next.js Server Action origin protection.
- Prevent privileged database helpers from being callable by untrusted roles; pin `search_path`, validate actor identity, and minimize grants.

Acceptance:

- Reset-database concurrency tests demonstrate exact limit/seat/single-use invariants under parallel requests.
- Executed RLS tests prove cross-user, cross-family, cross-role, and anonymous isolation.
- Limits work consistently across simulated server instances and reset windows.
- No client-side pre-check is the final authority for an invariant.
- Cross-origin mutation with a valid session cookie is rejected without changing data, while same-origin requests and independently authenticated callbacks/cron paths still work.

### Phase 06 — Real admin authorization, rollout control, and durable audit

Objective: ensure the control plane changes runtime truth safely and records privileged effects durably.

Required work:

- Make `/admin/roles` update authoritative Supabase Auth metadata and its ledger coherently. Handle partial failure, retry, session/JWT freshness, and audit.
- Before implementation, trace every current reader/writer of `app_metadata.userRole`, any role arrays, profile roles, and `admin_role_assignments`. Architect must select and document one backward-compatible canonical runtime claim model; Planner may not assume a new metadata shape. Centralize one permission evaluator used by Proxy, page guards, APIs, Server Actions, and navigation; migrate old claims safely and detect metadata/ledger drift as a critical health failure.
- Add last-super-admin, self-demotion, bootstrap, duplicate-role, disabled-user, session-revocation, and break-glass protections.
- Make rollout definitions server-enforced for their named routes/features/actions and reflected consistently in navigation and direct access. Define deterministic targeting, defaults, precedence, and emergency-off behavior.
- Use a typed feature registry with explicit defaults—never implicit `true`. Rollout precedence is a user-visible product decision: Architect must inventory current targeting semantics and viable orders, and Orchestrator must obtain explicit product authority before Phase 06 approval. Record the selected deterministic order and test every precedence pair; do not install a guessed order.
- Replace hardcoded `featureEnabled: true` entitlement output with the same evaluated server decision the product uses.
- Classify privileged mutations by audit criticality. Critical mutations must write their durable audit event in the same transaction or durable outbox before returning success; noncritical failures must be visible/retriable, never swallowed.
- Add actor, subject, reason, before/after summary, request correlation, timestamp, outcome, and redaction policy without storing secrets.
- Fix the immediate Supabase error-handling bug: audit insertion must check returned `{ error }`, not only catch thrown exceptions.
- Prove support and super-admin permissions separately for every control.

Acceptance:

- Role changes alter actual runtime access after controlled session refresh/revocation, not merely a table row.
- Support can authenticate and is redirected to `/admin`, but can access only its tested permission set.
- Rollout-off blocks direct route/action/API access as well as hiding navigation; rollout-on enables only the intended cohort.
- Critical action cannot report success without durable audit evidence.
- Last-admin and self-lockout adversarial tests pass.

### Phase 07 — Complete every student utility

Objective: turn every accessible student utility into the capability its name and UI promise.

#### Study Search

- Implement indexed, curriculum-aware search over published/eligible lessons, topics/concepts, and student-safe question text.
- Scope to grade/subject/visibility/rollout and never expose drafts, answer keys, marking internals, private Nex data, or another user’s records.
- Add ranking, debounced query, empty/error/loading states, keyboard/mobile behavior, deep links, and safe highlighting.
- Keep personal shortcuts/history as a distinct section, not as a substitute for content search.

#### Saved

- Connect lesson bookmarks, relevant practice/mock question save actions, and existing quick notes to one server-backed saved-item model and UI.
- Make save/unsave idempotent and user-scoped. Resolve or migrate local-only state rather than leaving two truths.
- Preserve a usable source link/context when content versions change or become unavailable.

#### Mistake Journal

- Automatically and idempotently upsert eligible wrong practice and mock answers with subject/topic/question/session/provenance.
- Support review, corrected/mastered state, reattempt/deep link, and repeated-mistake aggregation without duplicates.
- Replace disconnected local queue/state with authoritative server behavior and define content-deletion/version handling.

#### Weekly Goal controls and learning memory

- Keep the student’s visibility control truthful, persisted, and clearly explained. Phase 08 exclusively owns parent rendering, RLS/service enforcement, report behavior, and parent privacy tests for the goal.
- Make Learning Memory wording accurately describe its projection. Provide truthful provenance/last-updated information and safe reset/clear controls if the UI promises memory management.

#### Focus Sessions

- Implement a real persisted timer with server timestamps, reload/resume, pause/cancel/complete semantics, background-tab behavior, maximum bounds, and server-validated elapsed credit.
- Do not award planned time from a manual completion click. Add accessible controls and deterministic time tests.

#### Offline Packs

- Implement real installable web/offline infrastructure: manifest, service worker strategy, versioned per-user artifact manifest, eligible lesson/reference payloads, cache/IndexedDB storage, integrity/hash checking, progress, quota/error handling, expiry, refresh, deletion, and logout/account-switch purge.
- Never cache tokens, privileged responses, answer keys beyond policy, another user’s data, or sensitive Nex/payment/admin content.
- Verify a selected pack can be opened and used with the network disabled, then reconciles safely after reconnection.
- This phase owns the offline pack artifact manifest and service worker/cache behavior. Phase 11 owns only the public Web App Manifest/metadata and regression-checks offline behavior; it must not create a second implementation owner.

#### Concept Library

- Implement a real published concept/reference library with grade/subject/topic/category organization, formulas/explanations/examples as appropriate, search/filter, deep links, empty states, and content-source/version metadata.
- Prefer deriving formulas, definitions, worked examples, and key points from reviewed published lesson blocks with source links. Do not fabricate reference content to fill an empty category.
- Provide a controlled Authoring Studio/admin lifecycle with draft/review/publish/retire and visibility/RLS rules; four static links to `/learn` do not satisfy this feature.
- This phase owns Concept Library implementation and its authoring lifecycle. Phase 10 only verifies it in the global content-coverage/product-truth gate and must not duplicate its implementation ledger row.

#### Readiness

- Replace bare/static simulator links with session-aware generate/resume/start actions, accurate eligibility, loading/error recovery, and the correct exam/mock destination.

Acceptance:

- Every utility has component/integration tests, negative authorization tests, and Playwright coverage of its primary and failure journey.
- Offline has an actual browser-offline test, Focus has time/race tests, Search has visibility/leakage tests, and Saved/Mistakes prove insertion from real learning flows.
- The map may label these Operational only after QA verifies the advertised behavior.

### Phase 08 — Parent, family, notifications, and privacy lifecycle

Objective: complete the family journey and make communications reliable, consensual, and recoverable.

Required work:

- Add parent unlink/revoke with confirmation, authorization, impact messaging, session/access revocation, history, and safe relink behavior.
- Add parent profile/settings and notification preferences for channel/event/frequency with verified contact handling and unsubscribe/opt-out behavior where required.
- Show `parent_visible` weekly goals only for correctly linked students.
- Phase 08 exclusively owns parent-visible Weekly Goal rendering, cross-family privacy, report behavior, and revocation effects; Phase 07 owns only the student control.
- Complete family seat/member lifecycle for join, invite, expiry, removal, subscription loss, resubscription, owner change if supported, and atomic count reconciliation.
- Define durable notification state: queued, sending, delivered/accepted, failed, retryable, exhausted, suppressed, and provider callback status. Never equate mock/queued/provider-accepted with human delivery.
- Add bounded retry/backoff, idempotency, duplicate suppression, dead-letter/operator recovery, and observability for weekly reports and transactional notices.
- Implement documented retention, redaction, export/access, and deletion behavior for contact data, message bodies, report payloads, uploads, Nex data, payment data, and view-as evidence.
- Reconcile the implementation with the repository’s existing 90-day notification-log retention requirement; if legal/product policy requires a different period, obtain and record that authority rather than silently changing it.
- Verify cron authentication, timezone/week boundaries, duplicate execution, provider outage, and partial batch recovery.

Acceptance:

- Parent access disappears immediately and durably after unlink/revoke.
- Preference and privacy tests prove suppressed events never send.
- Weekly goal privacy, cross-family isolation, family-seat concurrency, duplicate cron, and retry tests pass.
- Provider staging evidence proves real SMS/email status behavior before final readiness.

### Phase 09 — Complete admin operational workflows

Objective: make every admin page an honest, executable control surface with recovery.

Required work:

- Reports: generate real authorized CSV/download outputs for every exposed report link with stable schemas, escaping/formula-injection protection, streaming/size limits, audit, and empty/error states.
- Communications: implement template lifecycle plus authorized audience preview/count, consent/preference filtering, scheduling or immediate send, idempotency, approval where required, progress, failure/retry, cancellation, provider status, and audit. If the page does not promise campaigns, rename and narrow it only with explicit product approval.
- Experiments: define lifecycle, deterministic assignment, server-side exposure, conflict/rollout precedence, metrics, stop/rollback, and no personally unsafe targeting. A stored experiment row alone is insufficient.
- Persist stable experiment assignments, deduplicate exposure, record typed conversion events, and show sample size/conversion by variant. Experiment targeting must never bypass a disabled rollout, entitlement, role, grade, or content-visibility boundary.
- Bulk Actions: implement a typed allowlisted command registry for every advertised action, validation/preview, exact affected count, approval, idempotent execution, partial-failure recovery, status, audit, and safe replay. Never execute arbitrary action names or client-supplied queries.
- Saved Views: make saved filters/search/sort state actually reapply to the target page, with ownership and invalid-schema recovery.
- Admin Search: provide authorized useful search over its claimed entities with pagination, safe result snippets, and role filtering.
- Content Calendar: provide a real date/review/publish workflow matching its wording or explicitly correct the wording with product approval.
- System Health: use Phase 02’s real probes, freshness, queues, migration truth, latency, provider state, and links to recovery—not activity proxies.
- Phase 02 exclusively owns provider/environment probe primitives and health semantics. Phase 09 owns the authorized admin presentation, operational actions, and recovery links that consume those probes; keep separate ledger IDs and do not reimplement the probe layer.
- Payments/subscriptions: add audited reconciliation, cancellation/expiry/renewal/refund-dispute representation as supported by the actual business/provider contract; do not invent unsupported money movement.
- Approvals: ensure approval changes a typed executable state and cannot be bypassed by calling the executor directly.
- High-risk bulk/campaign work requires four-eyes separation: the requester cannot approve or execute their own request. Cap batch size, persist item-level outcomes, and retry only failed items idempotently.

Acceptance:

- No admin control reports an effect that runtime did not perform.
- Every mutation has authorization, validation, idempotency, audit, progress/outcome, and failure recovery.
- Support and super-admin matrices are independently tested.
- CSV formula-injection, over-broad audience, stale approval, duplicate execution, and partial failure adversarial tests pass.

### Phase 10 — Content coverage and product truth

Objective: align production labels, active subjects, exam language, and governance with verified content/data reality.

Required work:

- Correct `isTopicPracticeReady()` and `getTopicReadinessLabel()` so `PROD_READY` means the documented production coverage target, not the five-question session-start threshold. Keep “can start” separate from “production ready.”
- Use one production-readiness definition throughout code and Studio: every required subtopic has a published lesson and each topic has at least 21 published questions—7 easy, 7 medium, and 7 hard. A selected band with 5 questions is only session-startable.
- Reconcile F4 B2 migration/test/generator work with source provenance and the current branch; verify no accidental omission, duplicate, malformed content, or user change loss.
- Build an executable coverage matrix from current database/content source for every enabled grade, subject, topic, lesson, practice difficulty, diagnostic, mock, concept-library, and offline dependency.
- Enforce content gates at publish/rollout time so an under-covered topic cannot be advertised as production-ready.
- Verify Authoring Studio draft/review/approve/publish/retire/version behavior, content sanitizer, assets, math rendering, and audit.
- Treat Concept Library here as a coverage/regression consumer of the Phase 07 implementation, not a second implementation owner.
- Use accurate exam language. If content is generated mock practice rather than licensed official past papers, remove every misleading “past paper” claim while preserving the real mock-exam journey. Do not create or scrape a true past-paper archive without explicit licensing/product authority.
- Reconcile pricing, trial, plan limits, subject availability, and rollout copy with server configuration and actual entitlements.
- Update stale Next 15, 13-screen, math-only, V1-banned-feature, route inventory, architecture, deployment, and user-flow documents to link to the map and reflect verified current behavior.

Acceptance:

- Automated coverage checks fail on every under-target state while separately identifying startable content.
- All enabled subjects/grades have verified data coverage or remain server-enforced unavailable without a false UI claim.
- Product wording never implies official/licensed material without evidence.
- The complete route/role/content documentation agrees with the fresh repository scan.

### Phase 11 — Browser security, discovery, resilience, performance, and accessibility

Objective: harden the browser/public surface and prove acceptable behavior under realistic constraints.

Required work:

- Add and verify an environment-aware CSP compatible with Next.js, Supabase, Sentry, fonts/assets/media, camera, microphone, and required providers without unsafe broad wildcards. Use nonce/hash strategy where required by the installed Next.js guide.
- Add frame protection, `X-Content-Type-Options`, Referrer Policy, Permissions Policy, HSTS only in valid HTTPS production context, and other justified headers. Verify they appear on intended routes and do not break Nex multimodal flows.
- Add robots, sitemap, canonical metadata, Open Graph/Twitter assets, manifest, icons, and accurate route metadata for public discovery. Keep authenticated/admin/private routes out of indexing.
- Install and configure Lighthouse CI in this phase, check in a deterministic configuration, and wire `npx lhci autorun` into the release harness. Do not require an unavailable command before this phase supplies it.
- Add route-specific error boundaries/recovery for public, student, parent, and admin journeys, including provider/timeouts, chunk/navigation failures, unauthorized/expired sessions, and retry safety.
- Wire client and server observability using the installed Next.js 16 convention, including `instrumentation-client.ts`, server instrumentation, global error capture, release/environment tags, redaction, and non-public source maps. Do not assume legacy Sentry config filenames are loaded.
- Remove duplicate student-shell/page aggregate requests and N+1/service-role query patterns; add server timing/query/latency instrumentation and budgets.
- Request-cache the session/profile lookup, give utility routes narrow loaders rather than the full multi-source student aggregate, and prove query/index improvements with timing and `EXPLAIN ANALYZE` where applicable.
- Use reproducible performance profiles and evidence. At minimum: Lighthouse mobile with a checked-in simulated Slow 3G profile (400 ms RTT, 500 Kbps down/up, 4× CPU slowdown); public Lighthouse performance ≥90 and accessibility/best-practices/SEO ≥95; LCP ≤2.5 s, CLS ≤0.1, and TBT ≤200 ms in that lab run; authenticated dashboard server response p95 ≤800 ms in staging; no more than one session/profile lookup per request; and no route bundle regression over 20 KB gzip without explicit product/architecture authority. If the environment cannot measure one threshold reliably, resolve the replacement metric in `DECISION-REGISTER.md` before Phase 11 approval, not after testing.
- Complete keyboard navigation, focus management, labels, live status, contrast, reduced motion, touch targets, zoom/reflow, semantic headings, chart/table alternatives, and screen-reader journeys. Use Windows Narrator with Microsoft Edge for the named manual screen-reader gate unless QA records another installed screen-reader/browser pair before Phase 11 approval.
- Verify upload/media constraints, image optimization, caching/privacy headers, and no user-specific cache leakage.

Acceptance:

- Automated header assertions and browser smoke tests pass with no critical CSP violations.
- Public metadata/robots/sitemap are correct; private routes are not indexable.
- Accessibility automation plus manual keyboard/screen-reader checks cover every primary role journey and every new utility/control.
- Accessibility evidence includes route, role, viewport, browser, assistive technology/version, test steps, result, axe JSON, and Playwright trace/screenshot where relevant.
- Performance evidence includes the checked-in device/network profile, Lighthouse JSON/HTML, deployed/staging commit and environment, sample count, p50/p95 server timing, query counts, bundle report, and threshold comparison; all numeric budgets above pass.
- A deliberate client render error and server error appear in staging observability with redacted payloads and resolved stack traces; provider/cron/payment/audit failures drive actionable health/alerts.

### Phase 12 — Full-system release proof and operational readiness

Objective: independently prove the whole map, provider paths, recovery, and release state from a clean baseline.

Required work:

- Extend Playwright to cover every journey in `nexus-map.md`: visitor conversion, email signup/login, OAuth policy, onboarding/diagnostic, daily dashboard, learn, practice, Nex text/camera/voice, mocks/readiness, plans/tasks/progress/revision, all student utilities, pricing/payment, profile/family, parent, support, super-admin, and Authoring Studio.
- Add API/security tests for every protected route and callback, executed RLS tests against a reset database, concurrency/load tests for invariants, and provider failure/recovery tests.
- Run real authorized staging/sandbox checks for Supabase, Gemini/OpenAI as enabled, Daraja, Celcom, Resend, Sentry, cron, camera/OCR, and speech. Store redacted timestamps, environment, correlation IDs, outcome, and screenshots/log evidence. Test fallback paths deliberately; mock evidence is invalid.
- Verify migration history locally and, only with authorization, against linked Supabase. Dry-run before any remote apply.
- Complete and safely dry-run runbooks for provider outage, AI fallback/outage, payment reconciliation, webhook replay, stuck notification, cron failure, admin lockout/break-glass, compromised credential rotation, data restore/forward-fix, rollback, security incident, and release rollback.
- Perform a fresh route/API/action/table/policy/provider/feature/test rescan. Reconcile counts and behavior with `nexus-map.md` and update it.
- Have QA independently audit the entire remediation ledger, decision register, map, final diff, and release evidence.

Acceptance:

- Every confirmed-gap ledger row is `VERIFIED_COMPLETE`; any historical/candidate row with `VERIFIED_NOT_REPRODUCIBLE` or `SUPERSEDED_WITH_EVIDENCE` has independently checked evidence. No duplicate or missing map row exists.
- Every accessible named feature performs the advertised capability in a real browser and authorized environment.
- No skipped test, mock provider success, waived security issue, or unverified claim is counted as passing.
- `FINAL-SIGNOFF.md` contains the evidence-backed verdict and is signed by independent QA status, not only the Coder/Orchestrator.

## 8. Mandatory verification matrix

Use current script names discovered from `package.json`; update scripts only through an approved phase. At minimum, record commands, environment, exit codes, durations, test counts, and artifact links for:

```powershell
npm ci
npm run env:check
npm run lint
npm run typecheck
npm test
npm run test:scope-check
npm run build
npm run test:e2e:ci
npx lhci autorun
npm audit --audit-level=moderate
npm run db:reset
npx supabase db lint
npx supabase migration list
```

When linked checks are authorized and configured, also run and record:

```powershell
npx supabase db lint --linked
npx supabase migration list --linked
npx supabase db push --linked --dry-run
```

Before using any linked command, inspect `--help`, confirm its installed-version semantics, print and record the linked project reference/organization without secrets, classify the target as development, staging, or production, and compare it with the intended environment. Remote verification/mutation must use an isolated development or staging project unless the user explicitly authorizes the named production target and exact command. Obtain explicit authority for any operation that can mutate remote state. A failed or unavailable linked/provider gate means `NOT_READY`; it is not a local test failure to conceal.

Also require phase-specific evidence for:

- payment forgery, replay, reordering, mismatch, duplicate, and reconciliation;
- production environment fail-closed matrix;
- role/page/API/action matrix;
- executed RLS positive/negative cases;
- parallel quota/seat/invite/idempotency cases;
- durable limiter multi-instance behavior;
- notification retries, suppression, privacy, and provider callbacks;
- real Saved/Mistake insertion flows;
- Focus timer time semantics;
- offline browser behavior and account-switch purge;
- search visibility and answer-key leakage;
- admin approval/execution/audit and failure recovery;
- content coverage and production-ready labels;
- CSP/header/SEO assertions;
- accessibility and keyboard journeys;
- slow-network/performance/query budgets;
- real provider staging/sandbox checks;
- runbook dry runs.

QA must run commands itself. A Coder’s claim or pasted old output is not release evidence. Do not use `--passWithNoTests`, skip markers, reduced suites, non-blocking CI clauses, or mocked integrations to make a gate green.

## 9. Final production gate

The only permitted final verdicts are `READY_FOR_PRODUCTION` or `NOT_READY`.

`READY_FOR_PRODUCTION` is allowed only when all of the following are true:

- Every map gap and every newly found gap is `VERIFIED_COMPLETE`.
- Zero unresolved P0, P1, P2, Partial, Shell, journey, coverage, privacy, operational, or documentation rows remain.
- Lint, standalone typecheck, full tests, scope check, build, dependency audit, and complete Playwright suite are green from a clean install.
- Local database reset, executable RLS tests, concurrency tests, and migration verification pass.
- Authorized local/linked migration histories match and the release migration plan is proven.
- No production provider can silently mock or report fake success.
- Payment proof, replay safety, state transitions, reconciliation, side-effect idempotency, and durable limits are verified.
- Every role boundary, service-role read, admin mutation, rollout, entitlement, and audit effect is proven.
- Every accessible feature performs its advertised capability; no shell or disconnected journey remains.
- Real-provider staging/sandbox checks have current redacted evidence.
- Security headers, SEO/private indexing, error recovery, privacy, accessibility, and performance budgets pass.
- Monitoring, alerts, retention jobs, reconciliation, and incident/recovery runbooks exist and have been safely exercised.
- A fresh route/API/action/table/policy/feature rescan matches the updated `nexus-map.md`.
- The dirty-worktree ownership record proves no pre-existing user work was lost.

If an upstream dependency has no safe compatible release, credentials/provider access are unavailable, licensing/product authority is missing, a remote migration is unauthorized, or any required gate cannot be truthfully executed, the verdict is `NOT_READY` with the exact blocker, owner, needed authority, and verification step. Continue all other safe in-scope remediation; do not use one blocker to stop unrelated work.

## 10. Start now

Do not begin by proposing a smaller scope. Do not stop after producing the plan.

1. Read the required sources.
2. Capture worktree truth.
3. Dispatch Architect and Planner subagents for Phase 00.
4. Create the complete remediation ledger and all-phase dependency plan.
5. Show the ledger reconciliation totals: map items found, ledger rows created, duplicate/missing count, and phase ownership count.
6. Approve and execute Phase 01 only after Phase 00 passes independent QA.
7. Continue phase by phase, updating artifacts, the ledger, and `nexus-map.md` each time.
8. Escalate only genuine user-authority/external blockers immediately while continuing independent work.
9. Finish with independent full-system QA and the evidence-backed final verdict.

The foundation is `nexus-map.md`. Nothing in that map may disappear between discovery, planning, code, QA, and signoff.
