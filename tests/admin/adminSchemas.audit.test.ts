import { describe, expect, it } from "vitest";

import {
  auditLogActionSchema,
  auditLogQuerySchema,
} from "@/schemas/adminSchemas";

const EXPECTED_ACTIONS = [
  "platform_setting.update",
  "subscription_plan.update",
  "beta_invite.create",
  "content.generate",
  "content.publish",
  "content.discard",
  "content.lesson_draft.update",
  "content.question_draft.update",
  "assessment.calibration.create",
  "subscription.comp",
  "user.profile.update",
  "user.impersonate.start",
  "user.impersonate.end",
  "nex_flag.create",
  "nex_flag.resolve",
  "parent.sms.send",
  "coupon.create",
  "coupon.deactivate",
  "support_case.create",
  "support_case.update",
  "feature_rollout.upsert",
  "admin_alert.create",
  "admin_alert.update",
  "admin_role.assign",
  "admin_communication_template.create",
  "admin_experiment.create",
  "admin_saved_view.create",
  "admin_approval.create",
  "admin_approval.update",
] as const;

describe("auditLogActionSchema", () => {
  it("enumerates exactly the supported admin audit actions", () => {
    expect(auditLogActionSchema.options).toEqual(EXPECTED_ACTIONS);
    expect(auditLogActionSchema.options).toHaveLength(EXPECTED_ACTIONS.length);
  });

  it("accepts every supported action", () => {
    for (const action of EXPECTED_ACTIONS) {
      expect(auditLogActionSchema.safeParse(action).success).toBe(true);
    }
  });

  it("rejects an unknown action", () => {
    expect(auditLogActionSchema.safeParse("content.delete").success).toBe(false);
  });
});

describe("auditLogQuerySchema", () => {
  it("parses an empty query (all filters optional)", () => {
    const parsed = auditLogQuerySchema.safeParse({});
    expect(parsed.success).toBe(true);
  });

  it("parses a fully-specified valid query and coerces limit to a number", () => {
    const parsed = auditLogQuerySchema.safeParse({
      action: "content.publish",
      actorUserId: "00000000-0000-4000-8000-000000000001",
      limit: "25",
      before: "2026-06-22T00:00:00.000Z",
    });

    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.limit).toBe(25);
      expect(typeof parsed.data.limit).toBe("number");
    }
  });

  it("rejects an invalid action", () => {
    const parsed = auditLogQuerySchema.safeParse({ action: "nope" });
    expect(parsed.success).toBe(false);
  });

  it("rejects a non-uuid actorUserId", () => {
    const parsed = auditLogQuerySchema.safeParse({ actorUserId: "not-a-uuid" });
    expect(parsed.success).toBe(false);
  });

  it("enforces the lower limit bound (>= 1)", () => {
    expect(auditLogQuerySchema.safeParse({ limit: "0" }).success).toBe(false);
  });

  it("enforces the upper limit bound (<= 200)", () => {
    expect(auditLogQuerySchema.safeParse({ limit: "201" }).success).toBe(false);
    expect(auditLogQuerySchema.safeParse({ limit: "200" }).success).toBe(true);
  });

  it("rejects a non-integer limit", () => {
    expect(auditLogQuerySchema.safeParse({ limit: "10.5" }).success).toBe(false);
  });

  it("requires before to be an ISO datetime", () => {
    expect(auditLogQuerySchema.safeParse({ before: "2026-06-22" }).success).toBe(
      false,
    );
    expect(
      auditLogQuerySchema.safeParse({ before: "2026-06-22T00:00:00.000Z" })
        .success,
    ).toBe(true);
  });
});
