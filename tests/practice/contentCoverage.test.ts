import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const { getMathematicsContentCoverage } = await import(
  "@/server/services/contentAdminReadService"
);

function coverageBuilder() {
  const builder: {
    select: ReturnType<typeof vi.fn>;
    eq: ReturnType<typeof vi.fn>;
    in: ReturnType<typeof vi.fn>;
    order: ReturnType<typeof vi.fn>;
    maybeSingle: ReturnType<typeof vi.fn>;
    then: (resolve: (value: unknown) => unknown) => unknown;
  } = {
    select: vi.fn(() => builder),
    eq: vi.fn(() => builder),
    in: vi.fn(() => builder),
    order: vi.fn(() => builder),
    maybeSingle: vi.fn(async () => ({ data: null, error: null })),
    then: (resolve: (value: unknown) => unknown) => resolve({ data: [], error: null }),
  };
  return builder;
}

beforeEach(() => {
  from.mockReset().mockImplementation(() => coverageBuilder());
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("getMathematicsContentCoverage", () => {
  it("includes subtopic question counts by difficulty", async () => {
    const curriculumId = "curriculum-cbc";
    const subjectId = "subject-math";
    const topicId = "topic-algebra";
    const subtopicId = "subtopic-linear";

    from.mockImplementation((table: string) => {
      const builder = coverageBuilder();

      if (table === "curricula") {
        builder.maybeSingle = vi.fn(async () => ({
          data: { id: curriculumId },
          error: null,
        }));
        return builder;
      }

      if (table === "subjects") {
        builder.maybeSingle = vi.fn(async () => ({
          data: { id: subjectId },
          error: null,
        }));
        return builder;
      }

      if (table === "topics") {
        builder.then = (resolve: (value: unknown) => unknown) =>
          resolve({
            data: [
              {
                id: topicId,
                code: "algebra",
                title: "Algebra",
                sort_order: 1,
              },
            ],
            error: null,
          });
        return builder;
      }

      if (table === "subtopics") {
        builder.then = (resolve: (value: unknown) => unknown) =>
          resolve({
            data: [
              {
                id: subtopicId,
                code: "linear_equations",
                title: "Linear Equations",
                sort_order: 1,
                topic_id: topicId,
              },
            ],
            error: null,
          });
        return builder;
      }

      if (table === "lessons") {
        builder.then = (resolve: (value: unknown) => unknown) =>
          resolve({ data: [], error: null });
        return builder;
      }

      if (table === "practice_questions") {
        builder.then = (resolve: (value: unknown) => unknown) =>
          resolve({
            data: [
              { topic_id: topicId, subtopic_id: subtopicId, difficulty: "easy" },
              { topic_id: topicId, subtopic_id: subtopicId, difficulty: "easy" },
              { topic_id: topicId, subtopic_id: subtopicId, difficulty: "medium" },
              { topic_id: topicId, subtopic_id: null, difficulty: "hard" },
            ],
            error: null,
          });
        return builder;
      }

      return builder;
    });

    const coverage = await getMathematicsContentCoverage();
    const cbc = coverage.find((entry) => entry.code === "CBC");
    const algebra = cbc?.topics.find((topic) => topic.id === topicId);
    const linear = algebra?.subtopics.find((subtopic) => subtopic.id === subtopicId);

    expect(linear?.questionCounts).toEqual({
      easy: 2,
      medium: 1,
      hard: 0,
    });
    expect(algebra?.questionCounts).toEqual({
      easy: 2,
      medium: 1,
      hard: 1,
    });
  });
});
