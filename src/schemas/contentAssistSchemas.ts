import { z } from "zod";

import {
  generatedQuestionSchema,
  generatedLessonSchema,
} from "@/schemas/contentGenerationSchemas";
import { lessonBlockSchema } from "@/schemas/lessonContentSchemas";

const curriculumSchema = z.enum(["CBC", "KCSE"]);
const gradeLevelSchema = z.string().min(1).max(50);
const difficultySchema = z.enum(["easy", "medium", "hard"]);

export const contentAssistRequestSchema = z.discriminatedUnion("action", [
  z.object({
    action: z.literal("draft_lesson"),
    subtopicId: z.string().uuid(),
    curriculum: curriculumSchema,
    gradeLevel: gradeLevelSchema,
  }),
  z.object({
    action: z.literal("expand_section"),
    subtopicId: z.string().uuid(),
    curriculum: curriculumSchema,
    gradeLevel: gradeLevelSchema,
    blockId: z.string().uuid(),
    blocks: z.array(lessonBlockSchema).min(1),
  }),
  z.object({
    action: z.literal("simplify"),
    subtopicId: z.string().uuid(),
    curriculum: curriculumSchema,
    targetGradeLevel: gradeLevelSchema,
    blocks: z.array(lessonBlockSchema).min(1),
  }),
  z.object({
    action: z.literal("generate_questions"),
    topicId: z.string().uuid(),
    subtopicId: z.string().uuid().optional(),
    curriculum: curriculumSchema,
    gradeLevel: gradeLevelSchema,
    difficulty: difficultySchema,
    count: z.number().int().min(1).max(10),
  }),
  z.object({
    action: z.literal("rewrite_block"),
    subtopicId: z.string().uuid(),
    curriculum: curriculumSchema,
    gradeLevel: gradeLevelSchema,
    block: lessonBlockSchema,
    instruction: z.string().max(500).optional(),
  }),
]);

export const assistBlocksResponseSchema = z.object({
  blocks: z.array(lessonBlockSchema).min(1),
});

export const assistRewriteResponseSchema = z.object({
  block: lessonBlockSchema,
});

export const assistQuestionsResponseSchema = z.object({
  questions: z.array(generatedQuestionSchema).min(1).max(10),
});

export const assistDraftLessonResponseSchema = generatedLessonSchema;

export type ContentAssistRequest = z.infer<typeof contentAssistRequestSchema>;
