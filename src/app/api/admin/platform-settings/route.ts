import "server-only";

import { NextResponse } from "next/server";

import {
  getEffectiveSubscriptionConfig,
  clearPlatformSettingsCache,
} from "@/lib/platform/getPlatformSettings";
import { createAdminClient } from "@/lib/supabase/admin";
import { platformSettingsPatchSchema } from "@/schemas/adminSchemas";
import { requireAdminApi } from "@/server/services/requireAdminApi";

const PLATFORM_SETTING_MAP: Record<string, string> = {
  freeDailyNexMessageLimit: "free_daily_nex_message_limit",
  freeDailyPracticeSessionLimit: "free_daily_practice_session_limit",
  premiumDailyNexMessageLimit: "premium_daily_nex_message_limit",
  premiumDailyPracticeSessionLimit: "premium_daily_practice_session_limit",
  familyMaxStudents: "family_max_students",
  promotionIsActive: "promotion_is_active",
  promotionTitle: "promotion_title",
  promotionEndsAt: "promotion_ends_at",
  promotionPremiumAmountKes: "promotion_premium_amount_kes",
  nexOpsCharsPerToken: "nex_ops_chars_per_token",
  nexOpsUsdToKesRate: "nex_ops_usd_to_kes_rate",
  nexOpsGeminiInputUsdPerMillion: "nex_ops_gemini_input_usd_per_million",
  nexOpsGeminiOutputUsdPerMillion: "nex_ops_gemini_output_usd_per_million",
  nexOpsOpenaiInputUsdPerMillion: "nex_ops_openai_input_usd_per_million",
  nexOpsOpenaiOutputUsdPerMillion: "nex_ops_openai_output_usd_per_million",
  contentAutoApproveEnabled: "content_auto_approve_enabled",
};

const SUBSCRIPTION_PLAN_FIELD_MAP: Record<string, string> = {
  premiumDailyAmountKes: "premium_daily",
  premiumWeeklyAmountKes: "premium_weekly",
  premiumAmountKes: "premium",
  premiumTermlyAmountKes: "premium_termly",
  familyAmountKes: "family",
};

async function upsertPlatformSetting(
  key: string,
  value: unknown,
  userId: string,
): Promise<{ previousValue: unknown; newValue: unknown }> {
  const admin = createAdminClient();

  const { data: existing } = await admin
    .from("platform_settings")
    .select("setting_value")
    .eq("setting_key", key)
    .maybeSingle();

  const previousValue = existing?.setting_value ?? null;

  const { error } = await admin.from("platform_settings").upsert(
    {
      setting_key: key,
      setting_value: value,
      updated_by_user_id: userId,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "setting_key" },
  );

  if (error) {
    throw new Error(error.message);
  }

  return { previousValue, newValue: value };
}

async function appendAuditLog(input: {
  userId: string;
  changeType: "platform_setting" | "subscription_plan" | "promotion";
  settingKey: string;
  previousValue: unknown;
  newValue: unknown;
  changeReason?: string;
}): Promise<void> {
  const admin = createAdminClient();

  await admin.from("platform_settings_audit_log").insert({
    super_admin_user_id: input.userId,
    change_type: input.changeType,
    setting_key: input.settingKey,
    previous_value: input.previousValue,
    new_value: input.newValue,
    change_reason: input.changeReason ?? null,
  });
}

async function updateSubscriptionPlanAmount(input: {
  userId: string;
  planCode: string;
  amountKes: number;
  changeReason?: string;
}): Promise<void> {
  const admin = createAdminClient();
  const { data: existingPlan } = await admin
    .from("subscription_plans")
    .select("amount_kes")
    .eq("plan_code", input.planCode)
    .maybeSingle();

  await admin
    .from("subscription_plans")
    .update({
      amount_kes: input.amountKes,
      updated_by_user_id: input.userId,
    })
    .eq("plan_code", input.planCode);

  await appendAuditLog({
    userId: input.userId,
    changeType: "subscription_plan",
    settingKey: `${input.planCode}.amount_kes`,
    previousValue: existingPlan?.amount_kes ?? null,
    newValue: input.amountKes,
    changeReason: input.changeReason,
  });
}

export async function PATCH(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const parsed = platformSettingsPatchSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid request body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const admin = createAdminClient();
    const changes = parsed.data;

    for (const [inputKey, settingKey] of Object.entries(PLATFORM_SETTING_MAP)) {
      const value = changes[inputKey as keyof typeof changes];
      if (value === undefined) {
        continue;
      }

      const { previousValue, newValue } = await upsertPlatformSetting(
        settingKey,
        value,
        auth.userId,
      );

      await appendAuditLog({
        userId: auth.userId,
        changeType: inputKey.startsWith("promotion")
          ? "promotion"
          : "platform_setting",
        settingKey,
        previousValue,
        newValue,
        changeReason: changes.changeReason,
      });
    }

    for (const [inputKey, planCode] of Object.entries(SUBSCRIPTION_PLAN_FIELD_MAP)) {
      const value = changes[inputKey as keyof typeof changes];
      if (typeof value !== "number") {
        continue;
      }

      await updateSubscriptionPlanAmount({
        userId: auth.userId,
        planCode,
        amountKes: value,
        changeReason: changes.changeReason,
      });
    }

    clearPlatformSettingsCache();
    const config = await getEffectiveSubscriptionConfig();

    const { data: auditLog } = await admin
      .from("platform_settings_audit_log")
      .select("id, change_type, setting_key, previous_value, new_value, change_reason, created_at")
      .order("created_at", { ascending: false })
      .limit(10);

    return NextResponse.json({
      success: true,
      data: {
        config,
        recentAuditLog: auditLog ?? [],
      },
    });
  } catch (error) {
    console.error("PLATFORM_SETTINGS_PATCH_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not update platform settings.",
        },
      },
      { status: 500 },
    );
  }
}
