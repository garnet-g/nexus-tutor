/** Launch defaults — used only when platform_settings DB read fails. */
export const SUBSCRIPTION_LAUNCH_DEFAULTS = {
  freeNex: 10,
  freePractice: 3,
  premiumNex: 75,
  premiumPractice: 20,
  familyMaxStudents: 4,
  premiumAmountKes: 799,
  familyAmountKes: 2499,
} as const;
