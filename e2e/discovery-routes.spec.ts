import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Discovery routes — public", () => {
  test("teacher waitlist page renders", async ({ page }) => {
    await page.goto("/waitlist/teacher");
    await page.waitForLoadState("domcontentloaded");
    await expect(
      page.getByRole("heading", { name: /teacher waitlist/i }),
    ).toBeVisible();
    await expect(
      page.getByRole("button", { name: /join waitlist/i }),
    ).toBeVisible();
  });
});

test.describe("Discovery routes — student", () => {
  test("assignment-help loads with homework mode", async ({ page }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    await page.goto("/assignment-help?mode=homework");

    if (page.url().includes("/diagnostic")) {
      test.skip(true, "Student has not completed diagnostic");
      return;
    }

    await expect(
      page.getByRole("heading", { name: /assignment help/i }),
    ).toBeVisible();
    await expect(page.getByRole("radio", { name: /homework/i })).toHaveAttribute(
      "aria-checked",
      "true",
    );
  });

  test("exam-prep page renders the current exam experience", async ({ page }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    await page.goto("/exam-prep");

    if (page.url().includes("/diagnostic")) {
      test.skip(true, "Student has not completed diagnostic");
      return;
    }

    await expect(
      page.getByRole("heading", { name: /exam prep/i }),
    ).toBeVisible();
    await expect(
      page
        .getByRole("button", { name: /start paper 1/i })
        .or(page.getByText(/CBC exam prep is coming soon/i)),
    ).toBeVisible();
  });
});
