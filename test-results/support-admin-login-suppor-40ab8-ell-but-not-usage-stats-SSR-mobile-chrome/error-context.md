# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: support-admin-login.spec.ts >> support admin login >> support user can reach admin shell but not usage-stats SSR
- Location: e2e\support-admin-login.spec.ts:9:7

# Error details

```
TimeoutError: page.waitForURL: Timeout 30000ms exceeded.
=========================== logs ===========================
waiting for navigation until "load"
============================================================
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
      - generic [ref=e12]:
        - generic [ref=e13]:
          - generic [ref=e14]: "N"
          - generic [ref=e15]: Welcome back
          - generic [ref=e16]: Sign in to continue your learning journey.
        - generic [ref=e17]:
          - generic [ref=e18]:
            - generic [ref=e19]:
              - generic [ref=e20]: Email
              - textbox "Email" [ref=e21]:
                - /placeholder: you@example.com
            - generic [ref=e22]:
              - generic [ref=e23]: Password
              - textbox "Password" [ref=e24]:
                - /placeholder: ••••••••
            - alert [ref=e25]: fetch failed
            - button "Sign in" [ref=e26] [cursor=pointer]
          - paragraph [ref=e27]:
            - text: Don't have an account?
            - link "Sign up" [ref=e28] [cursor=pointer]:
              - /url: /signup
    - contentinfo [ref=e29]:
      - generic [ref=e30]:
        - paragraph [ref=e31]: © 2026 Nexus · Garnet Labs
        - generic [ref=e32]:
          - link "Pricing" [ref=e33] [cursor=pointer]:
            - /url: /pricing
          - link "About" [ref=e34] [cursor=pointer]:
            - /url: /about
          - link "Sign up" [ref=e35] [cursor=pointer]:
            - /url: /signup
  - alert [ref=e36]
```

# Test source

```ts
  1  | import { test, expect } from "@playwright/test";
  2  | 
  3  | const SUPPORT_EMAIL =
  4  |   process.env.E2E_SUPPORT_EMAIL?.trim() || "support@nexus.local";
  5  | const SUPPORT_PASSWORD =
  6  |   process.env.E2E_SUPPORT_PASSWORD?.trim() || "NexusDev1";
  7  | 
  8  | test.describe("support admin login", () => {
  9  |   test("support user can reach admin shell but not usage-stats SSR", async ({
  10 |     page,
  11 |   }) => {
  12 |     await page.goto("/login", { waitUntil: "domcontentloaded" });
  13 |     await page.locator("#email").fill(SUPPORT_EMAIL);
  14 |     await page.locator("#password").fill(SUPPORT_PASSWORD);
  15 |     await page.getByRole("button", { name: /sign in/i }).click();
  16 | 
> 17 |     await page.waitForURL(/\/admin\/support/, { timeout: 30_000 });
     |                ^ TimeoutError: page.waitForURL: Timeout 30000ms exceeded.
  18 |     await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
  19 | 
  20 |     // SSR guard redirects to /login; proxy bounces the still-authenticated
  21 |     // support user straight to /admin/support, so that is the only committed URL.
  22 |     await page.goto("/admin/usage-stats");
  23 |     await page.waitForURL(/\/admin\/support/, { timeout: 30_000 });
  24 |     await expect(page).not.toHaveURL(/usage-stats/);
  25 |   });
  26 | });
  27 | 
```