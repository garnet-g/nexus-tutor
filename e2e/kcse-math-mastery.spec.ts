import { expect, test } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("KCSE Math Mastery", () => {
  test("exam prep offers a KCSE paper picker and assessment mode is visible", async ({ page }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);

    await page.goto("/exam-prep");
    if (page.url().includes("/diagnostic")) {
      test.skip(true, "Student has not completed diagnostic");
      return;
    }

    await expect(page.getByRole("heading", { name: /exam prep/i })).toBeVisible();
    await expect(page.getByRole("button", { name: /start paper 1/i })).toBeVisible();
    await expect(page.getByRole("button", { name: /start paper 2/i })).toBeVisible();

    await page.goto("/nex?mode=assessment");
    await expect(page.getByRole("radio", { name: /assessment/i })).toHaveAttribute(
      "aria-checked",
      "true",
    );
  });

  test("student can sit, submit, and self-mark a KCSE paper", async ({ page }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    await page.goto("/exam-prep");
    if (page.url().includes("/diagnostic")) {
      test.skip(true, "Student has not completed diagnostic");
      return;
    }

    await page.getByRole("button", { name: /start paper 1/i }).click();
    await page.waitForURL(/\/exam-papers\/[^/]+$/, { timeout: 15_000 });

    const firstAnswerInput = page.getByPlaceholder("Final answer").first();
    await expect(firstAnswerInput).toBeVisible();
    await firstAnswerInput.fill("999999"); // deliberately wrong, to exercise the self-mark path

    await page.getByRole("button", { name: /submit paper/i }).click();
    await page.waitForURL(/\/exam-papers\/[^/]+\/results$/, { timeout: 15_000 });

    await expect(page.getByText(/verified.*self-marked/i)).toBeVisible();

    const selfMarkCheckbox = page.getByRole("checkbox").first();
    if (await selfMarkCheckbox.isVisible().catch(() => false)) {
      await selfMarkCheckbox.check();
      await page.getByRole("button", { name: /confirm self-marking/i }).click();
      await expect(page.getByText(/verified.*self-marked/i)).toBeVisible();
    }
  });
});
