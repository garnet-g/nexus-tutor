import { z } from "zod";

export const savedItemSchema = z.object({
  itemType: z.enum(["question", "lesson", "topic", "note"]).default("question"),
  itemId: z.string().uuid().optional().nullable(),
  title: z.string().trim().min(2).max(160),
  description: z.string().trim().max(500).optional().nullable(),
  href: z.string().trim().min(1).max(500).refine((value) => value.startsWith("/"), {
    message: "Use an app-relative path.",
  }),
  metadata: z.record(z.string(), z.unknown()).default({}),
});

export const savedItemUpdateSchema = savedItemSchema.partial().extend({
  id: z.string().uuid(),
});

export const mistakeJournalCreateSchema = z.object({
  questionId: z.string().uuid().optional().nullable(),
  topicId: z.string().uuid().optional().nullable(),
  questionText: z.string().trim().min(2).max(4000),
  chosenAnswer: z.string().trim().max(2000).optional().nullable(),
  correctAnswer: z.string().trim().max(2000).optional().nullable(),
  explanation: z.string().trim().max(4000).optional().nullable(),
  source: z.enum(["practice", "mock_exam", "manual"]).default("manual"),
  status: z.enum(["open", "retried", "mastered"]).default("open"),
});

export const mistakeJournalUpdateSchema = z.object({
  id: z.string().uuid(),
  status: z.enum(["open", "retried", "mastered"]),
});

export const weeklyGoalSchema = z.object({
  weekStartDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  targetMinutes: z.coerce.number().int().min(15).max(3000),
  targetTasks: z.coerce.number().int().min(1).max(200),
  parentVisible: z.coerce.boolean().default(true),
  note: z.string().trim().max(500).optional().nullable(),
});

export const focusSessionCreateSchema = z.object({
  subject: z.string().trim().max(120).optional().nullable(),
  topicId: z.string().uuid().optional().nullable(),
  durationMinutes: z.coerce.number().int().min(5).max(240).default(25),
  status: z.enum(["planned", "in_progress", "completed", "cancelled"]).default("planned"),
});

export const focusSessionUpdateSchema = z.object({
  id: z.string().uuid(),
  status: z.enum(["planned", "in_progress", "completed", "cancelled"]),
});

export const offlinePackSchema = z.object({
  packKey: z.string().trim().min(2).max(80).regex(/^[a-z0-9_-]+$/i),
  title: z.string().trim().min(2).max(160),
  description: z.string().trim().max(500).optional().nullable(),
  status: z.enum(["ready", "downloaded", "expired"]).default("ready"),
  sizeKb: z.coerce.number().int().min(0).max(100000).default(0),
});

export const offlinePackUpdateSchema = z.object({
  id: z.string().uuid(),
  status: z.enum(["ready", "downloaded", "expired"]),
});
