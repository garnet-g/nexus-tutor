# Phase-2 Navigation & Presentation Flow Trace — v2-discovery-ux

Date: 2026-06-16  
Scope: Sprint-2 breadcrumb paths, dashboard/progress/study-plan CTAs, discovery-route regression

## Verdict

**PASS** — All five requested flow groups trace end-to-end from UI trigger to valid in-app destination (or guarded redirect). No BLOCKER-level integration breaks found.

One WARNING: study-plan page omits practice/learn CTAs when no plan exists at all (only generate buttons); empty-task CTAs appear only after a plan is created with zero tasks.

## Evidence Inputs

- Phase brief: `.planning/milestones/v2-discovery-ux/phases/phase-2/PHASE-BRIEF.md`
- Coder changelog: `.planning/milestones/v2-discovery-ux/phases/phase-2/CODER-CHANGELOG.md`
- Targeted code inspection across breadcrumb, stat-card, dashboard, progress, study-plan, and discovery route files
- Unit test run: `npm test -- tests/navigation/breadcrumbs.test.tsx` — 3/3 PASS

## Flow Matrix (UI → link/href → route → consumer behavior)

| Flow | UI trigger / path | href / navigation target | Route file | Downstream behavior | Status | Notes |
|---|---|---|---|---|---|---|
| **B1** Learn topic breadcrumbs | `Breadcrumbs` on `/learn/[topicId]` | `Learn` → `/learn`; current = topic title | `learn/[topicId]/page.tsx`, `learn/page.tsx` | `/learn` renders `LearnSubjectExplorer` → `SubjectTree` links to `/learn/{topicId}` | **PASS** | Canonical label "Learn"; topic title is non-link current page |
| **B2** Lesson breadcrumbs | `Breadcrumbs` on `/learn/[topicId]/[lessonId]` | `Learn` → `/learn`; topic → `/learn/{topicId}`; current = lesson title | `learn/[topicId]/[lessonId]/page.tsx` | Topic href resolves to topic page; `TopicList` links lessons at same path pattern | **PASS** | Three-level hierarchy wired; `lesson.topicId` mismatch triggers `notFound()` |
| **B3** Exam simulator breadcrumbs | `Breadcrumbs` on `/exam-simulator?sessionId=…` | `Exam Prep` → `/exam-prep`; current = "Exam Simulator" | `exam-simulator/page.tsx`, `exam-prep/page.tsx` | Missing/invalid `sessionId` redirects to `/exam-prep` before render; valid session loads `ExamSimulatorShell` | **PASS** | Redirect targets canonical `/exam-prep` (not `/mock-exams`) |
| **D1** Dashboard health stat CTA | `StatCard` "Academic Health Score" | `/progress` — "Review progress" | `progress/page.tsx` | Progress page loads `getProgressSummary`, renders focus summary + stat cards | **PASS** | `insight` + `description` + `linkLabel` present |
| **D2** Dashboard streak stat CTA | `StatCard` "Streak" | `/learn` — "Learn today" | `learn/page.tsx` | Learn explorer renders subject/topic tree | **PASS** | |
| **D3** Dashboard recommended topic CTA | `StatCard` "Recommended topic" | `/practice?topicId={id}` or `/practice` — "Practice this topic" | `practice/page.tsx` → `PracticeTopicPicker` | `searchParams.get("topicId")` auto-mounts `PracticeSession` when topic matches | **PASS** | Falls back to topic picker if ID absent/invalid |
| **D4** Dashboard daily goal CTA | `StatCard` "Today's goal" | `/study-plan` — "View study plan" | `study-plan/page.tsx` | Renders daily goal, `StudyPlanActions`, task list when plan exists | **PASS** | |
| **D5** Dashboard pricing CTA | `StatCard` "Premium from" | `/pricing` — "View plans" | `(public)/pricing/page.tsx` | Public pricing display | **PASS** | Subscription config from `getEffectiveSubscriptionConfig()` |
| **D6** Dashboard empty-state CTAs | `DashboardEmptyStates` (when `showEmptyState`) | `/learn`, `/practice`, `/assignment-help`, `/exam-prep` | All route files present | Canonical labels: Learn, Assignment Help, Exam Prep; `Button` + `Link` render pattern | **PASS** | Regression-safe vs Phase 1 empty-state wiring |
| **P1** Progress focus — practice CTA | Focus summary card primary button | `practiceHref` = `/practice?topicId={id}` or `/practice` | `practice/page.tsx` | Same `PracticeTopicPicker` topicId auto-select | **PASS** | Copy adapts: "Practice {topic}" vs "Start practice" |
| **P2** Progress focus — learn CTA | Focus summary secondary button | `learnHref` = `/learn/{topicId}` or `/learn` | `learn/[topicId]/page.tsx` or `learn/page.tsx` | Topic page shows breadcrumbs + `TopicList` | **PASS** | |
| **P3** Progress focus — exam prep CTA | Focus summary tertiary button | `/exam-prep` — "Exam Prep" | `exam-prep/page.tsx` | Renders `ExamPrepWizard` | **PASS** | |
| **P4** Progress stat card CTAs | Three `StatCard`s on progress page | `/exam-prep`, `/learn`, `/study-plan` | Respective pages | Each destination loads authenticated student content | **PASS** | |
| **S1** Study plan empty tasks CTAs | `StudyPlanTaskList` when `plan.tasks.length === 0` | `/practice` — "Start practice"; `/learn` — "Browse Learn" | `practice/page.tsx`, `learn/page.tsx` | Action-led copy + min-h-11 link buttons | **PASS** | Rendered via `study-plan/page.tsx` when `plan` exists |
| **S2** Study plan no-plan state | `study-plan/page.tsx` when `plan === null` | Generate buttons only (no practice/learn links) | N/A | `StudyPlanActions` POSTs `/api/study-plans` then reloads | **WARN** | Empty-task CTAs not shown until plan exists; generate path still wired |
| **R1** Teacher waitlist (regression) | `/waitlist/teacher` | Form → `POST /api/waitlist/teacher` | `(public)/waitlist/teacher/page.tsx` | Unchanged by Phase 2 allowlist | **PASS** | Covered by `e2e/discovery-routes.spec.ts` |
| **R2** Mock-exams redirect (regression) | `/mock-exams` | Server redirect → `/exam-prep` | `mock-exams/page.tsx` | `redirect("/exam-prep")` | **PASS** | E2E asserts URL match |
| **R3** Assignment Help (regression) | `/assignment-help` | Page load, homework mode default | `assignment-help/page.tsx` | Renders `NexChatPanel`; not in Phase 2 allowlist | **PASS** | E2E asserts heading + mode value |
| **R4** Exam Prep wizard (regression) | `/exam-prep` | Page load | `exam-prep/page.tsx` | Renders `ExamPrepWizard`; not in Phase 2 allowlist | **PASS** | E2E asserts heading + start button |

## Component Wiring Summary

| Export / component | Provided by | Consumed by | Called at runtime | Status |
|---|---|---|---|---|
| `Breadcrumbs` | `breadcrumbs.tsx` | learn topic, lesson, exam-simulator pages | Rendered with page-specific `items` arrays | **WIRED** |
| `StatCard` (`insight`, `href`, `linkLabel`) | `stat-card.tsx` | `dashboard/page.tsx`, `progress/page.tsx` | `Link` rendered when `href && linkLabel` | **WIRED** |
| `DashboardEmptyStates` | `DashboardEmptyStates.tsx` | `dashboard/page.tsx` | Conditional on `shouldShowDashboardEmptyState()` | **WIRED** |
| `StudyPlanTaskList` empty branch | `StudyPlanView.tsx` | `study-plan/page.tsx` | When `plan` truthy and `tasks.length === 0` | **WIRED** |
| `PracticeTopicPicker` topicId param | `PracticeSession.tsx` | `practice/page.tsx` | Reads `useSearchParams().get("topicId")` | **WIRED** |

## Breadcrumb Path Detail

| Page | Trail | Clickable ancestors | Current page |
|---|---|---|---|
| `/learn/{topicId}` | Learn / {Topic title} | `/learn` | Topic title (`aria-current="page"`) |
| `/learn/{topicId}/{lessonId}` | Learn / {Topic} / {Lesson} | `/learn`, `/learn/{topicId}` | Lesson title |
| `/exam-simulator?sessionId=…` | Exam Prep / Exam Simulator | `/exam-prep` | Exam Simulator |

Unit tests (`tests/navigation/breadcrumbs.test.tsx`) assert `aria-label="Breadcrumb"`, ancestor `<a href>`, and current-page `<span aria-current="page">` for learn and exam-simulator hierarchies.

## Canonical Label Check (UX-NAV-02)

| Surface | Labels used | Match canonical? |
|---|---|---|
| Breadcrumbs | Learn, Exam Prep | Yes |
| `StudentNav` | Learn, Exam Prep, Assignment Help (overflow) | Yes |
| `DashboardEmptyStates` | Learn, Assignment Help, Exam Prep | Yes |
| Exam simulator redirects | `/exam-prep` (not mock-exams) | Yes |

## Findings

### BLOCKERS

None.

### WARNINGS

1. **Study plan no-plan state (S2)** — When `getActiveStudyPlan` returns `null`, `StudyPlanTaskList` is not mounted and practice/learn CTAs are absent. User must click "Generate daily plan" first. Empty-task CTAs (S1) satisfy UX-DASH-04 for the zero-task case but not the no-plan case.

2. **Practice topicId deep-link** — Dashboard/progress CTAs append `?topicId=`; if the ID is stale or not in `listPracticeTopics`, the picker UI appears instead of auto-starting a session. Graceful degradation, not a break.

## Requirement Integration Map

| Requirement | Integration path | Status | Issue |
|---|---|---|---|
| UX-NAV-01 | Page → `Breadcrumbs` → ancestor `Link` hrefs → learn/exam-prep routes | **WIRED** | — |
| UX-NAV-02 | Breadcrumbs + `StudentNav` + `DashboardEmptyStates` share Learn / Exam Prep / Assignment Help | **WIRED** | — |
| UX-NAV-03 | `StudentNav` MOBILE_NAV_ITEMS (4) + OVERFLOW_NAV_ITEMS unchanged | **WIRED** | — |
| UX-DASH-01 | `StatCard` `insight` prop → rendered in `CardContent` | **WIRED** | — |
| UX-DASH-02 | Dashboard `StatCard`s → `href` + `linkLabel` → destination pages | **WIRED** | — |
| UX-DASH-03 | Progress focus card → practice/learn/exam-prep `Link`s + stat card links | **WIRED** | — |
| UX-DASH-04 | `StudyPlanTaskList` empty branch → practice/learn CTAs | **PARTIAL** | No CTAs when plan is null (S2) |
| Regression (discovery routes) | Phase 1 routes outside allowlist → unchanged handlers + E2E spec | **WIRED** | — |

## Final PASS/FAIL Matrix

| Flow group | Result |
|---|---|
| Breadcrumb navigation (learn topic, lesson, exam simulator) | **PASS** |
| Dashboard stat card CTAs and links | **PASS** |
| Progress focus summary CTAs | **PASS** |
| Study plan empty state CTAs | **PASS** (WARN on no-plan state) |
| Regression: discovery routes | **PASS** |

**Overall: PASS** — Phase 2 navigation and presentation flows are integrated end-to-end with no blockers. Address S2 warning if no-plan study-plan UX should mirror empty-task CTAs.
