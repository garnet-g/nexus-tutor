import "server-only";

import { z } from "zod";

import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

export const parentProductPreferencesSchema = z.object({
  displayName: z.string().min(2).max(120).optional(),
  contactPhone: z.string().min(8).max(20).optional().nullable(),
  preferredLanguage: z.enum(["en", "sw"]).optional(),
  dashboardSummary: z.enum(["compact", "detailed"]).optional(),
});

export type ParentProductPreferences = z.infer<typeof parentProductPreferencesSchema>;

export async function getParentProductPreferences(parentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("parent_profiles")
    .select("full_name, phone_number, product_preferences")
    .eq("id", parentId)
    .maybeSingle();

  if (error || !data) {
    throw new Error("Parent profile not found.");
  }

  const stored = (data.product_preferences ?? {}) as Record<string, unknown>;

  return {
    displayName: String(stored.displayName ?? data.full_name),
    contactPhone: (stored.contactPhone as string | null | undefined) ?? data.phone_number,
    preferredLanguage: (stored.preferredLanguage as "en" | "sw" | undefined) ?? "en",
    dashboardSummary: (stored.dashboardSummary as "compact" | "detailed" | undefined) ?? "detailed",
  };
}

export async function updateParentProductPreferences(
  parentId: string,
  input: ParentProductPreferences,
) {
  const parsed = parentProductPreferencesSchema.parse(input);
  const admin = createAdminClient();

  const { data: existing, error: readError } = await admin
    .from("parent_profiles")
    .select("product_preferences, full_name, phone_number")
    .eq("id", parentId)
    .maybeSingle();

  if (readError || !existing) {
    throw new Error("Parent profile not found.");
  }

  const current = (existing.product_preferences ?? {}) as Record<string, unknown>;
  const nextPreferences = {
    ...current,
    ...parsed,
  };

  const { data, error } = await admin
    .from("parent_profiles")
    .update({
      product_preferences: nextPreferences,
      ...(parsed.displayName ? { full_name: parsed.displayName } : {}),
      ...(parsed.contactPhone !== undefined ? { phone_number: parsed.contactPhone } : {}),
    })
    .eq("id", parentId)
    .select("full_name, phone_number, product_preferences")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save parent settings.");
  }

  return getParentProductPreferences(parentId);
}

export async function getParentNotificationPreferences(parentId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("parent_notification_preferences")
    .select("*")
    .eq("parent_id", parentId)
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  if (!data) {
    return {
      channelSms: true,
      channelEmail: true,
      weeklyReport: true,
      linkUpdates: true,
      atRiskAlerts: true,
    };
  }

  return {
    channelSms: Boolean(data.channel_sms),
    channelEmail: Boolean(data.channel_email),
    weeklyReport: Boolean(data.weekly_report),
    linkUpdates: Boolean(data.link_updates),
    atRiskAlerts: Boolean(data.at_risk_alerts),
  };
}

export const parentNotificationPreferencesSchema = z.object({
  channelSms: z.boolean().optional(),
  channelEmail: z.boolean().optional(),
  weeklyReport: z.boolean().optional(),
  linkUpdates: z.boolean().optional(),
  atRiskAlerts: z.boolean().optional(),
});

export async function updateParentNotificationPreferences(
  parentId: string,
  input: z.infer<typeof parentNotificationPreferencesSchema>,
) {
  const parsed = parentNotificationPreferencesSchema.parse(input);
  const supabase = await createClient();

  const patch = {
    parent_id: parentId,
    ...(parsed.channelSms !== undefined ? { channel_sms: parsed.channelSms } : {}),
    ...(parsed.channelEmail !== undefined ? { channel_email: parsed.channelEmail } : {}),
    ...(parsed.weeklyReport !== undefined ? { weekly_report: parsed.weeklyReport } : {}),
    ...(parsed.linkUpdates !== undefined ? { link_updates: parsed.linkUpdates } : {}),
    ...(parsed.atRiskAlerts !== undefined ? { at_risk_alerts: parsed.atRiskAlerts } : {}),
  };

  const { data, error } = await supabase
    .from("parent_notification_preferences")
    .upsert(patch, { onConflict: "parent_id" })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save notification preferences.");
  }

  return getParentNotificationPreferences(parentId);
}

export async function isParentNotificationEnabled(
  parentId: string,
  event: "weekly_report" | "link_updates" | "at_risk_alerts",
  channel: "sms" | "email",
): Promise<boolean> {
  const prefs = await getParentNotificationPreferences(parentId);

  if (channel === "sms" && !prefs.channelSms) {
    return false;
  }

  if (channel === "email" && !prefs.channelEmail) {
    return false;
  }

  if (event === "weekly_report") {
    return prefs.weeklyReport;
  }

  if (event === "link_updates") {
    return prefs.linkUpdates;
  }

  return prefs.atRiskAlerts;
}
