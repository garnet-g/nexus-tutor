/**
 * @vitest-environment node
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { PATCH } from "@/app/api/admin/approvals/route";
import { POST } from "@/app/api/admin/bulk-actions/execute/route";

vi.mock("server-only", () => ({}));

const getUser = vi.fn();
const getSession = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({ auth: { getUser, getSession } })),
}));

vi.mock("@/server/services/sessionFreshnessService", () => ({
  validateSessionFreshness: vi.fn(async () => ({ ok: true })),
}));

const getApprovalById = vi.fn();
const updateApproval = vi.fn();
const executeApprovedBulkAction = vi.fn();
const recordAdminAudit = vi.fn();

vi.mock("@/server/services/adminPlatformService", () => ({
  createApproval: vi.fn(),
  listApprovals: vi.fn(),
  getApprovalById: (...args: unknown[]) => getApprovalById(...args),
  updateApproval: (...args: unknown[]) => updateApproval(...args),
  isBulkActionRequestType: (requestType: string) => requestType.startsWith("bulk_"),
}));

vi.mock("@/server/services/adminBulkActionsService", () => ({
  BulkActionExecutionError: class BulkActionExecutionError extends Error {
    code: "NOT_FOUND" | "FORBIDDEN" | "VALIDATION_ERROR";
    constructor(code: "NOT_FOUND" | "FORBIDDEN" | "VALIDATION_ERROR", message: string) {
      super(message);
      this.code = code;
    }
  },
  executeApprovedBulkAction: (...args: unknown[]) => executeApprovedBulkAction(...args),
}));

vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const APPROVAL_ID = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa";

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
  recordAdminAudit.mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("bulk action approval workflow", () => {
  it("blocks requester from approving their own bulk job (PR-125)", async () => {
    authedAs("super_admin", "requester-1");
    getApprovalById.mockResolvedValue({
      id: APPROVAL_ID,
      requestType: "bulk_comp_grant",
      requestedBy: "requester-1",
      status: "pending",
    });

    const response = await PATCH(
      new Request("https://nexus.test/api/admin/approvals", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ approvalId: APPROVAL_ID, status: "approved" }),
      }),
    );

    expect(response.status).toBe(403);
    const body = await response.json();
    expect(body.error.code).toBe("FOUR_EYES_VIOLATION");
    expect(updateApproval).not.toHaveBeenCalled();
  });

  it("returns 403 when executing without approved status (PR-070)", async () => {
    authedAs();
    const { BulkActionExecutionError } = await import(
      "@/server/services/adminBulkActionsService"
    );
    executeApprovedBulkAction.mockRejectedValue(
      new BulkActionExecutionError(
        "FORBIDDEN",
        "Bulk actions require an approved request.",
      ),
    );

    const response = await POST(
      new Request("https://nexus.test/api/admin/bulk-actions/execute", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ approvalId: APPROVAL_ID }),
      }),
    );

    expect(response.status).toBe(403);
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("executes approved bulk action with audit row (PR-069)", async () => {
    authedAs("super_admin", "executor-1");
    executeApprovedBulkAction.mockResolvedValue({
      command: "bulk_comp_grant",
      affectedCount: 2,
      succeeded: 2,
      failed: 0,
      errors: [],
      idempotentReplay: false,
    });

    const response = await POST(
      new Request("https://nexus.test/api/admin/bulk-actions/execute", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ approvalId: APPROVAL_ID }),
      }),
    );

    expect(response.status).toBe(200);
    expect(executeApprovedBulkAction).toHaveBeenCalledWith({
      approvalId: APPROVAL_ID,
      actorUserId: "executor-1",
    });
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "admin_bulk_action.execute",
        targetId: APPROVAL_ID,
        metadata: expect.objectContaining({
          command: "bulk_comp_grant",
          affectedCount: 2,
        }),
      }),
    );
  });
});
