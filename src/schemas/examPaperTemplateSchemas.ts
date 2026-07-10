import { z } from "zod";

export const templateParamDefSchema = z.object({
  name: z.string().min(1),
  min: z.number(),
  max: z.number(),
  step: z.number().positive().optional(),
});

export const templatePartSchema = z.object({
  label: z.string().min(1).max(4),
  prompt: z.string().min(1),
  marks: z.number().int().positive(),
  answerType: z.enum(["numeric", "short_answer"]),
  answerExpr: z.string().optional(),
  answerText: z.string().optional(),
  tolerance: z.number().min(0).optional(),
});

export const templateMarkSchemeStepSchema = z.object({
  code: z.string().min(1),
  text: z.string().min(1),
});

export const examPaperTemplateBodySchema = z.object({
  params: z.array(templateParamDefSchema),
  stem: z.string().min(1),
  parts: z.array(templatePartSchema).min(1),
  markScheme: z.array(templateMarkSchemeStepSchema),
});

export const examPaperTemplateIntakeSchema = z.object({
  paper: z.union([z.literal(1), z.literal(2)]),
  section: z.enum(["I", "II"]),
  formLevel: z.number().int().min(1).max(4),
  topicId: z.string().uuid(),
  marks: z.number().int().positive(),
  difficulty: z.enum(["easy", "medium", "hard"]),
  body: examPaperTemplateBodySchema,
});

export const approveExamPaperTemplateSchema = z.object({
  templateId: z.string().uuid(),
});
