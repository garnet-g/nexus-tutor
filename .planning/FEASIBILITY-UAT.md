# Nexus V1 — Feasibility UAT Script

**Version:** 1.0  
**Date:** 2026-06-13  
**Authority:** [MVP Feature Scope Lock §5](../docs/product-governance/mvp-feature-scope-lock.md#5-acceptance-criteria-v1-launch)

This script validates V1 launch readiness through five student personas and two parent flows. Each scenario maps to acceptance criteria in scope lock section 5.

---

## Test environment

| Item | Requirement |
|------|-------------|
| Viewport | 375px width (mobile-first) |
| Browser | Chrome or Safari mobile emulation |
| Accounts | Fresh email per persona; one parent account |
| Payments | M-Pesa sandbox or mock mode |
| Data | Seeded Mathematics curriculum (CBC + KCSE) |

---

## Student personas

### Persona 1 — CBC Grade 6 newcomer (Amina)

**Profile:** First-time Nexus user, CBC Grade 6, targets Band 1, uses phone only.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Visit `/` landing | Hero, Nex/diagnostic/practice features, signup CTA visible | Mobile & UX |
| 2 | Sign up with email | Account created, redirected to onboarding | Auth & Onboarding |
| 3 | Complete onboarding (CBC, Grade 6, school, target) | Profile saved | Auth & Onboarding |
| 4 | Start diagnostic | 20 math questions load | Diagnostic & Health Score |
| 5 | Submit diagnostic | Health score 0–100, predicted band shown | Diagnostic & Health Score |
| 6 | Open dashboard | Health score, streak, recommended topic visible | Diagnostic & Health Score |
| 7 | Open Nex, ask to explain fractions | Socratic response, no full solution dump | Nex AI Tutor |
| 8 | Complete one practice session (10 Q) | Score + weak areas shown | Learn & Practice |

**Pass:** All steps complete without horizontal overflow at 375px.

---

### Persona 2 — KCSE Form 3 repeater (Brian)

**Profile:** Returning user, KCSE Form 3, weak in algebra, uses free tier.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Sign in | Lands on dashboard (diagnostic complete) | Auth & Onboarding |
| 2 | Browse Learn → topic → lesson | Notes + examples render | Learn & Practice |
| 3 | Start practice (medium difficulty) | 10 questions, mastery updates | Learn & Practice |
| 4 | Send 10 Nex messages | 11th message blocked with limit message | Nex AI Tutor |
| 5 | View Progress | Topic mastery, XP, level visible | Progress & Gamification |
| 6 | Check streak after daily activity | Streak increments (Africa/Nairobi) | Progress & Gamification |

**Pass:** Free tier limits enforced server-side.

---

### Persona 3 — Premium trial student (Cynthia)

**Profile:** KCSE Form 4, exam in 6 weeks, starts 7-day trial.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Visit `/pricing` (public) | Prices match `getEffectiveSubscriptionConfig` | Subscriptions & M-Pesa |
| 2 | Sign up and complete diagnostic | Dashboard accessible | Diagnostic & Health Score |
| 3 | Start 7-day premium trial from `/pricing` | Trial active, higher limits | Subscriptions & M-Pesa |
| 4 | Open Study Plan | Exam countdown plan available | Study Plans |
| 5 | Use Nex revision mode | Revision guidance returned | Nex AI Tutor |
| 6 | Attempt homework help | No full answer before 3 attempts | Nex AI Tutor |

**Pass:** Premium limits apply during trial.

---

### Persona 4 — Family plan sibling (David)

**Profile:** Second student on family plan, parent already linked to sibling.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Parent pays Family plan via M-Pesa | Subscription active | Subscriptions & M-Pesa |
| 2 | David signs up independently | Own student profile | Auth & Onboarding |
| 3 | Complete diagnostic | Own health score separate from sibling | Diagnostic & Health Score |
| 4 | David uses Nex and practice | Premium limits apply | Subscriptions & M-Pesa |
| 5 | Verify RLS | David cannot see sibling data | Security |

**Pass:** Data isolation between students confirmed.

---

### Persona 5 — Google OAuth student (Elena)

**Profile:** Signs up with Google, skips password flow.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Sign up with Google | Account created with student role | Auth & Onboarding |
| 2 | Incomplete onboarding → visit `/dashboard` | Redirected to onboarding | Auth & Onboarding |
| 3 | Complete onboarding + diagnostic | Badge on first diagnostic | Diagnostic & Health Score |
| 4 | Navigate full student nav | Dashboard, Learn, Nex, Practice, Progress, Study Plan, Pricing | Mobile & UX |
| 5 | Bottom nav on mobile | Touch targets ≥48px, no overflow | Mobile & UX |

**Pass:** OAuth path matches email signup outcomes.

---

## Parent flows

### Parent flow A — Link and observe (Grace)

**Profile:** Parent of Persona 1 (Amina), free linked account.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Sign up as parent at `/signup?role=parent` | Parent account created | Auth & Onboarding |
| 2 | Enter student invite code | Link succeeds | Parent Corner |
| 3 | Open Parent Dashboard | Study time, health score, weak topics visible | Parent Corner |
| 4 | Verify no chat access | Nex messages not visible to parent | Parent Corner |
| 5 | Attempt to mutate student data | Blocked by RLS | Security |

**Pass:** Parent sees outcomes only, read-only.

---

### Parent flow B — Premium weekly email (Henry)

**Profile:** Parent of premium/trial student.

| Step | Action | Expected result | §5 criterion |
|------|--------|-----------------|--------------|
| 1 | Link to premium student | Dashboard populates | Parent Corner |
| 2 | Trigger weekly report (cron or manual) | Email sent via Resend | Parent Corner |
| 3 | Email content | Study time, score trend, weak topics — no chat logs | Parent Corner |
| 4 | Student downgrades to free | Weekly email stops for that student | Subscriptions & M-Pesa |

**Pass:** Email matches premium-linked rules.

---

## Go / no-go checklist

Reference: [mvp-feature-scope-lock.md §5](../docs/product-governance/mvp-feature-scope-lock.md#5-acceptance-criteria-v1-launch)

### Authentication & Onboarding
- [ ] Student email + Google registration works
- [ ] Parent registration separate from student
- [ ] Onboarding captures curriculum, grade, school, target grade
- [ ] Incomplete onboarding redirects correctly

### Diagnostic & Health Score
- [ ] 20-question math diagnostic (CBC + KCSE)
- [ ] Health score 0–100 with topic breakdown
- [ ] Predicted grade on dashboard
- [ ] Dashboard gated until diagnostic complete

### Learn & Practice
- [ ] Mathematics topic tree browsable
- [ ] Lessons render notes + examples
- [ ] Practice: 10 questions, selectable difficulty
- [ ] Results show score and weak areas
- [ ] Mastery updates after practice

### Nex AI Tutor
- [ ] Four modes: Explain, Practice, Homework, Revision
- [ ] Homework: no full answer before 3 attempts
- [ ] Gemini primary, OpenAI fallback
- [ ] Free tier daily limit enforced server-side
- [ ] Messages logged in `nex_messages`

### Progress & Gamification
- [x] Topic mastery on progress page
- [x] XP and level increment
- [x] Streak (Kenya timezone)
- [x] ≥3 badges achievable

### Study Plans
- [ ] Daily recommended topic on dashboard
- [ ] Exam countdown plan (premium/trial)
- [ ] Daily goal minutes tracked

### Parent Corner
- [ ] Invite-code linking
- [ ] Study time, health score, weak topics visible
- [ ] Weekly email for premium linked students

### Subscriptions & M-Pesa
- [ ] Free forever with daily caps
- [ ] Pricing from DB via `getEffectiveSubscriptionConfig`
- [ ] Admin price change reflects within 60s
- [ ] M-Pesa STK push end-to-end (sandbox)

### Mobile & UX
- [x] All screens functional at 375px (smoke e2e)
- [x] Student bottom navigation
- [ ] Touch targets ≥48px
- [x] No horizontal overflow on key pages (landing smoke)

### Security
- [ ] RLS on all tables
- [ ] No service role in client bundle
- [ ] Cross-student data inaccessible

### Performance
- [ ] Dashboard <3s on throttled 3G
- [ ] Nex response within 5s typical

---

## Private Beta Readiness (implementation status)

The Private Beta milestone build is complete. Execute this UAT script against **staging** (see `docs/DEPLOYMENT.md`) after:

1. Docker local stack or Supabase cloud staging is running
2. `.env.local` / Vercel env vars configured
3. Beta invites generated at `/admin/beta-invites` (when `BETA_INVITE_REQUIRED=true`)

**Automated pre-UAT gates (run locally):**

```bash
npm test              # 87+ tests including streak badge + 20 Nex golden cases
npm run test:scope-check
npm run test:e2e      # Playwright public smoke at 375px (dev server auto-starts)
npm run test:e2e:ci   # Build + e2e with production server (set CI=true)
npm run deploy:check
```

### Engineering pre-verification (2026-06-15)

Automated/code review status before staging walkthrough:

| Area | Status | Evidence |
|------|--------|----------|
| Streak badge `seven_day_streak` | PASS | `practiceService.updateStudentStreak` upserts badge at day 7; `tests/streakBadge.test.ts` |
| Progress achievable badges (≥3) | PASS | Progress page shows diagnostic, practice, 7-day streak |
| Playwright public smoke | PASS | `e2e/smoke.spec.ts` (5 tests) |
| Playwright student auth gate | PASS (when creds set) | `e2e/student-gate.spec.ts` + `E2E_*` env |
| CI includes e2e | PASS | `.github/workflows/ci.yml` |
| Nairobi streak boundary | PASS | Existing `getNairobiDateString()` preserved |

**Staging manual walkthrough:** Personas 1–5 and parent flows A–B still require execution on staging with real Supabase, M-Pesa sandbox, and Resend.

Record results below as you walk through personas.

---

## Go / no-go decision

| Decision | Criteria |
|----------|----------|
| **GO** | All checklist items pass; zero P0/P1 defects; 5 personas + 2 parent flows pass |
| **NO-GO** | Any §5 security item fails; payment flow broken; diagnostic or Nex pipeline bypassed |
| **CONDITIONAL GO** | Minor UX issues only; document fixes with 48h remediation plan |

**Sign-off:**

| Role | Name | Date | Decision |
|------|------|------|----------|
| Product | | | |
| Engineering | | | |
| QA | | | |
