import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { POST as assistPOST } from "@/app/api/admin/content/assist/route";

const requireContentAuthor = vi.fn();
vi.mock("@/server/services/contentAuthorGuard", () => ({
  requireContentAuthor: (...args: unknown[]) => requireContentAuthor(...args),
}));

const runContentAssist = vi.fn();
vi.mock("@/server/services/contentAssistService", () => ({
  runContentAssist: (...args: unknown[]) => runContentAssist(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const subtopicId = "00000000-0000-4000-8000-000000000501";

beforeEach(() => {
  requireContentAuthor.mockReset().mockResolvedValue({
    ok: true,
    userId: "super-1",
    role: "super_admin",
  });
  runContentAssist.mockReset().mockResolvedValue({
    model: "test-model",
    result: {
      title: "Draft lesson",
      estimatedMinutes: 10,
      blocks: [{ type: "heading", content: "Intro" }],
    },
  });
  recordAdminAudit.mockReset().mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("content assist route", () => {
  it("audits draft lesson assist without persisting content", async () => {
    const response = await assistPOST(
      new Request("https://nexus.test/api/admin/content/assist", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          action: "draft_lesson",
          subtopicId,
          curriculum: "KCSE",
          gradeLevel: "Form 2",
        }),
      }),
    );

    expect(response.status).toBe(200);
    expect(runContentAssist).toHaveBeenCalled();
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "content.assist.draft_lesson",
        targetType: "subtopic",
        targetId: subtopicId,
      }),
    );
  });
});
