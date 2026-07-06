import type { Page } from "@playwright/test";

export function hasE2eStudentCredentials(): boolean {
  return Boolean(
    process.env.E2E_STUDENT_EMAIL?.trim() &&
      process.env.E2E_STUDENT_PASSWORD?.trim(),
  );
}

export function hasE2eParentCredentials(): boolean {
  return Boolean(
    process.env.E2E_PARENT_EMAIL?.trim() && process.env.E2E_PARENT_PASSWORD?.trim(),
  );
}

export function hasE2eAdminCredentials(): boolean {
  return Boolean(
    process.env.E2E_SUPER_ADMIN_EMAIL?.trim() &&
      process.env.E2E_SUPER_ADMIN_PASSWORD?.trim(),
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

export async function loginAsParent(page: Page): Promise<void> {
  const email = process.env.E2E_PARENT_EMAIL;
  const password = process.env.E2E_PARENT_PASSWORD;

  if (!email || !password) {
    throw new Error("E2E_PARENT_EMAIL and E2E_PARENT_PASSWORD must be set");
  }

  await page.goto("/login");
  await page.getByLabel(/^email$/i).fill(email);
  await page.getByLabel(/^password$/i).fill(password);
  await page.getByRole("button", { name: /sign in/i }).click();
  await page.waitForURL(/\/parent/, { timeout: 30_000 });
}

export async function loginAsSuperAdmin(page: Page): Promise<void> {
  const email = process.env.E2E_SUPER_ADMIN_EMAIL;
  const password = process.env.E2E_SUPER_ADMIN_PASSWORD;

  if (!email || !password) {
    throw new Error("E2E_SUPER_ADMIN_EMAIL and E2E_SUPER_ADMIN_PASSWORD must be set");
  }

  await page.goto("/login");
  await page.getByLabel(/^email$/i).fill(email);
  await page.getByLabel(/^password$/i).fill(password);
  await page.getByRole("button", { name: /sign in/i }).click();
  await page.waitForURL(/\/admin/, { timeout: 30_000 });
}
