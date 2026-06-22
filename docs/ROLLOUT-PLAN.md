# Nexus — Freemium Pilot Rollout Plan

**Goal:** Put Nexus in the hands of ~1,000 Form 1–4 students on a free-with-limits tier, prove it lifts measurable exam outcomes, and convert a meaningful share to paid (higher limits) via M-Pesa.

**Date:** 2026-06-22
**Owner:** Garnet (product / architecture)
**Status:** Planning

---

## 1. Where Nexus stands today

Nexus is further along than a typical pre-launch product. The following are built and, per the internal audit, broadly working:

- **Learning surfaces:** lessons (`/learn`), practice, diagnostic + academic health score, mastery tracking, mock exams, exam simulator, study plans, revision, progress, profile.
- **Nex AI tutor:** text chat, voice, and camera (photo-of-question) modes, with a Socratic engine, curriculum context, and response validation.
- **Monetization plumbing:** M-Pesa STK push + callback, subscription system, free/premium/family plans, and — importantly — **server-side daily limit enforcement already exists** on Nex chat, camera, and voice via `getNexDailyLimit`, plus configurable free/premium limits for Nex messages and practice sessions (`free_daily_nex_message_limit`, `premium_daily_nex_message_limit`, `free_daily_practice_session_limit`, `premium_daily_practice_session_limit`) and a `NexDailyLimitBanner`.
- **Stakeholder surfaces:** parent dashboard, parent SMS outcomes, super-admin (users, content, payments, usage stats, nex-ops, audit log, beta invites).

The freemium *mechanism* you want already exists. The work ahead is about (a) making the free experience usable and trustworthy enough that 1,000 students don't churn, and (b) making the paid tier obviously worth buying.

### Honest gaps (verified against the codebase)

| Gap | Evidence | Severity for this rollout |
|---|---|---|
| No offline / low-data / PWA support | No service worker, manifest, or offline caching anywhere in `src`/`public` | **Critical** |
| Thin content | ~60 lessons + ~940 practice questions across 3 subjects; several seed lessons are placeholders | **Critical** |
| Limits cover only Nex + practice | Enforcement found only in `api/nex/*`; mock exams, diagnostics, lessons ungated | **High** |
| Not production-hardened | Audit: `undici` high advisory, M-Pesa callback trust, deprecated middleware, failing Playwright e2e | **High** |
| No cohort / teacher layer | Only a teacher *waitlist*; no class grouping or bulk onboarding | **Medium** (matters at 1,000) |
| Conversion moment unproven | Limit banner exists; one-tap path to M-Pesa upgrade not confirmed | **High** (this is the revenue) |

---

## 2. Guiding principles

1. **Free has to prove value before it limits.** A free student should reach the "my predicted grade moved" moment *before* hitting a wall. Limits that bite before the aha-moment cause churn, not conversion.
2. **Gate outcomes, not just costs.** Lock the things students/parents pay for (unlimited mocks, full predicted-grade tracker, high Nex limits) — not only the expensive AI calls.
3. **Assume a shared Android phone on metered data with patchy connectivity.** Every feature is judged against this reality.
4. **Parents pay; students use.** The person spending money mostly experiences Nexus through an SMS. That channel is a first-class product surface, not a notification.
5. **Measure outcomes from day one.** A free pilot only de-risks the paid launch if you can show grade lift and engagement. Instrument before you scale.

---

## 3. Workstreams

Each workstream lists the problem, what to build, acceptance criteria (done = shippable), and rough effort (S ≈ days, M ≈ 1–2 weeks, L ≈ 3+ weeks for one developer).

### WS-1 — Offline & low-data (PWA)  ·  Effort: L  ·  Priority: P0

**Problem.** No offline support. Form 1–4 students share Android phones, buy data in bundles, and lose connectivity (boarding-school prep time, rural areas). An always-online, data-hungry app gets uninstalled fast — and a churned free user never converts.

**Build.**
- Installable PWA: web app manifest, icons, install prompt, splash.
- Service worker with a caching strategy: cache-first for lessons and downloaded practice sets; network-first for Nex/AI and anything that writes.
- "Download for offline" on lessons and practice topics; offline indicator and a sync queue that flushes practice answers + progress when back online.
- **Low-data mode toggle:** defer images, disable autoplay, and surface the data cost of voice/camera before each use ("Voice uses ~X MB").
- Graceful degradation: when offline, hide/queue features that need the network instead of erroring.

**Acceptance criteria.**
- App installs to home screen on Android Chrome.
- A student can open a previously viewed lesson and complete a downloaded practice set with airplane mode on; answers sync on reconnect.
- Lighthouse PWA + offline checks pass; no uncaught errors offline.
- Voice/camera show a data-cost notice before invocation.

### WS-2 — Content depth & coverage  ·  Effort: L  ·  Priority: P0

**Problem.** ~60 lessons can't sustain even one form-year, and some seed lessons are clearly placeholder text. Free users who hit "no content for my topic" in week one won't return, let alone pay.

**Build.**
- **Coverage matrix** (subject × form × topic × lesson × practice-question count) as the source of truth for "what's launch-ready." Build it as a script/report off the seed + DB so it stays honest.
- A **launch-depth decision** (see §6 Open decisions): deep on Math first, or shallow across Math/Science/English. Recommendation: go *deep* on the subjects you launch — depth converts; breadth with gaps churns.
- Replace placeholder lessons with real CBC/KCSE-aligned content; minimum bar per launched topic: lesson + worked examples + a practice bank large enough to avoid repetition (target ≥ 20 questions/topic).
- Seed-completeness tests that fail CI if a "launch-visible" topic is missing lessons or has < N questions.
- A clear "coming soon" state for non-launched subjects so the gap reads as roadmap, not breakage.

**Acceptance criteria.**
- Coverage matrix published; every launch-visible topic meets the minimum bar.
- CI fails on under-filled launch topics.
- No placeholder/lorem content reachable by students.

### WS-3 — Production hardening  ·  Effort: M  ·  Priority: P0

**Problem.** The audit says not production-ready. With real money (M-Pesa) and real minors, these are non-negotiable before launch.

**Build.**
- **M-Pesa callback/webhook trust:** verify source/signature, make handlers idempotent, reconcile against STK query; never grant entitlement on an unverified callback.
- Resolve dependency advisories (`undici` high, `postcss`/Next moderate).
- Migrate deprecated `middleware` → `proxy` (Next 16).
- **Fail-closed env preflight:** app refuses to boot/serve privileged paths if required secrets/config are missing in production.
- Fix the failing public Playwright smoke (CTA role mismatch) and get an authenticated "fresh student → diagnostic complete" e2e green.
- Per-route auth enforcement on all API routes (don't rely on UI-route protection).
- Error monitoring confirmed live (Sentry configs exist — verify they report in prod).

**Acceptance criteria.**
- `npm audit` clean at moderate+; build has no deprecation warnings.
- M-Pesa entitlement granted only after verified, idempotent confirmation; replay/duplicate callbacks are safe.
- Lint, typecheck, unit, scope-check, and the two key e2e paths all green in CI.
- Production boot fails loudly on missing config.

### WS-4 — Freemium gating across all surfaces  ·  Effort: M  ·  Priority: P0

**Problem.** Limits exist only for Nex and practice. Mock exams, diagnostics, and the predicted-grade tracker — your most pay-worthy features — are currently ungated, while the AI chat (which students will tolerate limiting) is the only thing locked.

**Build.**
- A single **entitlements module** that maps `planCode` → limits/access for *every* metered surface (Nex text/voice/camera, practice, mock exams, study-plan regeneration, predicted-grade history depth). Centralize so limits aren't scattered per-route.
- Apply gating server-side on mock exams and any other ungated pay surface.
- A proposed free/paid split (tune in pilot):

  | Surface | Free | Paid |
  |---|---|---|
  | Lessons | Unlimited (core hook) | Unlimited |
  | Nex questions (text) | Small daily allowance | High / effectively unlimited |
  | Nex voice + camera | Very limited (data + cost) | Generous |
  | Practice sessions | Limited/day | Unlimited |
  | Mock exams | 1 per term/subject | Unlimited |
  | Predicted-grade tracker | Current grade only | Full history + trend + per-topic plan |
  | Parent SMS report | Monthly | Weekly |

**Acceptance criteria.**
- Every metered action checks entitlement server-side via one module.
- Plan limits configurable from platform settings (extend existing pattern).
- Free vs paid behavior covered by tests.

### WS-5 — The conversion moment & upgrade path  ·  Effort: M  ·  Priority: P0

**Problem.** Hitting a limit is the single highest-intent moment you get. If the path from "limit reached" to "paid" has friction, the revenue leaks here.

**Build.**
- When a free user hits any limit, show a contextual, personalized upsell ("You've used today's 5 free questions — unlock unlimited before your exam") with a **one-tap M-Pesa STK push** inline (no page hop, pre-filled amount).
- Post-payment: entitlement updates within seconds and the user resumes the exact action they were blocked on.
- Upsell copy tuned per surface (mock-exam wall ≠ chat wall) and timed to peak intent (e.g., evening before assessments).
- Clear paid-state confirmation + receipt; handle pending/failed STK gracefully with retry.

**Acceptance criteria.**
- From a limit wall, a test user completes M-Pesa payment and resumes the blocked action without leaving the flow.
- Failed/cancelled payment returns the user cleanly with a retry.
- Conversion events instrumented (wall shown → STK initiated → paid → resumed).

### WS-6 — Free-tier value-before-limit tuning  ·  Effort: S–M  ·  Priority: P1

**Problem.** Freemium lives or dies on whether the free experience delivers a felt win before the wall.

**Build.**
- Define and instrument the **activation moment**: diagnostic complete → predicted grade shown → first measurable mastery gain.
- Set initial free limits generous enough that a typical first session reaches activation (don't let the chat limit bite during onboarding).
- A/B-able limit config so you can tune during the pilot from platform settings without redeploys.

**Acceptance criteria.**
- ≥ X% of new free students reach activation in session 1 (set target from pilot data).
- Limits adjustable without code deploy.

### WS-7 — Parent SMS as a paid hook  ·  Effort: S–M  ·  Priority: P1

**Problem.** The payer mostly experiences Nexus via SMS. A reliable, outcome-focused message ("Brian did 40 questions this week; predicted grade up to B-") is the strongest justification for spend — and a natural free→paid lever (monthly free, weekly paid).

**Build.**
- Verify the parent-SMS pipeline (`api/admin/outcomes/parent-sms`, `cron/weekly-reports`) actually sends real, accurate, outcome-framed messages — not a stub.
- Tie report cadence to plan (monthly free / weekly paid).
- Include a short, trackable upgrade prompt in the free-tier SMS.

**Acceptance criteria.**
- Parents receive an accurate weekly/monthly report reflecting real activity and grade movement.
- Cadence respects plan; opt-out handled; deliverability monitored.

### WS-8 — Predicted-grade story (the product narrative)  ·  Effort: M  ·  Priority: P1

**Problem.** Students and parents don't buy "AI tutoring." They buy a visibly rising KCSE grade. You already compute mastery + a health score — the work is making the *movement* legible.

**Build.**
- Surface predicted grade prominently with **change over time** ("C+ → B because you mastered Quadratics").
- Per-topic contribution: what to study next to move the grade most.
- Make the full history/trend a paid feature (free shows current grade only).

**Acceptance criteria.**
- Student dashboard shows current predicted grade + recent change with a plain-language reason.
- Trend/history gated to paid.

### WS-9 — Mock-exam KCSE realism  ·  Effort: M  ·  Priority: P2

**Problem.** Realistic, marked KCSE-format mocks with worked solutions are a top reason to pay over a free chatbot.

**Build.**
- Mocks mirror real KCSE paper structure, timing, and marking per subject.
- Worked, step-by-step solutions on review; map wrong answers to misconceptions and to remedial lessons.
- Unlimited mocks as a paid lever (free = limited).

**Acceptance criteria.**
- A student sits a timed mock matching KCSE format, gets a marked result with worked solutions and targeted next steps.

### WS-10 — Cohort onboarding & operator visibility  ·  Effort: M  ·  Priority: P2 (P1 if a school/teacher runs the pilot)

**Problem.** Onboarding ~1,000 students one-by-one (signup → diagnostic → maybe M-Pesa) is painful, and you'll want to see who's active and who's stuck during the pilot.

**Build.**
- Bulk invite codes / join links (extend existing invite-code plumbing) to enroll a cohort quickly.
- A cohort grouping concept and a lightweight operator view (reuse super-admin usage-stats) showing per-student activation, activity, and grade movement across the pilot group.
- If a teacher/school is involved, a minimal teacher view of their class.

**Acceptance criteria.**
- A cohort of test students self-enrolls via codes in minutes.
- Operator can see activation and activity for the whole pilot group in one place.

---

## 4. Sequencing

```
PHASE 0 — Pre-launch (must ship before a single real student)   [WS-1, WS-2, WS-3]
  Offline/PWA · Content depth on launch subjects · Production hardening
  Exit gate: app usable offline on a low-end Android, launch subjects pass the
  content bar, money path verified, CI/e2e green.

PHASE 1 — Monetization-ready launch                              [WS-4, WS-5, WS-8]
  Gating across all surfaces · One-tap upgrade at the wall · Predicted-grade story
  Exit gate: a free user can hit a wall and pay in one flow; grade movement is visible.

PHASE 2 — Convert & retain                                       [WS-6, WS-7, WS-9]
  Free-limit tuning · Parent SMS hook · Mock-exam realism
  Exit gate: activation rate and SMS deliverability hit targets; mocks feel like KCSE.

PHASE 3 — Scale the cohort                                       [WS-10]
  Bulk onboarding · Operator/teacher visibility
  Exit gate: 1,000 students enrolled and observable.
```

Phases 0 → 1 are strictly sequential. Within Phase 2, WS-6/7/9 can run in parallel. WS-10 can start earlier if a school/teacher is the distribution channel.

---

## 5. Metrics (instrument before launch)

- **Activation rate:** % of new free students who complete diagnostic + see predicted grade in session 1.
- **Week-1 / Week-4 retention** (free).
- **Wall → STK → paid funnel** conversion at each step, per surface.
- **Free→paid conversion rate** overall.
- **Outcome proof:** predicted-grade movement distribution across the cohort (the headline pilot result).
- **Data/health:** average data per session, offline-session count, crash/error rate, M-Pesa callback failure/reconciliation rate.
- **SMS:** delivery rate, parent upgrade-link click-through.

---

## 6. Open decisions (need your call)

1. **Launch depth:** deep on Math only, or shallow across Math/Science/English? (Recommend deep.)
2. **Exact free limits** per surface — set starting values, then tune in pilot.
3. **Paid price point(s)** and whether to offer low daily/weekly M-Pesa options vs monthly-only, for affordability.
4. **Distribution:** pure B2C (students/parents find it) or seeded through schools/teachers? (Affects WS-10 priority.)
5. **Minor-data / consent posture:** parental consent and data handling for under-18s — worth nailing down before 1,000 minors are onboarded.

---

## 7. Risk register

| Risk | Mitigation |
|---|---|
| Free users churn on data cost / connectivity | WS-1 offline + low-data mode is P0 |
| Content gaps cause week-1 churn | WS-2 coverage bar + CI gate; honest "coming soon" |
| Money path bug grants/denies wrongly | WS-3 callback trust + idempotency + reconciliation |
| Limits bite before activation → no conversion | WS-6 tuning; generous onboarding limits |
| Pay surfaces ungated → no reason to pay | WS-4 gate outcomes, not just AI cost |
| Minor data/consent exposure at scale | Decision §6.5 before scaling |
| AI cost runs ahead of revenue | Voice/camera tightly limited on free; monitor cost per active user |

---

*This plan synthesizes the current codebase state (verified June 2026) and the internal production-readiness audit. P0 = blocks launch; P1 = needed to convert; P2 = needed to scale.*
