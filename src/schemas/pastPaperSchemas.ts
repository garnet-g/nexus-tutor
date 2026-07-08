import { z } from "zod";

export const pastPaperSubmitSchema = z.object({
  answers: z
    .array(
      z.object({
        questionId: z.string().uuid("Invalid question id"),
        studentAnswer: z.string().max(5000).optional(),
        ocrImageUrl: z.string().url().optional(),
      }),
    )
    .min(1, "At least one answer is required"),
});

export const pastPaperMarkSchema = z.object({
  questionId: z.string().uuid("Invalid question id"),
  studentAnswer: z.string().max(5000).optional(),
  imageBase64: z.string().optional(),
  mimeType: z.string().optional(),
});

export type PastPaperSubmitInput = z.infer<typeof pastPaperSubmitSchema>;
export type PastPaperMarkInput = z.infer<typeof pastPaperMarkSchema>;
