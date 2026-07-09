import { expect, test } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("KCSE Math Mastery", () => {
  test("exam prep is math-first and assessment mode is visible", async ({ page }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);

    await page.goto("/exam-prep");
    if (page.url().includes("/diagnostic")) {
      test.skip(true, "Student has not completed diagnostic");
      return;
    }

    await expect(page.getByRole("heading", { name: /exam prep/i })).toBeVisible();

    const subjectSelect = page.locator("select").first();
    await expect(subjectSelect).toBeVisible();
    await expect(subjectSelect.locator("option")).toHaveCount(1);
    await expect(subjectSelect.locator("option").first()).toHaveText(/math/i);

    await page.goto("/nex?mode=assessment");
    await expect(page.getByRole("radio", { name: /assessment/i })).toHaveAttribute(
      "aria-checked",
      "true",
    );
  });
});
