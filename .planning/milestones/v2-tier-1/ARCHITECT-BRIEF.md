---
milestone: v2-tier-1
phase: null
agent: architect
version: 1
status: READY_FOR_PLANNING
inputs:
  - docs/product-governance/product-principles.md
  - docs/product-governance/mvp-feature-scope-lock.md
  - docs/phase-1-foundation/technical-architecture.md
  - docs/phase-2-product-systems/nex-socratic-tutor-engine.md
outputs:
  - .planning/milestones/v2-tier-1/ARCHITECT-BRIEF.md
---

# ARCHITECT-BRIEF — V2 Tier 1 (Post–Private Beta)

**Horizon:** 90–120 days after Private Beta sign-off  
**Verdict:** `READY_FOR_PLANNING`

## Executive summary

Private Beta validates: Kenyan students and parents use a **Nex-first** math companion. V2 Tier 1 converts validation into **habit and exam readiness** via scope-lock Tier 1: Camera, Assessment Mode, Mock Exams, Science + English, Voice — **without forking the Socratic pipeline**.

The codebase is production-shaped (~121 `src/` files, 7 migrations, 85+ tests, 20 Nex golden cases, CI). V2 extends existing subsystems.

## Current state

### Strengths
- Full Nex pipeline (`generateNexResponse` → mode → Socratic → validate → model)
- Learning data model: diagnostic, mastery, practice, Nex sessions, study plans, RLS
- Kenya stack: M-Pesa, Celcom, Resend, Nairobi timezone, DB-driven pricing
- Governance: scope-check, wave planning, FEASIBILITY-UAT script

### Gaps
- Text-only Nex; no camera, voice, or streaming
- Assessment Mode specified but not in UI/`detectNexMode`
- Misconception flywheel designed but not persisted to `student_profiles.metadata`
- Math content thin; Science/English dormant in schema
- E2E = public smoke only; §5 UAT unchecked

### Technical debt (address in V2)
- Admin client per Nex turn — cache before voice/camera traffic
- Thin model router for text vs vision
- Non-streaming chat — stream for 3G perceived latency
- Golden tests offline only — add nightly LLM-as-judge on staging

## Feature bets (Nex-centered)

### 1. Ask Nex with Camera
Photo → vision parse → Homework/Explain → same Socratic rules. Kenya: low-end Android, handwritten + printed KCSE questions. **V2.2, image only.**

### 2. Nex Assessment Mode
In-chat micro-assessments beyond onboarding diagnostic; scores feed mastery + health score. Kenya: "Quick check" framing (CBC continuous assessment culture). **V2.1 first.**

### 3. AI Mock Exams + Exam Simulator
Timed KNEC-style papers (original items), Nex debrief in Revision mode. **V2.3.**

### 4. Science + English
Same Nex spine; extend curriculum context and Learn. No essay ghostwriting for English. **V2.4.**

### 5. AI Voice Tutor
Push-to-talk adapter in front of `/api/nex/chat` — not a separate bot. **V2.5.**

## Architecture decisions

| Area | Decision |
|------|----------|
| Socratic Engine | Build (extend) — core IP |
| Vision | Buy — Gemini multimodal in `callNexModel` |
| STT/TTS | Buy — abstract in `lib/nex/voice/` |
| Exam items | Build — original items only, no scraped KNEC papers |
| Analytics | Buy — PostHog/Amplitude for event taxonomy |
| Model router | Build thin interface — text / vision / fallback |

### Data flywheel
`student actions` → `topic_mastery`, misconceptions, assessment scores` → `loadStudentMemory` → `Nex` → `health score, parent reports, retention`

**New persistence:** `misconception_events` (or metadata JSONB V2.1), `exam_simulations`, `media_uploads` + Storage bucket `nex-uploads` (7-day TTL, student-owned RLS).

## Non-negotiables
- Nex is backbone; pipeline never bypassed from UI
- Homework: no full answer before 3 attempts (camera included)
- Mobile-first 375px; Kenya-first payments/comms
- Freemium forever with caps
- Parents see aggregates, not chat logs or photos
- Scope lock Tier 2+ still banned (study groups, teachers, offline, native apps)

## Risks

| Risk | Mitigation |
|------|------------|
| Camera as cheating tool | Homework default + validator + rate limits |
| Vision parse errors | Student confirms extracted text |
| Voice cost | Push-to-talk + minute caps on free |
| Multi-subject dilutes math | Manifest minimum before marketing |
| Child photo privacy | Short retention, no training use, RLS |

## North-star metrics (beta → V2)

| Metric | Beta target | V2 target |
|--------|-------------|-----------|
| Learning loop completion (diag → Nex → practice / week) | ≥25% WAU | ≥35% |
| Nex depth (msgs × sessions/week) | ≥4 × ≥3 | ≥5 × ≥4 |
| Health score velocity (30d) | Positive | ≥+5 pts |
| Homework answer leak rate | <1% | <1% |

## Recommended sequencing (for Planner)

| Phase | Deliverable |
|-------|-------------|
| **0** | Beta hardening: UAT, streak badge, e2e in CI |
| **2.1** | Assessment Mode + misconception persistence |
| **2.2** | Camera (Homework + Explain) |
| **2.3** | Mock Exams + Exam Simulator |
| **2.4** | Science + English content |
| **2.5** | Voice push-to-talk |

## Open questions
- None blocking Phase 0. Phase 2.4 needs content manifest authorship before Coder starts 2.4.
