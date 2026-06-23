import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { POST as createLessonPOST } from "@/app/api/admin/content/drafts/lesson/create/route";

const requireSuperAdmin = vi.fn();
vi.mock("@/server/services/superAdminGuard", () => ({
  requireSuperAdmin: (...args: unknown[]) => requireSuperAdmin(...args),
}));

const createManualDraftLesson = vi.fn();
vi.mock("@/server/services/contentGenerationService", () => ({
  createManualDraftLesson: (...args: unknown[]) => createManualDraftLesson(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const subtopicId = "00000000-0000-4000-8000-000000000201";
const lessonId = "00000000-0000-4000-8000-000000000202";

beforeEach(() => {
  requireSuperAdmin.mockReset().mockResolvedValue({ ok: true, userId: "super-1" });
  createManualDraftLesson.mockReset().mockResolvedValue({
    lessonId,
    title: "Untitled lesson",
    estimatedMinutes: 10,
    content: { blocks: [] },
    subtopicId,
  });
  recordAdminAudit.mockReset().mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("POST /api/admin/content/drafts/lesson/create", () => {
  it("creates a manual draft lesson and audits the action", async () => {
    const response = await createLessonPOST(
      new Request("https://nexus.test/api/admin/content/drafts/lesson/create", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ subtopicId, title: "Fractions intro" }),
      }),
    );

    expect(response.status).toBe(200);
    expect(createManualDraftLesson).toHaveBeenCalledWith(
      { subtopicId, title: "Fractions intro" },
      "super-1",
    );
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "content.lesson_draft.create",
        targetType: "draft_lesson",
        targetId: lessonId,
      }),
    );
  });

  it("rejects unauthenticated callers", async () => {
    requireSuperAdmin.mockResolvedValue({
      ok: false,
      status: 401,
      message: "Missing session.",
    });

    const response = await createLessonPOST(
      new Request("https://nexus.test/api/admin/content/drafts/lesson/create", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ subtopicId }),
      }),
    );

    expect(response.status).toBe(401);
    expect(createManualDraftLesson).not.toHaveBeenCalled();
  });
});
