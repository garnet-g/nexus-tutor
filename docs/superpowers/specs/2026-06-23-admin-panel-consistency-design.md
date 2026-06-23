# Admin Panel — Consistency Pass & UX Elevation

**Date:** 2026-06-23
**Status:** Approved (design) — pending spec review
**Scope:** All 10 super-admin pages under `src/app/(super-admin)/admin/*`

## Problem

The admin console renders in three inconsistent visual tiers:

1. **Broken tier** — `PlatformSettingsEditor.tsx` and `BetaInvitesPanel.tsx` use `bg-primary`
   (the teal brand color) as the *panel* background and hand-roll raw `<input>`/`<button>`
   elements. Result: loud teal blocks with floating near-black "pill" inputs that match
   nothing else in the app.
2. **Off-token tier** — `usage-stats/page.tsx` re-implements a local `StatCard` and page
   header using the legacy `bg-card`/`border-border` tokens instead of the shared
   `bg-nexus-surface`/`border-nexus-border`.
3. **Good tier** — Users, Payments, Outcomes, Audit log, Nex ops already use the shared
   `PageHeader`/`Panel`/`StatCard` from `adminUi.tsx`. But even these duplicate:
   filter-pill groups (3×), status pills (3 near-identical implementations), table
   scaffolding (~6×), and inline `<p>` mutation messages everywhere.

There is no shared form vocabulary, no toast system, and no confirmation dialog, so every
new admin surface diverges further.

## Goals

- One design language across all 10 pages (consistency pass — keep current dark + teal-accent system).
- Extract the missing shared primitive layer so future pages stay consistent by default.
- Add four UX upgrades: toasts + confirm dialogs, empty/loading states, table search/sort/CSV
  export, and copy-to-clipboard + micro-polish.
- **No behavior or data changes** beyond the additive features above. This is a UI/DRY pass.

## Non-Goals

- Merging or renaming the duplicate Nex ops dashboards (see Known Issues — flagged only).
- Any change to admin API routes, services, or auth guards.
- Visual redesign / new brand direction.

## Design

### Part 1 — Shared primitive layer

Extend `src/features/admin/components/adminUi.tsx` and add a sibling
`src/features/admin/components/adminForm.tsx`. All primitives consume existing
`nexus-*` tokens (verified present in `globals.css`) and the existing
`@/components/ui/Button`.

| Primitive | Replaces | Notes |
|-----------|----------|-------|
| `Field` (label + control + hint/error) | hand-rolled `<label><span/><input/></label>` | wraps any control |
| `Input`, `Select`, `Textarea`, `Checkbox` | raw inputs on `bg-background`/`bg-primary` | shared focus ring, `bg-nexus-sunken` surface |
| `StatusBadge` (`tone` prop) | `SubscriptionPill`, `StatusPill`, active/inactive pill | tones: `success`/`warning`/`danger`/`neutral`/`info` |
| `FilterTabs` | duplicated filter-pill blocks in Users/Payments/Outcomes | link-based, preserves existing query-param behavior |
| `SearchInput` | inline `<form method=get>` search | GET-form preserving behavior; adds clear button |
| `DataTable` | repeated `<table>` head/body/empty-state markup | `columns` config + `emptyMessage`; keeps server-rendered rows |
| `useToast` + `<Toaster>` | inline `<p className="text-red-400">` messages | client provider mounted in layout |
| `ConfirmDialog` | unguarded destructive actions | wraps publish, comp subscription, impersonate, send SMS |

The `Button` component already exists and is correct — the fix is to *use* it in the
broken-tier files instead of raw `<button className="bg-card">`.

### Part 2 — Per-page migration

- **Platform settings, Beta invites** (broken tier): rewrite with `Panel` + form primitives +
  `Button`. Remove all `bg-primary` panel backgrounds. Mutation feedback → toasts.
- **Usage stats** (off-token): replace local `StatCard`/header with shared `PageHeader`/`StatCard`/`Panel`/`DataTable`.
- **Users, Payments, Outcomes, Audit log, Nex ops** (good tier): swap duplicated pills →
  `StatusBadge`, filter blocks → `FilterTabs`, tables → `DataTable`. Visual output is
  effectively unchanged; the code converges. Add `SearchInput` to Audit log (currently none).

### Part 3 — UX features (all four selected)

1. **Toasts + confirm dialogs** — `<Toaster>` mounted once in `(super-admin)/layout.tsx`;
   `useToast()` for save/create/delete results. `ConfirmDialog` gates destructive/sensitive
   mutations: content publish, comp subscription, impersonate / view-as-student, at-risk parent SMS.
2. **Empty & loading states** — iconographic `EmptyState` primitive for "no rows"; per-route
   `loading.tsx` skeletons (Content already has one as the pattern to follow).
3. **Table search + sort + CSV export** — `SearchInput` where missing; client column sort in
   `DataTable` (sort the already-fetched page, no new queries); `ExportCsvButton` for
   ledger / audit / users tables.
4. **Copy-to-clipboard + polish** — `CopyButton` for invite codes and IDs (audit actor/target,
   M-Pesa refs); consistent focus rings, hover states, and `tabular-nums` on all numeric cells.

## Architecture & boundaries

- **Presentation-only.** Primitives live in `src/features/admin/components/`. No server,
  service, or schema files change. Existing pages keep server-side data fetching and
  query-param filtering exactly as-is; `DataTable`/`FilterTabs`/`SearchInput` render the
  same server-provided data and emit the same URLs.
- **Client islands stay small.** `Toaster`, `ConfirmDialog`, `CopyButton`, `ExportCsvButton`,
  and sort interactions are client components; pages remain server components where they
  already are.
- **Each primitive is independently testable:** given props → known markup; no hidden deps.

## Testing

- Unit/component tests for new primitives (`StatusBadge` tones, `DataTable` empty state,
  `FilterTabs` href generation, `CopyButton`, `ConfirmDialog` confirm/cancel).
- Existing admin tests must continue to pass (they assert routes/contracts, not styling).
- Manual visual check of all 10 pages in the running app before completion.

## Known Issues (flagged, not fixed this pass)

- **Duplicate Nex ops dashboards.** `/admin/usage-stats` (titled "Nex ops", backed by
  `nexOpsService` + `NexOpsReviewPanel`) and `/admin/nex-ops` (titled "Nex ops", backed by
  `adminNexOpsReadService` + `NexFlagReviewPanel`) show overlapping metrics; the nav labels
  the first "Usage stats." Both will be styled consistently here, but consolidation/rename
  is deferred to a separate decision.

## Rollout

Single PR, no migrations, no env changes. Reversible by revert.
