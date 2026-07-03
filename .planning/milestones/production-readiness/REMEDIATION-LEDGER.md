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
  - .planning/milestones/production-readiness/STATUS.md
outputs:
  - .planning/milestones/production-readiness/REMEDIATION-LEDGER.md
---

# Remediation Ledger — Production Readiness

## Reconciliation summary (Phase 00)

| Metric | Count |
|---|---:|
| Map anchors (§5–§12 distinct findings) | 108 |
| Master prompt §6 minimum catalog entries | 42 |
| Newly discovered in Phase 00 rescan (stale map counts, harness gaps) | 8 |
| **Total ledger rows** | **139** |
| Duplicates | 0 |
| Missing owner phases | 0 |

**Phase ownership distribution:** 00=2, 01=9, 02=9, 03=17, 04=8, 05=11, 06=6, 07=13, 08=15, 09=10, 10=10, 11=19, 12=10 (sum **139**)

**Source-metric note:** Map anchors (108) + catalog seeds (42) + rescan findings (8) = 158 *candidate* items; ledger rows = 139 after merging overlapping anchors (§5.6 bookmarks→PR-034, §5.7 localStorage→PR-036, callback dedupe→PR-056) and collapsing multi-line catalog bullets into single traceable rows.

**Merged map anchors (not duplicate rows):** §5.6 lesson bookmarks → PR-034; §5.7 localStorage misses → PR-036; callback dedupe race → PR-056.

**Status legend:** `DISCOVERED` = confirmed gap, not yet in active phase plan execution. `PLANNED` = assigned to owner phase with acceptance tests defined.

---

| ID | Source/map anchor | Severity | Role/journey | Current break | Required outcome | Owner phase | Exact acceptance tests | Status | Evidence link |
|---|---|---|---|---|---|---|---|---|---|
| PR-001 | §12 P0.1 | P0 | Student billing | `/api/mpesa/callback` accepts unauthenticated POST | Callback requires provider-supported verified channel; anonymous forgery returns 401/403 | 03 | Adversarial test: unsigned POST with forged success → no paid state | VERIFIED_COMPLETE | `phases/phase-03/QA-REPORT.md` v4; secret callback route; production RPC grants |
| PR-002 | §12 P0.1 | P0 | Student billing | Checkout request ID returned to student treated as payment proof | Activation requires independent Daraja verification, not checkout ID alone | 03 | Test: initiate STK, forge callback with checkout ID → subscription stays pending | VERIFIED_COMPLETE | `phases/phase-03/QA-REPORT.md` v4; sanitized STK response |
| PR-003 | §12 P0.1; catalog replay | P0 | Student billing | No replay/expiry controls on callback events | Idempotent callback ledger; replay/stale rejected | 03 | Test: duplicate/reordered verified callbacks → single activation | VERIFIED_COMPLETE | `20260701090000`; `20260701091000`; rollback atomicity probe |
| PR-004 | §12 P0.2 | P0 | Student billing | `isMock=true` path marks payment paid | Production cannot mark paid when mock flag set | 03 | Env matrix: prod + missing Daraja → checkout fails closed | VERIFIED_COMPLETE | Phase 02 fail-closed tests; Phase 03 stk-push route |
| PR-005 | §12 P0.2 | P0 | Ops/deploy | Missing Daraja creds allow paid activation | Startup/deploy validation fails when paid checkout enabled without creds | 02 | `npm run env:check` fails on incomplete M-Pesa in production fixture | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; `env:check` + M-Pesa fail-closed |
| PR-006 | §12 P0.3 | P0 | Student Nex | Gemini returns mock text when key missing | Production returns explicit unavailable error, no fake tutor response | 02 | Prod fixture Nex chat → 503/config error, no mock content persisted | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; Nex mock blocked in production |
| PR-007 | §12 P0.3 | P0 | Student Nex camera | Camera/OCR mocks success without vision creds | Fail closed in production; no fake OCR session | 02 | `/api/nex/camera` prod fixture → error, no persisted fake extraction | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; camera/OCR fail-closed |
| PR-008 | §12 P0.3 | P0 | Student Nex voice | Voice mocks transcription/TTS without creds | Fail closed in production | 02 | `/api/nex/voice` prod fixture → error | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; voice fail-closed |
| PR-009 | §12 P0.3 | P0 | Parent/notifications | Celcom mock records delivered SMS | Production never records mock SMS as delivered | 02 | Notification send prod fixture → failed/suppressed, not mock-delivered | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; Celcom mock suppressed |
| PR-010 | §12 P0.3 | P0 | Parent/notifications | Resend mock records sent email | Production never records mock email as sent | 02 | Email send prod fixture → fail closed | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; Resend mock suppressed |
| PR-011 | §12 P1.1 | P1 | CI/release | `tsc --noEmit` fails on dotAll at test:68,115 | Standalone typecheck passes | 01 | `npm run typecheck` exit 0 | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; typecheck exit 0 |
| PR-012 | §11; STATUS | P1 | Content CI | Map claims missing F4 B2 migration; test may desync | Test references `20260625240000_kcse_math_f4_b2.sql` on branch | 01 | Focused content test + migration list pass | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; F4 B2 migration + content tests |
| PR-013 | §12 P1.2; §6.4 | P1 | Support admin | `/admin/usage-stats` SSR calls service-role snapshot without super-admin guard | Page guard matches API; support cannot read flagged Nex bodies/cost | 04 | Support session GET page → 403; super admin → 200 | VERIFIED_COMPLETE | `phases/phase-04/QA-REPORT.md` |
| PR-014 | §12 P1.3 | P1 | Student Nex | Nex daily usage read-then-update race | Atomic Postgres increment with constraint | 05 | 20 parallel `/api/nex/chat` → exact limit, no overage | PLANNED | `nex_daily_usage` |
| PR-015 | §12 P1.3 | P1 | Student practice | Practice daily cap read-then-update race | Atomic quota enforcement | 05 | Parallel practice starts → cap enforced | PLANNED | practice routes |
| PR-016 | §12 P1.3 | P1 | Student family | Family join seat count race | Transactional seat lock + constrained insert | 05 | Parallel `/api/family/join` → seats never exceeded | PLANNED | `familySubscriptionService.ts` |
| PR-017 | §12 P1.4 | P1 | CI/security | High `undici` advisory | Resolved or documented exception with regression proof | 01 | `npm audit --audit-level=moderate` no unreviewed high | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; audit clean (DEC-004) |
| PR-018 | §12 P1.4 | P1 | CI/security | Moderate PostCSS chain advisories | Safe resolution without Next downgrade | 01 | Audit clean or DEC-004 documented exception | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; deploy:check includes audit + scope-check |
| PR-019 | §12 P1.5 | P1 | All browser | No CSP in `next.config.ts` | Environment-aware CSP per Next 16 guide | 11 | Header assertion tests; Nex multimodal smoke | PLANNED | `next.config.ts` |
| PR-020 | §12 P1.5 | P1 | All browser | No frame protection | `X-Frame-Options` or CSP `frame-ancestors` | 11 | Header test on public + app routes | PLANNED | `next.config.ts` |
| PR-021 | §12 P1.5 | P1 | All browser | No `X-Content-Type-Options` | `nosniff` on intended routes | 11 | Header assertion | PLANNED | `next.config.ts` |
| PR-022 | §12 P1.5 | P1 | All browser | No Referrer-Policy | Policy set per security review | 11 | Header assertion | PLANNED | `next.config.ts` |
| PR-023 | §12 P1.5 | P1 | All browser | No Permissions-Policy | Camera/mic policies for Nex | 11 | Header assertion; camera journey works | PLANNED | `next.config.ts` |
| PR-024 | §12 P1.5 | P1 | Public prod | No HSTS on HTTPS production | HSTS only when valid HTTPS context | 11 | Staging/prod header test | PLANNED | `next.config.ts` |
| PR-025 | §5.1; §12 P1.5 | P1 | Visitor SEO | No `robots.ts` | Correct robots rules | 11 | `/robots.txt` test; admin routes disallowed | PLANNED | `src/app/robots.ts` (new) |
| PR-026 | §5.1; §12 P1.5 | P1 | Visitor SEO | No `sitemap.ts` | Public sitemap excludes private routes | 11 | Sitemap content test | PLANNED | `src/app/sitemap.ts` (new) |
| PR-027 | §5.1; §12 P1.5 | P1 | Visitor SEO | No manifest/OG/canonical strategy | Web manifest, OG/Twitter, canonical metadata | 11 | Metadata tests; Lighthouse SEO ≥95 | PLANNED | `src/app/layout.tsx`, manifest |
| PR-028 | §12 P1.6; §4 | P1 | Super admin | `/admin/roles` writes ledger only, not Auth metadata | Role change updates canonical runtime claim + ledger coherently | 06 | Role PATCH → JWT refresh → access changes | PLANNED | `src/app/api/admin/roles/route.ts` |
| PR-029 | §12 P1.6 | P1 | Student product | Rollout rows not consumed by feature gates | Server-enforced rollouts block/allow routes and APIs | 06 | Rollout-off → direct URL 404/403; on → cohort only | PLANNED | rollout service + DEC-001 |
| PR-030 | §12 P1.6 | P1 | Admin debug | Entitlement debug hardcodes `featureEnabled: true` | Evaluated server decision matches runtime | 06 | Debug output matches gate for off rollout | PLANNED | admin entitlement debug |
| PR-031 | §12 P1.7 | P1 | Admin audit | `recordAdminAudit()` swallows insert failures | Critical mutations fail closed or durable outbox (DEC-009) | 06 | Simulated audit DB failure → mutation blocked or retriable | PLANNED | audit service |
| PR-032 | §12 P1.7 | P1 | Admin audit | Audit insert checks throw only, not `{ error }` | Supabase `{ error }` handled | 06 | Unit test: returned error → visible failure | PLANNED | audit service |
| PR-033 | §5.11; §12 P1.8 | P1 | Student tools | Study Search does not query lesson/question text | Indexed curriculum-aware search with visibility scoping | 07 | Search returns published lesson hit; drafts/keys excluded | PLANNED | `/study-search`, search API |
| PR-034 | §5.6; §12 P1.8 | P1 | Student tools | Lesson bookmarks browser-local only | Bookmarks write server `student_saved_items` | 07 | Bookmark lesson → appears on `/saved` | PLANNED | lesson reader + saved API |
| PR-035 | §5.7; §12 P1.8 | P1 | Student tools | Practice save not connected to `/saved` | Save/unsave practice items server-backed | 07 | Save question → `/saved` lists it | PLANNED | practice results UI |
| PR-036 | §5.7; §12 P1.8 | P1 | Student tools | Mistake journal never auto-populated from practice/mock | Wrong answers upsert idempotently to journal | 07 | Complete practice with miss → journal row | PLANNED | `student_mistake_journal` |
| PR-037 | §5.11; §12 P1.8 | P1 | Parent | `parent_visible` weekly goal not shown on parent dashboard | Parent sees goal only for linked students when visible | 08 | Parent linked + visible goal → rendered; unlinked → hidden | PLANNED | `/parent` |
| PR-038 | §5.11; §12 P1.8 | P1 | Student tools | Focus sessions: manual complete, no timer | Persisted timer with server-validated elapsed credit | 07 | Timer race test; no credit from click-only complete | PLANNED | `/focus`, focus API |
| PR-039 | §5.11; §12 P1.8 | P1 | Student tools | Offline packs record-only, no SW/cache | Installable offline with manifest, SW, purge on logout | 07 | Playwright offline: pack opens with network disabled | PLANNED | `/offline`, SW |
| PR-040 | §5.11; §12 P1.8 | P1 | Student tools | Concept Library four static `/learn` links | Published concept/reference library + authoring lifecycle | 07 | Library browse/search; Studio publish path | PLANNED | `/library` |
| PR-041 | §5.11; §12 P1.8 | P1 | Student tools | Learning Memory wording overstates editability | Accurate projection + provenance/reset if promised | 07 | UI copy matches read-only projection; reset works | PLANNED | `/nex-memory` |
| PR-042 | §12 P1.9 | P1 | Content/product | `isTopicPracticeReady()` uses 5-question band threshold | `PROD_READY` requires 21 Q/topic + lessons per policy | 10 | Coverage test fails under-target; startable separate | PLANNED | `contentModel.ts` |
| PR-043 | §12 P1.9 | P1 | Content/product | `getTopicReadinessLabel()` can show PROD_READY early | Labels match DEC-002 production definition | 10 | Label unit tests per threshold matrix | PLANNED | `contentModel.ts` |
| PR-044 | §12 P1.10 | P1 | Admin ops | Health marks DB healthy on execute alone | Probes distinguish configured/reachable/degraded | 02 | Health shows missing provider as not healthy | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; health probes distinguish configured/degraded |
| PR-045 | §12 P1.10 | P1 | Admin ops | No AI/M-Pesa/SMS/email/cron/migration/latency probes | Timeout-bounded probes per enabled provider | 02 | Probe matrix tests with mocked timeouts | PLANNED | health probe module |
| PR-046 | §12 P1.11 | P1 | Public | Teacher waitlist in-memory `Map` rate limit | Durable distributed limiter with cleanup | 05 | Multi-instance simulation → consistent limits | PLANNED | `/api/waitlist/teacher` |
| PR-047 | §12 P1.11 | P1 | Student billing | Payment endpoints lack burst limits | Durable abuse limits by account/phone hash/IP HMAC | 03 | Burst test → 429 + Retry-After | PLANNED | payment routes |
| PR-048 | §12 P1.11 | P1 | Student Nex | AI/camera/voice lack burst limits beyond daily quota | Burst limits on multimodal endpoints | 05 | Parallel camera uploads throttled | PLANNED | nex routes |
| PR-049 | §12 P1.11 | P1 | Admin | Privileged admin mutations lack burst limits | Rate limits on exports/bulk/settings | 05 | Admin burst adversarial test | PLANNED | admin APIs |
| PR-050 | §12 P1.12 | P1 | Agents/docs | V1 scope lock bans live features | Scope lock updated to reference map + current routes | 10 | Doc audit: no banned-live contradiction | PLANNED | `mvp-feature-scope-lock.md` |
| PR-051 | §12 P1.12 | P1 | Agents/docs | Docs claim Next.js 15 | Architecture docs say Next 16.2.9 | 10 | Doc grep + link to map | PLANNED | governance docs |
| PR-052 | §12 P1.12 | P1 | Agents/docs | Screen inventory omits routes | Inventory matches 69-page scan | 10 | Route count reconciliation test/doc | PLANNED | screen inventory |
| PR-053 | §12 P1.12 | P1 | Agents/docs | User flows omit student/admin utilities | Flows cover map journeys | 10 | QA doc review checklist | PLANNED | user-flow docs |
| PR-054 | §5.2; §12 P2 | P2 | Visitor signup | Signup/profile/invite not transactional | Compensating/idempotent signup flow | 04 | Concurrent signup + invite → one profile, no orphan | VERIFIED_COMPLETE | Fix cycle 2 (2026-07-03): E2E green vs remote; migration pushed |
| PR-055 | §5.3; §12 P2 | P2 | Visitor OAuth | Beta invite not enforced in OAuth callback | OAuth obeys DEC-003 beta policy | 04 | OAuth without invite when required → blocked | VERIFIED_COMPLETE | Fix cycle 2 (2026-07-03): E2E green vs remote |
| PR-056 | §12 P2; catalog idempotency | P2 | Billing | Callback dedupe check-then-insert | DB uniqueness + atomic idempotency | 03 | Parallel identical callbacks → one row | VERIFIED_COMPLETE | callback event unique index; atomic production rollback probe |
| PR-057 | §12 P2; catalog retention | P2 | Privacy/ops | Notification retention policy unverified | Documented retention per DEC-006 | 08 | Retention job test + policy doc | PLANNED | notification migrations |
| PR-058 | §12 P2 | P2 | Privacy | Message body/phone PII handling unclear | Redaction in logs/exports per policy | 08 | Log snapshot test: no raw phone/body | PLANNED | notification service |
| PR-059 | §5.13; §12 P2 | P2 | Parent | No parent unlink/revoke UI | Unlink with confirmation + access revocation | 08 | Unlink → parent loses student data immediately | PLANNED | parent link API/UI |
| PR-060 | §5.13 | P2 | Parent | No parent profile/settings page | Parent settings for contact/preferences | 08 | Parent edits preferences → persisted | PLANNED | `/parent` settings |
| PR-061 | §5.13 | P2 | Parent | No notification preferences | Channel/event/frequency preferences | 08 | Suppressed event never sends | PLANNED | parent prefs |
| PR-062 | §5.13 | P2 | Parent | Weekly goal not displayed (see PR-037) | Parent rendering + RLS enforcement | 08 | Cross-family isolation test | PLANNED | parent dashboard |
| PR-063 | §5.9; §12 P2 | P2 | Student exams | Readiness bare simulator links | Session-aware generate/resume/start CTAs | 07 | Readiness with eligibility → starts session | PLANNED | `/readiness` |
| PR-064 | §5.5; §12 P2 | P2 | Student perf | Duplicate `getStudentChromeData` + experience loads | ≤1 session/profile lookup per request | 11 | Server timing test: single profile fetch | PLANNED | student layout |
| PR-065 | §12 P2 | P2 | Ops/perf | No query/latency instrumentation | Server timing + budgets | 11 | p95 dashboard ≤800ms staging evidence | PLANNED | instrumentation |
| PR-066 | §6.4; §12 P2 | P2 | Admin | `/admin/reports` no CSV export | Authorized CSV download per report link | 09 | Report click → valid CSV + audit | PLANNED | `/admin/reports` |
| PR-067 | §6.4 | P2 | Admin | `/admin/communications` templates only | Campaign sender or DEC-013 narrow UI | 09 | Send preview count + idempotent send | PLANNED | communications admin |
| PR-068 | §6.4 | P2 | Admin | `/admin/experiments` ledger only | Deterministic assignment + exposure metrics | 09 | Experiment obeys rollout precedence DEC-001 | PLANNED | experiments service |
| PR-069 | §6.4 | P2 | Admin | `/admin/bulk-actions` no executor | Typed allowlisted commands with approval | 09 | Approved bulk → executes with audit | PLANNED | bulk-actions |
| PR-070 | §6.4 | P2 | Admin | `/admin/approvals` ledger only | Approval gates executor; direct call blocked | 09 | Bypass approval API → 403 | PLANNED | approvals |
| PR-071 | §6.4 | P2 | Admin | `/admin/saved-views` partial | Saved filters reapply to target page | 09 | Load view → page query matches | PLANNED | saved-views |
| PR-072 | §6.4 | P2 | Admin | `/admin/search` partial | Useful entity search with role filter | 09 | Search returns authorized snippets only | PLANNED | `/admin/search` |
| PR-073 | §6.4 | P2 | Admin | `/admin/content-calendar` partial | Real review/publish calendar workflow | 09 | Calendar reflects review queue dates | PLANNED | content-calendar |
| PR-074 | §12 P2 | P2 | All roles | Missing route-specific error recovery | Error boundaries + retry for provider/401/chunk | 11 | Playwright: forced error → recovery UI | PLANNED | error boundaries |
| PR-075 | §12 P2; catalog bootstrap | P2 | Admin | No last-admin/self-demotion/bootstrap guards | Adversarial admin lockout protections | 06 | Last super-admin demotion blocked | PLANNED | roles service |
| PR-076 | §12 P2 | P2 | Ops | No payment reconciliation runbook | Documented + dry-run reconciliation procedure | 12 | Runbook exercise recorded | PLANNED | `RELEASE-EVIDENCE.md` |
| PR-077 | §12 P2 | P2 | Ops | No webhook replay tooling | Idempotent replay operator tool | 03 | Replay tool test on fixture event | PLANNED | admin ops |
| PR-078 | §12 P2 | P2 | Ops | Missing provider outage runbooks | AI/payment/cron incident runbooks dry-run | 12 | Runbook checklist PASS | PLANNED | ops docs |
| PR-079 | §11 | P1 | QA | No E2E parent journey | Playwright parent link + dashboard | 12 | `e2e/parent-journey.spec.ts` green | PLANNED | `e2e/` |
| PR-080 | §11 | P1 | QA | No E2E admin journey | Playwright support + super-admin smoke | 12 | `e2e/admin-journey.spec.ts` green | PLANNED | `e2e/` |
| PR-081 | §11 | P1 | QA | No E2E Authoring Studio | Studio publish path browser test | 12 | Studio E2E green | PLANNED | `e2e/studio.spec.ts` |
| PR-082 | §11 | P1 | QA | No E2E student utilities | Utilities primary journeys in Playwright | 12 | Utilities E2E green | PLANNED | `e2e/student-utilities.spec.ts` |
| PR-083 | §11 | P1 | QA | No E2E billing/multimodal Nex | Pricing/checkout smoke + camera/voice paths | 12 | Billing + multimodal specs green | PLANNED | `e2e/nex-camera.spec.ts` expand |
| PR-084 | §11 | P1 | QA | RLS tests read migration text only | Executed RLS tests on reset DB | 12 | `npm run db:reset` + RLS suite green | PLANNED | `tests/rls/` |
| PR-085 | §11 | P1 | QA | No concurrency tests | Parallel invariants suite | 12 | Concurrency package in CI | PLANNED | `tests/concurrency/` |
| PR-086 | §11 | P1 | QA | No real-provider staging checks | Sandbox evidence for Daraja/Celcom/Resend/AI | 12 | Redacted staging log in RELEASE-EVIDENCE | PLANNED | staging checklist |
| PR-087 | §11 | P1 | QA | No Lighthouse/perf budgets | LHCI + DEC-005 thresholds | 11 | `npx lhci autorun` PASS | PLANNED | `lighthouserc.js` |
| PR-088 | §12 P2; catalog support login | P1 | Support | Support login → "Unable to load account" | Support routed to `/admin` with correct role | 04 | Support OAuth/password → admin shell | VERIFIED_COMPLETE | Fix cycle 2 (2026-07-03): support seeded on remote; E2E support-admin-login PASS |
| PR-089 | catalog CSRF | P1 | Security | Cookie mutations lack Origin enforcement | Same-origin check on session cookie POST/PUT/PATCH/DELETE | 05 | Cross-origin POST with cookie → 403 | PLANNED | route middleware helper |
| PR-090 | catalog body limits | P1 | Security | No centralized request body size limits | Limits before parse on public/AI/admin routes | 05 | Oversize payload → 413 | PLANNED | body limit middleware |
| PR-091 | catalog atomic trial | P1 | Student billing | Trial creation not atomic | Trial + subscription rows atomic/compensating | 05 | Failed mid-trial → no partial premium | PLANNED | `/api/subscriptions/trial` |
| PR-092 | catalog atomic activation | P1 | Student billing | Subscription activation multi-row race | Atomic activation transaction | 05 | Parallel activation → one active sub | PLANNED | subscription service |
| PR-093 | catalog family setup | P1 | Student family | Family owner setup not atomic | Owner group + member atomic | 05 | Family create concurrency test | PLANNED | family service |
| PR-094 | catalog payment validation | P1 | Student billing | Amount/plan mismatch possible | Validate plan amount against platform settings | 03 | Wrong amount callback → rejected | VERIFIED_COMPLETE | strict callback proof plus atomic stored/verified amount comparison |
| PR-095 | catalog phone validation | P1 | Student billing | Phone format not strictly validated | Merchant/phone normalization + rejection | 03 | Invalid phone → 400 before STK | VERIFIED_COMPLETE | `mpesaStkPushSchema`; `validateQueryProof` strict phone match |
| PR-096 | catalog receipt uniqueness | P1 | Student billing | No uniqueness on provider receipt IDs | DB unique constraint on receipt/transaction IDs | 03 | Duplicate receipt → idempotent no-op | VERIFIED_COMPLETE | receipt and side-effect unique indexes in production |
| PR-097 | catalog Sentry | P1 | Ops | Client Sentry integration unverified for Next 16 | `instrumentation-client.ts` + server wiring | 11 | Staging deliberate error in Sentry | PLANNED | instrumentation files |
| PR-098 | catalog observability | P1 | Ops | Source maps/alerting incomplete | Release tags, redaction, non-public source maps | 11 | Sentry event has release env tags | PLANNED | Sentry config |
| PR-099 | catalog cron leakage | P2 | Security | Cron routes may leak error detail | Stable error codes; no stack to client | 04 | Cron failure → generic response | VERIFIED_COMPLETE | `weekly-reports/route.ts` CRON_JOB_FAILED |
| PR-100 | catalog error codes | P2 | UX | Inconsistent client error codes | Stable coded errors for recovery UI | 04 | API contract tests for error shape | VERIFIED_COMPLETE | `roleMatrix.test.ts` usage-stats 401 |
| PR-101 | catalog focus cancel | P2 | Student tools | Completed focus sessions cancellable | State machine: complete terminal | 07 | PATCH cancel after complete → 409 | PLANNED | focus API |
| PR-102 | catalog nex memory | P2 | Student tools | Raw internal metadata in Nex Memory UI | Redacted/summarized presentation | 07 | Snapshot test: no raw JSON blobs | PLANNED | nex-memory page |
| PR-103 | catalog cache leakage | P1 | Security | Private response cache leakage risk | `Cache-Control: private/no-store` on authenticated routes | 11 | Header tests on student/admin pages | PLANNED | route handlers |
| PR-104 | catalog offline purge | P1 | Student offline | Logout does not purge offline caches | SW/IDB purge on logout/account switch | 07 | Logout → offline pack inaccessible | PLANNED | SW + auth hook |
| PR-105 | catalog account switch | P1 | Student offline | Account switch may leak cached data | Per-user cache namespace isolation | 07 | Switch user → prior user data absent | PLANNED | offline manifest |
| PR-106 | §5.9; catalog past papers | P2 | Student/product | Mock exams may imply official past papers | Accurate mock language per DEC-007 | 10 | Copy audit: no false licensing claims | PLANNED | exam-prep UI |
| PR-107 | catalog retention PII | P1 | Privacy | No unified retention/deletion policy | Documented + enforced retention for PII/learning records | 08 | Deletion request test + audit | PLANNED | privacy module |
| PR-110 | §10 | P1 | Ops/deploy | No boot-time env validation | `env:check` on deploy + instrumentation | 02 | Server refuses traffic when prod misconfigured | VERIFIED_COMPLETE | `phases/phase-02/QA-REPORT.md` v2; instrumentation boot-time validation |
| PR-111 | §7.2 | P1 | Notifications | `/api/celcom/webhook` unverified public | Verified secret/idempotency like payments | 03 | Forged Celcom webhook → no false delivery | VERIFIED_COMPLETE | header secret gate; webhook event uniqueness; QA v4 |
| PR-113 | catalog polling | P1 | Student billing | No student payment status polling endpoint | Student-owned poll with auth + expiry UI | 03 | Pending payment → poll shows terminal state | VERIFIED_COMPLETE | `/api/mpesa/status`; `PricingCheckout`; Phase 03 tests |
| PR-114 | catalog duplicate pending | P1 | Student billing | Duplicate pending payments possible | Suppress duplicate pending per student/plan | 03 | Double STK click → one pending | VERIFIED_COMPLETE | active-payment unique index plus duplicate-pending route guard |
| PR-115 | catalog expiry | P1 | Student billing | Pending payments never expire | Expiry job + UI recovery | 03 | Stale pending → expired recoverable | VERIFIED_COMPLETE | `phases/phase-03/QA-REPORT.md` v4; `paymentExpiry.test.ts` + reconciliation service |
| PR-124 | catalog STK query | P0 | Student billing | No independent Daraja STK Query proof | Query before activation | 03 | Activation blocked until query success | VERIFIED_COMPLETE | mandatory `queryStkPush`; atomic process RPC; QA v4 |
| PR-116 | §2; v2-tier-1 | P1 | Student Nex | Phase 2.5 voice batch verification unexecuted | Voice golden + E2E verification recorded | 01 | Tier 2.5 voice test suite PASS | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; voice batch 12/12 |
| PR-117 | §11 | P1 | CI | CI not green on standalone typecheck | CI enforces same gates as deploy:check | 01 | GitHub workflow typecheck job green | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; CI typecheck job |
| PR-118 | §11; Phase 01 | P1 | CI | `test:e2e:ci` not self-contained | Build, start server, readiness, teardown | 01 | `npm run test:e2e:ci` alone exits 0 | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; test:e2e:ci self-contained |
| PR-119 | §11 | P1 | CI | `deploy:check` omits scope-check/audit | Unified release command | 01 | `npm run deploy:check` runs full matrix | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; deploy:check expanded |
| PR-120 | STATUS | P1 | CI | `env:check` script missing | Script exists (stub ok in 01, strict in 02) | 01 | `npm run env:check` exists exit 0 in test env | VERIFIED_COMPLETE | `phases/phase-01/QA-REPORT.md` v2; `phases/phase-02/QA-REPORT.md` v2; env:check stub + strict validation |
| PR-121 | STATUS rescan | P2 | Docs | Map said 38 migrations; branch has 39 | Map migration count matches live `supabase/migrations/` | 00 | Map §2 migration count = 39 | VERIFIED_COMPLETE | nexus-map.md §2 (2026-06-29) |
| PR-122 | STATUS rescan | P2 | Docs | STATUS claimed 6 E2E specs; repo has 5 | STATUS and map E2E count = 5 | 00 | `e2e/*.spec.ts` count = 5 in STATUS + map | VERIFIED_COMPLETE | STATUS.md §2 (2026-06-29) |
| PR-123 | catalog payment polling | P1 | Student billing | Reload during pending payment unclear | Recoverable pending UI + poll endpoint | 03 | (with PR-113) | PLANNED | pricing UI |
| PR-125 | Phase 09 | P2 | Admin | Bulk/campaign lacks four-eyes separation | Requester cannot approve own bulk job | 09 | Same actor approve → 403 | PLANNED | approvals + bulk |
| PR-126 | Phase 09 | P2 | Admin | CSV export formula injection risk | Escape/formula-safe CSV | 09 | Cell `=cmd` exported safely | PLANNED | report export |
| PR-127 | catalog session revoke | P1 | Security | No session revocation on privilege change | Revoke sessions on role/plan change | 04 | Role demote → old JWT rejected | VERIFIED_COMPLETE | Fix cycle 2 (2026-07-03): unit suite green; E2E shell access PASS |
| PR-128 | §9 privacy | P2 | Admin/privacy | View-as impersonation retention unclear | Retention/redaction for view-as evidence | 08 | Policy test + audit rows | PLANNED | impersonation sessions |
| PR-129 | catalog notification retry | P1 | Parent | No bounded retry/backoff for notifications | Retry with idempotency | 08 | Provider fail → retries then exhausted | PLANNED | notification outbox |
| PR-130 | catalog dead-letter | P1 | Parent | No notification dead-letter path | Operator recovery for exhausted sends | 08 | DLQ row visible in admin health | PLANNED | notification service |
| PR-131 | §5.13 | P2 | Parent/cron | Weekly report duplicate cron execution | Idempotent cron per student/week | 08 | Double cron → one report | PLANNED | weekly-reports cron |
| PR-132 | §5.13 | P2 | Parent/cron | Timezone/week boundary ambiguity | Documented TZ + boundary tests | 08 | TZ boundary unit test | PLANNED | weeklyReportService |
| PR-133 | §12 P2 | P2 | Family | Member removal/subscription loss lifecycle incomplete | Seat reclaim + access on sub lapse | 08 | Sub cancel → members lose family entitlements | PLANNED | family service |
| PR-134 | §12 P2 | P2 | Family | Resubscription/relink edge cases | Documented owner change policy | 08 | Integration test family lifecycle | PLANNED | family journeys |
| PR-135 | Phase 10 | P1 | Content | No executable coverage matrix | DB-driven coverage report per grade/subject/topic | 10 | `npm run test:coverage-matrix` fails under-target | PLANNED | coverage script |
| PR-136 | Phase 10 | P1 | Content | Under-covered topics can appear production-ready | Publish gate blocks false PROD_READY | 10 | Publish under-target → blocked | PLANNED | Studio gates |
| PR-137 | Phase 11 | P1 | A11y | No manual screen reader gate | DEC-011 Narrator+Edge journeys recorded | 11 | QA a11y report per primary role | PLANNED | QA-REPORT phase-11 |
| PR-138 | Phase 11 | P1 | A11y | Keyboard/focus gaps on new utilities | Full keyboard path on utilities + Nex | 11 | axe + manual keyboard checklist | PLANNED | student utilities |
| PR-139 | Phase 11 | P1 | Nex | CSP may break camera/mic | CSP verified with multimodal smoke | 11 | Camera E2E under CSP headers | PLANNED | nex-camera e2e |
| PR-140 | Phase 03 | P1 | Student billing | Provider-down checkout UX weak | Pending/error/recover states in UI | 03 | Playwright: provider down → recoverable message | PLANNED | `/pricing` |
| PR-141 | §10 | P2 | Ops | Platform settings 60s cache undocumented | Staleness documented for operators | 10 | Ops doc mentions cache window | PLANNED | platform settings doc |
| PR-142 | §3 | P2 | Security | Proxy matcher may omit newer student routes | Role matrix includes all 28 student pages | 04 | Matrix test every student `page.tsx` | VERIFIED_COMPLETE | Fix cycle 2 (2026-07-03): contract committed; E2E negative path PASS |

## Phase 00 discovery notes

- **PR-121, PR-122:** Map migration count (39) and E2E count (5) reconciled in Phase 00 QA fix pass.
- **PR-012:** DEC-015 selected — migration exists on branch; Phase 01 reconciles test, not fabricates SQL.
- **§5.6/§5.7 bookmark/localStorage anchors** merge into PR-034/PR-036 (single implementation row each).
- **Callback dedupe race** merges into PR-056 (single migration/test owner).

## Terminal status policy

Only `VERIFIED_COMPLETE`, `VERIFIED_NOT_REPRODUCIBLE`, or `SUPERSEDED_WITH_EVIDENCE` may close a row. `EXTERNAL_BLOCKER` requires named authority and verification command.
