/**
 * @vitest-environment node
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const root = process.cwd();
const migrationsDir = join(root, "supabase", "migrations");
const migrationName = readdirSync(migrationsDir).find((name) =>
  name.endsWith("_market_readiness_billing_and_past_papers.sql"),
);

function readMigration(): string {
  expect(migrationName, "Market readiness billing migration").toBeDefined();
  return readFileSync(join(migrationsDir, migrationName!), "utf8");
}

describe("process_verified_mpesa_payment billing-cycle intervals", () => {
  it("seeds premium_daily, premium_weekly, and premium_termly plans", () => {
    const sql = readMigration();

    expect(sql).toMatch(/'premium_daily',\s*'Premium Daily',\s*20,\s*'daily'/i);
    expect(sql).toMatch(/'premium_weekly',\s*'Premium Weekly',\s*150,\s*'weekly'/i);
    expect(sql).toMatch(/'premium_termly',\s*'Premium Termly',\s*1800,\s*'termly'/i);
  });

  it("derives the subscription period end from the plan's billing_cycle", () => {
    const sql = readMigration();

    expect(sql).toMatch(/plan\.billing_cycle/);
    expect(sql).toMatch(
      /v_period_end\s*:=\s*CASE\s+v_billing_cycle[\s\S]*?WHEN\s+'daily'\s+THEN\s+v_period_start\s*\+\s*INTERVAL\s+'1 day'/i,
    );
    expect(sql).toMatch(/WHEN\s+'weekly'\s+THEN\s+v_period_start\s*\+\s*INTERVAL\s+'7 days'/i);
    expect(sql).toMatch(/WHEN\s+'termly'\s+THEN\s+v_period_start\s*\+\s*INTERVAL\s+'120 days'/i);
    expect(sql).toMatch(/ELSE\s+v_period_start\s*\+\s*INTERVAL\s+'30 days'/i);
  });

  it("allows any non-free plan to be paid instead of hardcoding premium/family", () => {
    const sql = readMigration();

    expect(sql).toMatch(/IF\s+v_plan_code\s*=\s*'free'\s+THEN\s*\n\s*RAISE EXCEPTION 'Plan is not payable'/i);
    expect(sql).not.toMatch(/v_plan_code NOT IN \('premium', 'family'\)/);
  });

  it("keeps the function service-role only", () => {
    const sql = readMigration();

    expect(sql).toMatch(
      /grant\s+execute\s+on\s+function\s+public\.process_verified_mpesa_payment[^;]*\s+to\s+service_role/i,
    );
  });
});

describe("non-free plan checks in application code", () => {
  it("getNexDailyLimit and getPracticeDailyLimit treat every non-free plan as premium", () => {
    const source = readFileSync(
      join(root, "src", "lib", "platform", "getPlatformSettings.ts"),
      "utf8",
    );

    expect(source).toMatch(/if \(planCode !== "free"\) \{\s*\n\s*return config\.limits\.premiumNex;/);
    expect(source).toMatch(/if \(planCode !== "free"\) \{\s*\n\s*return config\.limits\.premiumPractice;/);
  });

  it("canAccessExamStudyPlan and resolvePlanAmountKes support dynamic non-free plans", () => {
    const source = readFileSync(
      join(root, "src", "server", "services", "subscriptionService.ts"),
      "utf8",
    );

    expect(source).toContain('return planCode !== "free";');
    expect(source).toContain('.from("subscription_plans")');
  });
});
