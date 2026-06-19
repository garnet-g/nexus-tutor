import { z } from "zod";

import { learningPreferencesSchema } from "@/schemas/profileSchemas";

export const nexModeSchema = z.enum([
  "explain",
  "practice",
  "homework",
  "revision",
  "assessment",
]);

export const nexChatRequestSchema = z.object({
  nexSessionId: z.string().uuid().optional(),
  studentMessage: z
    .string()
    .min(1, "Message is required")
    .max(4000, "Message is too long"),
  sessionMode: nexModeSchema.optional(),
  topicId: z.string().uuid().optional().nullable(),
  learningPreferences: learningPreferencesSchema.partial().optional(),
});

export type NexChatRequest = z.infer<typeof nexChatRequestSchema>;
