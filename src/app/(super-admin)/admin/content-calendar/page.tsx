import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { PageHeader, Panel, StatusBadge } from "@/features/admin/components/adminUi";
import { getContentCalendarDashboard } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminContentCalendarPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const data = await getContentCalendarDashboard().catch(() => ({
    reviewQueue: [],
    dueThisWeek: [],
  }));

  return (
    <>
      <PageHeader
        eyebrow="Quality"
        title="Content calendar"
        description="Review queue planning surface for lessons and questions awaiting publication."
        actions={<Button render={<Link href="/admin/studio/review" />} variant="outline">Review queue</Button>}
      />
      <Panel title="Due this week" description={`${data.dueThisWeek.length} review item${data.dueThisWeek.length === 1 ? "" : "s"} with submission dates in the current UTC week`}>
        <div className="space-y-3">
          {data.dueThisWeek.length === 0 ? (
            <p className="text-sm text-muted-foreground">No review items due right now.</p>
          ) : data.dueThisWeek.map((item) => (
            <div key={`${item.kind}-${item.id}`} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <p className="font-medium text-foreground">{item.kind === "lesson" ? item.title : item.questionText}</p>
                  <p className="mt-1 text-xs text-muted-foreground">{item.topicTitle}</p>
                </div>
                <StatusBadge tone="warning">{item.kind}</StatusBadge>
              </div>
            </div>
          ))}
        </div>
      </Panel>
    </>
  );
}
