import { describe, expect, it } from "vitest";

import {
  applySelfMarkedMethodMarks,
  autoMarkExamPaperAnswers,
  buildVerifiedTopicResults,
  composeExamPaperScore,
  type AnswerKeyPart,
} from "@/lib/examPapers/markingEngine";

const answerKey: AnswerKeyPart[] = [
  {
    sessionQuestionId: "q1",
    partLabel: "a",
    topicId: "topic-angles",
    marks: 3,
    answerType: "numeric",
    computedAnswer: "80",
    tolerance: 0,
  },
  {
    sessionQuestionId: "q1",
    partLabel: "b",
    topicId: "topic-angles",
    marks: 2,
    answerType: "short_answer",
    computedAnswer: "isosceles",
    tolerance: 0,
  },
];

describe("markingEngine", () => {
  describe("autoMarkExamPaperAnswers", () => {
    it("awards full marks for a correct numeric answer within tolerance", () => {
      const [marked] = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "80" },
      ]);
      expect(marked.isCorrect).toBe(true);
      expect(marked.autoMarks).toBe(3);
    });

    it("awards zero marks for a wrong numeric answer", () => {
      const [marked] = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "70" },
      ]);
      expect(marked.isCorrect).toBe(false);
      expect(marked.autoMarks).toBe(0);
    });

    it("matches short_answer case-insensitively and whitespace-normalized", () => {
      const [, marked] = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "b", studentAnswer: "  Isosceles  " },
      ]);
      expect(marked.isCorrect).toBe(true);
      expect(marked.autoMarks).toBe(2);
    });

    it("treats a missing or blank answer as incorrect", () => {
      const [marked] = autoMarkExamPaperAnswers(answerKey, []);
      expect(marked.isCorrect).toBe(false);
      expect(marked.autoMarks).toBe(0);
    });
  });

  describe("applySelfMarkedMethodMarks", () => {
    it("caps self-awarded marks at (marks - autoMarks)", () => {
      const autoMarked = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "70" }, // wrong, cap = 3
      ]);
      const marked = applySelfMarkedMethodMarks(autoMarked, [
        { sessionQuestionId: "q1", partLabel: "a", claimedMethodMarks: 10 },
      ]);
      const partA = marked.find((p) => p.partLabel === "a")!;
      expect(partA.selfAwardedMethodMarks).toBe(3);
      expect(partA.totalMarks).toBe(3);
    });

    it("allows zero self-awarded marks when the part is already fully correct", () => {
      const autoMarked = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "80" }, // correct, cap = 0
      ]);
      const marked = applySelfMarkedMethodMarks(autoMarked, [
        { sessionQuestionId: "q1", partLabel: "a", claimedMethodMarks: 5 },
      ]);
      const partA = marked.find((p) => p.partLabel === "a")!;
      expect(partA.selfAwardedMethodMarks).toBe(0);
      expect(partA.totalMarks).toBe(3);
    });

    it("floors negative claims at zero", () => {
      const autoMarked = autoMarkExamPaperAnswers(answerKey, []);
      const marked = applySelfMarkedMethodMarks(autoMarked, [
        { sessionQuestionId: "q1", partLabel: "a", claimedMethodMarks: -5 },
      ]);
      expect(marked.find((p) => p.partLabel === "a")!.selfAwardedMethodMarks).toBe(0);
    });
  });

  describe("composeExamPaperScore", () => {
    it("splits verified vs self-awarded marks and computes percentage", () => {
      const autoMarked = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "70" },
        { sessionQuestionId: "q1", partLabel: "b", studentAnswer: "isosceles" },
      ]);
      const marked = applySelfMarkedMethodMarks(autoMarked, [
        { sessionQuestionId: "q1", partLabel: "a", claimedMethodMarks: 2 },
      ]);
      const summary = composeExamPaperScore(marked);

      expect(summary.totalPossibleMarks).toBe(5);
      expect(summary.verifiedMarks).toBe(2); // part b auto-correct
      expect(summary.selfAwardedMarks).toBe(2); // part a self-marked
      expect(summary.combinedMarks).toBe(4);
      expect(summary.percentage).toBe(80);
    });
  });

  describe("buildVerifiedTopicResults", () => {
    it("aggregates correct/total per topic from auto-marked results only", () => {
      const autoMarked = autoMarkExamPaperAnswers(answerKey, [
        { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "80" },
        { sessionQuestionId: "q1", partLabel: "b", studentAnswer: "wrong" },
      ]);
      const results = buildVerifiedTopicResults(autoMarked);
      expect(results).toEqual([{ topicId: "topic-angles", correct: 1, total: 2 }]);
    });
  });
});
