# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: smoke.spec.ts >> Public smoke >> landing page loads with signup CTA
- Location: e2e\smoke.spec.ts:4:7

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByRole('link', { name: /start learning free/i })
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 5000ms
  - waiting for getByRole('link', { name: /start learning free/i })

```

```yaml
- banner:
  - link "Nexus":
    - /url: /
  - link "Sign in":
    - /url: /login
  - button "Get started"
- main:
  - paragraph: CBC & KCSE · Mathematics · Science · English
  - heading "The academic companion that grows with you" [level=1]
  - paragraph: Nexus combines Nex, your AI teacher, with diagnostics, curriculum lessons, and practice — built for Kenyan students from Grade 4 through Form 4.
  - button "Start learning free"
  - button "View pricing"
  - paragraph: Free forever · 10 Nex messages & 3 practice sessions daily
  - heading "Everything you need to study smarter" [level=2]
  - paragraph: Nex is the backbone — every feature feeds personalized teaching.
  - text: Tutor Nex AI Tutor
  - paragraph: Your Socratic study companion for Explain, Practice, Homework, and Revision — grounded in CBC and KCSE curriculum.
  - text: Insight Diagnostic Assessment
  - paragraph: A 20-question diagnostic builds your Academic Health Score and predicted grade so learning starts where you need it.
  - text: Mastery Practice Sessions
  - paragraph: Ten-question sessions with difficulty you choose. Mastery updates after every round so Nex knows what to teach next.
  - heading "Ready to meet Nex?" [level=2]
  - paragraph: Sign up in minutes. Complete your diagnostic, get your Health Score, and start learning with a tutor that guides — not gives away answers.
  - button "Create your account"
- contentinfo:
  - paragraph: © 2026 Nexus · Garnet Labs
  - link "Pricing":
    - /url: /pricing
  - link "About":
    - /url: /about
  - link "Sign up":
    - /url: /signup
- alert
```

# Test source

```ts
  1  | import { test, expect } from "@playwright/test";
  2  | 
  3  | test.describe("Public smoke", () => {
  4  |   test("landing page loads with signup CTA", async ({ page }) => {
  5  |     await page.goto("/");
  6  |     await expect(
  7  |       page.getByRole("heading", {
  8  |         name: /academic companion that grows with you/i,
  9  |       }),
  10 |     ).toBeVisible();
> 11 |     await expect(page.getByRole("link", { name: /start learning free/i })).toBeVisible();
     |                                                                            ^ Error: expect(locator).toBeVisible() failed
  12 |   });
  13 | 
  14 |   test("pricing page shows plan information", async ({ page }) => {
  15 |     await page.goto("/pricing", { waitUntil: "domcontentloaded" });
  16 |     await expect(
  17 |       page.getByRole("heading", { name: /pricing/i }),
  18 |     ).toBeVisible();
  19 |     await expect(page.getByText(/free/i).first()).toBeVisible();
  20 |   });
  21 | 
  22 |   test("login page renders", async ({ page }) => {
  23 |     await page.goto("/login");
  24 |     await expect(page.getByRole("button", { name: /sign in/i })).toBeVisible();
  25 |   });
  26 | 
  27 |   test("about page renders mission", async ({ page }) => {
  28 |     await page.goto("/about");
  29 |     await expect(
  30 |       page.getByRole("heading", {
  31 |         level: 1,
  32 |         name: /most trusted academic companion/i,
  33 |       }),
  34 |     ).toBeVisible();
  35 |   });
  36 | });
  37 | 
  38 | test.describe("Mobile layout", () => {
  39 |   test("no horizontal overflow on landing at 375px", async ({ page }) => {
  40 |     await page.goto("/");
  41 |     const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
  42 |     const clientWidth = await page.evaluate(() => document.documentElement.clientWidth);
  43 |     expect(scrollWidth).toBeLessThanOrEqual(clientWidth + 1);
  44 |   });
  45 | });
  46 | 
```