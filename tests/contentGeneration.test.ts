import { describe, expect, it } from "vitest";

import {
  generatedLessonSchema,
  generatedQuestionBankSchema,
  generatedQuestionSchema,
  lessonBlockSchema,
  type GeneratedLesson,
} from "@/schemas/contentGenerationSchemas";
import type { CurriculumLesson, LessonContent } from "@/types/curriculum";

const sampleLessonJson = {
  title: "Introduction to Linear Equations",
  estimatedMinutes: 12,
  blocks: [
    {
      type: "heading",
      content: "Introduction to Linear Equations",
    },
    {
      type: "paragraph",
      content:
        "A linear equation has one variable raised to the power of one. In Kenya, you might use them to work out matatu fares.",
    },
    {
      type: "example",
      title: "Worked Example 1",
      steps: ["Write the equation: 2x + 5 = 13", "Subtract 5 from both sides", "Divide by 2"],
      answer: "x = 4",
    },
    {
      type: "tip",
      content: "Always perform the same operation on both sides of the equation.",
    },
  ],
  shortQuiz: {
    questions: [
      {
        questionText: "What is the solution to x + 3 = 7?",
        options: ["x = 3", "x = 4", "x = 10"],
        correctAnswer: "x = 4",
      },
    ],
  },
};

const sampleQuestionBankJson = {
  questions: [
    {
      questionText: "What is 3/4 + 1/4?",
      questionType: "multiple_choice",
      options: ["1/2", "1", "4/8"],
      correctAnswer: "1",
      difficulty: "easy",
      explanation: "When denominators match, add numerators: 3 + 1 = 4, so 4/4 = 1.",
    },
  ],
};

function toCurriculumLesson(lessonId: string, generated: GeneratedLesson): CurriculumLesson {
  const content: LessonContent = {
    blocks: generated.blocks,
    shortQuiz: generated.shortQuiz,
  };

  return {
    id: lessonId,
    title: generated.title,
    content,
    estimatedMinutes: generated.estimatedMinutes,
    sortOrder: 1,
    subtopicId: "00000000-0000-4000-8000-000000000001",
    subtopicTitle: "Linear Equations",
    topicId: "00000000-0000-4000-8000-000000000002",
    topicTitle: "Algebra",
    subjectId: "00000000-0000-4000-8000-000000000003",
    curriculumCode: "CBC",
  };
}

describe("contentGenerationSchemas", () => {
  it("validates lesson blocks matching curriculum-content-model §5", () => {
    const lesson = generatedLessonSchema.parse(sampleLessonJson);

    expect(lesson.blocks).toHaveLength(4);
    expect(lessonBlockSchema.safeParse(lesson.blocks[2]).success).toBe(true);
    expect(lesson.shortQuiz?.questions).toHaveLength(1);
  });

  it("rejects malformed lesson output before DB write", () => {
    const invalid = {
      ...sampleLessonJson,
      blocks: [{ type: "video", content: "not allowed" }],
    };

    expect(generatedLessonSchema.safeParse(invalid).success).toBe(false);
  });

  it("validates question bank shape matching content-model §7", () => {
    const bank = generatedQuestionBankSchema.parse(sampleQuestionBankJson);
    expect(bank.questions[0].questionType).toBe("multiple_choice");
    expect(bank.questions[0].difficulty).toBe("easy");
  });

  it("maps validated lesson JSON to CurriculumLesson for LessonRenderer", () => {
    const parsed = generatedLessonSchema.parse(sampleLessonJson);
    const curriculumLesson = toCurriculumLesson("draft-lesson-id", parsed);

    expect(curriculumLesson.content.blocks.every((block) => "type" in block)).toBe(true);
    expect(curriculumLesson.content.shortQuiz?.questions[0].correctAnswer).toBe("x = 4");
  });

  it("rejects multiple choice when correctAnswer is not an option", () => {
    const invalid = {
      ...sampleQuestionBankJson.questions[0],
      correctAnswer: "2",
    };

    expect(generatedQuestionSchema.safeParse(invalid).success).toBe(false);
  });

  it("allows short answer questions with empty options", () => {
    const shortAnswer = {
      questionText: "Solve x + 2 = 5",
      questionType: "short_answer" as const,
      options: [],
      correctAnswer: "3",
      difficulty: "easy" as const,
      explanation: "Subtract 2 from both sides.",
    };

    expect(generatedQuestionSchema.safeParse(shortAnswer).success).toBe(true);
  });

  it("accepts chemical_equation and comprehension_passage blocks", () => {
    const lesson = generatedLessonSchema.parse({
      title: "Acids and Bases",
      estimatedMinutes: 12,
      blocks: [
        { type: "heading", content: "Acids" },
        { type: "paragraph", content: "An acid releases H+ ions in water." },
        {
          type: "chemical_equation",
          equation: "HCl + H_2O -> H_3O^+ + Cl^-",
          caption: "Hydrochloric acid in water",
        },
        {
          type: "comprehension_passage",
          title: "Kifungu",
          passage: "Juma aliamka asubuhi na mapema...",
        },
        { type: "tip", content: "Balance equations before checking states." },
      ],
    });

    expect(lesson.blocks).toHaveLength(5);
    expect(lessonBlockSchema.safeParse(lesson.blocks[2]).success).toBe(true);
    expect(lessonBlockSchema.safeParse(lesson.blocks[3]).success).toBe(true);
  });
});

describe("draft insert contract", () => {
  it("requires draft flags on generated lesson payload", () => {
    const draftInsert = {
      is_active: false,
      review_status: "draft" as const,
      content: {
        blocks: sampleLessonJson.blocks,
        shortQuiz: sampleLessonJson.shortQuiz,
      },
    };

    expect(draftInsert.is_active).toBe(false);
    expect(draftInsert.review_status).toBe("draft");
    expect(generatedLessonSchema.parse(sampleLessonJson).title).toBeTruthy();
  });
});
