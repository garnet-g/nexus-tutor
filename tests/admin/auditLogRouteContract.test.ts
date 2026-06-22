import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { GET } from "@/app/api/admin/audit-log/route";

vi.mock("server-only", () => ({}));

const getUser = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({ auth: { getUser } })),
}));

// admin_audit_log query builder used by listAdminAuditLog.
const select = vi.fn();
const order = vi.fn();
const limit = vi.fn();
const eq = vi.fn();
const lt = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const SAMPLE_ROWS = [
  {
    id: "11111111-1111-4111-8111-111111111111",
    actor_user_id: "actor-1",
    actor_role: "super_admin",
    action: "beta_invite.create",
    target_type: "beta_invite",
    target_id: "invite-1",
    metadata: {},
    ip_address: "203.0.113.9",
    user_agent: "UA",
    created_at: "2026-06-22T00:00:00.000Z",
  },
];

function authedAs(role: string | undefined, userId = "user-1") {
  getUser.mockResolvedValue({
    data: {
      user: {
        id: userId,
        app_metadata: role === undefined ? {} : { userRole: role },
      },
    },
    error: null,
  });
}

function makeRequest(query = ""): Request {
  return new Request(`https://nexus.test/api/admin/audit-log${query}`);
}

beforeEach(() => {
  getUser.mockReset();

  const builder = {
    select: select.mockImplementation(() => builder),
    order: order.mockImplementation(() => builder),
    limit: limit.mockImplementation(() => builder),
    eq: eq.mockImplementation(() => builder),
    lt: lt.mockImplementation(() => builder),
    then: (resolve: (v: unknown) => unknown) =>
      resolve({ data: SAMPLE_ROWS, error: null }),
  };
  from.mockReset().mockReturnValue(builder);
  select.mockReset().mockImplementation(() => builder);
  order.mockReset().mockImplementation(() => builder);
  limit.mockReset().mockImplementation(() => builder);
  eq.mockReset().mockImplementation(() => builder);
  lt.mockReset().mockImplementation(() => builder);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("GET /api/admin/audit-log", () => {
  it("returns 401 UNAUTHORIZED when there is no session", async () => {
    getUser.mockResolvedValue({ data: { user: null }, error: null });

    const response = await GET(makeRequest());
    const body = await response.json();

    expect(response.status).toBe(401);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe("UNAUTHORIZED");
  });

  it("returns 200 with entries for a support role", async () => {
    authedAs("support");

    const response = await GET(makeRequest());
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body).toEqual({ success: true, data: { entries: SAMPLE_ROWS } });
  });

  it("returns 200 for a super_admin role", async () => {
    authedAs("super_admin");

    const response = await GET(makeRequest());
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.success).toBe(true);
    expect(body.data.entries).toHaveLength(1);
  });

  it("returns 403 FORBIDDEN for a non-admin role", async () => {
    authedAs("teacher");

    const response = await GET(makeRequest());
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe("FORBIDDEN");
  });

  it("returns 400 VALIDATION_ERROR for an out-of-range limit", async () => {
    authedAs("super_admin");

    const response = await GET(makeRequest("?limit=9999"));
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe("VALIDATION_ERROR");
  });

  it("returns 400 VALIDATION_ERROR for an unknown action filter", async () => {
    authedAs("super_admin");

    const response = await GET(makeRequest("?action=not_a_real_action"));
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
  });

  it("forwards validated filters into the audit query", async () => {
    authedAs("support");

    const response = await GET(
      makeRequest(
        "?action=content.publish&limit=5&before=2026-06-22T00:00:00.000Z",
      ),
    );

    expect(response.status).toBe(200);
    expect(limit).toHaveBeenCalledWith(5);
    expect(eq).toHaveBeenCalledWith("action", "content.publish");
    expect(lt).toHaveBeenCalledWith("created_at", "2026-06-22T00:00:00.000Z");
  });
});
