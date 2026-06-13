# Mobile Experience Rules

**Version:** 1.0  
**Primary Target:** Android smartphones, 360–414px width, Kenya mobile networks

---

## 1. Mobile-First Mandate

1. Design and build at **375px width first**
2. Desktop is an enhancement — not a separate app
3. Every feature must be usable one-handed
4. Test on slow 3G throttling (Chrome DevTools)

---

## 2. Layout Rules

| Rule | Standard |
|------|----------|
| Page padding | `px-4` (16px minimum) |
| Max content width | `max-w-2xl` centered on tablet+ |
| Bottom navigation | Fixed on student app (4 tabs) |
| Top header | Sticky, 56px height, back button on sub-pages |
| Scroll | Vertical only — no horizontal scroll on content |
| Safe areas | Respect iOS safe-area-inset for notched devices |

---

## 3. Touch Targets

| Element | Minimum Size |
|---------|--------------|
| Buttons | 48×48px |
| List items | 48px height |
| Answer options (practice) | 48px height, full width |
| Bottom nav items | 48px tap area |

Spacing between tappable elements: ≥8px

---

## 4. Performance

| Rule | Target |
|------|--------|
| First Contentful Paint | <2s on 3G |
| Time to Interactive | <4s on 3G |
| JS bundle (student route) | Monitor with `@next/bundle-analyzer` |
| Images | WebP, lazy load, max 100KB hero |
| Fonts | Inter via `next/font` — no external CDN |

### Network Resilience

- Show skeleton loaders, not spinners alone
- Retry failed API calls once with backoff
- Offline: show friendly message — no full offline mode in V1
- Preserve Nex chat input on failed send

---

## 5. Nex Chat Mobile UX

- Input fixed at bottom above keyboard
- Auto-scroll to latest message
- Send on tap (no Enter key dependency on mobile)
- Message bubbles max-width 85%
- Long equations: horizontal scroll within bubble, not page
- Mode selector: horizontal chip scroll

---

## 6. Practice Mobile UX

- One question per screen (not all 10 visible)
- Large answer buttons
- Progress indicator: "Question 3 of 10"
- Timer optional (hidden V1 unless enabled)
- Results screen: score hero + weak topics list

---

## 7. Diagnostic Mobile UX

- One question per screen
- Cannot skip questions (V1)
- Progress bar at top
- Exit warning dialog ("Your progress will be lost")
- Results: full-screen celebration moment

---

## 8. M-Pesa Mobile UX

- Phone input with +254 prefix pre-filled
- Numeric keyboard for phone field
- Clear STK instructions: "Check your phone for M-Pesa prompt"
- Polling status with animated pending state
- Success: full-screen confirmation with receipt number

---

## 9. Typography on Mobile

- Body: 16px minimum (never 14px for lesson content)
- Health Score: 36px+ for hero display
- Avoid text over 3 lines in dashboard cards — truncate with "See more"

---

## 10. Forms

- One column always
- Labels above inputs
- Error messages inline below field
- Autocomplete enabled where appropriate
- `inputmode="numeric"` for phone numbers

---

## 11. Parent Dashboard Mobile

- Student selector: dropdown or horizontal chips if multiple linked
- Summary cards stacked vertically
- Weekly report: scrollable sections
- No complex charts V1 — numbers and lists only

---

## 12. Accessibility (Mobile)

- Contrast ratio ≥4.5:1 for body text
- Focus visible on interactive elements
- Screen reader labels on icon-only buttons
- No information conveyed by color alone (add icons/text)

---

## 13. Device Testing Matrix

| Device Class | Test |
|--------------|------|
| Small Android (360px) | Layout, tap targets |
| iPhone SE (375px) | Safe areas |
| Large phone (414px) | Content density |
| Tablet (768px+) | Max-width constraint |

---

## 14. Banned Mobile Patterns

- Hover-only interactions
- Tiny text links
- Multi-column forms on mobile
- Auto-playing video (V1 has no video)
- Modal on modal stacks
- Pull-to-refresh (V1 — unnecessary complexity)

---

## 15. Acceptance Criteria

- [ ] All 13+ screens usable at 375px without horizontal scroll
- [ ] All buttons meet 48px touch target
- [ ] Nex chat usable with on-screen keyboard open
- [ ] M-Pesa flow completable on mobile only
- [ ] Lighthouse mobile performance score ≥80
