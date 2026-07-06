/**
 * @vitest-environment node
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { GET } from "@/app/api/admin/reports/export/route";

vi.mock("server-only", () => ({}));

const getUser = vi.fn();
const getSession = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({ auth: { getUser, getSession } })),
}));

vi.mock("@/server/services/sessionFreshnessService", () => ({
  validateSessionFreshness: vi.fn(async () => ({ ok: true })),
}));

const buildAdminReportCsv = vi.fn();
vi.mock("@/server/services/adminReportExportService", () => ({
  buildAdminReportCsv: (...args: unknown[]) => buildAdminReportCsv(...args),
  isAdminReportExportKey: (value: string) =>
    ["users", "payments", "content", "audit"].includes(value),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

function authedAs(role = "super_admin", userId = "admin-1") {
  getUser.mockResolvedValue({
    data: { user: { id: userId, app_metadata: { userRole: role } } },
    error: null,
  });
  getSession.mockResolvedValue({
    data: { session: { access_token: "header.payload.signature" } },
    error: null,
  });
}

beforeEach(() => {
  vi.clearAllMocks();
  buildAdminReportCsv.mockResolvedValue({
    filename: "nexus-users-report.csv",
    csv: "id,fullName\n1,Alice\n",
    rowCount: 1,
  });
  recordAdminAudit.mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("GET /api/admin/reports/export", () => {
  it("returns CSV attachment and records admin_report_export audit row", async () => {
    authedAs();

    const response = await GET(
      new Request("https://nexus.test/api/admin/reports/export?key=users"),
    );

    expect(response.status).toBe(200);
    expect(response.headers.get("Content-Type")).toContain("text/csv");
    expect(response.headers.get("Content-Disposition")).toContain(
      "nexus-users-report.csv",
    );
    expect(await response.text()).toContain("Alice");
    expect(buildAdminReportCsv).toHaveBeenCalledWith("users");
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        actorUserId: "admin-1",
        actorRole: "super_admin",
        action: "admin_report_export",
        targetType: "admin_report",
        targetId: "users",
        metadata: expect.objectContaining({
          exportKey: "users",
          rowCount: 1,
        }),
      }),
    );
  });

  it("rejects invalid export keys", async () => {
    authedAs();

    const response = await GET(
      new Request("https://nexus.test/api/admin/reports/export?key=unknown"),
    );

    expect(response.status).toBe(400);
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });
});
