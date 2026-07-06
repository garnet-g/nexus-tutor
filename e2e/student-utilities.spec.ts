import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Student utilities journeys", () => {
  test("study search, saved items, and mistakes load for onboarded student", async ({
    page,
  }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);

    if (page.url().includes("/diagnostic") || page.url().includes("/onboarding")) {
      test.skip(true, "Student must complete onboarding and diagnostic");
      return;
    }

    await page.goto("/study-search");
    await expect(page.getByRole("heading", { name: /study search/i })).toBeVisible();

    await page.goto("/saved");
    await expect(page.getByRole("heading", { name: /saved questions/i })).toBeVisible();

    await page.goto("/mistakes");
    await expect(page.getByRole("heading", { name: /mistake journal/i })).toBeVisible();

    await page.goto("/focus");
    await expect(page.getByRole("heading", { name: /focus sessions/i })).toBeVisible();
  });
});
