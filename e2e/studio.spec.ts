import { test, expect } from "@playwright/test";

import { hasE2eAdminCredentials, loginAsSuperAdmin } from "./fixtures/auth";

test.describe("Studio publish path", () => {
  test("super admin opens studio workspace and review queue", async ({ page }) => {
    test.skip(!hasE2eAdminCredentials(), "Seeded super-admin credentials required");

    await loginAsSuperAdmin(page);
    await page.goto("/admin/studio");
    await expect(page.getByRole("heading", { name: /curriculum workspace/i })).toBeVisible();

    await page.goto("/admin/studio/review");
    await expect(page.getByRole("heading", { name: /review queue/i })).toBeVisible();
  });
});
