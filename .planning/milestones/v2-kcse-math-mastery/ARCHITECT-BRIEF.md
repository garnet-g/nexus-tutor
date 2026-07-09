---
milestone: v2-kcse-math-mastery
phase: 0
agent: architect
version: 1
status: DRAFT
inputs:
  - docs/product-governance/product-principles.md
  - docs/product-governance/mvp-feature-scope-lock.md
  - docs/phase-2-product-systems/nex-socratic-tutor-engine.md
  - docs/phase-2-product-systems/academic-health-score-engine.md
  - .planning/milestones/production-readiness/STATUS.md
outputs:
  - .planning/milestones/v2-kcse-math-mastery/ARCHITECT-BRIEF.md
---

# ARCHITECT-BRIEF — KCSE Math Mastery

## Executive summary

Nexus already has the core components for a strong KCSE Mathematics product: diagnostic, health score, predicted grade, exam prep, simulator, and Nex pipeline. This milestone hardens the learner loop for market leadership by unifying mobile IA around three student jobs, making assessment-driven Nex tutoring visible and reliable, and closing the outcome loop from mock performance to grade movement and parent-visible proof.

## Current state

### Strengths
- Exam prep and simulator are live and tested.
- Predicted grade and health score pipeline already exists.
- Nex teaching engine supports structured modes and memory signals.
- Math content depth is strong across Forms 1–4.

### Gaps
- Mobile IA still hides exam-prep/help actions behind deep links.
- Student-facing naming drifts across mock/exam-prep/simulator surfaces.
- Parent dashboard lacks live predicted-grade visibility.
- Nex assessment behavior exists server-side but is underexposed and partially heuristic.

### Technical debt to address in this milestone
- Inconsistent API field usage for simulator session IDs.
- Redirect-only `/mock-exams` route leaves history UX fragmented.
- Practice/assessment metadata fields are partially unused.

## Feature bets (ambitious, Nex-centered)

### Bet 1 — Mobile exam-prep clarity
- **Problem:** Students cannot immediately see "learn, get help, prep exams" in one mobile composition.
- **Solution:** Normalize mobile and desktop IA with clear job-oriented entry points.
- **Nex backbone tie-in:** "Get help now" stays anchored to Nex, not a separate tutor stack.
- **Kenya edge:** Optimized for phone-first study behavior with short-session exam prep.
- **Guardrail:** Preserve existing routes and functionality; no broad IA rewrite outside student surfaces.

### Bet 2 — Outcome loop trust
- **Problem:** Learners and parents need clear evidence that work translates to grade movement.
- **Solution:** Unify grade semantics and surface mock trend + predicted grade across student/parent views.
- **Nex backbone tie-in:** Mock and assessment outcomes feed weak-topic remediation and next learning actions.
- **Kenya edge:** Parent-visible outcomes increase trust for M-Pesa-funded subscriptions.
- **Guardrail:** Honest "KCSE-style" labeling only; no past-paper claims.

### Bet 3 — Nex as a KCSE Math teacher
- **Problem:** Nex feels helpful but not consistently assessment-driven.
- **Solution:** Surface assessment mode, strengthen answer grading, and feed results into study actions.
- **Nex backbone tie-in:** Uses `generateNexResponse` pipeline and existing memory/services only.
- **Kenya edge:** Form-aware coaching language and exam-focused remediation.
- **Guardrail:** No new AI providers, no bypasses, no subject expansion in this milestone.

## Architecture decisions

### Build vs buy
| Capability | Decision | Rationale |
|------------|----------|-----------|
| Mobile IA + exam loop UX | Build in existing app shell | Must match current Nexus navigation contracts |
| Assessment grading and handoff | Build on existing Nex services | Preserves single teaching pipeline and telemetry |
| Parent proof surfaces | Build in existing parent dashboard | Reuses current profile/progress data flows |

### AI evaluation strategy
| Layer | What | When |
|-------|------|------|
| Unit | Assessment scoring behavior and metadata updates | Phase 3 |
| Integration | Mock submit -> health/grade/plan updates | Phase 2 |
| End-to-end | Diagnostic -> mock -> Nex assessment -> plan task | Phase 4 |

### Data flywheel
- Diagnostic + mock + Nex assessment events update mastery and misconceptions.
- Memory/context loaders shape next prompt and revision actions.
- Parent/student surfaces show grade direction and weak-topic movement.

## Non-negotiables
- Mathematics-only scope for this milestone.
- Do not pause production-readiness program.
- Never bypass `generateNexResponse`.
- No hardcoded plan prices or limits.

## Risks and mitigations
| Risk | Severity | Mitigation |
|------|----------|------------|
| Nav changes regress student discoverability | Medium | Keep route contracts stable and validate with e2e |
| Grade semantics confusion persists | High | Define single authority in services and UI copy |
| Nex assessment over-correction breaks tone | Medium | Reuse Socratic constraints and golden tests |

## North-star metrics
| Metric | Beta target | Milestone target |
|--------|-------------|------------------|
| Mock completion rate (F3/F4) | Baseline +10% | Baseline +25% |
| Weekly active exam-prep users | Baseline +15% | Baseline +30% |
| Students with visible grade movement | Baseline +10% | Baseline +25% |
| Parent dashboard grade visibility adoption | 0% -> 40% | 60%+ of linked parents |

## Recommended sequencing (for Planner)
| Phase | Deliverable | Depends on |
|-------|-------------|------------|
| 1 | Mobile exam-prep UX unification | none |
| 2 | Outcome loop semantics + parent proof | 1 |
| 3 | Nex assessment-driven teaching loop | 2 |
| 4 | Closed-loop integration proof | 1,2,3 |

## Verdict

`READY_FOR_PLANNING`
