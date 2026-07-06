import { z } from "zod";

export const adminAlertSeveritySchema = z.enum(["critical", "urgent", "watch"]);
export const adminAlertStatusSchema = z.enum([
  "open",
  "acknowledged",
  "resolved",
]);

export const adminAlertCreateSchema = z.object({
  alertType: z.string().trim().min(2).max(80),
  severity: adminAlertSeveritySchema.default("watch"),
  title: z.string().trim().min(3).max(160),
  description: z.string().trim().max(2000).nullable().optional(),
  source: z.string().trim().min(2).max(80).default("admin"),
  targetType: z.string().trim().max(80).nullable().optional(),
  targetId: z.string().trim().max(160).nullable().optional(),
  metadata: z.record(z.string(), z.unknown()).default({}),
});

export type AdminAlertCreateInput = z.infer<typeof adminAlertCreateSchema>;

export const adminAlertUpdateSchema = z.object({
  alertId: z.string().uuid(),
  status: adminAlertStatusSchema,
});

export type AdminAlertUpdateInput = z.infer<typeof adminAlertUpdateSchema>;

export const adminRoleKeySchema = z.enum([
  "super_admin",
  "support",
  "content_reviewer",
  "finance_admin",
  "growth_admin",
  "ops_admin",
]);

export const adminRoleAssignmentSchema = z.object({
  userId: z.string().uuid(),
  roleKey: adminRoleKeySchema,
  mode: z.enum(["assign", "replace_runtime"]).optional(),
});

export const adminRoleRevokeSchema = z.object({
  userId: z.string().uuid(),
  roleKey: adminRoleKeySchema,
});

export type AdminRoleAssignmentInput = z.infer<typeof adminRoleAssignmentSchema>;

export const adminCommunicationChannelSchema = z.enum(["sms", "email"]);

export const adminCommunicationTemplateCreateSchema = z.object({
  templateKey: z
    .string()
    .trim()
    .min(3)
    .max(80)
    .regex(/^[a-z0-9_-]+$/),
  channel: adminCommunicationChannelSchema,
  title: z.string().trim().min(3).max(160),
  body: z.string().trim().min(5).max(2000),
});

export type AdminCommunicationTemplateCreateInput = z.infer<
  typeof adminCommunicationTemplateCreateSchema
>;

export const adminExperimentCreateSchema = z.object({
  experimentKey: z
    .string()
    .trim()
    .min(3)
    .max(80)
    .regex(/^[a-z0-9_-]+$/),
  title: z.string().trim().min(3).max(160),
  hypothesis: z.string().trim().max(1000).nullable().optional(),
  metricKey: z.string().trim().min(2).max(80).default("conversion"),
  variants: z.array(z.string().trim().min(1).max(80)).min(2).max(8),
});

export type AdminExperimentCreateInput = z.infer<
  typeof adminExperimentCreateSchema
>;

export const adminSavedViewCreateSchema = z.object({
  viewKey: z
    .string()
    .trim()
    .min(3)
    .max(80)
    .regex(/^[a-z0-9_-]+$/),
  title: z.string().trim().min(3).max(160),
  route: z.string().trim().startsWith("/admin").max(200),
  filters: z.record(z.string(), z.unknown()).default({}),
  isShared: z.boolean().default(false),
});

export type AdminSavedViewCreateInput = z.infer<
  typeof adminSavedViewCreateSchema
>;

export const adminApprovalCreateSchema = z.object({
  requestType: z.string().trim().min(2).max(80),
  title: z.string().trim().min(3).max(160),
  description: z.string().trim().max(2000).nullable().optional(),
  targetType: z.string().trim().max(80).nullable().optional(),
  targetId: z.string().trim().max(160).nullable().optional(),
  metadata: z.record(z.string(), z.unknown()).default({}),
});

export type AdminApprovalCreateInput = z.infer<
  typeof adminApprovalCreateSchema
>;

export const adminBulkActionExecuteSchema = z.object({
  approvalId: z.string().uuid(),
});

export type AdminBulkActionExecuteInput = z.infer<
  typeof adminBulkActionExecuteSchema
>;

export const adminApprovalUpdateSchema = z.object({
  approvalId: z.string().uuid(),
  status: z.enum(["approved", "rejected", "cancelled"]),
});

export type AdminApprovalUpdateInput = z.infer<
  typeof adminApprovalUpdateSchema
>;
