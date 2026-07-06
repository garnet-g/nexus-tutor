import AxeBuilder from "@axe-core/playwright";
import { test, expect } from "@playwright/test";

const KEYBOARD_CHECKLIST = [
  "Tab order reaches primary navigation and main CTA on landing",
  "Enter/Space activates Nex mode toggles on /nex",
  "Escape closes student utility drawers/modals",
  "Focus ring visible on interactive controls (manual contrast check)",
];

test.describe("accessibility smoke", () => {
  test("landing page has no serious axe violations", async ({ page }) => {
    await page.goto("/");
    const results = await new AxeBuilder({ page })
      .withTags(["wcag2a", "wcag2aa"])
      .analyze();

    const serious = results.violations.filter(
      (violation) => violation.impact === "serious" || violation.impact === "critical",
    );
    expect(serious).toEqual([]);
  });

  test("login page has no serious axe violations", async ({ page }) => {
    await page.goto("/login");
    const results = await new AxeBuilder({ page }).analyze();
    const serious = results.violations.filter(
      (violation) => violation.impact === "serious" || violation.impact === "critical",
    );
    expect(serious).toEqual([]);
  });

  test("records keyboard checklist items requiring human verification", async () => {
    expect(KEYBOARD_CHECKLIST.length).toBeGreaterThanOrEqual(4);
    test.info().annotations.push({
      type: "human-checklist",
      description: KEYBOARD_CHECKLIST.join(" | "),
    });
  });
});
