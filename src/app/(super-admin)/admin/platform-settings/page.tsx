import { redirect } from "next/navigation";

import { PageHeader } from "@/features/admin/components/adminUi";
import { PlatformSettingsEditor } from "@/features/admin/components/PlatformSettingsEditor";
import { getEffectiveSubscriptionConfigWithFallback } from "@/lib/platform/getPlatformSettings";
import { createAdminClient } from "@/lib/supabase/admin";
import { isContentAutoApproveEnabled } from "@/server/services/contentApprovalService";
import { getNexOpsPricingConfigFromPlatformSettings } from "@/server/services/nexOpsService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

type AuditLogEntry = {
  id: string;
  change_type: string;
  setting_key: string | null;
  previous_value: unknown;
  new_value: unknown;
  change_reason: string | null;
  created_at: string;
};

export default async function PlatformSettingsPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const config = await getEffectiveSubscriptionConfigWithFallback();
  const contentAutoApproveEnabled = await isContentAutoApproveEnabled();
  const nexOpsPricing = await getNexOpsPricingConfigFromPlatformSettings();

  let auditLog: AuditLogEntry[] = [];

  try {
    const admin = createAdminClient();
    const { data } = await admin
      .from("platform_settings_audit_log")
      .select(
        "id, change_type, setting_key, previous_value, new_value, change_reason, created_at",
      )
      .order("created_at", { ascending: false })
      .limit(10);
    auditLog = (data ?? []) as AuditLogEntry[];
  } catch {
    auditLog = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Configuration"
        title="Platform settings"
        description="Update pricing, daily limits, and promotions. Changes apply within 60 seconds."
      />

      <PlatformSettingsEditor
        initialConfig={config}
        initialAuditLog={auditLog}
        initialContentAutoApproveEnabled={contentAutoApproveEnabled}
        initialNexOpsPricing={nexOpsPricing}
      />
    </>
  );
}
