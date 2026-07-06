import Link from "next/link";

import { ParentNotificationPreferencesForm } from "@/features/parent-dashboard/components/ParentNotificationPreferencesForm";
import { ParentSettingsForm } from "@/features/parent-dashboard/components/ParentSettingsForm";
import { getSessionUser } from "@/server/services/authService";
import {
  getParentNotificationPreferences,
  getParentProductPreferences,
} from "@/server/services/parentPreferencesService";

export const dynamic = "force-dynamic";

export default async function ParentSettingsPage() {
  const sessionUser = await getSessionUser();
  const parentId = sessionUser?.parentProfile?.id;

  if (!parentId) {
    return null;
  }

  const [productPreferences, notificationPreferences] = await Promise.all([
    getParentProductPreferences(parentId),
    getParentNotificationPreferences(parentId),
  ]);

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <Link href="/parent" className="text-sm text-muted-foreground hover:text-foreground">
          ← Back to dashboard
        </Link>
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          Parent settings
        </h1>
        <p className="text-muted-foreground">
          Manage contact details and how Nexus reaches you about linked students.
        </p>
      </div>

      <ParentSettingsForm initial={productPreferences} />
      <ParentNotificationPreferencesForm initial={notificationPreferences} />
    </div>
  );
}
