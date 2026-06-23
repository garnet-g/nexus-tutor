import { z } from "zod";

const blockIdSchema = z.string().uuid().optional();

const lessonHeadingBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("heading"),
  content: z.string().min(1),
});

const lessonParagraphBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("paragraph"),
  content: z.string().min(1),
});

const lessonExampleBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("example"),
  title: z.string().min(1),
  steps: z.array(z.string().min(1)).min(1),
  answer: z.string().min(1),
});

const lessonTipBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("tip"),
  content: z.string().min(1),
});

const lessonChemicalEquationBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("chemical_equation"),
  equation: z.string().min(1),
  caption: z.string().min(1).optional(),
});

const lessonComprehensionPassageBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("comprehension_passage"),
  title: z.string().min(1).optional(),
  passage: z.string().min(1),
});

const lessonRichTextBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("rich_text"),
  markdown: z.string().min(1),
});

const lessonImageBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("image"),
  url: z.string().url(),
  alt: z.string().min(1),
  caption: z.string().min(1).optional(),
});

const lessonTableBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("table"),
  rows: z.array(z.array(z.string()).min(1)).min(1),
  caption: z.string().min(1).optional(),
});

const lessonMathBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("math_block"),
  latex: z.string().min(1),
  caption: z.string().min(1).optional(),
});

const lessonCalloutBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("callout"),
  variant: z.enum(["info", "warning", "key_point"]),
  content: z.string().min(1),
});

const lessonVideoEmbedBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("video_embed"),
  provider: z.string().min(1),
  url: z.string().url(),
  title: z.string().min(1).optional(),
});

const lessonDividerBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("divider"),
});

const lessonInlineQuestionBlockSchema = z
  .object({
    id: blockIdSchema,
    type: z.literal("question"),
    questionText: z.string().min(1),
    questionType: z.enum(["multiple_choice", "short_answer"]),
    options: z.array(z.string().min(1)).optional(),
    correctAnswer: z.string().min(1),
    explanation: z.string().min(1).optional(),
  })
  .superRefine((question, ctx) => {
    if (question.questionType === "multiple_choice") {
      if (!question.options || question.options.length < 2) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: "Multiple choice questions need at least two options.",
          path: ["options"],
        });
      }

      const normalizedAnswer = question.correctAnswer.trim().toLowerCase();
      const optionMatch = (question.options ?? []).some(
        (option) => option.trim().toLowerCase() === normalizedAnswer,
      );

      if (!optionMatch) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: "correctAnswer must match one of the options.",
          path: ["correctAnswer"],
        });
      }

      return;
    }

    if (question.options && question.options.length > 0) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Short answer questions must not include options.",
        path: ["options"],
      });
    }
  });

const lessonFileAttachmentBlockSchema = z.object({
  id: blockIdSchema,
  type: z.literal("file_attachment"),
  url: z.string().url(),
  name: z.string().min(1),
});

export const lessonBlockSchema = z.discriminatedUnion("type", [
  lessonHeadingBlockSchema,
  lessonParagraphBlockSchema,
  lessonExampleBlockSchema,
  lessonTipBlockSchema,
  lessonChemicalEquationBlockSchema,
  lessonComprehensionPassageBlockSchema,
  lessonRichTextBlockSchema,
  lessonImageBlockSchema,
  lessonTableBlockSchema,
  lessonMathBlockSchema,
  lessonCalloutBlockSchema,
  lessonVideoEmbedBlockSchema,
  lessonDividerBlockSchema,
  lessonInlineQuestionBlockSchema,
  lessonFileAttachmentBlockSchema,
]);

export const lessonShortQuizQuestionSchema = z.object({
  questionText: z.string().min(1),
  options: z.array(z.string().min(1)).min(2),
  correctAnswer: z.string().min(1),
});

function assignBlockId<T extends { id?: string }>(block: T): T & { id: string } {
  return {
    ...block,
    id: block.id ?? crypto.randomUUID(),
  };
}

export const lessonContentSchema = z
  .object({
    blocks: z.array(lessonBlockSchema).min(1),
    shortQuiz: z
      .object({
        questions: z.array(lessonShortQuizQuestionSchema).min(1).max(5),
      })
      .optional(),
  })
  .transform((content) => ({
    ...content,
    blocks: content.blocks.map(assignBlockId),
  }));

export const parseLessonContent = (raw: unknown) => lessonContentSchema.parse(raw);

export type LessonBlock = z.infer<typeof lessonBlockSchema>;
export type LessonContentParsed = z.infer<typeof lessonContentSchema>;
