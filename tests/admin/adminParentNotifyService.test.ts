import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { sendParentSms } from "@/server/services/adminParentNotifyService";

const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const sendCelcomSms = vi.fn();
vi.mock("@/lib/celcom/celcomClient", () => ({
  sendCelcomSms: (...args: unknown[]) => sendCelcomSms(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

function parentLinkBuilder(data: unknown) {
  const builder = {
    select: vi.fn(() => builder),
    eq: vi.fn(() => builder),
    order: vi.fn(() => builder),
    limit: vi.fn(() => builder),
    maybeSingle: vi.fn(async () => ({ data, error: null })),
  };

  return builder;
}

beforeEach(() => {
  from.mockReset().mockReturnValue(parentLinkBuilder(null));
  sendCelcomSms.mockReset();
  recordAdminAudit.mockReset();
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("sendParentSms", () => {
  it("returns NO_PARENT_PHONE without sending SMS when no active parent phone exists", async () => {
    const result = await sendParentSms({
      studentId: "student-1",
      message: "Please contact Nexus support.",
      adminUserId: "super-1",
    });

    expect(result).toEqual({
      ok: false,
      code: "NO_PARENT_PHONE",
      message: "No active parent with a phone number is linked to this student.",
    });
    expect(from).toHaveBeenCalledWith("student_parent_links");
    expect(sendCelcomSms).not.toHaveBeenCalled();
    expect(recordAdminAudit).toHaveBeenCalledWith({
      actorUserId: "super-1",
      actorRole: "super_admin",
      action: "parent.sms.send",
      targetType: "student",
      targetId: "student-1",
      metadata: {
        studentId: "student-1",
        smsStatus: "no_parent_phone",
      },
      request: undefined,
    });
  });
});
