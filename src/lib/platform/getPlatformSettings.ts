import "server-only";

import { SUBSCRIPTION_LAUNCH_DEFAULTS } from "@/constants/subscription.constants";
import { createAdminClient } from "@/lib/supabase/admin";

export interface EffectiveSubscriptionConfig {
  limits: {
    freeNex: number;
    freePractice: number;
    premiumNex: number;
    premiumPractice: number;
    familyMaxStudents: number;
  };
  pricing: {
    premiumDailyAmountKes: number;
    premiumWeeklyAmountKes: number;
    premiumAmountKes: number;
    premiumTermlyAmountKes: number;
    familyAmountKes: number;
  };
  promotion: {
    isActive: boolean;
    title: string | null;
    endsAt: string | null;
  };
}

const DEFAULTS = SUBSCRIPTION_LAUNCH_DEFAULTS;

let cachedConfig: { value: EffectiveSubscriptionConfig; expiresAt: number } | null =
  null;

const CACHE_TTL_MS = 60_000;

function readSetting(
  settings: Record<string, unknown>,
  key: string,
): unknown {
  return settings[key];
}

function readNumberSetting(
  settings: Record<string, unknown>,
  key: string,
  fallback: number,
): number {
  const value = readSetting(settings, key);
  return typeof value === "number" && Number.isFinite(value) ? value : fallback;
}

function readBooleanSetting(
  settings: Record<string, unknown>,
  key: string,
  fallback: boolean,
): boolean {
  const value = readSetting(settings, key);
  return typeof value === "boolean" ? value : fallback;
}

function readStringSetting(
  settings: Record<string, unknown>,
  key: string,
): string | null {
  const value = readSetting(settings, key);
  return typeof value === "string" ? value : null;
}

function resolvePromoPrice(
  premiumAmount: number,
  settings: Record<string, unknown>,
): number {
  const promoAmount = readNumberSetting(
    settings,
    "promotion_premium_amount_kes",
    -1,
  );
  const promoActive = readBooleanSetting(settings, "promotion_is_active", false);
  const promoEndsAt = readStringSetting(settings, "promotion_ends_at");

  if (!promoActive || promoAmount < 0) {
    return premiumAmount;
  }

  if (promoEndsAt) {
    const endsAt = new Date(promoEndsAt);
    if (!Number.isNaN(endsAt.getTime()) && endsAt.getTime() < Date.now()) {
      return premiumAmount;
    }
  }

  return promoAmount;
}

function buildConfigFromDefaults(): EffectiveSubscriptionConfig {
  return {
    limits: {
      freeNex: DEFAULTS.freeNex,
      freePractice: DEFAULTS.freePractice,
      premiumNex: DEFAULTS.premiumNex,
      premiumPractice: DEFAULTS.premiumPractice,
      familyMaxStudents: DEFAULTS.familyMaxStudents,
    },
    pricing: {
      premiumDailyAmountKes: DEFAULTS.premiumDailyAmountKes,
      premiumWeeklyAmountKes: DEFAULTS.premiumWeeklyAmountKes,
      premiumAmountKes: DEFAULTS.premiumAmountKes,
      premiumTermlyAmountKes: DEFAULTS.premiumTermlyAmountKes,
      familyAmountKes: DEFAULTS.familyAmountKes,
    },
    promotion: {
      isActive: false,
      title: null,
      endsAt: null,
    },
  };
}

async function loadPlatformSettingsMap(): Promise<Record<string, unknown>> {
  try {
    const supabase = createAdminClient();
    const { data, error } = await supabase
      .from("platform_settings")
      .select("setting_key, setting_value");

    if (error || !data) {
      return {};
    }

    return data.reduce<Record<string, unknown>>((acc, row) => {
      acc[row.setting_key] = row.setting_value;
      return acc;
    }, {});
  } catch {
    return {};
  }
}

async function loadSubscriptionPlans(): Promise<{
  premiumDaily: number;
  premiumWeekly: number;
  premium: number;
  premiumTermly: number;
  family: number;
}> {
  try {
    const supabase = createAdminClient();
    const { data, error } = await supabase
      .from("subscription_plans")
      .select("plan_code, amount_kes")
      .in("plan_code", [
        "premium_daily",
        "premium_weekly",
        "premium",
        "premium_termly",
        "family",
      ]);

    if (error || !data) {
      return {
        premiumDaily: DEFAULTS.premiumDailyAmountKes,
        premiumWeekly: DEFAULTS.premiumWeeklyAmountKes,
        premium: DEFAULTS.premiumAmountKes,
        premiumTermly: DEFAULTS.premiumTermlyAmountKes,
        family: DEFAULTS.familyAmountKes,
      };
    }

    const premiumDaily =
      data.find((plan) => plan.plan_code === "premium_daily")?.amount_kes ??
      DEFAULTS.premiumDailyAmountKes;
    const premiumWeekly =
      data.find((plan) => plan.plan_code === "premium_weekly")?.amount_kes ??
      DEFAULTS.premiumWeeklyAmountKes;
    const premium =
      data.find((plan) => plan.plan_code === "premium")?.amount_kes ??
      DEFAULTS.premiumAmountKes;
    const premiumTermly =
      data.find((plan) => plan.plan_code === "premium_termly")?.amount_kes ??
      DEFAULTS.premiumTermlyAmountKes;
    const family =
      data.find((plan) => plan.plan_code === "family")?.amount_kes ??
      DEFAULTS.familyAmountKes;

    return { premiumDaily, premiumWeekly, premium, premiumTermly, family };
  } catch {
    return {
      premiumDaily: DEFAULTS.premiumDailyAmountKes,
      premiumWeekly: DEFAULTS.premiumWeeklyAmountKes,
      premium: DEFAULTS.premiumAmountKes,
      premiumTermly: DEFAULTS.premiumTermlyAmountKes,
      family: DEFAULTS.familyAmountKes,
    };
  }
}

export async function getEffectiveSubscriptionConfig(): Promise<EffectiveSubscriptionConfig> {
  const now = Date.now();
  if (cachedConfig && cachedConfig.expiresAt > now) {
    return cachedConfig.value;
  }

  const [settings, plans] = await Promise.all([
    loadPlatformSettingsMap(),
    loadSubscriptionPlans(),
  ]);

  const config: EffectiveSubscriptionConfig = {
    limits: {
      freeNex: readNumberSetting(
        settings,
        "free_daily_nex_message_limit",
        DEFAULTS.freeNex,
      ),
      freePractice: readNumberSetting(
        settings,
        "free_daily_practice_session_limit",
        DEFAULTS.freePractice,
      ),
      premiumNex: readNumberSetting(
        settings,
        "premium_daily_nex_message_limit",
        DEFAULTS.premiumNex,
      ),
      premiumPractice: readNumberSetting(
        settings,
        "premium_daily_practice_session_limit",
        DEFAULTS.premiumPractice,
      ),
      familyMaxStudents: readNumberSetting(
        settings,
        "family_max_students",
        DEFAULTS.familyMaxStudents,
      ),
    },
    pricing: {
      premiumDailyAmountKes: plans.premiumDaily,
      premiumWeeklyAmountKes: plans.premiumWeekly,
      premiumAmountKes: resolvePromoPrice(plans.premium, settings),
      premiumTermlyAmountKes: plans.premiumTermly,
      familyAmountKes: plans.family,
    },
    promotion: {
      isActive: readBooleanSetting(settings, "promotion_is_active", false),
      title: readStringSetting(settings, "promotion_title"),
      endsAt: readStringSetting(settings, "promotion_ends_at"),
    },
  };

  cachedConfig = {
    value: config,
    expiresAt: now + CACHE_TTL_MS,
  };

  return config;
}

export function getNexDailyLimit(
  config: EffectiveSubscriptionConfig,
  planCode: string,
): number {
  if (planCode !== "free") {
    return config.limits.premiumNex;
  }

  return config.limits.freeNex;
}

export function getPracticeDailyLimit(
  config: EffectiveSubscriptionConfig,
  planCode: string,
): number {
  if (planCode !== "free") {
    return config.limits.premiumPractice;
  }

  return config.limits.freePractice;
}

export function clearPlatformSettingsCache(): void {
  cachedConfig = null;
}

export function getPlanAmountKesFromConfig(
  config: EffectiveSubscriptionConfig,
  planCode: string,
): number {
  if (planCode === "free") {
    return 0;
  }

  if (planCode === "family") {
    return config.pricing.familyAmountKes;
  }

  if (planCode === "premium_daily") {
    return config.pricing.premiumDailyAmountKes;
  }

  if (planCode === "premium_weekly") {
    return config.pricing.premiumWeeklyAmountKes;
  }

  if (planCode === "premium_termly") {
    return config.pricing.premiumTermlyAmountKes;
  }

  return config.pricing.premiumAmountKes;
}

export async function getEffectiveSubscriptionConfigWithFallback(): Promise<EffectiveSubscriptionConfig> {
  try {
    return await getEffectiveSubscriptionConfig();
  } catch {
    return buildConfigFromDefaults();
  }
}
