# Design System

**Version:** 1.0  
**Stack:** Tailwind CSS · shadcn/ui · Nexus semantic tokens

---

## 1. Design Principles

1. **Mobile-first** — Design for 375px width first, scale up
2. **Student-first** — Clarity over decoration; learning is the focus
3. **Kenya-first** — Warm, approachable, not cold Silicon Valley generic
4. **Simplicity** — Fewer components, consistent patterns
5. **Accessibility** — WCAG 2.1 AA minimum contrast

---

## 2. Color Tokens

Use semantic names from [Naming Guidelines §28](../product-governance/naming-guidelines.md):

### Brand Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusPrimary` | `#5B4FCF` | Primary actions, Nex accent, links |
| `nexusPrimaryDark` | `#4338A8` | Hover states |
| `nexusSecondary` | `#0EA5E9` | Secondary actions, info |
| `nexusAccent` | `#F59E0B` | XP, streaks, highlights |

### Surface Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusBackground` | `#FAFAFA` | Page background |
| `nexusSurface` | `#FFFFFF` | Cards, modals |
| `nexusSurfaceElevated` | `#FFFFFF` | Dropdowns (with shadow) |
| `nexusBorder` | `#E5E7EB` | Dividers, card borders |

### Text Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusTextPrimary` | `#111827` | Headings, body |
| `nexusTextSecondary` | `#6B7280` | Captions, metadata |
| `nexusTextInverse` | `#FFFFFF` | Text on primary buttons |

### Semantic Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusSuccess` | `#10B981` | Correct answers, mastery ≥70% |
| `nexusWarning` | `#F59E0B` | Developing mastery, alerts |
| `nexusDanger` | `#EF4444` | Errors, weak mastery |

### Tailwind Config Mapping

```ts
// tailwind.config.ts
colors: {
  nexus: {
    primary: '#5B4FCF',
    secondary: '#0EA5E9',
    accent: '#F59E0B',
    background: '#FAFAFA',
    surface: '#FFFFFF',
    success: '#10B981',
    warning: '#F59E0B',
    danger: '#EF4444',
  }
}
```

**Banned:** `purple1`, `blue2`, `mainColor`, generic AI gradient slop

---

## 3. Typography

### Font Stack

```css
--font-sans: 'Inter', system-ui, -apple-system, sans-serif;
--font-display: 'Inter', system-ui, sans-serif;
```

**V1:** Inter only (single font family). Add display font in V2 if brand requires.

### Scale (Mobile-First)

| Token | Size | Weight | Usage |
|-------|------|--------|-------|
| `text-display` | 28px / 1.2 | 700 | Dashboard greeting |
| `text-h1` | 24px / 1.3 | 700 | Page titles |
| `text-h2` | 20px / 1.35 | 600 | Section headers |
| `text-h3` | 18px / 1.4 | 600 | Card titles |
| `text-body` | 16px / 1.5 | 400 | Body text |
| `text-body-sm` | 14px / 1.5 | 400 | Secondary text |
| `text-caption` | 12px / 1.4 | 500 | Labels, badges |
| `text-score` | 36px / 1.1 | 700 | Health Score display |

### Rules

- Minimum body text: 16px on mobile
- Line length: max 65 characters for lesson content
- No ALL CAPS except badges/labels

---

## 4. Spacing

Base unit: **4px**

| Token | Value | Usage |
|-------|-------|-------|
| `space-1` | 4px | Tight inline |
| `space-2` | 8px | Icon gaps |
| `space-3` | 12px | Card internal padding (compact) |
| `space-4` | 16px | Standard padding |
| `space-6` | 24px | Section gaps |
| `space-8` | 32px | Page section spacing |
| `space-12` | 48px | Major section breaks |

### Page Layout

```
Mobile padding: px-4 (16px)
Desktop max-width: max-w-2xl (672px) for student app — focused, not wide dashboard
Desktop max-width: max-w-4xl (896px) for parent dashboard
```

---

## 5. Card Styles

### Standard Card (`StudentDashboardCard`)

```tsx
className="
  bg-nexus-surface
  border border-nexus-border
  rounded-2xl
  p-4
  shadow-sm
"
```

### Health Score Card (`AcademicHealthScoreCard`)

- Large score number (`text-score`)
- Circular progress ring or arc
- Subject breakdown below
- `nexusPrimary` accent on score

### Action Card (Continue Learning)

- Left: topic icon + title
- Right: chevron
- Full-width tap target (min 48px height)
- `nexusPrimary` left border accent (4px)

### Nex Chat Bubble

| Role | Style |
|------|-------|
| Student | `bg-nexus-primary text-white rounded-2xl rounded-br-sm` |
| Nex | `bg-nexus-surface border border-nexus-border rounded-2xl rounded-bl-sm` |

**No cards inside cards inside cards.**

---

## 6. Dashboard Layout

### Student Dashboard (Mobile)

```
┌─────────────────────────┐
│ Good Morning, {name}    │  ← Greeting
├─────────────────────────┤
│ Academic Health Score   │  ← Hero card
│ 67%  Predicted: B-      │
├─────────────────────────┤
│ Today's Goal │ Streak   │  ← 2-col stat row
│ 20 min       │ 🔥 5     │
├─────────────────────────┤
│ Continue: Linear Eqs →  │  ← Action card
├─────────────────────────┤
│ Recommended Topic       │
├─────────────────────────┤
│ Bottom Nav              │  ← Home | Learn | Nex | Progress
└─────────────────────────┘
```

### Bottom Navigation (Student)

| Tab | Icon | Route |
|-----|------|-------|
| Home | Home | `/dashboard` |
| Learn | Book | `/learn` |
| Nex | Sparkle | `/nex` |
| Progress | Chart | `/progress` |

Nex tab uses `nexusPrimary` accent — central feature.

---

## 7. Components (shadcn/ui Base)

Use shadcn primitives wrapped with Nexus tokens:

| shadcn | Nexus Wrapper |
|--------|---------------|
| Button | `NexusButton` (primary, secondary, ghost) |
| Card | `NexusCard` |
| Input | `NexusInput` |
| Dialog | `NexusModal` |
| Progress | `NexusProgress` |
| Badge | `NexusBadge` |
| Tabs | `NexusTabs` |

Component names from [Naming Guidelines §26](../product-governance/naming-guidelines.md).

---

## 8. Motion

- Subtle only — no heavy animations on mobile (performance)
- Page transitions: 150ms ease
- Score updates: count-up animation (optional)
- Streak flame: gentle pulse
- Respect `prefers-reduced-motion`

---

## 9. Icons

- Lucide icons (shadcn default)
- 20px standard, 24px navigation
- Stroke width: 1.5

---

## 10. Dark Mode

**V1:** Light mode only. Design tokens structured for future dark mode addition.

---

## 11. Do / Don't

| Do | Don't |
|----|-------|
| Large tap targets (48px min) | Tiny click areas |
| One primary CTA per screen | Multiple competing CTAs |
| Semantic color tokens | Hardcoded hex in components |
| Mobile-first layouts | Desktop-first shrinking |
| Nex as teacher personality | Generic chatbot UI |
