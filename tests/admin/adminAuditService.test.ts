import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import {
  listAdminAuditLog,
  recordAdminAudit,
} from "@/server/services/adminAuditService";

vi.mock("server-only", () => ({}));

// Captured query-builder for listAdminAuditLog assertions.
const insert = vi.fn();
const order = vi.fn();
const limit = vi.fn();
const eq = vi.fn();
const lt = vi.fn();
const select = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

beforeEach(() => {
  insert.mockReset().mockResolvedValue({ error: null });
  order.mockReset();
  limit.mockReset();
  eq.mockReset();
  lt.mockReset();
  select.mockReset();
  from.mockReset();

  // Build a chainable query builder that records every call and resolves with rows.
  const builder = {
    select: select.mockImplementation(() => builder),
    order: order.mockImplementation(() => builder),
    limit: limit.mockImplementation(() => builder),
    eq: eq.mockImplementation(() => builder),
    lt: lt.mockImplementation(() => builder),
    insert: insert.mockResolvedValue({ error: null }),
    then: (resolve: (v: unknown) => unknown) =>
      resolve({ data: [], error: null }),
  };

  from.mockReturnValue(builder);
});

afterEach(() => {
  vi.clearAllMocks();
  vi.unstubAllGlobals();
});

describe("recordAdminAudit", () => {
  it("inserts a fully-shaped audit row into admin_audit_log", async () => {
    await recordAdminAudit({
      actorUserId: "actor-1",
      actorRole: "super_admin",
      action: "beta_invite.create",
      targetType: "beta_invite",
      targetId: "invite-9",
      metadata: { inviteCode: "ABC123" },
    });

    expect(from).toHaveBeenCalledWith("admin_audit_log");
    expect(insert).toHaveBeenCalledTimes(1);
    expect(insert).toHaveBeenCalledWith({
      actor_user_id: "actor-1",
      actor_role: "super_admin",
      action: "beta_invite.create",
      target_type: "beta_invite",
      target_id: "invite-9",
      metadata: { inviteCode: "ABC123" },
      ip_address: null,
      user_agent: null,
    });
  });

  it("defaults optional target fields to null and metadata to an empty object", async () => {
    await recordAdminAudit({
      actorUserId: "actor-2",
      actorRole: "support",
      action: "content.publish",
    });

    expect(insert).toHaveBeenCalledWith(
      expect.objectContaining({
        actor_user_id: "actor-2",
        actor_role: "support",
        action: "content.publish",
        target_type: null,
        target_id: null,
        metadata: {},
        ip_address: null,
        user_agent: null,
      }),
    );
  });

  it("derives ip_address from the first x-forwarded-for hop and user_agent from the header", async () => {
    const request = new Request("https://nexus.test/admin", {
      headers: {
        "x-forwarded-for": "203.0.113.9, 70.41.3.18, 150.172.238.178",
        "user-agent": "Mozilla/5.0 (Test Runner)",
      },
    });

    await recordAdminAudit({
      actorUserId: "actor-3",
      actorRole: "super_admin",
      action: "platform_setting.update",
      request,
    });

    expect(insert).toHaveBeenCalledWith(
      expect.objectContaining({
        ip_address: "203.0.113.9",
        user_agent: "Mozilla/5.0 (Test Runner)",
      }),
    );
  });

  it("leaves ip_address null when x-forwarded-for is absent", async () => {
    const request = new Request("https://nexus.test/admin", {
      headers: { "user-agent": "UA-only" },
    });

    await recordAdminAudit({
      actorUserId: "actor-4",
      actorRole: "super_admin",
      action: "content.discard",
      request,
    });

    expect(insert).toHaveBeenCalledWith(
      expect.objectContaining({ ip_address: null, user_agent: "UA-only" }),
    );
  });

  it("returns ok:false when the insert rejects, and logs the failure", async () => {
    const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    insert.mockRejectedValueOnce(new Error("db down"));

    await expect(
      recordAdminAudit({
        actorUserId: "actor-5",
        actorRole: "super_admin",
        action: "content.generate",
      }),
    ).resolves.toEqual({ ok: false, error: "db down" });

    expect(consoleSpy).toHaveBeenCalledWith(
      "ADMIN_AUDIT_RECORD_FAILED",
      "content.generate",
      expect.any(Error),
    );
  });

  it("returns ok:false when createAdminClient itself throws", async () => {
    const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const { createAdminClient } = await import("@/lib/supabase/admin");
    vi.mocked(createAdminClient).mockImplementationOnce(() => {
      throw new Error("missing service role key");
    });

    await expect(
      recordAdminAudit({
        actorUserId: "actor-6",
        actorRole: "super_admin",
        action: "content.generate",
      }),
    ).resolves.toEqual({ ok: false, error: "missing service role key" });

    expect(consoleSpy).toHaveBeenCalledWith(
      "ADMIN_AUDIT_RECORD_FAILED",
      "content.generate",
      expect.any(Error),
    );
  });
});

describe("listAdminAuditLog", () => {
  it("selects the audit columns ordered by created_at desc with the default limit", async () => {
    await listAdminAuditLog({});

    expect(from).toHaveBeenCalledWith("admin_audit_log");
    expect(select).toHaveBeenCalledWith(
      "id, actor_user_id, actor_role, action, target_type, target_id, metadata, ip_address, user_agent, created_at",
    );
    expect(order).toHaveBeenCalledWith("created_at", { ascending: false });
    expect(limit).toHaveBeenCalledWith(50);
    expect(eq).not.toHaveBeenCalled();
    expect(lt).not.toHaveBeenCalled();
  });

  it("applies action, actorUserId, before and a custom limit", async () => {
    await listAdminAuditLog({
      action: "content.publish",
      actorUserId: "actor-7",
      before: "2026-06-22T00:00:00.000Z",
      limit: 10,
    });

    expect(limit).toHaveBeenCalledWith(10);
    expect(eq).toHaveBeenCalledWith("action", "content.publish");
    expect(eq).toHaveBeenCalledWith("actor_user_id", "actor-7");
    expect(lt).toHaveBeenCalledWith("created_at", "2026-06-22T00:00:00.000Z");
  });

  it("returns an empty array when the query yields no rows", async () => {
    const rows = await listAdminAuditLog({});

    expect(rows).toEqual([]);
  });

  it("throws when the query returns an error", async () => {
    const builder = {
      select: vi.fn().mockReturnThis(),
      order: vi.fn().mockReturnThis(),
      limit: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      lt: vi.fn().mockReturnThis(),
      then: (resolve: (v: unknown) => unknown) =>
        resolve({ data: null, error: { message: "boom" } }),
    };
    from.mockReturnValueOnce(builder);

    await expect(listAdminAuditLog({})).rejects.toThrow("boom");
  });
});
