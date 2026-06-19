import { describe, expect, it } from "vitest";

import { gradeAnswer } from "@/lib/diagnostic/scoringEngine";
import {
  buildDifficultySequence,
  getTargetQuestionCount,
  scoreMockExamAnswers,
  selectMockExamQuestions,
  type PracticeQuestionPoolItem,
} from "@/lib/mockExams/mockExamEngine";

const pool: PracticeQuestionPoolItem[] = [
  {
    id: "q-easy-1",
    topicId: "topic-a",
    topicTitle: "Algebra",
    questionText: "2 + 2",
    questionType: "numeric",
    options: null,
    correctAnswer: 4,
    difficulty: "easy",
  },
  {
    id: "q-medium-1",
    topicId: "topic-a",
    topicTitle: "Algebra",
    questionText: "5 x 3",
    questionType: "numeric",
    options: null,
    correctAnswer: 15,
    difficulty: "medium",
  },
  {
    id: "q-hard-1",
    topicId: "topic-b",
    topicTitle: "Geometry",
    questionText: "Area of square side 4",
    questionType: "numeric",
    options: null,
    correctAnswer: 16,
    difficulty: "hard",
  },
];

describe("mockExamEngine", () => {
  it("limits free preview papers to five questions", () => {
    expect(getTargetQuestionCount("kcse_style", true)).toBe(5);
    expect(getTargetQuestionCount("full_math", true)).toBe(5);
    expect(getTargetQuestionCount("kcse_style", false)).toBe(20);
  });

  it("builds a difficulty sequence for the requested count", () => {
    const sequence = buildDifficultySequence("kcse_style", 4);
    expect(sequence).toHaveLength(4);
    expect(sequence[0]).toBe("easy");
  });

  it("selects topic-specific questions when style is topic_specific", () => {
    const questions = selectMockExamQuestions({
      pool,
      style: "topic_specific",
      isPreview: true,
      topicId: "topic-b",
      curriculum: "KCSE",
      fallbackTopicId: "topic-b",
    });

    expect(questions.length).toBe(5);
    expect(questions.every((question) => question.topicId === "topic-b")).toBe(true);
  });

  it("falls back to generated questions when the pool is empty", () => {
    const questions = selectMockExamQuestions({
      pool: [],
      style: "cbc_style",
      isPreview: true,
      curriculum: "CBC",
      fallbackTopicId: "topic-a",
    });

    expect(questions).toHaveLength(5);
    expect(questions[0].practiceQuestionId).toBeNull();
    expect(questions[0].questionText).toContain("Grade-level");
  });

  it("scores answers and surfaces weak topics", () => {
    const scored = scoreMockExamAnswers(
      [
        {
          id: "q1",
          topicId: "topic-a",
          questionType: "numeric",
          correctAnswer: 4,
        },
        {
          id: "q2",
          topicId: "topic-b",
          questionType: "numeric",
          correctAnswer: 16,
        },
      ],
      [
        { questionId: "q1", studentAnswer: 4 },
        { questionId: "q2", studentAnswer: 10 },
      ],
      gradeAnswer,
    );

    expect(scored.correctCount).toBe(1);
    expect(scored.scorePercentage).toBe(50);
    expect(scored.weakTopicIds).toEqual(["topic-b"]);
  });
});
