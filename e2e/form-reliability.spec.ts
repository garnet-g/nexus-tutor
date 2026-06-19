import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Public form reliability", () => {
  test("teacher waitlist disables submit while loading", async ({ page }) => {
    await page.route("**/api/waitlist/teacher", async () => {
      await new Promise(() => {
        /* keep request pending for loading-state assertion */
      });
    });

    await page.goto("/waitlist/teacher");

    await page.getByLabel(/full name/i).fill("Test Teacher");
    await page.getByLabel(/^email$/i).fill("teacher@school.ke");
    await page.getByLabel(/school name/i).fill("Test School");

    const submitButtonEnabled = page
      .locator('form')
      .getByRole("button", { name: /join waitlist/i });
    await expect(submitButtonEnabled).toBeEnabled();

    await submitButtonEnabled.click({ noWaitAfter: true });

    // The button label changes to "Joining..." immediately, so re-locate by
    // type instead of by accessible name.
    const submitButtonDuring = page.locator('form button[type="submit"]').first();
    await expect(submitButtonDuring).toBeDisabled({ timeout: 10_000 });
    await expect(submitButtonDuring).toHaveText(/joining/i);
  });

  test("teacher waitlist shows validation messages for empty required fields", async ({
    page,
  }) => {
    await page.goto("/waitlist/teacher");

    await page.locator("form").evaluate((form) => {
      form.setAttribute("novalidate", "");
    });

    await page.getByRole("button", { name: /join waitlist/i }).click();

    await expect(page.getByText(/full name is required/i)).toBeVisible();
    await expect(page.getByText(/email is required/i)).toBeVisible();
    await expect(page.getByText(/school name is required/i)).toBeVisible();
    await expect(page.getByRole("button", { name: /join waitlist/i })).toBeEnabled();
  });
});

test.describe("ProfileForm learning preferences reliability", () => {
  test.beforeAll(() => {
    test.skip(!hasE2eStudentCredentials(), "Missing E2E_STUDENT_EMAIL/PASSWORD");
  });

  test("Profile submit disables while server action pending", async ({ page }) => {
    await loginAsStudent(page);
    await page.goto("/profile");

    // Keep only the profile update server action pending so pending-state UI can be asserted.
    let stalledOnce = false;
    await page.route("**/_next/**", async (route) => {
      const req = route.request();
      const method = req.method().toUpperCase();
      const { pathname } = new URL(req.url());
      const postData = req.postData() ?? "";
      const isProfileUpdateRequest =
        postData.includes("sessionGoalMinutes") &&
        postData.includes("explanationDepth") &&
        postData.includes("reminderChannel");

      if (
        !stalledOnce &&
        method === "POST" &&
        pathname.startsWith("/_next/") &&
        isProfileUpdateRequest
      ) {
        stalledOnce = true;
        const delayMs = 3000 + Math.floor(Math.random() * 2000); // 3–5s
        await new Promise((resolve) => setTimeout(resolve, delayMs));
      }

      await route.continue();
    });

    const sessionGoalMinutes = page.locator('input[name="sessionGoalMinutes"]');
    const profileForm = page.locator("form").filter({
      has: page.getByLabel(/session goal/i),
    });
    const submitButton = profileForm.locator('button[type="submit"]').first();

    // Ensure the profile server-action payload contains the full preference set,
    // so the pending interception predicate is deterministic.
    await page.locator('select[name="explanationDepth"]').selectOption("quick");
    await page.locator('select[name="reminderChannel"]').selectOption("sms");
    await sessionGoalMinutes.fill("25");
    await submitButton.click({ noWaitAfter: true });

    await expect(submitButton).toBeDisabled({ timeout: 10_000 });
    await expect(submitButton).toHaveText(/saving/i, { timeout: 10_000 });
  });

  test("Validation messages + rehydration on success", async ({ page }) => {
    await loginAsStudent(page);
    await page.goto("/profile");

    const sessionGoalMinutes = page.locator('input[name="sessionGoalMinutes"]');
    const profileForm = page.locator("form").filter({
      has: page.getByLabel(/session goal/i),
    });
    const submitButton = profileForm.locator('button[type="submit"]').first();

    // Trigger sessionGoalMinutes validation error.
    await sessionGoalMinutes.fill("1");
    await submitButton.click();

    const sessionGoalMinutesError = page.locator(
      "#profile-sessionGoalMinutes-error",
    );
    await expect(sessionGoalMinutesError).toBeVisible();
    await expect(sessionGoalMinutesError).toContainText(/at least 5 minutes/i);
    await expect(sessionGoalMinutes).toHaveAttribute(
      "aria-describedby",
      /profile-sessionGoalMinutes-error/,
    );

    // Submit valid value and assert success.
    await sessionGoalMinutes.fill("25");
    await submitButton.click();
    await expect(page.getByText(/Profile updated\./i)).toBeVisible();

    // Reload and verify the form rehydrates from persisted preferences.
    await page.reload();
    await expect(
      page.locator('input[name="sessionGoalMinutes"]'),
    ).toHaveValue("25");
  });
});
