import { z } from "zod";

export const studyPlanGenerateSchema = z.object({
  planType: z.enum(["daily", "exam"]).default("daily"),
  examCountdownDays: z.number().int().min(1).max(90).optional(),
  dailyGoalMinutes: z.number().int().min(10).max(180).default(20),
});
