/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const mockGetApprovalById = vi.fn();
const mockMarkApprovalExecuted = vi.fn();
const mockRpc = vi.fn();
const mockFrom = vi.fn();

vi.mock("@/server/services/adminPlatformService", () => ({
  getApprovalById: (...args: any[]) => mockGetApprovalById(...args),
  isBulkActionRequestType: () => true,
  markApprovalExecuted: (...args: any[]) => mockMarkApprovalExecuted(...args),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    rpc: mockRpc,
    from: mockFrom,
  })),
}));

import { executeApprovedBulkAction, BulkActionExecutionError } from "@/server/services/adminBulkActionsService";

function makeQueryChain(resolvedValue: any) {
  const chain: any = {};
  chain.select = () => chain;
  chain.eq = () => chain;
  chain.order = () => chain;
  chain.limit = () => chain;
  chain.insert = () => Promise.resolve({ error: null });
  chain.update = () => chain;
  chain.maybeSingle = () => Promise.resolve(resolvedValue);
  chain.single = () => Promise.resolve(resolvedValue);
  return chain;
}

describe("admin bulk actions four-eyes enforcement", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("throws BulkActionExecutionError FORBIDDEN when the requester attempts to execute the bulk action", async () => {
    mockGetApprovalById.mockResolvedValueOnce({
      id: "approval-1",
      requestType: "bulk_comp_grant",
      title: "Grant comp seats",
      description: "Bulk grant",
      status: "approved",
      requestedBy: "admin-same",
      reviewedBy: "admin-other",
      metadata: {},
    });

    await expect(
      executeApprovedBulkAction({
        approvalId: "approval-1",
        actorUserId: "admin-same",
      }),
    ).rejects.toThrow(new BulkActionExecutionError("FORBIDDEN", "The actor who requested this bulk action cannot also execute it."));

    expect(mockMarkApprovalExecuted).not.toHaveBeenCalled();
  });

  it("allows execution and marks executed when requester differs from executor", async () => {
    mockGetApprovalById.mockResolvedValueOnce({
      id: "approval-1",
      requestType: "bulk_comp_grant",
      title: "Grant comp seats",
      description: "Bulk grant",
      status: "approved",
      requestedBy: "admin-requester",
      reviewedBy: "admin-approver",
      metadata: {
        studentIds: ["00000000-0000-4000-8000-000000000001"],
        planCode: "premium",
        reason: "Comp grant for pilot user",
      },
    });

    mockFrom.mockImplementation((table: string) => {
      if (table === "student_profiles") {
        return makeQueryChain({ data: { id: "00000000-0000-4000-8000-000000000001" }, error: null });
      }
      if (table === "subscription_plans") {
        return makeQueryChain({ data: { id: "plan-1", plan_code: "premium" }, error: null });
      }
      if (table === "student_subscriptions") {
        return makeQueryChain({ data: { id: "sub-1" }, error: null });
      }
      return makeQueryChain({ data: null, error: null });
    });

    mockRpc.mockResolvedValue({ data: null, error: null });

    const result = await executeApprovedBulkAction({
      approvalId: "approval-1",
      actorUserId: "admin-executor",
    });

    console.log("DEBUG_RESULT:", JSON.stringify(result, null, 2));

    expect(result.errors).toEqual([]);
    expect(result.affectedCount).toBe(1);
    expect(result.succeeded).toBe(1);
    expect(mockMarkApprovalExecuted).toHaveBeenCalledWith({
      approvalId: "approval-1",
      executionSummary: {
        affectedCount: 1,
        succeeded: 1,
        failed: 0,
        command: "bulk_comp_grant",
      },
    });
  });
});
