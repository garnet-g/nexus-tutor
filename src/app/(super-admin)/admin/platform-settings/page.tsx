import { PlatformSettingsEditor } from "@/features/admin/components/PlatformSettingsEditor";

import { getEffectiveSubscriptionConfigWithFallback } from "@/lib/platform/getPlatformSettings";

import { createAdminClient } from "@/lib/supabase/admin";



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

  const config = await getEffectiveSubscriptionConfigWithFallback();



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

    <div className="space-y-6">

      <div className="space-y-2">

        <h1 className="text-3xl font-semibold tracking-tight">Platform settings</h1>

        <p className="text-muted-foreground">

          Update pricing, daily limits, and promotions. Changes apply within 60 seconds.

        </p>

      </div>



      <PlatformSettingsEditor

        initialConfig={config}

        initialAuditLog={auditLog}

      />

    </div>

  );

}


