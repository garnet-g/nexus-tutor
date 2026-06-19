import { z } from "zod";

export const mpesaStkPushSchema = z.object({
  subscriptionPlanId: z.string().uuid("Select a subscription plan"),
  phoneNumber: z
    .string()
    .regex(/^\+254[17]\d{8}$/, "Enter a valid Kenyan number (+254...)"),
});

export type MpesaStkPushInput = z.infer<typeof mpesaStkPushSchema>;
