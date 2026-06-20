import { describe, expect, it, beforeEach } from "vitest";

import {
  addToReviewQueue,
  clearReviewQueue,
  getReviewQueue,
  getReviewQueueCount,
  removeFromReviewQueue,
} from "@/lib/practice/reviewQueue";

const studentId = "test-student-id";

const sampleQuestion = {
  practiceQuestionId: "11111111-1111-4111-8111-111111111111",
  questionText: "What is 2 + 2?",
  questionType: "multiple_choice",
  options: ["3", "4", "5"],
  difficulty: "easy",
  explanation: "Two plus two equals four.",
  topicId: "22222222-2222-4222-8222-222222222222",
  topicTitle: "Addition",
};

describe("reviewQueue", () => {
  beforeEach(() => {
    clearReviewQueue(studentId);
  });

  it("stores and counts missed questions per student", () => {
    expect(getReviewQueueCount(studentId)).toBe(0);
    addToReviewQueue(studentId, sampleQuestion);
    expect(getReviewQueueCount(studentId)).toBe(1);
    expect(getReviewQueue(studentId)[0]?.questionText).toBe("What is 2 + 2?");
  });

  it("deduplicates by practiceQuestionId", () => {
    addToReviewQueue(studentId, sampleQuestion);
    addToReviewQueue(studentId, sampleQuestion);
    expect(getReviewQueueCount(studentId)).toBe(1);
  });

  it("removes answered review items", () => {
    addToReviewQueue(studentId, sampleQuestion);
    removeFromReviewQueue(studentId, sampleQuestion.practiceQuestionId);
    expect(getReviewQueueCount(studentId)).toBe(0);
  });
});
