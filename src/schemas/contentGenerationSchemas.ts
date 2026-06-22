import { z } from "zod";

const lessonHeadingBlockSchema = z.object({
  type: z.literal("heading"),
  content: z.string().min(1),
});

const lessonParagraphBlockSchema = z.object({
  type: z.literal("paragraph"),
  content: z.string().min(1),
});

const lessonExampleBlockSchema = z.object({
  type: z.literal("example"),
  title: z.string().min(1),
  steps: z.array(z.string().min(1)).min(1),
  answer: z.string().min(1),
});

const lessonTipBlockSchema = z.object({
  type: z.literal("tip"),
  content: z.string().min(1),
});

const lessonChemicalEquationBlockSchema = z.object({
  type: z.literal("chemical_equation"),
  equation: z.string().min(1),
  caption: z.string().min(1).optional(),
});

const lessonComprehensionPassageBlockSchema = z.object({
  type: z.literal("comprehension_passage"),
  title: z.string().min(1).optional(),
  passage: z.string().min(1),
});

export const lessonBlockSchema = z.discriminatedUnion("type", [
  lessonHeadingBlockSchema,
  lessonParagraphBlockSchema,
  lessonExampleBlockSchema,
  lessonTipBlockSchema,
  lessonChemicalEquationBlockSchema,
  lessonComprehensionPassageBlockSchema,
]);

export const lessonShortQuizQuestionSchema = z.object({
  questionText: z.string().min(1),
  options: z.array(z.string().min(1)).min(2),
  correctAnswer: z.string().min(1),
});

export const generatedLessonSchema = z.object({
  title: z.string().min(1).max(200),
  estimatedMinutes: z.number().int().min(5).max(60),
  blocks: z.array(lessonBlockSchema).min(1),
  shortQuiz: z
    .object({
      questions: z.array(lessonShortQuizQuestionSchema).min(1).max(5),
    })
    .optional(),
});

export const generatedQuestionSchema = z
  .object({
    questionText: z.string().min(1).max(500),
    questionType: z.enum(["multiple_choice", "short_answer"]),
    options: z.array(z.string().min(1)),
    correctAnswer: z.string().min(1),
    difficulty: z.enum(["easy", "medium", "hard"]),
    explanation: z.string().min(1).max(1000),
  })
  .superRefine((question, ctx) => {
    if (question.questionType === "multiple_choice") {
      if (question.options.length < 2) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: "Multiple choice questions need at least two options.",
          path: ["options"],
        });
      }

      const normalizedAnswer = question.correctAnswer.trim().toLowerCase();
      const optionMatch = question.options.some(
        (option) => option.trim().toLowerCase() === normalizedAnswer,
      );

      if (!optionMatch) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: "correctAnswer must match one of the options.",
          path: ["correctAnswer"],
        });
      }

      return;
    }

    if (question.options.length > 0) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Short answer questions must not include options.",
        path: ["options"],
      });
    }
  });

export const generatedQuestionBankSchema = z.object({
  questions: z.array(generatedQuestionSchema).min(1).max(20),
});

export const generateLessonDraftInputSchema = z.object({
  subtopicId: z.string().uuid(),
  curriculum: z.enum(["CBC", "KCSE"]),
  gradeLevel: z.string().min(1).max(50),
  adminId: z.string().uuid(),
});

export const generateQuestionBankDraftInputSchema = z.object({
  topicId: z.string().uuid(),
  subtopicId: z.string().uuid().optional(),
  difficulty: z.enum(["easy", "medium", "hard"]),
  count: z.number().int().min(1).max(20),
  curriculum: z.enum(["CBC", "KCSE"]),
  gradeLevel: z.string().min(1).max(50),
  adminId: z.string().uuid(),
});

export const publishDraftInputSchema = z.object({
  kind: z.enum(["lesson", "question"]),
  id: z.string().uuid(),
  adminId: z.string().uuid(),
});

export const discardDraftInputSchema = publishDraftInputSchema;

export const generateContentRequestSchema = z.discriminatedUnion("type", [
  z.object({
    type: z.literal("lesson"),
    subtopicId: z.string().uuid(),
    curriculum: z.enum(["CBC", "KCSE"]),
    gradeLevel: z.string().min(1).max(50),
  }),
  z.object({
    type: z.literal("questions"),
    topicId: z.string().uuid(),
    subtopicId: z.string().uuid().optional(),
    difficulty: z.enum(["easy", "medium", "hard"]),
    count: z.number().int().min(1).max(20),
    curriculum: z.enum(["CBC", "KCSE"]),
    gradeLevel: z.string().min(1).max(50),
  }),
]);

export const draftActionRequestSchema = z.object({
  kind: z.enum(["lesson", "question"]),
  id: z.string().uuid(),
});

export const updateDraftLessonRequestSchema = z.object({
  id: z.string().uuid(),
  title: z.string().min(1).max(200),
  estimatedMinutes: z.number().int().min(5).max(60),
  blocks: z.array(lessonBlockSchema).min(1),
  shortQuiz: z
    .object({
      questions: z.array(lessonShortQuizQuestionSchema).min(1).max(5),
    })
    .optional(),
});

export const updateDraftQuestionRequestSchema = generatedQuestionSchema.extend({
  id: z.string().uuid(),
});

export type LessonBlock = z.infer<typeof lessonBlockSchema>;
export type GeneratedLesson = z.infer<typeof generatedLessonSchema>;
export type GeneratedQuestion = z.infer<typeof generatedQuestionSchema>;
export type GeneratedQuestionBank = z.infer<typeof generatedQuestionBankSchema>;
