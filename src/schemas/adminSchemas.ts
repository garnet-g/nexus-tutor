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
