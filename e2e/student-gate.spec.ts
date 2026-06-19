import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Student auth gate", () => {
  test.skip(
    !hasE2eStudentCredentials(),
    "Set E2E_STUDENT_EMAIL and E2E_STUDENT_PASSWORD in env",
  );

  test("login redirects to onboarding, diagnostic, or dashboard", async ({
    page,
  }) => {
    await loginAsStudent(page);

    await expect(page).toHaveURL(/\/(onboarding|dashboard|diagnostic)/);
  });

  test("incomplete onboarding cannot access dashboard directly", async ({
    page,
  }) => {
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
