import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Nex camera affordance", () => {
  test("shows camera button in homework mode on login page mock", async ({ page }) => {
    await page.goto("/login");
    await expect(page.getByTestId("nex-camera-button")).toHaveCount(0);
  });

  test.skip(
    !hasE2eStudentCredentials(),
    "Set E2E_STUDENT_EMAIL and E2E_STUDENT_PASSWORD for authenticated Nex camera test",
  );

  test("renders camera button in homework mode for authenticated students", async ({
    page,
  }) => {
    await loginAsStudent(page);
    await page.goto("/nex");
    await page.getByRole("radio", { name: /homework/i }).click();
    await expect(page.getByTestId("nex-camera-button")).toBeVisible();
    await expect(page.getByTestId("nex-camera-input")).toBeAttached();
  });

  test("hides camera button in practice mode", async ({ page }) => {
    await loginAsStudent(page);
    await page.goto("/nex");
    await page.getByRole("radio", { name: /practice/i }).click();
    await expect(page.getByTestId("nex-camera-button")).toHaveCount(0);
  });
});
