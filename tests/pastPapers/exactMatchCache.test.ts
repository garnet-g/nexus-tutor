/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const answerUpserts: Record<string, unknown>[] = [];
const mockCachedAnswer = {
  score: 2,
  feedback: "Direct cache match: correct!",
};

const question = {
  id: "question-1",
  question_text: "Solve for x: 3x + 5 = 20",
  marking_scheme: "1 mark for isolating 3x = 15, 1 mark for x = 5",
  marks: 2,
};

const attempt = { id: "attempt-1", past_paper_id: "paper-1" };

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table === "past_paper_attempts") {
        const builder = {
          select: () => builder,
          eq: () => builder,
          maybeSingle: async () => ({ data: attempt, error: null }),
          single: async () => ({ data: attempt, error: null }),
          update: () => ({ eq: async () => ({ data: null, error: null }) }),
        };
        return builder;
      }

      if (table === "past_paper_questions") {
        const builder = {
          select: () => builder,
          eq: () => builder,
          maybeSingle: async () => ({ data: question, error: null }),
        };
        return builder;
      }

      if (table === "past_paper_answers") {
        const builder = {
          select: () => builder,
          eq: () => builder,
          not: () => builder,
          ilike: () => builder,
          limit: () => builder,
          maybeSingle: async () => ({ data: mockCachedAnswer, error: null }),
          upsert: async (row: Record<string, unknown>) => {
            answerUpserts.push(row);
            return { data: null, error: null };
          },
        };
        return builder;
      }

      const builder = {
        select: () => builder,
        eq: () => builder,
        maybeSingle: async () => ({ data: null, error: null }),
      };
      return builder;
    },
  })),
}));

vi.mock("@/lib/env/providerModes", () => ({
  isNexMockAllowed: () => false, // Ensure live calls would be tried if not cached
  assertNexConfiguredForLiveMode: vi.fn(),
  createMockAdapterMetadata: () => ({ adapter: "explicit-test", isMock: true }),
  ConfigurationError: class ConfigurationError extends Error {},
}));

describe("markAttemptQuestionWithAI exact-match cache", () => {
  beforeEach(() => {
    answerUpserts.length = 0;
  });

  it("retrieves and serves exact matching results from past_paper_answers cache directly", async () => {
    const { markAttemptQuestionWithAI } = await import(
      "@/server/services/pastPaperService"
    );

    const result = await markAttemptQuestionWithAI(
      "attempt-1",
      "question-1",
      "student-1",
      { studentAnswer: "x = 5" },
    );

    expect(result.score).toBe(2);
    expect(result.feedback).toBe("Direct cache match: correct!");

    expect(answerUpserts).toHaveLength(1);
    expect(answerUpserts[0]).toMatchObject({
      attempt_id: "attempt-1",
      question_id: "question-1",
      student_answer: "x = 5",
      score: 2,
      feedback: "Direct cache match: correct!",
    });
  });
});
