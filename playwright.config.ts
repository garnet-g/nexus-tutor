import { defineConfig, devices } from "@playwright/test";

const E2E_PORT = 3000;
const E2E_BASE_URL = `http://localhost:${E2E_PORT}`;

/** CI harness: `test:e2e:ci` sets CI via npm lifecycle; Playwright starts/stops production server. */
const isCiHarness =
  process.env.CI === "true" ||
  process.env.npm_lifecycle_event === "test:e2e:ci";

if (isCiHarness) {
  process.env.CI = "true";
}

export default defineConfig({
  testDir: "./e2e",
  globalSetup: "./e2e/global-setup.ts",
  fullyParallel: true,
  forbidOnly: isCiHarness,
  retries: isCiHarness ? 2 : 0,
  workers: isCiHarness ? 1 : undefined,
  reporter: "list",
  timeout: 60_000,
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? E2E_BASE_URL,
    trace: "on-first-retry",
    viewport: { width: 375, height: 812 },
    navigationTimeout: 60_000,
  },
  projects: [
    {
      name: "mobile-chrome",
      use: { ...devices["Pixel 5"] },
    },
  ],
  webServer: isCiHarness
    ? {
        command: `npm run start -- -p ${E2E_PORT}`,
        url: E2E_BASE_URL,
        reuseExistingServer: false,
        timeout: 120_000,
      }
    : {
        command: "npm run dev",
        url: E2E_BASE_URL,
        reuseExistingServer: true,
        timeout: 120_000,
      },
});
