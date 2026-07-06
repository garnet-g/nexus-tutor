import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Student auth gate", () => {
  test("login redirects to onboarding, diagnostic, or dashboard", async ({
    page,
  }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);

    await expect(page).toHaveURL(/\/(onboarding|dashboard|diagnostic)/);
  });

  test("incomplete onboarding cannot access dashboard directly", async ({
    page,
  }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);

    if (page.url().includes("/onboarding")) {
      await page.goto("/dashboard");
      await expect(page).toHaveURL(/\/onboarding/);
      return;
    }

    if (page.url().includes("/diagnostic")) {
      await page.goto("/dashboard");
      await expect(page).toHaveURL(/\/diagnostic/);
      return;
    }

    await expect(page).toHaveURL(/\/dashboard/);
  });
});
