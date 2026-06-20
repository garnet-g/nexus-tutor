# Design System

**Version:** 2.0
**Stack:** Tailwind CSS v4 (`@theme`) · shadcn/ui (Base UI) · Nexus semantic tokens
**Supersedes:** v1.0 (generic purple + Inter-only + emoji stack)

---

## 0. What changed in v2.0 and why

v1.0 said the right things ("warm, approachable, not cold Silicon Valley generic") but specified the exact recipe that produces cold Silicon Valley generic: a default AI-SaaS purple (`#5B4FCF`), Inter-as-everything, uniform `rounded-2xl` cards, flat `shadow-sm`, and emoji for streaks. A student could not tell the result apart from a crypto dashboard.

v2.0 replaces the **identity layer** (color, type, depth, iconography, the role of Nex) while keeping the **good structural decisions** (mobile-first, 4px spacing, accessibility floor, component-wrapping pattern). The goal is a product that looks like *someone made deliberate choices* — warm, scholarly, premium, unmistakably Nexus.

**Design north star:** Nexus is a *companion*, not a dashboard. The UI should feel like a good notebook and a patient teacher — warm paper, considered type, calm focus, one clear next step — not an analytics panel.

---

## 1. Design Principles

1. **Companion, not dashboard** — Every screen answers "what do I do next?" before "here are your stats."
2. **Nex has a face** — Nex is the backbone; it gets a consistent visual presence, voice color, and motion, never a generic chatbot shell.
3. **Mobile-first** — Design for 375px width first, scale up.
4. **Warm scholarship** — Clarity with character. Warm paper, real depth, deliberate type. Decoration serves focus.
5. **Kenya-first** — Warm, grounded, locally legible — not imported SV minimalism, not tourist-cliché either.
6. **Accessibility** — WCAG 2.1 AA minimum contrast, always (all pairings below are AA-verified).

---

## 2. Color Tokens

The identity is **Deep Emerald + Warm Amber on warm paper**. Emerald carries trust, focus and growth (the brand and Nex); amber carries energy, achievement and warmth (XP, streaks, milestones). The canvas is warm paper, not cold gray — this single change removes most of the "AI-generated" feel.

> **Hard rule:** No purple. No multi-stop hero gradients ("AI gradient slop"). No pure cold gray (`#FAFAFA`/`#111827`) — warm equivalents only.

### Brand Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusPrimary` | `#15564B` | Primary actions, Nex voice, links, brand. Deep emerald. |
| `nexusPrimaryHover` | `#0F4339` | Hover/pressed states |
| `nexusPrimarySoft` | `#E3EFEA` | Tinted fills, selected states, Nex message background |
| `nexusAccent` | `#E0883B` | XP, streaks, achievements, highlights. Warm amber. |
| `nexusAccentSoft` | `#FBEEDD` | Achievement card fills, badge backgrounds |

### Surface Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusCanvas` | `#FAF7F2` | Page background (warm paper) |
| `nexusSurface` | `#FFFFFF` | Cards, modals, sheets |
| `nexusSurfaceSunken` | `#F3EFE8` | Insets, input wells, code/quiz blocks |
| `nexusBorder` | `#E7E1D6` | Dividers, card hairlines (warm, not gray) |
| `nexusBorderStrong` | `#D6CDBD` | Emphasized separators |

### Text Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusInk` | `#1A1A17` | Headings, body (warm near-black) |
| `nexusInkSecondary` | `#5C574E` | Captions, metadata, supporting copy |
| `nexusInkMuted` | `#8C857A` | Placeholders, disabled |
| `nexusInkInverse` | `#FBF8F3` | Text on emerald/dark surfaces |

### Semantic Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `nexusSuccess` | `#2F8F6B` | Correct answers, mastery ≥70% |
| `nexusSuccessSoft` | `#E0F0E8` | Success backgrounds |
| `nexusWarning` | `#C7791F` | Developing mastery, alerts (amber, darkened for text legibility) |
| `nexusDanger` | `#C2412F` | Errors, weak mastery (warm clay-red, not fire-engine) |
| `nexusDangerSoft` | `#F7E3DE` | Error backgrounds |

### Verified contrast (WCAG 2.1 AA)

| Pairing | Ratio | Result |
|---------|-------|--------|
| `nexusInk` on `nexusCanvas` | 16.6:1 | AAA |
| `nexusInkSecondary` on `nexusCanvas` | 6.9:1 | AA (incl. small text) |
| `nexusPrimary` on `nexusCanvas` | 8.0:1 | AAA |
| `nexusInkInverse` on `nexusPrimary` | 8.5:1 | AAA |
| `nexusInk` on `nexusAccent` | 6.6:1 | AA |

> **Amber rule:** `nexusAccent` is a *fill/icon* color, never a text color on white (it fails contrast). Put `nexusInk` on top of amber, or use `nexusWarning` when amber-toned text is needed.

### Tailwind v4 `@theme` mapping

```css
/* app/globals.css */
@import "tailwindcss";

@theme {
  /* Brand */
  --color-nexus-primary:        #15564B;
  --color-nexus-primary-hover:  #0F4339;
  --color-nexus-primary-soft:   #E3EFEA;
  --color-nexus-accent:         #E0883B;
  --color-nexus-accent-soft:    #FBEEDD;

  /* Surfaces */
  --color-nexus-canvas:         #FAF7F2;
  --color-nexus-surface:        #FFFFFF;
  --color-nexus-surface-sunken: #F3EFE8;
  --color-nexus-border:         #E7E1D6;
  --color-nexus-border-strong:  #D6CDBD;

  /* Ink */
  --color-nexus-ink:            #1A1A17;
  --color-nexus-ink-secondary:  #5C574E;
  --color-nexus-ink-muted:      #8C857A;
  --color-nexus-ink-inverse:    #FBF8F3;

  /* Semantic */
  --color-nexus-success:        #2F8F6B;
  --color-nexus-success-soft:   #E0F0E8;
  --color-nexus-warning:        #C7791F;
  --color-nexus-danger:         #C2412F;
  --color-nexus-danger-soft:    #F7E3DE;
}
```

Usage: `bg-nexus-primary`, `text-nexus-ink`, `border-nexus-border`. **Never hardcode hex in components.**

---

## 3. Typography

Inter-as-everything is a core reason v1 read as generic. v2 pairs a **characterful display serif** for human moments (greetings, scores, headings) with a **clean grotesk** for UI and body. A serif + grotesk pairing reads premium and scholarly and is instantly un-templated.

### Font Stack

```css
--font-display: 'Fraunces', Georgia, 'Times New Roman', serif;  /* warm optical serif, personality */
--font-sans:    'Hanken Grotesk', 'Inter', system-ui, sans-serif; /* body + UI */
--font-numeric: 'Hanken Grotesk', system-ui, sans-serif; /* tabular figures for scores/XP */
```

- **Display (Fraunces):** greetings, page titles, the Health Score number, Nex's name, celebratory moments. Use the "Soft" optical setting; weights 400–600. Gives Nexus a voice.
- **Body/UI (Hanken Grotesk):** everything else. Warmer and rounder than Inter, still neutral. Inter remains an acceptable fallback if a second webfont is a performance concern — but Fraunces for display is non-negotiable, it is the single biggest anti-generic lever.
- **Numbers:** enable `font-variant-numeric: tabular-nums` everywhere a number changes (score, XP, streak, timers) so digits don't jitter.

> Two webfonts max. Subset to Latin + the glyphs used. Self-host (`next/font/local`) for control and speed on Kenyan mobile networks.

### Scale (Mobile-First)

| Token | Size / line | Weight | Font | Usage |
|-------|-------------|--------|------|-------|
| `text-score` | 44px / 1.05 | 500 | Display | Health Score, big numbers |
| `text-display` | 30px / 1.15 | 500 | Display | Dashboard greeting |
| `text-h1` | 24px / 1.25 | 600 | Display | Page titles |
| `text-h2` | 20px / 1.3 | 600 | Sans | Section headers |
| `text-h3` | 18px / 1.4 | 600 | Sans | Card titles |
| `text-body` | 16px / 1.55 | 400 | Sans | Body text |
| `text-body-sm` | 14px / 1.5 | 400 | Sans | Secondary text |
| `text-caption` | 12px / 1.4 | 500 | Sans | Labels, badges |

### Rules

- Minimum body text 16px on mobile; lesson content line length max 66 characters.
- Display serif for *moments*, not paragraphs — never set body copy in Fraunces.
- No ALL CAPS except short badges/labels (with `+0.04em` tracking).

---

## 4. Spacing

Base unit: **4px** (unchanged — this part of v1 was right).

| Token | Value | Usage |
|-------|-------|-------|
| `space-1` | 4px | Tight inline |
| `space-2` | 8px | Icon gaps |
| `space-3` | 12px | Compact card padding |
| `space-4` | 16px | Standard padding |
| `space-6` | 24px | Section gaps |
| `space-8` | 32px | Page section spacing |
| `space-12` | 48px | Major section breaks |

### Page Layout

```
Mobile padding: px-5 (20px)  — a touch more air than v1's 16px reads more premium
Student app desktop max-width: max-w-md (480px) — a focused column, phone-shaped, centered on canvas
Parent dashboard desktop max-width: max-w-4xl (896px)
```

The student experience stays a **single focused column even on desktop** — it is a companion you talk to, not a wide grid you scan. Resist the urge to spread it into a multi-column dashboard.

---

## 5. Radius, Elevation & Depth

Flat `shadow-sm` everywhere is a generic tell. v2 uses a **considered radius scale** and **layered, warm-tinted shadows** for real depth.

### Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radius-sm` | 10px | Inputs, badges, small controls |
| `radius-md` | 16px | Buttons, list rows |
| `radius-lg` | 22px | Cards, sheets |
| `radius-xl` | 28px | Hero / Health Score card |
| `radius-full` | 9999px | Pills, avatars, Nex mark |

### Elevation (warm shadows, never pure black)

```css
--shadow-card:  0 1px 2px rgba(40,32,20,0.04), 0 4px 12px rgba(40,32,20,0.06);
--shadow-float: 0 2px 6px rgba(40,32,20,0.06), 0 12px 28px rgba(40,32,20,0.10);
--shadow-nex:   0 0 0 1px rgba(21,86,75,0.08), 0 8px 24px rgba(21,86,75,0.12); /* emerald-tinted glow for Nex surfaces */
```

Every card pairs a **hairline `nexusBorder`** with `--shadow-card`. Modals/sheets use `--shadow-float`. Nex's surfaces use `--shadow-nex` so the AI literally glows a little.

---

## 6. Iconography & Illustration

- **No emoji in product UI.** The 🔥 streak and emoji icons are the fastest way to look unfinished/AI-generated. Replace with a small **custom icon set** drawn on Lucide's grid (2px stroke, rounded caps) plus 2–3 bespoke marks (streak flame, mastery crest, Nex mark).
- **Lucide** for utility icons: 20px standard, 24px navigation, stroke 2.
- **Spot illustration** for empty states, onboarding, and milestones — a small consistent warm-line style (emerald + amber + ink). Illustration over stock or emoji is a premium signal.

---

## 7. Nex as a Character

Nex is the backbone, so it must *look* like a presence, not a tab.

- **Nex mark:** a single simple geometric avatar (a rounded emerald form) used consistently — chat, loading, milestones, parent reports. This is Nex's "face."
- **Voice color:** Nex always speaks in `nexusPrimary` territory. Nex message bubble = `nexusPrimarySoft` background, `nexusInk` text, `--shadow-nex`.
- **Presence, not chrome:** the Nex chat is a warm conversation surface, not a generic messenger. Greeting in display serif, generous spacing, the mark present.
- **"Thinking" state:** a calm emerald shimmer on the mark — never a spinner, never three bouncing dots (generic). Signals a patient teacher considering your answer.
- **Home leads with Nex:** the dashboard greeting is Nex speaking ("Morning, Brian — yesterday you nailed linear equations. Try word problems today?"), with the Health Score as something Nex *refers to*, not a hero stat card.

### Nex chat bubbles

| Role | Style |
|------|-------|
| Student | `bg-nexus-primary text-nexus-ink-inverse rounded-[22px] rounded-br-md` |
| Nex | `bg-nexus-primary-soft text-nexus-ink rounded-[22px] rounded-bl-md shadow-[--shadow-nex]` with Nex mark |

---

## 8. Cards & Key Surfaces

**No cards inside cards inside cards.** One elevation level per region.

### Standard Card

```tsx
className="bg-nexus-surface border border-nexus-border rounded-[22px] p-5 shadow-[var(--shadow-card)]"
```

### Health Score Card (hero)

- Large `text-score` number in **display serif**, emerald.
- Circular arc (emerald track on `nexusSurfaceSunken`), not a flashy ring.
- Framed as a sentence from Nex ("You're at 67 — a solid B-. One push on geometry moves you to B+."), not a bare metric.
- `radius-xl`, `--shadow-card`, amber dot only on genuine achievement.

### Action Card (Continue Learning)

- Left: topic mark + title (`text-h3`). Right: chevron.
- Full-width tap target, min 56px height.
- 3px `nexusPrimary` left accent bar.

### Achievement / Streak

- `nexusAccentSoft` fill, custom streak mark (not emoji), `nexusInk` numerals.

---

## 9. Buttons

| Variant | Style |
|---------|-------|
| Primary | `bg-nexus-primary text-nexus-ink-inverse rounded-[16px] h-12 font-sans font-semibold`, `--shadow-card`, hover `nexusPrimaryHover` |
| Secondary | `bg-nexus-surface border border-nexus-border-strong text-nexus-ink rounded-[16px] h-12` |
| Soft | `bg-nexus-primary-soft text-nexus-primary rounded-[16px] h-12` |
| Ghost | `text-nexus-primary` no fill |

One primary CTA per screen. Min height 48px (primary 48–56px). Press state: scale 0.98 + darken.

---

## 10. Components (shadcn / Base UI)

Wrap primitives with Nexus tokens — names per Naming Guidelines §26.

| Primitive | Nexus Wrapper |
|-----------|---------------|
| Button | `NexusButton` (primary, secondary, soft, ghost) |
| Card | `NexusCard` |
| Input | `NexusInput` (warm `surfaceSunken` well, `radius-sm`) |
| Dialog/Sheet | `NexusModal` / `NexusSheet` (`--shadow-float`) |
| Progress | `NexusProgress` (emerald on sunken track) |
| Badge | `NexusBadge` |
| Tabs | `NexusTabs` |
| — | `NexMark`, `NexBubble`, `NexThinking` (bespoke) |

---

## 11. Navigation

### Bottom Navigation (Student)

| Tab | Icon | Route |
|-----|------|-------|
| Home | Home | `/dashboard` |
| Learn | Book | `/learn` |
| Nex | NexMark | `/nex` |
| Progress | Chart | `/progress` |

The **Nex tab is the centre and is visually elevated** — the Nex mark sits in a raised emerald circle with `--shadow-nex`, slightly above the bar. It is the product's heart and should read that way. Active tabs use `nexusPrimary`; inactive use `nexusInkMuted`.

---

## 12. Motion

- Restrained, purposeful, 60fps on mid-range Android.
- Page transitions 180ms ease-out; press feedback 90ms.
- Score: count-up with ease-out on update.
- Streak/achievement: a single warm "settle" animation, not a loop.
- Nex thinking: slow emerald shimmer (~1.4s), respects `prefers-reduced-motion`.
- Reduced motion: cross-fades only.

---

## 13. Dark Mode

V1 light only — but tokens are already structured for it. v2's warm palette inverts cleanly: canvas → warm charcoal `#1A1714`, surface → `#23201B`, ink flips to `nexusInkInverse`, emerald/amber lift ~8% lightness for contrast. Build in V2.

---

## 14. Do / Don't

| Do | Don't |
|----|-------|
| Warm paper canvas, warm ink | Cold `#FAFAFA` / `#111827` |
| Emerald + amber identity | Default AI-SaaS purple |
| Display serif for moments | Inter-for-everything |
| Custom marks + spot illustration | Emoji as UI (🔥, ✨) |
| Layered warm shadows + hairline | Flat uniform `shadow-sm` |
| Nex with a face and voice color | Generic chatbot shell |
| Lead with "what's next?" | Lead with a grid of stat cards |
| Single focused column | Wide multi-column dashboard |
| One primary CTA per screen | Competing CTAs |
| Semantic tokens only | Hardcoded hex |

---

## 15. Migration notes (from v1.0)

1. Swap color tokens (`nexusPrimary` `#5B4FCF` → `#15564B`; add amber, warm surfaces/ink).
2. Add `Fraunces` + `Hanken Grotesk` via `next/font/local`; apply display serif to score/greeting/titles.
3. Replace `shadow-sm` with `--shadow-card`; add hairline borders.
4. Remove all emoji from components; introduce `NexMark` and custom streak/mastery marks.
5. Rebuild the dashboard as a Nex-led "today" view; demote the Health Score to a referenced stat.
6. Elevate the Nex tab in the bottom nav.
```
