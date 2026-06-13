# MVP Feature Scope Lock

**Version:** 1.0  
**Timeline:** First 90 days  
**Goal:** Validate that students and parents use an AI-powered study companion for CBC and KCSE — not "Can we build Khan Academy?"

**Authority:** This document locks V1 scope. Conflicts with [PRD](./prd.md) long-term vision are intentional deferrals. See [Product Principles](./product-principles.md) for mission and Nex-first rules.

---

## 1. V1 Core User Journey (Locked)

```
Student signs up
    → Selects curriculum (CBC/KCSE)
    → Completes diagnostic test
    → Receives Academic Health Score
    → Gets personalized study plan
    → Uses Nex AI Tutor
    → Completes practice questions
    → Tracks progress
```

Parent observes via lightweight Parent Dashboard.

---

## 2. V1 IN SCOPE ✅

### Curriculum & Content

| Item | Detail |
|------|--------|
| Curricula | CBC + KCSE |
| Subject | **Mathematics only** |
| Content types | Notes, examples, short quiz per lesson |
| Videos | ❌ Not in V1 |

### Modules

| Module | V1 Scope |
|--------|----------|
| Authentication | Email + Google signup/login |
| Onboarding | Curriculum, grade, school, target grade |
| Diagnostic Assessment | 20-question math diagnostic |
| Academic Health Score | Overall + topic breakdown |
| Predicted Grade | KCSE letter grade / CBC band |
| Dashboard | Health score, daily goal, streak, recommended topic |
| Learn | Topic → subtopic → lesson library |
| Practice | Topic + difficulty, 10 questions per session |
| Nex AI Tutor | Explain, Practice, Homework, Revision modes (text). **Assessment Mode = V2** (spec exists in docs) |
| Progress | Study time, XP, mastery, streaks |
| Study Plans | Daily + exam countdown (premium/trial) |
| Parent Corner | Study time, score, weak topics, recent activity |
| Gamification | XP, levels, badges, streaks (minimal) |
| Subscriptions | Freemium: free forever + Premium (799) + Family (2499, 4 seats) |
| M-Pesa | STK push basic subscription payment |
| Free Trial | 7-day premium trial |
| Notifications | Celcom SMS + Resend email (core templates) |
| Platform Admin | Super admin control panel — live pricing, limits, promotions |

### Tech Stack (Locked)

- Next.js 15, TypeScript, Tailwind, shadcn/ui
- Supabase (Auth + Postgres + RLS)
- Nex: **Gemini Flash** primary (`GEMINI_API_KEY`), **OpenAI** fallback (`OPENAI_API_KEY`)
- Vercel hosting

---

## 2.1 Launch Defaults (V1)

### Freemium model

**Free forever** with daily usage caps. Paid plans raise limits — they do not replace core access.

| Setting | Value |
|---------|-------|
| **Free plan** | Forever — never expires |
| **Premium Individual** | **KES 799 / month** — higher daily limits |
| **Family** | **KES 2,499 / month** — up to **4 students**, premium limits each |
| **Free Nex messages** | 10 / day |
| **Free practice sessions** | 3 / day |
| **Premium Nex messages** | 75 / day |
| **Premium practice sessions** | 20 / day |
| **Free trial** | 7 days at premium limits, manual CTA, once per student |
| **Predicted grade** | Visible on dashboard (free + premium) |
| **Daily topic recommendation** | Free |
| **Exam study plan** | Premium or trial |
| **Parent in-app dashboard** | Free when linked |
| **Parent weekly email** | Premium linked students |
| **Parent linking** | Invite code only |
| **Google login** | Optional alongside email |
| **Phone number** | Optional at signup; required for M-Pesa / SMS |
| **CBC grades** | Grade 4–9 |
| **KCSE forms** | Form 1–4 |
| **Timezone** | Africa/Nairobi |
| **Nex context window** | Last 10 message turns |
| **Homework hint escalation** | Level 4 / full solution after **3 attempts** |
| **Student memory (V1)** | Derived from existing tables — no separate memory DB |
| **Confidence / learning style** | V2 |
| **V1 launch gate** | All §5 acceptance criteria pass → private beta ready |

### Screens (13+)

Public: Landing, Pricing, About, Login, Signup  
Student: Onboarding, Diagnostic, Dashboard, Learn, Topic/Lesson, Practice, Nex, Progress, Profile, Subscription  
Parent: Parent Dashboard

---

## 3. V1 BANNED ❌

Do not build, scaffold, or stub these in V1:

| Feature | Reason |
|---------|--------|
| AI Voice Tutor | MVP explicit exclusion |
| Ask Nex with Camera | MVP explicit exclusion |
| AI Mock Exams | V2 |
| Exam Simulator | V2 |
| Study Groups | V2 (PRD Phase 2) |
| Teacher Dashboard | V2 (PRD future phase) |
| School Portals | V2 |
| Career Guidance | V2 (PRD Phase 2) |
| University Pathway Planner | V2 |
| Leaderboards | V2 |
| Holiday Learning Program | V2 |
| Cambridge curriculum | V2 |
| Science, English, Kiswahili active content | V2 (schema/seed may prepare) |
| Nex Assessment Mode (in-chat) | V2 (onboarding diagnostic is V1) |
| Advanced billing (dunning, invoicing automation) | V2 |
| Offline mode | V2 |
| Native mobile apps | V2 (mobile web only) |
| Additional payment providers | Architecture authority rule |
| Alternative AI tutors | Architecture authority rule |

---

## 4. V2 BACKLOG 📋

Prioritized for post-validation:

### Tier 1 (High engagement PRD features)

1. Ask Nex with Camera
2. Nex Assessment Mode (in-session evaluation beyond onboarding diagnostic)
3. AI Mock Exams + Exam Simulator
4. Science + English active content
5. AI Voice Tutor

### Tier 2 (Community & institution)

5. Study Groups
6. Leaderboards
7. Teacher Dashboard
8. School analytics

### Tier 3 (Older student features)

9. Career Guidance Module
10. University Pathway Planner
11. Holiday Learning Program

### Tier 4 (Platform)

12. Cambridge curriculum
13. Kiswahili subject
14. Knowledge graph visualization
15. Advanced parent analytics

---

## 5. Acceptance Criteria (V1 Launch)

### Authentication & Onboarding

- [ ] Student can register with email or Google
- [ ] Parent can register separately
- [ ] Onboarding captures curriculum, grade, school, target grade
- [ ] Incomplete onboarding redirects appropriately

### Diagnostic & Health Score

- [ ] 20-question math diagnostic for CBC and KCSE variants
- [ ] healthScore displayed 0–100 with strong/weak topics
- [ ] Predicted grade shown on dashboard
- [ ] Dashboard blocked until diagnostic complete
- [ ] Badge awarded on first diagnostic

### Learn & Practice

- [ ] Mathematics topic tree browsable for student's curriculum
- [ ] Lessons render notes + examples
- [ ] Practice session: 10 questions, difficulty selectable
- [ ] Results show score and weak areas
- [ ] Mastery updates after practice

### Nex AI Tutor

- [ ] Text chat with Nex in **4 active modes** (Explain, Practice, Homework, Revision)
- [ ] Homework: no full answer before 3 student attempts
- [ ] Gemini Flash primary; OpenAI fallback on failure
- [ ] Curriculum-grounded math responses
- [ ] Free tier daily message limit enforced server-side
- [ ] All messages logged in `nex_messages`

### Progress & Gamification

- [ ] Topic mastery visible on progress page
- [ ] XP and level increment on activities
- [ ] Streak tracks daily activity (Kenya timezone)
- [ ] At least 3 badges achievable (diagnostic, streak, practice)

### Study Plans

- [ ] Daily recommended topic on dashboard
- [ ] Exam countdown plan via Nex revision mode (premium/trial)
- [ ] Daily goal minutes tracked

### Parent Corner

- [ ] Parent links to student via invite code
- [ ] Parent sees study time, health score, weak topics
- [ ] Weekly email report for premium (Resend)

### Subscriptions & M-Pesa

- [ ] Free forever plan with daily caps (10 Nex, 3 practice at launch defaults)
- [ ] Premium/Family pricing read from DB (defaults 799 / 2499)
- [ ] Super admin can change price/limits; pricing page + M-Pesa update within 60s
- [ ] Promotion override (e.g. 699) expires at `promotion_ends_at`
- [ ] Audit log records every admin change

### Mobile & UX

- [ ] All screens functional at 375px width
- [ ] Bottom navigation on student app
- [ ] Touch targets ≥48px

### Security

- [ ] RLS enabled on all tables
- [ ] No service role key in client bundle
- [ ] Student cannot access other student data

### Performance

- [ ] Dashboard loads <3s on 3G
- [ ] Nex response starts streaming/display within 5s typical

---

## 6. Success Metrics (90-Day Validation)

| Metric | Target |
|--------|--------|
| Student signups | Track |
| Diagnostic completion rate | ≥70% of signups |
| Week 1 retention | ≥40% |
| Nex sessions per active student/week | ≥3 |
| Practice sessions per active student/week | ≥2 |
| Parent account creation | ≥20% of student signups |
| Trial → paid conversion | Track (no fixed target V1) |

---

## 7. Scope Change Process

To add a V1-banned feature:

1. Document rationale
2. Update this scope lock document
3. Update affected architecture docs
4. Explicit user/stakeholder approval

Agents must **flag**, not implement, scope expansions.

---

## 8. Conflict Register

| PRD Says | V1 Lock Says | Resolution |
|----------|--------------|------------|
| Diagnostic covers Math, English, Science | Math only | V1 lock |
| Premium includes camera tutoring | Camera V2 | V1 lock |
| Full gamification (leaderboards) | No leaderboards V1 | V1 lock |
| Multiple subjects in Learn pillar | Math only V1 | V1 lock |
| Teachers as secondary users | Future phase | V1 lock |
| GPT vs Gemini | Gemini Flash primary, OpenAI fallback | Resolved |
| Nex Assessment Mode | Onboarding diagnostic V1; in-chat Assessment V2 | Resolved |
| MVP draft `users` table | `student_profiles` per naming | Naming guide |

---

## 9. Definition of Done (V1)

V1 is done when:

1. All acceptance criteria in §5 pass
2. 13+ screens deployed to production
3. M-Pesa sandbox tested end-to-end; production credentials ready
4. Minimum viable math curriculum seeded (all V1 topics)
5. No V1-banned features in codebase
6. Documentation in `docs/` reflects implemented system
