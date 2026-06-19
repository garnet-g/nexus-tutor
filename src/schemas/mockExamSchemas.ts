import { z } from "zod";

export const MOCK_EXAM_STYLES = [
  "kcse_style",
  "cbc_style",
  "topic_specific",
  "full_math",
] as const;

export type MockExamStyle = (typeof MOCK_EXAM_STYLES)[number];

export const mockExamStyleSchema = z.enum(MOCK_EXAM_STYLES);

export const generateMockExamSchema = z.object({
  examStyle: mockExamStyleSchema,
  topicId: z.string().uuid().optional(),
  subjectCode: z.enum(["mathematics", "science", "english"]).optional(),
});

export const submitMockExamSchema = z.object({
  answers: z.array(
    z.object({
      questionId: z.string().uuid(),
      studentAnswer: z.unknown(),
    }),
  ),
});

export const startExamSimulatorSchema = z.object({
  mockExamSessionId: z.string().uuid(),
  durationMinutes: z.number().int().min(10).max(180).optional(),
});

export const submitExamSimulatorSchema = z.object({
  answers: z.array(
    z.object({
      questionId: z.string().uuid(),
      studentAnswer: z.unknown(),
    }),
  ),
  questionIndex: z.number().int().min(0).optional(),
});

export const FREE_MOCK_EXAM_PREVIEW_LIMIT = 5;

export function studentHasMockExamAccess(planCode: string): boolean {
  return planCode === "premium" || planCode === "family";
}
