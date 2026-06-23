import Link from "next/link";
import { redirect } from "next/navigation";

import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";
import { Button } from "@/components/ui/Button";

export const dynamic = "force-dynamic";

export default async function StudioIndexPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Authoring Studio"
        title="Manual lesson authoring"
        description="Create and edit structured lesson drafts block by block. AI assist arrives in a later phase."
        actions={
          <Button render={<Link href="/admin/studio/new" />}>New lesson</Button>
        }
      />

      <Panel title="Get started">
        <p className="text-sm text-muted-foreground">
          Open an existing draft from the legacy content queue, or start a new manual lesson for any
          subtopic. Saved drafts stay in <code>review_status=draft</code> until the approval workflow
          ships in Phase 3.
        </p>
        <div className="mt-4 flex flex-wrap gap-2">
          <Button render={<Link href="/admin/studio/new" />}>New lesson</Button>
          <Button variant="outline" render={<Link href="/admin/content" />}>
            Open content queue
          </Button>
        </div>
      </Panel>
    </div>
  );
}
