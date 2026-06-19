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
  test.skip(
    !hasE2eStudentCredentials(),
    "Set E2E_STUDENT_EMAIL and E2E_STUDENT_PASSWORD in env",
  );

  test("mock-exams redirects to exam-prep", async ({ page }) => {
    await loginAsStudent(page);
    await page.goto("/mock-exams");
    await expect(page).toHaveURL(/\/exam-prep/);
  });

  test("assignment-help loads with homework mode", async ({ page }) => {
    await loginAsStudent(page);
    await page.goto("/assignment-help");

    if (page.url().includes("/diagnostic")) {
      test.skip(true, "Student has not completed diagnostic");
      return;
    }

    await expect(
      page.getByRole("heading", { name: /assignment help/i }),
    ).toBeVisible();
    await expect(page.getByLabel(/^mode$/i)).toHaveValue("homework");
  });

  test("exam-prep page renders wizard", async ({ page }) => {
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
      page.getByRole("button", { name: /start exam preparation/i }),
    ).toBeVisible();
  });
});
