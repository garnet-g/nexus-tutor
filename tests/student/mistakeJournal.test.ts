/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const maybeSingle = vi.fn();
const insert = vi.fn();
const update = vi.fn();

function createQueryBuilder() {
  const builder: Record<string, unknown> = {};
  const chain = () => builder;
  builder.select = vi.fn(chain);
  builder.eq = vi.fn(chain);
  builder.maybeSingle = maybeSingle;
  builder.insert = (...args: unknown[]) => {
    insert(...args);
    return {
      select: () => ({
        single: async () => ({
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
        }),
      }),
    };
  };
  builder.update = (...args: unknown[]) => {
    update(...args);
    return {
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
    };
  };
  return builder;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => createQueryBuilder(),
  })),
}));

import { upsertMistakeJournalEntry } from "@/server/services/mistakeJournalService";

const questionId = "00000000-0000-4000-8000-000000000020";

describe("mistake journal upsert", () => {
  beforeEach(() => {
    maybeSingle.mockReset();
    insert.mockReset();
    update.mockReset();
  });

  it("inserts a new journal row for a first-time miss", async () => {
    maybeSingle.mockResolvedValueOnce({ data: null, error: null });

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
    expect(insert).toHaveBeenCalledTimes(1);
    expect(update).not.toHaveBeenCalled();
  });

  it("updates an existing row instead of inserting a duplicate", async () => {
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
    expect(update).toHaveBeenCalledTimes(1);
    expect(insert).not.toHaveBeenCalled();
  });
});
