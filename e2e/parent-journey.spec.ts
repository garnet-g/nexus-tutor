import { test, expect } from "@playwright/test";

import { hasE2eParentCredentials, loginAsParent } from "./fixtures/auth";

test.describe("Parent journey", () => {
  test("linked parent sees student on dashboard", async ({ page }) => {
    test.skip(!hasE2eParentCredentials(), "Seeded parent credentials required");

    await loginAsParent(page);
    await expect(page.getByRole("heading", { name: /parent dashboard/i })).toBeVisible();
    await expect(page.getByText(/dev student/i)).toBeVisible();
  });
});
