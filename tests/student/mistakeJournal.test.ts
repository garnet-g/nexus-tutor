/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const upsert = vi.fn();
const maybeSingle = vi.fn();
const insert = vi.fn();
let upsertShouldFail = false;

function createQueryBuilder() {
  const builder: Record<string, unknown> = {};
  const chain = () => builder;
  builder.select = vi.fn(chain);
  builder.eq = vi.fn(chain);
  builder.maybeSingle = maybeSingle;
  builder.upsert = (...args: unknown[]) => {
    upsert(...args);
    return {
      select: () => ({
        single: async () => {
          if (upsertShouldFail) {
            return {
              data: null,
              error: { code: "23505", message: "duplicate key value" },
            };
          }

          return {
            data: {
              id: "mistake-1",
              question_id: "00000000-0000-4000-8000-000000000020",
              topic_id: "00000000-0000-4000-8000-000000000030",
              question_text: "What is 2 + 2?",
              chosen_answer: "3",
              correct_answer: "4",
              explanation: "Count on.",
              source: "practice",
              status: "open",
              created_at: "2026-07-06T00:00:00.000Z",
              updated_at: "2026-07-06T00:00:00.000Z",
            },
            error: null,
          };
        },
      }),
    };
  };
  builder.update = () => ({
    eq: vi.fn(() => ({
      eq: vi.fn(() => ({
        select: () => ({
          single: async () => ({
            data: {
              id: "mistake-existing",
              question_id: "00000000-0000-4000-8000-000000000020",
              topic_id: "00000000-0000-4000-8000-000000000030",
              question_text: "What is 2 + 2?",
              chosen_answer: "5",
              correct_answer: "4",
              explanation: "Count on.",
              source: "practice",
              status: "open",
              created_at: "2026-07-06T00:00:00.000Z",
              updated_at: "2026-07-06T01:00:00.000Z",
            },
            error: null,
          }),
        }),
      })),
    })),
  });
  builder.insert = (...args: unknown[]) => {
    insert(...args);
    return {
      select: () => ({
        single: async () => ({
          data: {
            id: "mistake-1",
            question_id: null,
            topic_id: null,
            question_text: "Manual note",
            chosen_answer: null,
            correct_answer: null,
            explanation: null,
            source: "manual",
            status: "open",
            created_at: "2026-07-06T00:00:00.000Z",
            updated_at: "2026-07-06T00:00:00.000Z",
          },
          error: null,
        }),
      }),
    };
  };
  return builder;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => createQueryBuilder(),
  })),
}));

import {
  recordPracticeSessionMistakesNonFatal,
  upsertMistakeJournalEntry,
} from "@/server/services/mistakeJournalService";

const questionId = "00000000-0000-4000-8000-000000000020";

describe("mistake journal upsert", () => {
  beforeEach(() => {
    upsert.mockReset();
    maybeSingle.mockReset();
    insert.mockReset();
    upsertShouldFail = false;
  });

  it("uses onConflict upsert for question-backed rows", async () => {
    const row = await upsertMistakeJournalEntry("student-1", {
      questionId,
      topicId: "00000000-0000-4000-8000-000000000030",
      questionText: "What is 2 + 2?",
      chosenAnswer: "3",
      correctAnswer: "4",
      explanation: "Count on.",
      source: "practice",
    });

    expect(row.id).toBe("mistake-1");
    expect(upsert).toHaveBeenCalledWith(
      expect.objectContaining({
        student_id: "student-1",
        question_id: questionId,
      }),
      { onConflict: "student_id,question_id" },
    );
  });

  it("falls back to update when upsert reports a unique violation", async () => {
    upsertShouldFail = true;
    maybeSingle.mockResolvedValueOnce({
      data: { id: "mistake-existing", status: "retried" },
      error: null,
    });

    const row = await upsertMistakeJournalEntry("student-1", {
      questionId,
      topicId: "00000000-0000-4000-8000-000000000030",
      questionText: "What is 2 + 2?",
      chosenAnswer: "5",
      correctAnswer: "4",
      explanation: "Count on.",
      source: "practice",
    });

    expect(row.id).toBe("mistake-existing");
    expect(insert).not.toHaveBeenCalled();
  });
});
