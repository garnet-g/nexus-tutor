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
    - navigation "Main navigation" [ref=e3]:
      - generic [ref=e4]:
        - link "HomeSpot home" [ref=e5] [cursor=pointer]:
          - /url: /
          - img [ref=e6]
          - generic [ref=e7]: HomeSpot
        - button "Open menu" [ref=e8] [cursor=pointer]:
          - img [ref=e10]
    - generic [ref=e13]:
      - generic [ref=e15]:
        - link "HomeSpot home" [ref=e17] [cursor=pointer]:
          - /url: /
          - img [ref=e18]
          - generic [ref=e19]: HomeSpot
        - generic [ref=e20]:
          - heading "Welcome back" [level=1] [ref=e21]
          - paragraph [ref=e22]: Sign in to your account to continue
          - generic [ref=e23]:
            - generic [ref=e24]:
              - generic [ref=e25]: Email address
              - textbox "Email address" [ref=e26]:
                - /placeholder: you@example.co.ke
                - text: support@nexus.local
            - generic [ref=e27]:
              - generic [ref=e28]:
                - generic [ref=e29]: Password
                - link "Forgot password?" [ref=e30] [cursor=pointer]:
                  - /url: /forgot-password
              - generic [ref=e31]:
                - textbox "Password" [ref=e32]:
                  - /placeholder: Enter your password
                  - text: NexusDev1
                - button "Show password" [ref=e33] [cursor=pointer]:
                  - img [ref=e34]
            - paragraph [ref=e38]: Database connection failed. Check DATABASE_URL and DIRECT_URL on the server.
            - button "Sign in" [ref=e39] [cursor=pointer]
          - paragraph [ref=e40]: Need access? Contact your building manager.
        - paragraph [ref=e41]:
          - text: No account?
          - link "Register" [ref=e42] [cursor=pointer]:
            - /url: /register
      - contentinfo [ref=e43]:
        - navigation [ref=e44]:
          - link "Privacy" [ref=e45] [cursor=pointer]:
            - /url: /privacy
          - generic [ref=e46]: ·
          - link "Terms" [ref=e47] [cursor=pointer]:
            - /url: /terms
          - generic [ref=e48]: ·
          - link "Support" [ref=e49] [cursor=pointer]:
            - /url: /help
  - region "Notifications (F8)":
    - list
  - alert [ref=e50]
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
  20 |     await page.goto("/admin/usage-stats");
  21 |     await page.waitForURL(/\/login/, { timeout: 30_000 });
  22 |   });
  23 | });
  24 | 
```