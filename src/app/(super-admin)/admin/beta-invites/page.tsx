import { BetaInvitesPanel } from "@/features/admin/components/BetaInvitesPanel";
import {
  listBetaInvites,
  type BetaInvite,
} from "@/server/services/betaInviteService";

export const dynamic = "force-dynamic";

export default async function BetaInvitesPage() {
  let invites: BetaInvite[] = [];

  try {
    invites = await listBetaInvites();
  } catch {
    invites = [];
  }

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight">Beta invites</h1>
        <p className="text-muted-foreground">
          Generate invite codes for private beta signup when BETA_INVITE_REQUIRED is
          enabled.
        </p>
      </div>

      <BetaInvitesPanel initialInvites={invites} />
    </div>
  );
}
