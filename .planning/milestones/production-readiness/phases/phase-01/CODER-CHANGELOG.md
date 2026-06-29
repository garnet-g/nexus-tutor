---
milestone: production-readiness
phase: 01
agent: coder
status: READY_FOR_QA
---

# CODER-CHANGELOG — Phase 01 Green Baseline

## Summary

Restored reliable quality gates: standalone typecheck green, npm audit clean (DEC-004), expanded `deploy:check`, CI harness for E2E, Tier 1 Phase 2.5 voice verification batch, and KCSE F4 B2 content test alignment (DEC-015).

## Criterion IDs

| ID | Action |
|----|--------|
| PR-011 | Fixed TS1501 dotAll — rewrote regex in `kcseMathSeedContent.test.ts` (DEC-012 path A) |
| PR-012 | F4 B2 migration already in test allowlist; 70/70 content tests pass (DEC-015) |
| PR-017 | `npm audit fix` upgraded `undici`; `overrides.postcss` pinned 8.5.15 (DEC-004 path A+B) |
| PR-018 | `deploy:check` now includes scope-check + audit |
| PR-116 | `env:check` stub added (`node -e process.exit(0)`) — strict validation deferred Phase 02 |
| PR-117 | `test:e2e:ci` + `playwright.config.ts` CI harness (build → prod server :3000 → Playwright teardown) |
| PR-118 | `.github/workflows/ci.yml` enforces typecheck, scope-check, audit, `test:e2e:ci` |
| PR-119 | Lint warning cleared in allowlisted `kcseMathSeedContent.test.ts` |
| PR-120 | Tier 2.5 voice batch: `tests/nex/voice{Pipeline,Golden,Route}.test.ts` — 12/12 pass |

## Files touched

| File | Change |
|------|--------|
| `package.json` | `deploy:check`, `env:check`, `test:e2e:ci`, `overrides.postcss` |
| `package-lock.json` | `npm audit fix` + override lock refresh |
| `playwright.config.ts` | CI harness via `npm_lifecycle_event === test:e2e:ci`, fixed port 3000 |
| `.github/workflows/ci.yml` | audit step; `test:e2e:ci` replaces manual e2e |
| `tests/content/kcseMathSeedContent.test.ts` | ES2017-safe regex; unused catch binding |
| `tests/nex/voicePipeline.test.ts` | **new** — pipeline limits, mock STT/TTS, validation path |
| `tests/nex/voiceGolden.test.ts` | **new** — V2-VOICE-09 golden transcript → validation |
| `tests/nex/voiceRoute.test.ts` | **new** — route auth/gating/validation (node vitest env) |
| `src/lib/nex/voiceTranscription.ts` | **new** — re-export barrel for `voiceTranscribe` |
| `src/lib/nex/voiceSynthesis.ts` | **new** — re-export barrel for `voiceSynthesize` |

**Not modified (pre-existing, out of allowlist):** `tests/voicePipeline.test.ts` (legacy path; canonical tests now under `tests/nex/`).

## RED evidence (before fixes)

```
npm run typecheck
> tsc --noEmit
tests/content/kcseMathSeedContent.test.ts(68,39): error TS1501: dotAll only available when targeting es2018+
tests/content/kcseMathSeedContent.test.ts(115,60): error TS1501: ...
EXIT:1

npm audit --audit-level=moderate
3 vulnerabilities (2 moderate postcss via next, 1 high undici)
EXIT:1
```

`npx vitest run tests/content/kcseMathSeedContent.test.ts` — **already GREEN** (70/70) before regex fix; migration reconciliation was current on branch.

## GREEN evidence (after fixes)

| Command | Result |
|---------|--------|
| `npm run lint` | PASS (3 warnings in non-allowlisted scripts only) |
| `npm run typecheck` | PASS |
| `npm test` | PASS — 85 files, 464 tests |
| `npm run test:scope-check` | PASS |
| `npm run build` | PASS — Next 16.2.9 |
| `npm audit --audit-level=moderate` | PASS — 0 vulnerabilities |
| `npm run deploy:check` | PASS |
| `npx vitest run tests/nex/voicePipeline.test.ts tests/nex/voiceGolden.test.ts tests/nex/voiceRoute.test.ts` | PASS — 12/12 |

`npm run test:e2e:ci` — **NOT_RUN** (Playwright browser install + server lifecycle; defer to QA matrix).

## Decisions resolved

| Decision | Resolution |
|----------|------------|
| DEC-004 | Path A (`npm audit fix` → undici) + path B (`overrides.postcss: 8.5.15`); no `--force` Next downgrade |
| DEC-012 | Path A — `[\s\S]*?` replaces dotAll `s` flag; `target` remains ES2017 |
| DEC-015 | Test already lists `20260625240000_kcse_math_f4_b2.sql` with `expectedLessonCount: 45`; no SQL edits |

## Deviations

1. **Voice module names:** Production code uses `voiceTranscribe.ts` / `voiceSynthesize.ts`; allowlist aliases added as re-export barrels only (no import rewiring).
2. **Legacy voice test:** `tests/voicePipeline.test.ts` left in place (not allowlisted for delete); Phase 01 canonical location is `tests/nex/voicePipeline.test.ts`.
3. **voiceRoute tests:** `@vitest-environment node` required — jsdom FormData+Blob caused 5s timeouts on audio validation cases.
4. **env:check:** Inline `node -e "process.exit(0)"` stub per Phase 01 plan; strict matrix is Phase 02.
