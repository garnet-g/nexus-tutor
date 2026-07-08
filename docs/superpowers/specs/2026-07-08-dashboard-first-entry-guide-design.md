# Dashboard First-Entry Guide Design

**Date:** 2026-07-08

**Status:** Approved design, awaiting implementation planning

**Surface:** Student dashboard

**Selected direction:** Three-step contextual spotlight tour

## Problem

The student dashboard exposes many useful destinations at once. On a student's first arrival after the diagnostic, the page does not make the relationship between the personalized next action, progress feedback, and the wider Nexus toolkit obvious. A new student can understand the individual labels and still be unsure where to begin.

The guide must reduce that first-entry uncertainty without adding permanent dashboard clutter or turning the dashboard into a feature catalogue.

## Goals

- Lead a first-time student into the personalized primary study action.
- Explain only the dashboard concepts needed to act confidently.
- Teach the real interface in context on desktop and mobile.
- Allow immediate skipping and later replay.
- Persist completion at account level across devices.
- Preserve the server-rendered dashboard and existing information architecture.

## Non-goals

- A tour of every Nexus route or sidebar item.
- A replacement for onboarding or the diagnostic.
- A permanent getting-started checklist.
- Product analytics, tour experimentation, or a general-purpose tour framework.
- Changes to the dashboard's data model beyond tour completion state.

## Considered approaches

### Welcome modal

A modal would be obvious and warm, but it would hide the interface the student is supposed to learn and delay the first useful action.

### Three-step contextual spotlight tour — selected

The tour highlights the real dashboard targets and explains them in place. It introduces the personalized action first, treats progress as feedback rather than extra work, and ends with the wider toolkit. It adds no permanent dashboard card.

### Embedded checklist

A checklist would be non-blocking, but it would add another card to an already dense dashboard and could look like another obligation rather than help.

## Student experience

The guide opens automatically on the first dashboard visit after the student has completed the diagnostic and has not completed or skipped the current tour version.

### Step 1: Your next step

- Target: the dashboard's personalized primary-action area.
- Message: Nexus has selected the most useful next study action from the student's plan and recent progress.
- Primary control: **Next**.
- Secondary control: **Skip guide**.

### Step 2: Your progress

- Target: the academic-health and daily-progress region.
- Message: academic health, the daily goal, and the streak are feedback about learning progress, not three additional tasks.
- Primary control: **Next**.
- Secondary controls: **Back** and **Skip guide**.

### Step 3: Your toolkit

- Desktop target: the student navigation/sidebar, including the Ask Nex entry point.
- Mobile target: the bottom navigation, where Nex remains the visually central action.
- Message: the student can explore Learn and Practice or ask Nex for help at any time.
- Primary control: **Start learning**.
- Secondary controls: **Back** and **Skip guide**.

**Start learning** records completion and navigates to the current personalized primary-action URL. **Skip guide** records the same tour version as seen but leaves the student on the dashboard. Either choice prevents automatic reappearance.

The Profile page includes a **Show dashboard guide** link to `/dashboard?guide=1`. Replay does not reset or downgrade persisted tour state.

## Architecture

### Persistence

Add a `dashboard_tour_version` integer column to `student_profiles` with a non-null default of `0`. The application defines `CURRENT_DASHBOARD_TOUR_VERSION = 1`.

The server-rendered dashboard opens the tour when either condition is true:

1. `profile.dashboard_tour_version < CURRENT_DASHBOARD_TOUR_VERSION`, or
2. the validated replay query is present.

An authenticated server action updates only the active student's profile and never accepts a student ID from the client. It records the current server-owned tour version rather than trusting a client-provided version.

This state is intentionally separate from `learning_preferences`, which describes tutoring preferences and may be rewritten by profile updates.

### Rendering boundaries

The dashboard page remains a Server Component. It passes these serializable values into a focused client component:

- whether the tour should initially open;
- whether the tour is a replay;
- the personalized primary-action URL.

The dashboard and `StudentAppShell` expose stable `data-tour` anchors. The tour component finds only those named anchors and does not depend on styling classes or DOM position.

The feature remains dashboard-specific rather than introducing a generic application-wide tour system.

### Tour state

The client component owns the current valid step, open/closed state, and measured target rectangle. It remeasures on viewport resize, scroll, and target changes. If an expected anchor is not rendered at the current breakpoint, the component advances to the next available step. If no valid targets remain, it closes without blocking the dashboard.

## Responsive presentation

### Desktop

- Dim the page while leaving the target visually clear.
- Position the coachmark beside the highlighted target within viewport bounds.
- Keep the target visible without changing dashboard layout.

### Mobile

- Scroll the current target into view before presenting the step.
- Use a bottom sheet for the guide content instead of a small anchored popover.
- Leave enough clearance for the fixed mobile navigation and safe-area inset.
- Highlight the mobile navigation rather than the hidden desktop sidebar on step 3.

Only tour controls are interactive while a step is open, preventing accidental navigation through the dimmed page.

## Accessibility

- Present the guide as a labelled dialog with the current step and total step count.
- Move focus into the guide when it opens and restore focus when it closes.
- Keep keyboard focus within the active guide controls.
- Support Escape as an explicit skip action.
- Announce step changes to assistive technology.
- Maintain visible focus states and sufficient contrast in both themes.
- Respect `prefers-reduced-motion`; motion is optional and never required to understand state.
- Keep **Back**, **Next**, **Start learning**, and **Skip guide** as semantic buttons with unambiguous accessible names.

## Failure handling

- Missing tour anchors are skipped rather than treated as fatal errors.
- If persistence fails, the guide still closes so the student is never trapped.
- A browser-session suppression flag prevents the guide from reopening repeatedly after a failed save during that session.
- After the final persistence attempt, **Start learning** still navigates to the personalized action; a save failure is logged and the browser-session suppression flag prevents an immediate repeat.
- Invalid replay query values are ignored.

## Testing

### Unit and component tests

- Opens for an unseen current tour version and remains closed for a seen version.
- Advances, returns, skips, and completes with the correct labels and state.
- Selects desktop and mobile navigation anchors at their respective breakpoints.
- Skips missing anchors and closes when no anchors exist.
- Traps/restores focus, supports Escape, and announces step changes.
- Uses reduced-motion behavior when requested.
- Suppresses repeat opening in the current session after a persistence failure.

### Server tests

- The completion action requires an authenticated student.
- The action updates only the active student's profile.
- The stored version comes from the server constant.
- Persistence errors return a safe failure result.

### End-to-end tests

- A first-time student sees the tour after the diagnostic-to-dashboard transition.
- Skip prevents automatic reappearance.
- Completion navigates to the personalized primary action and prevents reappearance.
- Profile replay opens the guide without resetting stored state.
- The flow is usable at desktop and mobile viewports with keyboard controls.

## Acceptance criteria

- The tour contains exactly three conceptual steps and does not enumerate every feature.
- It appears automatically only for students whose stored version is older than the current version.
- Completion and skipping persist across devices.
- The final action uses the live personalized primary-action URL.
- Replay is available from Profile.
- Desktop and mobile use the appropriate visible navigation target.
- The dashboard remains fully usable if guide rendering or persistence fails.
- Focus, keyboard, reduced-motion, and screen-reader behavior meet the accessibility requirements above.
