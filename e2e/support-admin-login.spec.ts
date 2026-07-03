import { test, expect } from "@playwright/test";

const SUPPORT_EMAIL =
  process.env.E2E_SUPPORT_EMAIL?.trim() || "support@nexus.local";
const SUPPORT_PASSWORD =
  process.env.E2E_SUPPORT_PASSWORD?.trim() || "NexusDev1";

test.describe("support admin login", () => {
  test("support user can reach admin shell but not usage-stats SSR", async ({
    page,
  }) => {
    await page.goto("/login", { waitUntil: "domcontentloaded" });
    await page.locator("#email").fill(SUPPORT_EMAIL);
    await page.locator("#password").fill(SUPPORT_PASSWORD);
    await page.getByRole("button", { name: /sign in/i }).click();

    await page.waitForURL(/\/admin\/support/, { timeout: 30_000 });
    await expect(page.getByRole("heading", { level: 1 })).toBeVisible();

    // SSR guard redirects to /login; proxy bounces the still-authenticated
    // support user straight to /admin/support, so that is the only committed URL.
    await page.goto("/admin/usage-stats");
    await page.waitForURL(/\/admin\/support/, { timeout: 30_000 });
    await expect(page).not.toHaveURL(/usage-stats/);
  });
});
