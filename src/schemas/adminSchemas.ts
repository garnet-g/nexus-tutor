import { z } from "zod";

export const platformSettingsPatchSchema = z.object({
  freeDailyNexMessageLimit: z.number().int().min(1).max(500).optional(),
  freeDailyPracticeSessionLimit: z.number().int().min(1).max(500).optional(),
  premiumDailyNexMessageLimit: z.number().int().min(1).max(500).optional(),
  premiumDailyPracticeSessionLimit: z.number().int().min(1).max(500).optional(),
  familyMaxStudents: z.number().int().min(1).max(20).optional(),
  promotionIsActive: z.boolean().optional(),
  promotionTitle: z.string().max(200).nullable().optional(),
  promotionEndsAt: z.string().datetime().nullable().optional(),
  promotionPremiumAmountKes: z.number().int().min(1).max(100_000).nullable().optional(),
  premiumAmountKes: z.number().int().min(1).max(100_000).optional(),
  familyAmountKes: z.number().int().min(1).max(100_000).optional(),
  changeReason: z.string().max(500).optional(),
});

export type PlatformSettingsPatchInput = z.infer<typeof platformSettingsPatchSchema>;

export const auditLogActionSchema = z.enum([
  "platform_setting.update",
  "subscription_plan.update",
  "beta_invite.create",
  "content.generate",
  "content.publish",
  "content.discard",
  "content.lesson_draft.update",
  "content.question_draft.update",
  "assessment.calibration.create",
  "subscription.comp",
  "user.impersonate.start",
  "user.impersonate.end",
  "nex_flag.create",
  "nex_flag.resolve",
  "parent.sms.send",
  "coupon.create",
  "coupon.deactivate",
]);

export const auditLogQuerySchema = z.object({
  action: auditLogActionSchema.optional(),
  actorUserId: z.string().uuid().optional(),
  limit: z.coerce.number().int().min(1).max(200).optional(),
  before: z.string().datetime().optional(),
});

export type AuditLogQueryInput = z.infer<typeof auditLogQuerySchema>;

// --- Phase 2 read-only dashboard query schemas ---

export const paymentStatusFilterSchema = z.enum([
  "pending",
  "processing",
  "paid",
  "failed",
  "cancelled",
  "expired",
  "refunded",
]);

export const paymentsQuerySchema = z.object({
  status: paymentStatusFilterSchema.optional(),
  from: z.string().datetime().optional(),
  to: z.string().datetime().optional(),
  limit: z.coerce.number().int().min(1).max(200).optional(),
});

export type PaymentsQueryInput = z.infer<typeof paymentsQuerySchema>;

export const outcomesQuerySchema = z.object({
  curriculum: z.enum(["CBC", "KCSE"]).optional(),
  gradeLevel: z.string().max(40).optional(),
  riskThreshold: z.coerce.number().min(0).max(100).optional(),
  limit: z.coerce.number().int().min(1).max(200).optional(),
});

export type OutcomesQueryInput = z.infer<typeof outcomesQuerySchema>;

export const nexOpsQuerySchema = z.object({
  limit: z.coerce.number().int().min(1).max(200).optional(),
});

export type NexOpsQueryInput = z.infer<typeof nexOpsQuerySchema>;

// --- Phase 3a user management schemas ---

export const userTypeFilterSchema = z.enum(["student", "parent"]);

export const usersQuerySchema = z.object({
  query: z.string().max(120).optional(),
  type: userTypeFilterSchema.optional(),
  limit: z.coerce.number().int().min(1).max(200).optional(),
  before: z.string().datetime().optional(),
});

export type UsersQueryInput = z.infer<typeof usersQuerySchema>;

export const compPlanCodeSchema = z.enum(["premium", "family", "free"]);

export const compGrantSchema = z.object({
  planCode: compPlanCodeSchema,
  reason: z.string().min(3).max(500),
  expiresAt: z.string().datetime().nullable().optional(),
});

export type CompGrantInput = z.infer<typeof compGrantSchema>;

export const impersonationStartSchema = z.object({
  reason: z.string().min(3).max(500),
});

export type ImpersonationStartInput = z.infer<typeof impersonationStartSchema>;

// --- Phase 3b: Nex conversation review schemas ---

export const nexFlagStatusSchema = z.enum(["open", "resolved", "escalated"]);

export const nexReviewQuerySchema = z.object({
  status: nexFlagStatusSchema.optional(),
  limit: z.coerce.number().int().min(1).max(200).optional(),
  before: z.string().datetime().optional(),
});

export type NexReviewQueryInput = z.infer<typeof nexReviewQuerySchema>;

export const resolveFlagSchema = z.object({
  status: z.enum(["resolved", "escalated"]),
  notes: z.string().max(2000).optional(),
});

export type ResolveFlagInput = z.infer<typeof resolveFlagSchema>;

export const createFlagSchema = z.object({
  messageId: z.string().uuid(),
  sessionId: z.string().uuid().optional(),
  studentId: z.string().uuid().optional(),
  reason: z.string().max(1000).optional(),
});

export type CreateFlagInput = z.infer<typeof createFlagSchema>;

// --- Phase 3b: at-risk parent SMS schema ---

export const parentNotifySchema = z.object({
  studentId: z.string().uuid(),
  message: z.string().min(5).max(480),
});

export type ParentNotifyInput = z.infer<typeof parentNotifySchema>;

// --- Phase 3b: coupon management schemas ---

export const couponDiscountTypeSchema = z.enum(["percent", "fixed"]);
export const couponPlanSchema = z.enum(["premium", "family", "any"]);

export const couponsQuerySchema = z.object({
  activeOnly: z
    .union([z.literal("true"), z.literal("false")])
    .optional()
    .transform((value) => value === "true"),
  limit: z.coerce.number().int().min(1).max(200).optional(),
});

export type CouponsQueryInput = z.infer<typeof couponsQuerySchema>;

export const couponCreateSchema = z
  .object({
    code: z
      .string()
      .trim()
      .min(3)
      .max(40)
      .regex(/^[A-Za-z0-9_-]+$/, "Use letters, numbers, hyphen or underscore."),
    discountType: couponDiscountTypeSchema,
    discountValue: z.number().positive().max(1_000_000),
    appliesToPlan: couponPlanSchema.default("any"),
    maxUses: z.number().int().min(1).max(1_000_000).nullable().optional(),
    expiresAt: z.string().datetime().nullable().optional(),
  })
  .refine(
    (value) => value.discountType !== "percent" || value.discountValue <= 100,
    {
      message: "Percentage discount cannot exceed 100.",
      path: ["discountValue"],
    },
  );

export type CouponCreateInput = z.infer<typeof couponCreateSchema>;
