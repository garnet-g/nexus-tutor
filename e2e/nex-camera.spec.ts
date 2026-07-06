import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Nex camera affordance", () => {
  test("shows camera button in homework mode on login page mock", async ({ page }) => {
    await page.goto("/login");
    await expect(page.getByTestId("nex-camera-button")).toHaveCount(0);
  });

  test("denies camera/mic on public login route", async ({ page }) => {
    const loginResponse = await page.goto("/login");
    const loginPolicy =
      loginResponse?.headers()["permissions-policy"] ??
      loginResponse?.headers()["Permissions-Policy"];
    expect(loginPolicy).toMatch(/camera=\(\)/);
  });

  test("allows camera/mic only on Nex routes via Permissions-Policy", async ({
    page,
  }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    const nexPageResponse = await page.goto("/nex");
    const nexPolicy =
      nexPageResponse?.headers()["permissions-policy"] ??
      nexPageResponse?.headers()["Permissions-Policy"];
    expect(nexPolicy).toMatch(/camera=\(self\)/);
    expect(nexPolicy).toMatch(/microphone=\(self\)/);
  });

  test("renders camera button in homework mode for authenticated students", async ({
    page,
  }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    await page.goto("/nex");
    await page.getByRole("radio", { name: /homework/i }).click();
    await expect(page.getByTestId("nex-camera-button")).toBeVisible();
    await expect(page.getByTestId("nex-camera-input")).toBeAttached();
  });

  test("hides camera button in practice mode", async ({ page }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    await page.goto("/nex");
    await page.getByRole("radio", { name: /practice/i }).click();
    await expect(page.getByTestId("nex-camera-button")).toHaveCount(0);
  });

  test("keeps private cache headers on authenticated student routes", async ({
    page,
  }) => {
    test.skip(!hasE2eStudentCredentials(), "Seeded student credentials required");

    await loginAsStudent(page);
    const response = await page.goto("/dashboard");
    const cacheControl =
      response?.headers()["cache-control"] ?? response?.headers()["Cache-Control"];
    expect(cacheControl).toMatch(/private/i);
    expect(cacheControl).toMatch(/no-store/i);
  });
});
