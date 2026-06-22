import { z } from "zod";

export const practiceStartSchema = z.object({
  topicId: z.string().uuid(),
  subtopicId: z.string().uuid().optional(),
  difficulty: z.enum(["easy", "medium", "hard"]).default("medium"),
  questionCount: z.number().int().min(5).max(20).default(10),
});

export const practiceAnswerSchema = z.object({
  practiceQuestionId: z.string().uuid(),
  studentAnswer: z.union([z.string(), z.number(), z.boolean()]),
  timeSpentSeconds: z.number().int().min(0).default(0),
});

export const practiceCompleteSchema = z.object({
  timeSpentSeconds: z.number().int().min(0).default(0),
});
