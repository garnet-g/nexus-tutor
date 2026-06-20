import { z } from "zod";

export const lessonCompleteSchema = z.object({
  durationSeconds: z.number().int().min(0).max(14_400).optional(),
  quizPassed: z.boolean().optional(),
});
