/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const answerUpserts: Record<string, unknown>[] = [];

const question = {
  id: "question-1",
  question_text: "Solve for x: 3x + 5 = 20",
  marking_scheme: "1 mark for isolating 3x = 15, 1 mark for x = 5",
  marks: 2,
};

const attempt = { id: "attempt-1", past_paper_id: "paper-1" };

function selectChain(data: unknown) {
  const builder = {
    select: () => builder,
    eq: () => builder,
    maybeSingle: async () => ({ data, error: null }),
    single: async () => ({ data, error: null }),
  };
  return builder;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table === "past_paper_attempts") {
        return {
          ...selectChain(attempt),
          update: () => ({ eq: async () => ({ data: null, error: null }) }),
        };
      }

      if (table === "past_paper_questions") {
        return selectChain(question);
      }

      if (table === "past_paper_answers") {
        return {
          select: () => ({
            eq: async () => ({ data: [{ score: 2, question_id: question.id }], error: null }),
          }),
          upsert: async (row: Record<string, unknown>) => {
            answerUpserts.push(row);
            return { data: null, error: null };
          },
        };
      }

      return selectChain(null);
    },
  })),
}));

vi.mock("@/lib/env/providerModes", () => ({
  isNexMockAllowed: () => true,
  assertNexConfiguredForLiveMode: vi.fn(),
  createMockAdapterMetadata: () => ({ adapter: "explicit-test", isMock: true }),
  ConfigurationError: class ConfigurationError extends Error {},
}));

describe("markAttemptQuestionWithAI", () => {
  beforeEach(() => {
    answerUpserts.length = 0;
    vi.resetModules();
  });

  it("scores a typed answer using the mock grader and persists score + feedback", async () => {
    const { markAttemptQuestionWithAI } = await import(
      "@/server/services/pastPaperService"
    );

    const result = await markAttemptQuestionWithAI(
      "attempt-1",
      "question-1",
      "student-1",
      { studentAnswer: "x = 5" },
    );

    expect(result.maxMarks).toBe(2);
    expect(result.score).toBeGreaterThanOrEqual(0);
    expect(result.score).toBeLessThanOrEqual(2);
    expect(result.feedback).toBeTruthy();

    expect(answerUpserts).toHaveLength(1);
    expect(answerUpserts[0]).toMatchObject({
      attempt_id: "attempt-1",
      question_id: "question-1",
      student_answer: "x = 5",
    });
  });

  it("throws NOT_FOUND when the attempt does not belong to the student", async () => {
    vi.doMock("@/lib/supabase/admin", () => ({
      createAdminClient: vi.fn(() => ({
        from: () => {
          const builder = {
            select: () => builder,
            eq: () => builder,
            maybeSingle: async () => ({ data: null, error: null }),
          };
          return builder;
        },
      })),
    }));

    const { markAttemptQuestionWithAI } = await import(
      "@/server/services/pastPaperService"
    );

    await expect(
      markAttemptQuestionWithAI("attempt-x", "question-1", "student-1", {
        studentAnswer: "x = 5",
      }),
    ).rejects.toThrow("NOT_FOUND");
  });
});
