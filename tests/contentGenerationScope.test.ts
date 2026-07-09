import { describe, expect, it } from "vitest";

import {
  assertSubjectInGenerationScope,
  buildLessonSystemPromptForTest,
} from "@/server/services/contentGenerationService";

const baseSubtopicContext = {
  subtopicId: "sub-1",
  subtopicTitle: "Sample Subtopic",
  subtopicCode: "sample_subtopic",
  topicId: "topic-1",
  topicTitle: "Sample Topic",
  topicCode: "sample_topic",
  subjectId: "subject-1",
  subjectCode: "mathematics",
  subjectName: "Mathematics",
  curriculumCode: "KCSE" as const,
};

describe("assertSubjectInGenerationScope", () => {
  it("allows mathematics only", () => {
    expect(() => assertSubjectInGenerationScope("mathematics")).not.toThrow();
  });

  it("rejects other subject codes with SCOPE_VIOLATION", () => {
    expect(() => assertSubjectInGenerationScope("chemistry")).toThrow("SCOPE_VIOLATION");
    expect(() => assertSubjectInGenerationScope("kiswahili")).toThrow("SCOPE_VIOLATION");
    expect(() => assertSubjectInGenerationScope("history")).toThrow("SCOPE_VIOLATION");
    expect(() => assertSubjectInGenerationScope("cambridge")).toThrow("SCOPE_VIOLATION");
  });
});

describe("buildLessonSystemPrompt", () => {
  it("kiswahili prompt does not mention Mathematics and uses Kiswahili register", () => {
    const prompt = buildLessonSystemPromptForTest(
      {
        ...baseSubtopicContext,
        subjectCode: "kiswahili",
        subjectName: "Kiswahili",
      },
      "Form 2",
    );

    expect(prompt).not.toMatch(/Mathematics/i);
    expect(prompt).toContain("Kiswahili");
    expect(prompt).toContain("comprehension_passage");
    expect(prompt).toContain("Kiswahili sanifu");
  });

  it("mathematics prompt keeps worked example requirement", () => {
    const prompt = buildLessonSystemPromptForTest(baseSubtopicContext, "Grade 7");

    expect(prompt).toContain("Mathematics");
    expect(prompt).toContain("worked example");
    expect(prompt).toContain("chapati");
  });

  it("chemistry prompt references chemical_equation blocks", () => {
    const prompt = buildLessonSystemPromptForTest(
      {
        ...baseSubtopicContext,
        subjectCode: "chemistry",
        subjectName: "Chemistry",
      },
      "Form 3",
    );

    expect(prompt).toContain("Chemistry");
    expect(prompt).toContain("chemical_equation");
    expect(prompt).toContain("IUPAC");
  });
});
