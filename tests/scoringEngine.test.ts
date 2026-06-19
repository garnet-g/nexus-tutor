import { describe, expect, it } from "vitest";

import {
  gradeAnswer,
  scoreDiagnosticAttempt,
} from "@/lib/diagnostic/scoringEngine";

describe("scoringEngine", () => {
  it("grades multiple choice answers exactly", () => {
    expect(gradeAnswer("multiple_choice", "B", "B")).toBe(true);
    expect(gradeAnswer("multiple_choice", "B", "b")).toBe(true);
    expect(gradeAnswer("multiple_choice", "B", "A")).toBe(false);
  });

  it("grades numeric answers within tolerance", () => {
    expect(gradeAnswer("numeric", 42, 42)).toBe(true);
    expect(gradeAnswer("numeric", 42, 42.005)).toBe(true);
    expect(gradeAnswer("numeric", 42, 42.02)).toBe(false);
  });

  it("computes weighted diagnostic score and topic classifications", () => {
    const result = scoreDiagnosticAttempt(
      [
        {
          diagnosticQuestionId: "q1",
          topicId: "algebra",
          topicTitle: "Algebra",
          difficulty: "easy",
          questionType: "multiple_choice",
          correctAnswer: "A",
        },
        {
          diagnosticQuestionId: "q2",
          topicId: "algebra",
          topicTitle: "Algebra",
          difficulty: "hard",
          questionType: "numeric",
          correctAnswer: 10,
        },
        {
          diagnosticQuestionId: "q3",
          topicId: "geometry",
          topicTitle: "Geometry",
          difficulty: "medium",
          questionType: "multiple_choice",
          correctAnswer: "C",
        },
        {
          diagnosticQuestionId: "q4",
          topicId: "geometry",
          topicTitle: "Geometry",
          difficulty: "medium",
          questionType: "multiple_choice",
          correctAnswer: "D",
        },
      ],
      [
        { diagnosticQuestionId: "q1", studentAnswer: "A" },
        { diagnosticQuestionId: "q2", studentAnswer: 10 },
        { diagnosticQuestionId: "q3", studentAnswer: "C" },
        { diagnosticQuestionId: "q4", studentAnswer: "A" },
      ],
    );

    expect(result.diagnosticScore).toBe(75);
    expect(result.healthScore).toBe(75);
    expect(result.strongTopics.map((topic) => topic.topicTitle)).toEqual([
      "Algebra",
    ]);
    expect(result.weakTopics).toHaveLength(0);
    expect(result.recommendedTopics).toHaveLength(0);
    expect(result.topicScores).toEqual([
      expect.objectContaining({ topicTitle: "Algebra", topicScore: 100 }),
      expect.objectContaining({ topicTitle: "Geometry", topicScore: 50 }),
    ]);
  });

  it("marks weak and recommended topics below threshold", () => {
    const result = scoreDiagnosticAttempt(
      [
        {
          diagnosticQuestionId: "q1",
          topicId: "fractions",
          topicTitle: "Fractions",
          difficulty: "easy",
          questionType: "multiple_choice",
          correctAnswer: "A",
        },
        {
          diagnosticQuestionId: "q2",
          topicId: "fractions",
          topicTitle: "Fractions",
          difficulty: "easy",
          questionType: "multiple_choice",
          correctAnswer: "B",
        },
        {
          diagnosticQuestionId: "q3",
          topicId: "algebra",
          topicTitle: "Algebra",
          difficulty: "medium",
          questionType: "multiple_choice",
          correctAnswer: "C",
        },
      ],
      [
        { diagnosticQuestionId: "q1", studentAnswer: "B" },
        { diagnosticQuestionId: "q2", studentAnswer: "C" },
        { diagnosticQuestionId: "q3", studentAnswer: "A" },
      ],
    );

    expect(result.weakTopics.map((topic) => topic.topicTitle)).toEqual([
      "Fractions",
      "Algebra",
    ]);
  });
});
