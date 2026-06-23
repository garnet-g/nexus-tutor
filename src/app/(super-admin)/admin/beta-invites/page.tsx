import { redirect } from "next/navigation";

import { PageHeader } from "@/features/admin/components/adminUi";
import { BetaInvitesPanel } from "@/features/admin/components/BetaInvitesPanel";
import {
  listBetaInvites,
  type BetaInvite,
} from "@/server/services/betaInviteService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function BetaInvitesPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  let invites: BetaInvite[] = [];

  try {
    invites = await listBetaInvites();
  } catch {
    invites = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Growth"
        title="Beta invites"
        description="Generate invite codes for private beta signup when BETA_INVITE_REQUIRED is enabled."
      />

      <BetaInvitesPanel initialInvites={invites} />
    </>
  );
}
