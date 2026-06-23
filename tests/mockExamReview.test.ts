import { describe, expect, it } from "vitest";

import {
  buildMockExamReview,
  type MarkedAnswer,
  type ReviewQuestionInput,
} from "@/lib/mockExams/mockExamEngine";

const questions: ReviewQuestionInput[] = [
  {
    id: "q2",
    sortOrder: 1,
    questionText: "Capital of Kenya?",
    questionType: "short_answer",
    options: null,
    difficulty: "easy",
    topicTitle: "Geography",
    correctAnswer: "Nairobi",
    explanation: "Nairobi is the capital.",
  },
  {
    id: "q1",
    sortOrder: 0,
    questionText: "2 + 2?",
    questionType: "multiple_choice",
    options: ["3", "4", "5"],
    difficulty: "easy",
    topicTitle: "Arithmetic",
    correctAnswer: "4",
    explanation: null,
  },
];

const marked: MarkedAnswer[] = [
  { questionId: "q1", topicId: "t-arith", isCorrect: true, studentAnswer: "4" },
  { questionId: "q2", topicId: "t-geo", isCorrect: false, studentAnswer: "Mombasa" },
];

describe("buildMockExamReview", () => {
  it("orders questions by sortOrder regardless of input order", () => {
    const review = buildMockExamReview(questions, marked);
    expect(review.map((q) => q.questionId)).toEqual(["q1", "q2"]);
  });

  it("maps each question's answer and correctness from the graded answers", () => {
    const review = buildMockExamReview(questions, marked);

    const first = review[0];
    expect(first.isCorrect).toBe(true);
    expect(first.yourAnswer).toBe("4");
    expect(first.correctAnswer).toBe("4");
    expect(first.options).toEqual(["3", "4", "5"]);

    const second = review[1];
    expect(second.isCorrect).toBe(false);
    expect(second.yourAnswer).toBe("Mombasa");
    expect(second.correctAnswer).toBe("Nairobi");
    expect(second.explanation).toBe("Nairobi is the capital.");
  });

  it("normalizes blank or missing answers to null and defaults correctness to false", () => {
    const review = buildMockExamReview(
      [
        {
          id: "q3",
          sortOrder: 2,
          questionText: "Unanswered",
          questionType: "numeric",
          options: null,
          difficulty: "medium",
          topicTitle: "Algebra",
          correctAnswer: "42",
          explanation: null,
        },
      ],
      [{ questionId: "q3", topicId: "t", isCorrect: false, studentAnswer: "  " }],
    );

    expect(review[0].yourAnswer).toBeNull();
    expect(review[0].isCorrect).toBe(false);
  });

  it("treats a question with no matching graded answer as unanswered + incorrect", () => {
    const review = buildMockExamReview(
      [
        {
          id: "missing",
          sortOrder: 0,
          questionText: "No answer recorded",
          questionType: "short_answer",
          options: null,
          difficulty: "easy",
          topicTitle: "Topic",
          correctAnswer: "x",
          explanation: null,
        },
      ],
      [],
    );

    expect(review[0].yourAnswer).toBeNull();
    expect(review[0].isCorrect).toBe(false);
  });
});
