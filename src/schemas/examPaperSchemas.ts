import { z } from "zod";

export const examPaperNumberSchema = z.union([z.literal(1), z.literal(2)]);

export const generateExamPaperSchema = z.object({
  paper: examPaperNumberSchema,
});

export const submitExamPaperAnswersSchema = z.object({
  answers: z.array(
    z.object({
      sessionQuestionId: z.string().uuid(),
      partLabel: z.string().min(1).max(4),
      studentAnswer: z.string().max(500),
    }),
  ),
});

export const selfMarkExamPaperSchema = z.object({
  claims: z.array(
    z.object({
      sessionQuestionId: z.string().uuid(),
      partLabel: z.string().min(1).max(4),
      claimedMethodMarks: z.number().int().min(0).max(10),
    }),
  ),
});

export const chooseSectionTwoSchema = z.object({
  sessionQuestionIds: z.array(z.string().uuid()).length(5),
});

export const FREE_EXAM_PAPER_SAMPLE_QUESTION_COUNT = 5;

export function studentHasExamPaperAccess(planCode: string): boolean {
  return planCode === "premium" || planCode === "family";
}
