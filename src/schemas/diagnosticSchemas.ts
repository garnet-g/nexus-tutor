import { z } from "zod";

export const diagnosticAnswerSchema = z.object({
  diagnosticQuestionId: z.string().uuid(),
  studentAnswer: z.union([z.string(), z.number(), z.boolean()]),
});

export const diagnosticSubmitSchema = z.object({
  answers: z.array(diagnosticAnswerSchema).min(1),
});
