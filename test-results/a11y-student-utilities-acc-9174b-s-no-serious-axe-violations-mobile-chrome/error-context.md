# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: a11y-student-utilities.spec.ts >> accessibility smoke >> landing page has no serious axe violations
- Location: e2e\a11y-student-utilities.spec.ts:12:7

# Error details

```
Error: expect(received).toEqual(expected) // deep equality

- Expected  -   1
+ Received  + 339

- Array []
+ Array [
+   Object {
+     "description": "Ensure the contrast between foreground and background colors meets WCAG 2 AA minimum contrast ratio thresholds",
+     "help": "Elements must meet minimum color contrast ratio thresholds",
+     "helpUrl": "https://dequeuniversity.com/rules/axe/4.12/color-contrast?application=playwright",
+     "id": "color-contrast",
+     "impact": "serious",
+     "nodes": Array [
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 3.8,
+               "expectedContrastRatio": "4.5:1",
+               "fgColor": "#747472",
+               "fontSize": "12.0pt (16px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 3.8 (foreground color: #747472, background color: #171814, font size: 12.0pt (16px), font weight: normal). Expected contrast ratio of 4.5:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 3.8 (foreground color: #747472, background color: #171814, font size: 12.0pt (16px), font weight: normal). Expected contrast ratio of 4.5:1",
+         "html": "<p class=\"mt-10 max-w-xl text-base leading-7 text-white/40 sm:text-lg sm:leading-8\" style=\"clip-path: inset(0px 100% 0px 0px);\">I keep losing marks in simultaneous equations when there are fractions.</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           ".sm\\:leading-8",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 3.8,
+               "expectedContrastRatio": "4.5:1",
+               "fgColor": "#747472",
+               "fontSize": "12.0pt (16px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 3.8 (foreground color: #747472, background color: #171814, font size: 12.0pt (16px), font weight: normal). Expected contrast ratio of 4.5:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 3.8 (foreground color: #747472, background color: #171814, font size: 12.0pt (16px), font weight: normal). Expected contrast ratio of 4.5:1",
+         "html": "<p class=\"mt-8 text-base leading-7 text-white/40 sm:text-lg\" style=\"clip-path: inset(0px 100% 0px 0px);\">Multiply everything by 6.</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           ".leading-7.sm\\:text-lg.mt-8",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 1.52,
+               "expectedContrastRatio": "4.5:1",
+               "fgColor": "#49341e",
+               "fontSize": "8.3pt (11px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 1.52 (foreground color: #49341e, background color: #171814, font size: 8.3pt (11px), font weight: normal). Expected contrast ratio of 4.5:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8\" style=\"opacity: 0.25;\">",
+                 "target": Array [
+                   ".gap-5",
+                 ],
+               },
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 1.52 (foreground color: #49341e, background color: #171814, font size: 8.3pt (11px), font weight: normal). Expected contrast ratio of 4.5:1",
+         "html": "<p class=\"font-mono text-[11px] uppercase tracking-[0.2em] text-[#e0883b]\">Predicted grade</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           ".text-\\[11px\\].text-\\[\\#e0883b\\].tracking-\\[0\\.2em\\]",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 2.2,
+               "expectedContrastRatio": "3:1",
+               "fgColor": "#50504c",
+               "fontSize": "36.0pt (48px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 2.2 (foreground color: #50504c, background color: #171814, font size: 36.0pt (48px), font weight: normal). Expected contrast ratio of 3:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8\" style=\"opacity: 0.25;\">",
+                 "target": Array [
+                   ".gap-5",
+                 ],
+               },
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 2.2 (foreground color: #50504c, background color: #171814, font size: 36.0pt (48px), font weight: normal). Expected contrast ratio of 3:1",
+         "html": "<p class=\"mt-4 font-mono text-5xl leading-none sm:text-7xl\">B-</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           ".text-5xl",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 1.38,
+               "expectedContrastRatio": "4.5:1",
+               "fgColor": "#31322e",
+               "fontSize": "7.5pt (10px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 1.38 (foreground color: #31322e, background color: #171814, font size: 7.5pt (10px), font weight: normal). Expected contrast ratio of 4.5:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8\" style=\"opacity: 0.25;\">",
+                 "target": Array [
+                   ".gap-5",
+                 ],
+               },
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 1.38 (foreground color: #31322e, background color: #171814, font size: 7.5pt (10px), font weight: normal). Expected contrast ratio of 4.5:1",
+         "html": "<p class=\"font-mono text-[10px] uppercase tracking-[0.18em] text-white/45\">Marks won back</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           "div:nth-child(1) > .tracking-\\[0\\.18em\\].text-\\[10px\\].text-white\\/45",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 1.52,
+               "expectedContrastRatio": "3:1",
+               "fgColor": "#49341e",
+               "fontSize": "22.5pt (30px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 1.52 (foreground color: #49341e, background color: #171814, font size: 22.5pt (30px), font weight: normal). Expected contrast ratio of 3:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8\" style=\"opacity: 0.25;\">",
+                 "target": Array [
+                   ".gap-5",
+                 ],
+               },
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 1.52 (foreground color: #49341e, background color: #171814, font size: 22.5pt (30px), font weight: normal). Expected contrast ratio of 3:1",
+         "html": "<p class=\"mt-3 font-heading text-3xl leading-none text-[#e0883b] sm:text-4xl\">+<!-- -->0</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           "div:nth-child(1) > .text-3xl.sm\\:text-4xl.mt-3",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 1.38,
+               "expectedContrastRatio": "4.5:1",
+               "fgColor": "#31322e",
+               "fontSize": "7.5pt (10px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 1.38 (foreground color: #31322e, background color: #171814, font size: 7.5pt (10px), font weight: normal). Expected contrast ratio of 4.5:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8\" style=\"opacity: 0.25;\">",
+                 "target": Array [
+                   ".gap-5",
+                 ],
+               },
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 1.38 (foreground color: #31322e, background color: #171814, font size: 7.5pt (10px), font weight: normal). Expected contrast ratio of 4.5:1",
+         "html": "<p class=\"font-mono text-[10px] uppercase tracking-[0.18em] text-white/45\">Today's session</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           "div:nth-child(2) > .tracking-\\[0\\.18em\\].text-\\[10px\\].text-white\\/45",
+         ],
+       },
+       Object {
+         "all": Array [],
+         "any": Array [
+           Object {
+             "data": Object {
+               "bgColor": "#171814",
+               "contrastRatio": 2.2,
+               "expectedContrastRatio": "3:1",
+               "fgColor": "#50504c",
+               "fontSize": "22.5pt (30px)",
+               "fontWeight": "normal",
+               "messageKey": null,
+             },
+             "id": "color-contrast",
+             "impact": "serious",
+             "message": "Element has insufficient color contrast of 2.2 (foreground color: #50504c, background color: #171814, font size: 22.5pt (30px), font weight: normal). Expected contrast ratio of 3:1",
+             "relatedNodes": Array [
+               Object {
+                 "html": "<div class=\"flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8\" style=\"opacity: 0.25;\">",
+                 "target": Array [
+                   ".gap-5",
+                 ],
+               },
+               Object {
+                 "html": "<div class=\"overflow-x-clip bg-[#171814] text-nexus-text-inverse\">",
+                 "target": Array [
+                   ".text-nexus-text-inverse",
+                 ],
+               },
+             ],
+           },
+         ],
+         "failureSummary": "Fix any of the following:
+   Element has insufficient color contrast of 2.2 (foreground color: #50504c, background color: #171814, font size: 22.5pt (30px), font weight: normal). Expected contrast ratio of 3:1",
+         "html": "<p class=\"mt-3 font-heading text-3xl leading-none sm:text-4xl\">28m</p>",
+         "impact": "serious",
+         "none": Array [],
+         "target": Array [
+           "div:nth-child(2) > .text-3xl.sm\\:text-4xl.mt-3",
+         ],
+       },
+     ],
+     "tags": Array [
+       "cat.color",
+       "wcag2aa",
+       "wcag143",
+       "TTv5",
+       "TT13.c",
+       "EN-301-549",
+       "EN-9.1.4.3",
+       "ACT",
+       "RGAAv4",
+       "RGAA-3.2.1",
+     ],
+   },
+ ]
```

# Page snapshot

```yaml
- generic [active] [ref=e1]:
  - generic [ref=e2]:
    - banner [ref=e3]:
      - generic [ref=e4]:
        - link "Nexus" [ref=e5] [cursor=pointer]:
          - /url: /
        - generic [ref=e6]:
          - link "Sign in" [ref=e7] [cursor=pointer]:
            - /url: /login
          - button "Get started" [ref=e8] [cursor=pointer]
    - main [ref=e9]:
      - generic [ref=e10]:
        - generic [ref=e13]:
          - generic [ref=e16]:
            - generic [ref=e17]:
              - paragraph [ref=e20]: Your AI tutor for KCSE
              - heading "Revise the one thing. Not everything." [level=1] [ref=e21]:
                - text: Revise the
                - generic [ref=e22]: one thing.
                - generic [ref=e24]: Not everything.
              - paragraph [ref=e25]: Nexus looks at how you study, finds the exact mistake costing you marks, and shows you what to fix next.
              - generic [ref=e26]:
                - button "Start your diagnosis →" [ref=e27] [cursor=pointer]:
                  - text: Start your diagnosis
                  - generic [ref=e28]: →
                - button "See revision plans" [ref=e29] [cursor=pointer]
            - figure "Nex Fraction equations" [ref=e30]:
              - generic [ref=e31]:
                - generic [ref=e34]: Nex
                - generic [ref=e35]: Fraction equations
              - paragraph [ref=e36]: I keep dropping marks on fraction equations under time pressure.
              - paragraph [ref=e37]: "Before any answer: what one move clears every denominator at once?"
              - paragraph [ref=e38]: Nex asks first. That question is where the lost marks hide.
          - generic [ref=e40]: Scroll
        - generic [ref=e45]:
          - generic [ref=e47]:
            - heading "It doesn't just give you the answer. It finds the mistake." [level=2] [ref=e49]:
              - text: It doesn't just give you the answer.
              - generic [ref=e50]: It finds the mistake.
            - paragraph [ref=e51]: I keep losing marks in simultaneous equations when there are fractions.
            - generic [ref=e52]:
              - paragraph [ref=e53]: Your working
              - paragraph [ref=e54]:
                - generic [ref=e55]:
                  - text: ½x
                  - img [ref=e56]
                - text: +
                - generic [ref=e58]:
                  - text: ⅓y
                  - img [ref=e59]
                - text: = 7
              - generic [ref=e61]: x + ⅓y = 14
              - paragraph [ref=e62]: Only the halves got cleared.
            - paragraph [ref=e63]:
              - generic [ref=e64]: Don't rush to the answer. What one multiplication clears every fraction at once?
            - paragraph [ref=e65]: Multiply everything by 6.
          - generic:
            - generic:
              - paragraph: 0 marks
              - paragraph: That's 6 marks you were giving away. It was never algebra. You just needed to clear the fractions first.
        - generic [ref=e68]:
          - generic [ref=e70]:
            - heading "Every session fixes something." [level=2] [ref=e71]
            - generic [ref=e72]:
              - generic [ref=e73]:
                - generic [ref=e74]:
                  - paragraph [ref=e75]: Predicted grade
                  - paragraph [ref=e76]: B-
                - generic [ref=e77]:
                  - generic [ref=e78]:
                    - paragraph [ref=e79]: Marks won back
                    - paragraph [ref=e80]: "+0"
                  - generic [ref=e81]:
                    - paragraph [ref=e82]: Today's session
                    - paragraph [ref=e83]: 28m
              - generic [ref=e84]:
                - paragraph [ref=e85]: Topics still costing you marks
                - generic [ref=e86]:
                  - generic [ref=e87]:
                    - paragraph [ref=e89]:
                      - text: Fraction equations
                      - generic [ref=e90]: Fixed today
                    - paragraph [ref=e92]: 0%
                  - generic [ref=e94]:
                    - paragraph [ref=e96]: Moles and ratios
                    - paragraph [ref=e98]: 0%
                  - generic [ref=e100]:
                    - paragraph [ref=e102]: Set-book evidence
                    - paragraph [ref=e104]: 0%
          - generic:
            - generic:
              - heading "And it stays with you." [level=2]
              - generic:
                - generic:
                  - article:
                    - paragraph: Form 1
                    - generic:
                      - heading "Build strong basics" [level=3]
                      - paragraph: Catch the small gaps before they grow into exam panic.
                  - article:
                    - paragraph: Form 2
                    - generic:
                      - heading "Connect the topics" [level=3]
                      - paragraph: Algebra, graphs, rates and grammar stop being strangers.
                  - article:
                    - paragraph: Form 3
                    - generic:
                      - heading "Fix the gaps before mocks" [level=3]
                      - paragraph: One honest pass over every topic that still wobbles.
                  - article:
                    - paragraph: Form 4
                    - generic:
                      - heading "Walk into KCSE ready" [level=3]
                      - paragraph: Mock rhythm, a predicted grade, and a plan you trust.
        - generic [ref=e108]:
          - generic [ref=e109]:
            - paragraph [ref=e110]: 11 days to the mock
            - heading "This time you walk in knowing exactly what you fixed." [level=2] [ref=e111]
          - generic [ref=e112]:
            - paragraph [ref=e113]: Give Nex one revision session tonight. Get the next move before you close the books.
            - button "Start your diagnosis →" [ref=e114] [cursor=pointer]:
              - text: Start your diagnosis
              - generic [ref=e115]: →
    - contentinfo [ref=e116]:
      - generic [ref=e117]:
        - paragraph [ref=e118]: © 2026 Nexus · Garnet Labs
        - generic [ref=e119]:
          - link "Pricing" [ref=e120] [cursor=pointer]:
            - /url: /pricing
          - link "About" [ref=e121] [cursor=pointer]:
            - /url: /about
          - link "Sign up" [ref=e122] [cursor=pointer]:
            - /url: /signup
  - alert [ref=e123]
```

# Test source

```ts
  1  | import AxeBuilder from "@axe-core/playwright";
  2  | import { test, expect } from "@playwright/test";
  3  | 
  4  | const KEYBOARD_CHECKLIST = [
  5  |   "Tab order reaches primary navigation and main CTA on landing",
  6  |   "Enter/Space activates Nex mode toggles on /nex",
  7  |   "Escape closes student utility drawers/modals",
  8  |   "Focus ring visible on interactive controls (manual contrast check)",
  9  | ];
  10 | 
  11 | test.describe("accessibility smoke", () => {
  12 |   test("landing page has no serious axe violations", async ({ page }) => {
  13 |     await page.goto("/");
  14 |     const results = await new AxeBuilder({ page })
  15 |       .withTags(["wcag2a", "wcag2aa"])
  16 |       .analyze();
  17 | 
  18 |     const serious = results.violations.filter(
  19 |       (violation) => violation.impact === "serious" || violation.impact === "critical",
  20 |     );
> 21 |     expect(serious).toEqual([]);
     |                     ^ Error: expect(received).toEqual(expected) // deep equality
  22 |   });
  23 | 
  24 |   test("login page has no serious axe violations", async ({ page }) => {
  25 |     await page.goto("/login");
  26 |     const results = await new AxeBuilder({ page }).analyze();
  27 |     const serious = results.violations.filter(
  28 |       (violation) => violation.impact === "serious" || violation.impact === "critical",
  29 |     );
  30 |     expect(serious).toEqual([]);
  31 |   });
  32 | 
  33 |   test("records keyboard checklist items requiring human verification", async () => {
  34 |     expect(KEYBOARD_CHECKLIST.length).toBeGreaterThanOrEqual(4);
  35 |     test.info().annotations.push({
  36 |       type: "human-checklist",
  37 |       description: KEYBOARD_CHECKLIST.join(" | "),
  38 |     });
  39 |   });
  40 | });
  41 | 
```