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

export type MpesaStkPushInput = z.infer<typeof mpesaStkPushSchema>;
export type MpesaStatusQuery = z.infer<typeof mpesaStatusQuerySchema>;
