import { describe, expect, it, vi } from "vitest";

vi.mock("@/lib/supabase/admin", () => ({ createAdminClient: vi.fn() }));

import { createAdminClient } from "@/lib/supabase/admin";
import { getExamPaperResults, selfMarkExamPaperSession } from "@/server/services/examPaperService";

function makeFakeAdmin() {
  const answerUpdates: any[] = [];
  const sessionUpdates: any[] = [];

  return {
    answerUpdates,
    sessionUpdates,
    from(table: string) {
      if (table === "exam_paper_sessions") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({
                maybeSingle: () =>
                  Promise.resolve({
                    data: {
                      id: "s1",
                      status: "submitted",
                      total_marks: 5,
                      verified_marks: 0,
                      self_awarded_marks: 0,
                    },
                  }),
              }),
            }),
          }),
          update: (payload: any) => {
            sessionUpdates.push(payload);
            return { eq: () => Promise.resolve({ data: null, error: null }) };
          },
        };
      }
      if (table === "exam_paper_session_questions") {
        return {
          select: () => ({
            eq: () => ({
              eq: () =>
                Object.assign(
                  Promise.resolve({ data: [{ id: "q1", topic_id: "topic-angles" }] }),
                  {
                    order: () =>
                      Promise.resolve({
                        data: [
                          {
                            id: "q1",
                            question_number: 1,
                            section: "I",
                            rendered_stem: "stem",
                            rendered_parts: [{ label: "a", prompt: "Compute.", marks: 3 }],
                          },
                        ],
                      }),
                  },
                ),
              order: () =>
                Promise.resolve({
                  data: [
                    {
                      id: "q1",
                      question_number: 1,
                      section: "I",
                      rendered_stem: "stem",
                      rendered_parts: [{ label: "a", prompt: "Compute.", marks: 3 }],
                    },
                  ],
                }),
            }),
          }),
        };
      }
      if (table === "exam_paper_session_answer_keys") {
        return {
          select: () => ({
            in: () =>
              Promise.resolve({
                data: [
                  {
                    session_question_id: "q1",
                    answer_key: [{ label: "a", computedAnswer: "80", marks: 3 }],
                    mark_scheme: [{ code: "M1", text: "step" }],
                  },
                ],
              }),
          }),
        };
      }
      if (table === "exam_paper_answers") {
        return {
          select: () => ({
            in: () =>
              Promise.resolve({
                data: [
                  { session_question_id: "q1", part_label: "a", student_answer: "70", is_correct: false, auto_marks: 0, self_awarded_method_marks: 0 },
                ],
              }),
          }),
          update: (payload: any) => {
            answerUpdates.push(payload);
            return { eq: () => ({ eq: () => Promise.resolve({ data: null, error: null }) }) };
          },
        };
      }
      throw new Error(`Unexpected table: ${table}`);
    },
  };
}

describe("selfMarkExamPaperSession", () => {
  it("caps self-awarded marks and updates session status", async () => {
    const admin = makeFakeAdmin();
    vi.mocked(createAdminClient).mockReturnValue(admin as any);

    const result = await selfMarkExamPaperSession("s1", "student-1", [
      { sessionQuestionId: "q1", partLabel: "a", claimedMethodMarks: 2 },
    ]);

    expect(result.combinedMarks).toBe(2);
    expect(admin.sessionUpdates).toContainEqual({ status: "self_marked", self_awarded_marks: 2 });
  });
});

describe("getExamPaperResults", () => {
  it("returns null when the session is still in progress", async () => {
    const admin = makeFakeAdmin();
    admin.from = ((table: string) => {
      if (table === "exam_paper_sessions") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({ maybeSingle: () => Promise.resolve({ data: { status: "in_progress" } }) }),
            }),
          }),
        };
      }
      throw new Error(`Unexpected table: ${table}`);
    }) as any;
    vi.mocked(createAdminClient).mockReturnValue(admin as any);

    const result = await getExamPaperResults("s1", "student-1");
    expect(result).toBeNull();
  });

  it("assembles the marked-paper view with revealed mark scheme", async () => {
    const admin = makeFakeAdmin();
    vi.mocked(createAdminClient).mockReturnValue(admin as any);

    const result = await getExamPaperResults("s1", "student-1");
    expect(result?.questions).toHaveLength(1);
    expect(result?.questions[0].markScheme).toEqual([{ code: "M1", text: "step" }]);
    expect(result?.questions[0].parts[0].computedAnswer).toBe("80");
  });
});
