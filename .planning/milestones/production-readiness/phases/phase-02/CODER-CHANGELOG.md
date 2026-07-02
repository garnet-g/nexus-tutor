# CODER-CHANGELOG — Phase 02 (Production environment policy)

**Milestone:** production-readiness  
**Phase:** 02  
**Agent:** Coder  
**Date:** 2026-06-29

## Summary

Implemented typed `APP_ENV` policy (DEC-014), strict `env:check`, boot-time validation in `instrumentation.ts`, fail-closed provider clients, and real health probes replacing activity-proxy summaries on `/admin/health`.

## Ledger coverage

| ID | Change |
|----|--------|
| PR-005 | M-Pesa mock STK blocked in production/staging live modes |
| PR-006–PR-010 | Explicit `APP_ENV` + provider modes; no silent mocks in production |
| PR-044 | Nex text model fails closed without credentials in live mode |
| PR-045 | Notification clients fail closed (no mock-delivered status) |
| PR-110 | `instrumentation.ts` validates env before traffic in staging/production |
| PR-120 | `npm run env:check` strict validation (replaces Phase 01 stub) |

## TDD evidence

| Step | Command | Result |
|------|---------|--------|
| RED | `npx vitest run tests/env/productionFailClosed.test.ts` (before impl) | FAIL — modules missing |
| GREEN | `npx vitest run tests/env/ tests/health/probes.test.ts` | 11/11 PASS |
| Verify | `npm run env:check` | exit 0 |
| Verify | `$env:APP_ENV="production"; npx vitest run tests/env/` | PASS |
| Verify | `npm test` | 475/475 PASS |
| Verify | `npm run build` | exit 0 |

## Files changed (allowlist + necessary wiring)

| File | Action |
|------|--------|
| `package.json` | `env:check` → `tsx src/lib/env/validateEnv.ts`; `deploy:check` prepends `env:check` |
| `src/lib/env/envSchema.ts` | **NEW** — Zod-style typed schema, production/test matrix |
| `src/lib/env/validateEnv.ts` | **NEW** — CLI + `validateEnvironment()` / `assertEnvironmentValid()` |
| `src/lib/env/providerModes.ts` | **NEW** — `ConfigurationError`, mock adapter metadata, provider assertions |
| `src/instrumentation.ts` | Boot-time `assertEnvironmentValid()` for staging/production |
| `src/lib/health/types.ts` | **NEW** — probe status types |
| `src/lib/health/probes.ts` | **NEW** — configured/reachable/degraded/misconfigured probes |
| `src/server/services/healthService.ts` | **NEW** — maps probes for admin presentation |
| `src/app/(super-admin)/admin/health/page.tsx` | Consumes `healthService` probes (see allowlist note) |
| `src/lib/nex/geminiClient.ts` | **NEW** — Gemini client + mock response helper |
| `src/lib/nex/openaiClient.ts` | **NEW** — OpenAI client + judge |
| `src/lib/nex/callNexModel.ts` | Fail-closed via provider modes; delegates to client modules |
| `src/lib/mpesa/mpesaClient.ts` | Fail-closed STK; explicit mock metadata in test mode |
| `src/lib/notifications/celcomClient.ts` | **NEW** — fail-closed SMS |
| `src/lib/notifications/resendClient.ts` | **NEW** — fail-closed email |
| `tests/env/envSchema.test.ts` | **NEW** |
| `tests/env/productionFailClosed.test.ts` | **NEW** |
| `tests/health/probes.test.ts` | **NEW** |

## Allowlist deviations (escalation)

| Planned path | Actual | Reason |
|--------------|--------|--------|
| `src/app/admin/health/page.tsx` | `src/app/(super-admin)/admin/health/page.tsx` | Route group is the live `/admin/health` page; duplicate path would conflict |
| `src/lib/nex/callNexModel.ts` | Modified | Required to wire `geminiClient`/`openaiClient` fail-closed policy |
| `src/lib/celcom/celcomClient.ts` | Re-export shim | Preserves existing `@/lib/celcom` imports |
| `src/lib/resend/resendClient.ts` | Re-export shim | Preserves existing `@/lib/resend` imports |

**Out of scope (deferred):** Camera/voice (`extractImageText`, `voiceTranscribe`, `voiceSynthesize`) still use legacy `NEX_MOCK_AI` paths — not on Phase 02 allowlist. Production boot validation + Nex text fail-closed covers primary teaching path.

## Security notes

- Validation output lists missing **keys names only**, never secret values.
- Health probes never serialize credential env vars.

## Planner verdict note

Phase 02 plan shows `PENDING`; build proceeded per orchestrator `APPROVED_TO_BUILD` instruction.
