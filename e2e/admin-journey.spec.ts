import { test, expect } from "@playwright/test";

import { hasE2eAdminCredentials, loginAsSuperAdmin } from "./fixtures/auth";

const SUPPORT_EMAIL =
  process.env.E2E_SUPPORT_EMAIL?.trim() || "support@nexus.local";
const SUPPORT_PASSWORD =
  process.env.E2E_SUPPORT_PASSWORD?.trim() || "NexusDev1";

test.describe("Admin journey", () => {
  test("support user reaches support shell and is blocked from usage-stats", async ({
    page,
  }) => {
    await page.goto("/login", { waitUntil: "domcontentloaded" });
    await page.locator("#email").fill(SUPPORT_EMAIL);
    await page.locator("#password").fill(SUPPORT_PASSWORD);
    await page.getByRole("button", { name: /sign in/i }).click();

    await page.waitForURL(/\/admin\/support/, { timeout: 30_000 });
    await expect(page.getByRole("heading", { level: 1 })).toBeVisible();

    await page.goto("/admin/usage-stats");
    await page.waitForURL(/\/admin\/support/, { timeout: 30_000 });
    await expect(page).not.toHaveURL(/usage-stats/);
  });

  test("super admin reaches admin overview and health probes", async ({ page }) => {
    test.skip(!hasE2eAdminCredentials(), "Seeded super-admin credentials required");

    await loginAsSuperAdmin(page);
    await expect(page).toHaveURL(/\/admin/);
    await page.goto("/admin/health");
    await expect(page.getByRole("heading", { name: /system health/i })).toBeVisible();
    await expect(page.getByText(/database/i).first()).toBeVisible();
  });
});
