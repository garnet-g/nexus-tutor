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

    await page.goto("/admin/usage-stats");
    await page.waitForURL(/\/login/, { timeout: 30_000 });
  });
});
