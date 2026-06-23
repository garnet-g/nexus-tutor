import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { PATCH as lessonPATCH } from "@/app/api/admin/content/drafts/lesson/route";

const requireContentAuthor = vi.fn();
vi.mock("@/server/services/contentAuthorGuard", () => ({
  requireContentAuthor: (...args: unknown[]) => requireContentAuthor(...args),
}));

const updateDraftLesson = vi.fn();
vi.mock("@/server/services/contentGenerationService", () => ({
  updateDraftLesson: (...args: unknown[]) => updateDraftLesson(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const lessonId = "00000000-0000-4000-8000-000000000101";

beforeEach(() => {
  requireContentAuthor.mockReset().mockResolvedValue({
    ok: true,
    userId: "super-1",
    role: "super_admin",
  });
  updateDraftLesson.mockReset().mockResolvedValue({ id: lessonId });
  recordAdminAudit.mockReset().mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("content draft update audit routes", () => {
  it("audits successful draft lesson updates without logging full lesson body", async () => {
    const response = await lessonPATCH(
      new Request("https://nexus.test/api/admin/content/drafts/lesson", {
        method: "PATCH",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          id: lessonId,
          title: "Linear equations",
          estimatedMinutes: 15,
          blocks: [{ type: "paragraph", content: "Solve step by step." }],
          shortQuiz: {
            questions: [
              {
                questionText: "What is x if x + 2 = 5?",
                options: ["2", "3"],
                correctAnswer: "3",
              },
            ],
          },
        }),
      }),
    );

    expect(response.status).toBe(200);
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        actorUserId: "super-1",
        actorRole: "super_admin",
        action: "content.lesson_draft.update",
        targetType: "draft_lesson",
        targetId: lessonId,
        metadata: {
          lessonId,
          title: "Linear equations",
          blockCount: 1,
          quizQuestionCount: 1,
        },
      }),
    );
  });
});
