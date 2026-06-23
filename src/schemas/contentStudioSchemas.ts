import { z } from "zod";

import { generatedQuestionSchema } from "@/schemas/contentGenerationSchemas";

export const studioQuestionRowSchema = generatedQuestionSchema.extend({
  id: z.string().uuid().optional(),
  subtopicId: z.string().uuid().nullable().optional(),
  reviewStatus: z.enum(["draft", "in_review", "published", "archived"]).optional(),
  isActive: z.boolean().optional(),
  delete: z.boolean().optional(),
});

export const bulkSaveTopicQuestionsRequestSchema = z.object({
  topicId: z.string().uuid(),
  questions: z.array(studioQuestionRowSchema),
});

export const createManualQuestionRequestSchema = generatedQuestionSchema.extend({
  topicId: z.string().uuid(),
  subtopicId: z.string().uuid().nullable().optional(),
});

export const reorderSubtopicLessonsRequestSchema = z.object({
  subtopicId: z.string().uuid(),
  lessonIds: z.array(z.string().uuid()).min(1),
});

export const questionCsvRowSchema = z
  .object({
    questionText: z.string().min(1),
    questionType: z.enum(["multiple_choice", "short_answer"]),
    options: z.string().optional(),
    correctAnswer: z.string().min(1),
    difficulty: z.enum(["easy", "medium", "hard"]),
    explanation: z.string().min(1),
    subtopicId: z.string().uuid().optional(),
  })
  .superRefine((row, ctx) => {
    const options = parseCsvOptions(row.options);
    const parsed = generatedQuestionSchema.safeParse({
      questionText: row.questionText,
      questionType: row.questionType,
      options,
      correctAnswer: row.correctAnswer,
      difficulty: row.difficulty,
      explanation: row.explanation,
    });

    if (!parsed.success) {
      for (const issue of parsed.error.issues) {
        ctx.addIssue({
          code: "custom",
          message: issue.message,
          path: issue.path,
        });
      }
    }
  });

export function parseCsvOptions(raw: string | undefined): string[] {
  if (!raw?.trim()) {
    return [];
  }

  return raw
    .split("|")
    .map((option) => option.trim())
    .filter(Boolean);
}

export type StudioQuestionRowInput = z.infer<typeof studioQuestionRowSchema>;
export type BulkSaveTopicQuestionsRequest = z.infer<typeof bulkSaveTopicQuestionsRequestSchema>;
export type CreateManualQuestionRequest = z.infer<typeof createManualQuestionRequestSchema>;
