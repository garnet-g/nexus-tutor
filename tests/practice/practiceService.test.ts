import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import type { StudentProfile } from "@/types/database";

const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const { startPracticeSession } = await import("@/server/services/practiceService");

const TOPIC_ID = "11111111-1111-4111-8111-111111111111";
const OTHER_TOPIC_ID = "33333333-3333-4333-8333-333333333333";
const SUBTOPIC_ID = "22222222-2222-4222-8222-222222222222";

const profile = {
  id: "student-1",
  curriculum: "CBC",
  grade_level: "Grade 6",
} as StudentProfile;

function makeQuestion(id: string, subtopicId: string | null) {
  return {
    id,
    question_text: "What is 2 + 2?",
    question_type: "multiple_choice",
    options: ["3", "4"],
    difficulty: "medium",
    explanation: "Two plus two equals four.",
    subtopic_id: subtopicId,
    correct_answer: "4",
  };
}

function topicBuilder(topicId = TOPIC_ID) {
  return {
    select: vi.fn(() => topicBuilder(topicId)),
    eq: vi.fn(() => topicBuilder(topicId)),
    maybeSingle: vi.fn(async () => ({
      data: {
        id: topicId,
        title: "Algebra",
        subject_id: "subject-1",
        min_grade_sort_order: 1,
        subjects: { curriculum_id: "curriculum-1", code: "mathematics" },
      },
      error: null,
    })),
  };
}

function subtopicBuilder(topicId: string, subtopicId: string) {
  return {
    select: vi.fn(() => subtopicBuilder(topicId, subtopicId)),
    eq: vi.fn(() => subtopicBuilder(topicId, subtopicId)),
    maybeSingle: vi.fn(async () => ({
      data: { id: subtopicId, topic_id: topicId, title: "Linear Equations" },
      error: null,
    })),
  };
}

function curriculumBuilder() {
  return {
    select: vi.fn(() => curriculumBuilder()),
    eq: vi.fn(() => curriculumBuilder()),
    maybeSingle: vi.fn(async () => ({ data: { id: "curriculum-1" }, error: null })),
  };
}

function gradeLevelBuilder() {
  return {
    select: vi.fn(() => gradeLevelBuilder()),
    eq: vi.fn(() => gradeLevelBuilder()),
    maybeSingle: vi.fn(async () => ({ data: { sort_order: 3 }, error: null })),
  };
}

function questionBuilder(questions: ReturnType<typeof makeQuestion>[]) {
  const builder = {
    select: vi.fn(() => builder),
    eq: vi.fn(() => builder),
    not: vi.fn(() => builder),
    limit: vi.fn(async () => ({ data: questions, error: null })),
  };
  return builder;
}

function sessionBuilder() {
  return {
    insert: vi.fn(() => sessionBuilder()),
    select: vi.fn(() => sessionBuilder()),
    single: vi.fn(async () => ({ data: { id: "session-1" }, error: null })),
  };
}

beforeEach(() => {
  from.mockReset();
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("startPracticeSession", () => {
  it("filters questions by subtopic when subtopicId is provided", async () => {
    const subtopicQuestions = [
      makeQuestion("q-1", SUBTOPIC_ID),
      makeQuestion("q-2", SUBTOPIC_ID),
      makeQuestion("q-3", SUBTOPIC_ID),
      makeQuestion("q-4", SUBTOPIC_ID),
      makeQuestion("q-5", SUBTOPIC_ID),
    ];

    from.mockImplementation((table: string) => {
      if (table === "topics") {
        return topicBuilder();
      }
      if (table === "subtopics") {
        return subtopicBuilder(TOPIC_ID, SUBTOPIC_ID);
      }
      if (table === "curricula") {
        return curriculumBuilder();
      }
      if (table === "grade_levels") {
        return gradeLevelBuilder();
      }
      if (table === "practice_questions") {
        return questionBuilder(subtopicQuestions);
      }
      if (table === "practice_sessions") {
        return sessionBuilder();
      }
      throw new Error(`Unexpected table ${table}`);
    });

    const result = await startPracticeSession(profile, {
      topicId: TOPIC_ID,
      subtopicId: SUBTOPIC_ID,
      difficulty: "medium",
      questionCount: 5,
    });

    expect(result.questions).toHaveLength(5);
    expect(result.subtopicTitle).toBe("Linear Equations");
  });

  it("rejects subtopic and topic mismatch", async () => {
    from.mockImplementation((table: string) => {
      if (table === "topics") {
        return topicBuilder();
      }
      if (table === "subtopics") {
        return subtopicBuilder(OTHER_TOPIC_ID, SUBTOPIC_ID);
      }
      if (table === "curricula") {
        return curriculumBuilder();
      }
      if (table === "grade_levels") {
        return gradeLevelBuilder();
      }
      throw new Error(`Unexpected table ${table}`);
    });

    await expect(
      startPracticeSession(profile, {
        topicId: TOPIC_ID,
        subtopicId: SUBTOPIC_ID,
        difficulty: "medium",
        questionCount: 5,
      }),
    ).rejects.toThrow("INVALID_SUBTOPIC");
  });

  it("throws NO_QUESTIONS_FOR_SUBTOPIC when subtopic has no published questions", async () => {
    from.mockImplementation((table: string) => {
      if (table === "topics") {
        return topicBuilder();
      }
      if (table === "subtopics") {
        return subtopicBuilder(TOPIC_ID, SUBTOPIC_ID);
      }
      if (table === "curricula") {
        return curriculumBuilder();
      }
      if (table === "grade_levels") {
        return gradeLevelBuilder();
      }
      if (table === "practice_questions") {
        return questionBuilder([]);
      }
      throw new Error(`Unexpected table ${table}`);
    });

    await expect(
      startPracticeSession(profile, {
        topicId: TOPIC_ID,
        subtopicId: SUBTOPIC_ID,
        difficulty: "medium",
        questionCount: 5,
      }),
    ).rejects.toThrow("NO_QUESTIONS_FOR_SUBTOPIC");
  });

  it("throws NO_QUESTIONS_FOR_TOPIC when topic has no published questions", async () => {
    from.mockImplementation((table: string) => {
      if (table === "topics") {
        return topicBuilder();
      }
      if (table === "curricula") {
        return curriculumBuilder();
      }
      if (table === "grade_levels") {
        return gradeLevelBuilder();
      }
      if (table === "practice_questions") {
        return questionBuilder([]);
      }
      throw new Error(`Unexpected table ${table}`);
    });

    await expect(
      startPracticeSession(profile, {
        topicId: TOPIC_ID,
        difficulty: "medium",
        questionCount: 5,
      }),
    ).rejects.toThrow("NO_QUESTIONS_FOR_TOPIC");
  });

  it("does not start a topic session when fewer than five published questions are available", async () => {
    from.mockImplementation((table: string) => {
      if (table === "topics") {
        return topicBuilder();
      }
      if (table === "curricula") {
        return curriculumBuilder();
      }
      if (table === "grade_levels") {
        return gradeLevelBuilder();
      }
      if (table === "practice_questions") {
        return questionBuilder([
          makeQuestion("q-1", null),
          makeQuestion("q-2", null),
          makeQuestion("q-3", null),
          makeQuestion("q-4", null),
        ]);
      }
      throw new Error(`Unexpected table ${table}`);
    });

    await expect(
      startPracticeSession(profile, {
        topicId: TOPIC_ID,
        difficulty: "medium",
        questionCount: 5,
      }),
    ).rejects.toThrow("NO_QUESTIONS_FOR_TOPIC");
  });
});
