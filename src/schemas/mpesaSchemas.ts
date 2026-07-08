import { z } from "zod";

export const mpesaStkPushSchema = z.object({
  subscriptionPlanId: z.string().uuid("Select a subscription plan"),
  phoneNumber: z
    .string()
    .regex(/^\+254[17]\d{8}$/, "Enter a valid Kenyan number (+254...)"),
});

export const mpesaStatusQuerySchema = z.object({
  mpesaPaymentId: z.string().uuid("Invalid payment id"),
});

export const mpesaManualReconcileSchema = z.object({
  subscriptionPlanId: z.string().uuid("Select a subscription plan"),
  mpesaCode: z
    .string()
    .trim()
    .regex(/^[A-Za-z0-9]{6,20}$/, "Enter a valid M-Pesa transaction code"),
});

export type MpesaStkPushInput = z.infer<typeof mpesaStkPushSchema>;
export type MpesaStatusQuery = z.infer<typeof mpesaStatusQuerySchema>;
export type MpesaManualReconcileInput = z.infer<typeof mpesaManualReconcileSchema>;
