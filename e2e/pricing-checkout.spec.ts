import { test, expect } from "@playwright/test";

import { hasE2eStudentCredentials, loginAsStudent } from "./fixtures/auth";

test.describe("Pricing checkout — provider down", () => {
  test.skip(!hasE2eStudentCredentials(), "Requires E2E_STUDENT_EMAIL/PASSWORD");

  test("shows recoverable message when M-Pesa STK push fails", async ({ page }) => {
    await loginAsStudent(page);

    await page.route("**/api/mpesa/stk-push", async (route) => {
      await route.fulfill({
        status: 502,
        contentType: "application/json",
        body: JSON.stringify({
          success: false,
          error: {
            code: "MPESA_PAYMENT_FAILED",
            message: "M-Pesa STK push failed.",
          },
        }),
      });
    });

    await page.goto("/pricing", { waitUntil: "domcontentloaded" });
    await page.getByLabel(/m-pesa phone number/i).fill("+254712345678");
    await page.getByRole("button", { name: /send stk push/i }).click();

    await expect(page.getByTestId("checkout-provider-error")).toBeVisible();
    await expect(
      page.getByText(/m-pesa is temporarily unavailable/i),
    ).toBeVisible();
    await expect(page.getByRole("button", { name: /send stk push/i })).toBeEnabled();
  });
});
