import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { PATCH as lessonPATCH } from "@/app/api/admin/content/drafts/lesson/route";
import { PATCH as questionPATCH } from "@/app/api/admin/content/drafts/question/route";

const requireSuperAdmin = vi.fn();
vi.mock("@/server/services/superAdminGuard", () => ({
  requireSuperAdmin: (...args: unknown[]) => requireSuperAdmin(...args),
}));

const updateDraftLesson = vi.fn();
const updateDraftQuestion = vi.fn();
vi.mock("@/server/services/contentGenerationService", () => ({
  updateDraftLesson: (...args: unknown[]) => updateDraftLesson(...args),
  updateDraftQuestion: (...args: unknown[]) => updateDraftQuestion(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const lessonId = "00000000-0000-4000-8000-000000000101";
const questionId = "00000000-0000-4000-8000-000000000102";

beforeEach(() => {
  requireSuperAdmin.mockReset().mockResolvedValue({
    ok: true,
    userId: "super-1",
  });
  updateDraftLesson.mockReset().mockResolvedValue({ id: lessonId });
  updateDraftQuestion.mockReset().mockResolvedValue({ id: questionId });
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

  it("audits successful draft question updates without logging full answer content", async () => {
    const response = await questionPATCH(
      new Request("https://nexus.test/api/admin/content/drafts/question", {
        method: "PATCH",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          id: questionId,
          questionText: "What is 2 + 2?",
          questionType: "multiple_choice",
          options: ["3", "4"],
          correctAnswer: "4",
          difficulty: "easy",
          explanation: "Two plus two equals four.",
        }),
      }),
    );

    expect(response.status).toBe(200);
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        actorUserId: "super-1",
        actorRole: "super_admin",
        action: "content.question_draft.update",
        targetType: "draft_question",
        targetId: questionId,
        metadata: {
          questionId,
          questionType: "multiple_choice",
          difficulty: "easy",
          optionCount: 2,
        },
      }),
    );
  });
});
