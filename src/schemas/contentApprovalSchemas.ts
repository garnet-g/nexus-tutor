import { z } from "zod";

export const contentReviewActionSchema = z.object({
  kind: z.enum(["lesson", "question"]),
  id: z.string().uuid(),
  notes: z.string().max(1000).optional(),
});

export const restoreLessonVersionRequestSchema = z.object({
  lessonId: z.string().uuid(),
  versionId: z.string().uuid(),
});

export type ContentReviewAction = z.infer<typeof contentReviewActionSchema>;

export type ContentReviewServiceInput = ContentReviewAction & { adminId: string };
