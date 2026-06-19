import { test, expect } from "@playwright/test";

test.describe("Public smoke", () => {
  test("landing page loads with signup CTA", async ({ page }) => {
    await page.goto("/");
    await expect(
      page.getByRole("heading", {
        name: /academic companion that grows with you/i,
      }),
    ).toBeVisible();
    await expect(page.getByRole("link", { name: /start learning free/i })).toBeVisible();
  });

  test("pricing page shows plan information", async ({ page }) => {
    await page.goto("/pricing", { waitUntil: "domcontentloaded" });
    await expect(
      page.getByRole("heading", { name: /pricing/i }),
    ).toBeVisible();
    await expect(page.getByText(/free/i).first()).toBeVisible();
  });

  test("login page renders", async ({ page }) => {
    await page.goto("/login");
    await expect(page.getByRole("button", { name: /sign in/i })).toBeVisible();
  });

  test("about page renders mission", async ({ page }) => {
    await page.goto("/about");
    await expect(
      page.getByRole("heading", {
        level: 1,
        name: /most trusted academic companion/i,
      }),
    ).toBeVisible();
  });
});

test.describe("Mobile layout", () => {
  test("no horizontal overflow on landing at 375px", async ({ page }) => {
    await page.goto("/");
    const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
    const clientWidth = await page.evaluate(() => document.documentElement.clientWidth);
    expect(scrollWidth).toBeLessThanOrEqual(clientWidth + 1);
  });
});
