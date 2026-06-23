import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { POST as approvePOST } from "@/app/api/admin/content/review/approve/route";
import { POST as submitPOST } from "@/app/api/admin/content/review/submit/route";

const requireContentAuthor = vi.fn();
vi.mock("@/server/services/contentAuthorGuard", () => ({
  requireContentAuthor: (...args: unknown[]) => requireContentAuthor(...args),
}));

const submitForReview = vi.fn();
const approveAndPublish = vi.fn();
vi.mock("@/server/services/contentApprovalService", () => ({
  submitForReview: (...args: unknown[]) => submitForReview(...args),
  approveAndPublish: (...args: unknown[]) => approveAndPublish(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const lessonId = "00000000-0000-4000-8000-000000000701";

beforeEach(() => {
  requireContentAuthor.mockReset().mockResolvedValue({ ok: true, userId: "super-1", role: "super_admin" });
  submitForReview.mockReset().mockResolvedValue({
    id: lessonId,
    kind: "lesson",
    reviewStatus: "in_review",
    isActive: false,
    autoPublished: false,
  });
  approveAndPublish.mockReset().mockResolvedValue({
    id: lessonId,
    kind: "lesson",
    reviewStatus: "published",
    isActive: true,
  });
  recordAdminAudit.mockReset().mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("content review routes", () => {
  it("audits submit-for-review", async () => {
    const response = await submitPOST(
      new Request("https://nexus.test/api/admin/content/review/submit", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ kind: "lesson", id: lessonId }),
      }),
    );

    expect(response.status).toBe(200);
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "content.review.submit",
        targetType: "lesson",
        targetId: lessonId,
      }),
    );
  });

  it("audits approve-and-publish", async () => {
    const response = await approvePOST(
      new Request("https://nexus.test/api/admin/content/review/approve", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ kind: "lesson", id: lessonId }),
      }),
    );

    expect(response.status).toBe(200);
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "content.review.approve",
        targetType: "lesson",
        targetId: lessonId,
      }),
    );
  });

  it("returns gate failures from submit", async () => {
    const gateError = new Error("GATE_FAILED");
    (gateError as Error & { gateErrors: string[] }).gateErrors = ["Missing heading block."];
    submitForReview.mockRejectedValueOnce(gateError);

    const response = await submitPOST(
      new Request("https://nexus.test/api/admin/content/review/submit", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ kind: "lesson", id: lessonId }),
      }),
    );

    expect(response.status).toBe(422);
    const payload = (await response.json()) as {
      error: { code: string; gateErrors?: string[] };
    };
    expect(payload.error.code).toBe("GATE_FAILED");
    expect(payload.error.gateErrors).toEqual(["Missing heading block."]);
  });
});
