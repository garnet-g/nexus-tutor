import { z } from "zod";

import { COMMON_KCSE_SUBJECT_CODES } from "@/lib/curriculum/contentModel";

export const kcseCalibrationSourcePolicy =
  "do_not_copy_or_redistribute_source_questions" as const;

const forbiddenCopiedContentFields = [
  "copiedQuestionText",
  "questionText",
  "answerText",
  "markingSchemeText",
  "passageText",
  "verbatimSourceText",
] as const;

const observedCountSchema = z.object({
  observedCount: z.number().int().positive(),
});

export const kcseCalibrationIntakeSchema = z
  .object({
    subjectCode: z.enum(COMMON_KCSE_SUBJECT_CODES),
    paperNumber: z.number().int().min(1).max(3),
    sourceLabel: z.string().trim().min(3).max(120),
    extractionStatus: z.enum(["machine_readable", "needs_ocr"]),
    commandVerbs: z.array(z.string().trim().min(2).max(40)).max(40).default([]),
    markAllocation: z
      .array(
        z
          .object({
            marks: z.number().int().positive().max(100),
          })
          .merge(observedCountSchema),
      )
      .max(40)
      .default([]),
    topicSignals: z
      .array(
        z
          .object({
            tag: z
              .string()
              .trim()
              .min(2)
              .max(80)
              .regex(/^[a-z0-9_ -]+$/i),
          })
          .merge(observedCountSchema),
      )
      .max(80)
      .default([]),
    notes: z.array(z.string().trim().min(3).max(240)).max(20).default([]),
    sourcePolicy: z.literal(kcseCalibrationSourcePolicy),
  })
  .strict()
  .superRefine((value, ctx) => {
    const raw = value as Record<string, unknown>;
    for (const field of forbiddenCopiedContentFields) {
      if (field in raw) {
        ctx.addIssue({
          code: "custom",
          path: [field],
          message: "Calibration intake cannot include copied source content.",
        });
      }
    }

    if (
      value.extractionStatus === "machine_readable" &&
      value.commandVerbs.length === 0 &&
      value.markAllocation.length === 0 &&
      value.topicSignals.length === 0
    ) {
      ctx.addIssue({
        code: "custom",
        path: ["extractionStatus"],
        message: "Machine-readable calibration must include extracted metadata signals.",
      });
    }
  });

export type KcseCalibrationIntake = z.infer<typeof kcseCalibrationIntakeSchema>;
