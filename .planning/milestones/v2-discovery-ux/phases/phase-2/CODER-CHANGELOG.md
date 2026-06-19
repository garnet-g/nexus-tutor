# Phase 2 — Coder Changelog

## Summary

Navigation breadcrumbs, canonical label alignment in empty-state CTAs, and action-led dashboard/progress/study-plan presentation.

## Criteria addressed

| ID | Status | Notes |
|---|---|---|
| UX-NAV-01 | Done | Breadcrumbs on learn topic, lesson, and exam-simulator pages |
| UX-NAV-02 | Done | StudentNav already uses Learn, Assignment Help, Exam Prep; dashboard empty-state CTAs aligned |
| UX-NAV-03 | Done | Mobile nav unchanged (4 primary + overflow) |
| UX-DASH-01 | Done | StatCard `insight` prop for why-it-matters copy |
| UX-DASH-02 | Done | Dashboard stat cards include description, insight, and next-action links |
| UX-DASH-03 | Done | Progress page focus summary with practice/learn/exam-prep CTAs |
| UX-DASH-04 | Done | StudyPlanView empty tasks state with action-led copy and links |

## Files touched

| File | Change |
|---|---|
| `src/components/layout/breadcrumbs.tsx` | **New** — accessible breadcrumb nav component |
| `src/components/layout/stat-card.tsx` | Added optional `insight` prop |
| `src/app/(student)/learn/[topicId]/page.tsx` | Replaced back link with breadcrumbs |
| `src/app/(student)/learn/[topicId]/[lessonId]/page.tsx` | Replaced back link with breadcrumbs |
| `src/app/(student)/exam-simulator/page.tsx` | Added Exam Prep → Exam Simulator breadcrumbs |
| `src/app/(student)/dashboard/page.tsx` | Enhanced stat cards with insight + action copy |
| `src/app/(student)/progress/page.tsx` | Action-led focus summary + enhanced stat cards |
| `src/features/studyPlan/components/StudyPlanView.tsx` | Empty-task state with practice/learn CTAs |
| `src/features/dashboard/components/DashboardEmptyStates.tsx` | Canonical CTA labels (Learn, Assignment Help, Exam Prep) |
| `tests/navigation/breadcrumbs.test.tsx` | Component tests with `@testing-library/react` (aria-current, links vs current span) |

## Verification

```bash
npm run lint          # pass
npm run typecheck     # pass
npm test              # 16 files, 144 tests pass
npm run test:scope-check  # pass
npm run build         # pass
```

## Audit remediation (post-QA)

- **Breadcrumbs tests** — Replaced helper-only `breadcrumbs.test.ts` with `breadcrumbs.test.tsx` rendering the real `Breadcrumbs` component via `@testing-library/react`; asserts `aria-label`, ancestor `<a>` links, and current-page `<span aria-current="page">`.
- **Exam simulator redirects** — All fallback redirects in `exam-simulator/page.tsx` now target `/exam-prep` directly instead of `/mock-exams`, matching canonical Exam Prep IA.
