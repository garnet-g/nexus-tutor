import type { Page } from "@playwright/test";

export function hasE2eStudentCredentials(): boolean {
  return Boolean(
    process.env.E2E_STUDENT_EMAIL?.trim() &&
      process.env.E2E_STUDENT_PASSWORD?.trim(),
  );
}

export async function loginAsStudent(page: Page): Promise<void> {
  const email = process.env.E2E_STUDENT_EMAIL;
  const password = process.env.E2E_STUDENT_PASSWORD;

  if (!email || !password) {
    throw new Error(
      "E2E_STUDENT_EMAIL and E2E_STUDENT_PASSWORD must be set for authenticated tests",
    );
  }

  await page.goto("/login");
  await page.getByLabel(/^email$/i).fill(email);
  await page.getByLabel(/^password$/i).fill(password);
  await page.getByRole("button", { name: /sign in/i }).click();
  await page.waitForURL(/\/(onboarding|dashboard|diagnostic)/, {
    timeout: 30_000,
  });
}
