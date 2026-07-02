/**
 * @vitest-environment node
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const root = process.cwd();
const migrationsDir = join(root, "supabase", "migrations");
const repairMigrationName = readdirSync(migrationsDir).find((name) =>
  name.endsWith("_phase03_payment_security_repair.sql"),
);

function readRepairMigration(): string {
  expect(repairMigrationName, "Phase 03 payment security repair migration").toBeDefined();
  return readFileSync(join(migrationsDir, repairMigrationName!), "utf8");
}

describe("Phase 03 production payment repair", () => {
  it("restricts every payment mutation RPC to service_role", () => {
    const sql = readRepairMigration();

    for (const functionName of [
      "transition_mpesa_payment",
      "record_mpesa_callback_event",
      "verify_and_mark_mpesa_paid",
      "process_verified_mpesa_payment",
    ]) {
      expect(sql).toMatch(
        new RegExp(
          `revoke\\s+all\\s+on\\s+function\\s+public\\.${functionName}[^;]*\\s+from\\s+public`,
          "i",
        ),
      );
      expect(sql).toMatch(
        new RegExp(
          `revoke\\s+all\\s+on\\s+function\\s+public\\.${functionName}[^;]*\\s+from\\s+anon\\s*,\\s*authenticated`,
          "i",
        ),
      );
      expect(sql).toMatch(
        new RegExp(
          `grant\\s+execute\\s+on\\s+function\\s+public\\.${functionName}[^;]*\\s+to\\s+service_role`,
          "i",
        ),
      );
    }
  });

  it("uses security invoker and one atomic payment-entitlement RPC", () => {
    const sql = readRepairMigration();

    expect(sql).toMatch(
      /create\s+or\s+replace\s+function\s+public\.process_verified_mpesa_payment/i,
    );
    expect(sql).toMatch(/security\s+invoker/i);
    expect(sql).toMatch(/for\s+update/i);
    expect(sql).toMatch(/insert\s+into\s+public\.student_subscriptions/i);
    expect(sql).toMatch(/insert\s+into\s+public\.payment_transactions/i);
    expect(sql).toMatch(/insert\s+into\s+public\.billing_events/i);
    expect(sql).toMatch(/insert\s+into\s+public\.invoices/i);
    expect(sql).toMatch(/insert\s+into\s+public\.family_groups/i);
    expect(sql).toMatch(/insert\s+into\s+public\.family_group_members/i);
  });

  it("enforces one entitlement side-effect set per payment", () => {
    const sql = readRepairMigration();

    expect(sql).toMatch(
      /create\s+unique\s+index[^;]+payment_transactions[\s\S]+?mpesa_payment_id/i,
    );
    expect(sql).toMatch(
      /create\s+unique\s+index[^;]+invoices[\s\S]+?mpesa_payment_id/i,
    );
    expect(sql).toMatch(
      /create\s+unique\s+index[^;]+billing_events[\s\S]+?mpesaPaymentId/i,
    );
  });

  it("routes application activation through the atomic RPC", () => {
    const service = readFileSync(
      join(root, "src", "server", "services", "subscriptionService.ts"),
      "utf8",
    );

    expect(service).toContain('.rpc("process_verified_mpesa_payment"');
  });
});

describe("M-Pesa integration test isolation", () => {
  it("does not load production credentials or create unmanaged remote fixtures", () => {
    const mpesaTestsDir = join(root, "tests", "mpesa");
    const mutatingSuites = readdirSync(mpesaTestsDir)
      .filter((name) => name.endsWith(".test.ts"))
      .filter((name) => name !== "paymentSecurityRepair.test.ts")
      .map((name) => ({
        name,
        source: readFileSync(join(mpesaTestsDir, name), "utf8"),
      }))
      .filter(({ source }) => source.includes("createAdminClient"));

    expect(mutatingSuites.length).toBeGreaterThan(0);
    for (const suite of mutatingSuites) {
      expect(suite.source, `${suite.name} must not load .env.local`).not.toContain(
        'join(process.cwd(), ".env.local")',
      );
      expect(
        suite.source,
        `${suite.name} must use the isolated database guard`,
      ).toContain("assertIsolatedTestDatabase");
      if (suite.source.includes("auth.admin.createUser")) {
        expect(
          suite.source,
          `${suite.name} must register fixture cleanup`,
        ).toContain("registerTestUserCleanup");
      }
    }
  });
});
