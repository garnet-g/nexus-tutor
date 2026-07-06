import { test, expect } from "@playwright/test";

test.describe("Public error recovery", () => {
  test("shows retry actions when a client render error is forced", async ({ page }) => {
    await page.goto("/e2e-force-error?forceError=1");
    await expect(page.getByText("Page unavailable")).toBeVisible();
    await expect(page.getByRole("button", { name: /try again/i })).toBeVisible();
    await expect(page.getByRole("button", { name: /^home$/i })).toBeVisible();
  });
});
