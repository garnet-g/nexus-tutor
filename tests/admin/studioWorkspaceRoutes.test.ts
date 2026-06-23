import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { PATCH as bulkPATCH } from "@/app/api/admin/content/studio/topics/[topicId]/questions/bulk/route";
import { PATCH as reorderPATCH } from "@/app/api/admin/content/studio/subtopics/[subtopicId]/lessons/reorder/route";

const requireContentAuthor = vi.fn();
vi.mock("@/server/services/contentAuthorGuard", () => ({
  requireContentAuthor: (...args: unknown[]) => requireContentAuthor(...args),
}));

const bulkSaveTopicQuestions = vi.fn();
const reorderSubtopicLessons = vi.fn();
vi.mock("@/server/services/contentStudioService", () => ({
  bulkSaveTopicQuestions: (...args: unknown[]) => bulkSaveTopicQuestions(...args),
  reorderSubtopicLessons: (...args: unknown[]) => reorderSubtopicLessons(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const topicId = "00000000-0000-4000-8000-000000000501";
const subtopicId = "00000000-0000-4000-8000-000000000502";

beforeEach(() => {
  requireContentAuthor.mockReset().mockResolvedValue({ ok: true, userId: "super-1", role: "super_admin" });
  bulkSaveTopicQuestions.mockReset().mockResolvedValue({
    createdIds: ["q-new"],
    updatedIds: [],
    archivedIds: [],
    errors: [],
  });
  reorderSubtopicLessons.mockReset().mockResolvedValue({
    subtopicId,
    lessonIds: [
      "00000000-0000-4000-8000-000000000601",
      "00000000-0000-4000-8000-000000000602",
    ],
  });
  recordAdminAudit.mockReset().mockResolvedValue(undefined);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("studio workspace mutation routes", () => {
  it("audits bulk question saves", async () => {
    const response = await bulkPATCH(
      new Request(`https://nexus.test/api/admin/content/studio/topics/${topicId}/questions/bulk`, {
        method: "PATCH",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          questions: [
            {
              questionText: "What is 1 + 1?",
              questionType: "multiple_choice",
              options: ["1", "2"],
              correctAnswer: "2",
              difficulty: "easy",
              explanation: "Basic addition.",
            },
          ],
        }),
      }),
      { params: Promise.resolve({ topicId }) },
    );

    expect(response.status).toBe(200);
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "content.questions.bulk_save",
        targetType: "topic",
        targetId: topicId,
      }),
    );
  });

  it("audits lesson reorder operations", async () => {
    const response = await reorderPATCH(
      new Request(
        `https://nexus.test/api/admin/content/studio/subtopics/${subtopicId}/lessons/reorder`,
        {
          method: "PATCH",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({
            lessonIds: [
              "00000000-0000-4000-8000-000000000601",
              "00000000-0000-4000-8000-000000000602",
            ],
          }),
        },
      ),
      { params: Promise.resolve({ subtopicId }) },
    );

    expect(response.status).toBe(200);
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "content.lessons.reorder",
        targetType: "subtopic",
        targetId: subtopicId,
      }),
    );
  });
});
