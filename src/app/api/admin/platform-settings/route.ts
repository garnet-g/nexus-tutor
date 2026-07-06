import "server-only";

import { NextResponse } from "next/server";

import {
  getEffectiveSubscriptionConfig,
  clearPlatformSettingsCache,
} from "@/lib/platform/getPlatformSettings";
import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { platformSettingsPatchSchema } from "@/schemas/adminSchemas";

function getRoleFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): string | null {
  const role = appMetadata?.userRole;
  return typeof role === "string" ? role : null;
}

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
  contentAutoApproveEnabled: "content_auto_approve_enabled",
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

export async function PATCH(request: Request) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "UNAUTHORIZED",
            message: "Missing or invalid session.",
          },
        },
        { status: 401 },
      );
    }

    if (getRoleFromAppMetadata(user.app_metadata) !== "super_admin") {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "FORBIDDEN",
            message: "Super admin access required.",
          },
        },
        { status: 403 },
      );
    }

    const guardError = await enforceAdminMutationGuards(request, user.id);
    if (guardError) {
      return guardError;
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
        user.id,
      );

      await appendAuditLog({
        userId: user.id,
        changeType: inputKey.startsWith("promotion")
          ? "promotion"
          : "platform_setting",
        settingKey,
        previousValue,
        newValue,
        changeReason: changes.changeReason,
      });
    }

    if (changes.premiumAmountKes !== undefined) {
      const { data: existingPlan } = await admin
        .from("subscription_plans")
        .select("amount_kes")
        .eq("plan_code", "premium")
        .maybeSingle();

      await admin
        .from("subscription_plans")
        .update({
          amount_kes: changes.premiumAmountKes,
          updated_by_user_id: user.id,
        })
        .eq("plan_code", "premium");

      await appendAuditLog({
        userId: user.id,
        changeType: "subscription_plan",
        settingKey: "premium.amount_kes",
        previousValue: existingPlan?.amount_kes ?? null,
        newValue: changes.premiumAmountKes,
        changeReason: changes.changeReason,
      });
    }

    if (changes.familyAmountKes !== undefined) {
      const { data: existingPlan } = await admin
        .from("subscription_plans")
        .select("amount_kes")
        .eq("plan_code", "family")
        .maybeSingle();

      await admin
        .from("subscription_plans")
        .update({
          amount_kes: changes.familyAmountKes,
          updated_by_user_id: user.id,
        })
        .eq("plan_code", "family");

      await appendAuditLog({
        userId: user.id,
        changeType: "subscription_plan",
        settingKey: "family.amount_kes",
        previousValue: existingPlan?.amount_kes ?? null,
        newValue: changes.familyAmountKes,
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
