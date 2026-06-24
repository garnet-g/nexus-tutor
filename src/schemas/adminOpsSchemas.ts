import { z } from "zod";

export const adminSupportCaseIssueTypeSchema = z.enum([
  "account",
  "billing",
  "learning",
  "content",
  "nex",
  "parent",
  "technical",
  "other",
]);

export const adminSupportCasePrioritySchema = z.enum([
  "low",
  "medium",
  "high",
  "urgent",
]);

export const adminSupportCaseStatusSchema = z.enum([
  "open",
  "in_progress",
  "waiting_on_user",
  "resolved",
]);

export const adminSupportCaseCreateSchema = z.object({
  targetStudentId: z.string().uuid().nullable().optional(),
  targetParentId: z.string().uuid().nullable().optional(),
  issueType: adminSupportCaseIssueTypeSchema,
  priority: adminSupportCasePrioritySchema.default("medium"),
  status: adminSupportCaseStatusSchema.default("open"),
  title: z.string().trim().min(3).max(160),
  notes: z.string().trim().max(4000).nullable().optional(),
});

export type AdminSupportCaseCreateInput = z.infer<
  typeof adminSupportCaseCreateSchema
>;

export const adminSupportCaseUpdateSchema = z.object({
  caseId: z.string().uuid(),
  priority: adminSupportCasePrioritySchema.optional(),
  status: adminSupportCaseStatusSchema.optional(),
  notes: z.string().trim().max(4000).nullable().optional(),
  assignedToUserId: z.string().uuid().nullable().optional(),
});

export type AdminSupportCaseUpdateInput = z.infer<
  typeof adminSupportCaseUpdateSchema
>;

export const adminFeatureScopeSchema = z.enum([
  "global",
  "curriculum",
  "grade",
  "cohort",
  "student",
  "role",
]);

export const adminFeatureRolloutUpsertSchema = z
  .object({
    featureKey: z
      .string()
      .trim()
      .min(3)
      .max(80)
      .regex(/^[a-z0-9_-]+$/, "Use lowercase letters, numbers, hyphen, or underscore."),
    displayName: z.string().trim().min(3).max(120),
    description: z.string().trim().max(1000).nullable().optional(),
    isEnabled: z.boolean(),
    scope: adminFeatureScopeSchema.default("global"),
    scopeValue: z.string().trim().max(120).nullable().optional(),
  })
  .refine(
    (value) => value.scope === "global" || Boolean(value.scopeValue?.trim()),
    {
      message: "A scope value is required for scoped rollouts.",
      path: ["scopeValue"],
    },
  );

export type AdminFeatureRolloutUpsertInput = z.infer<
  typeof adminFeatureRolloutUpsertSchema
>;
