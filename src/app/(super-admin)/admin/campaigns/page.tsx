import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import {
  PageHeader,
  Panel,
  StatCard,
  StatusBadge,
} from "@/features/admin/components/adminUi";
import { listCoupons, type AdminCoupon } from "@/server/services/adminCouponService";
import {
  buildCampaignSummary,
  type CampaignSummary,
} from "@/server/services/adminOpsSummary";
import {
  listBetaInvites,
  type BetaInvite,
} from "@/server/services/betaInviteService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const EMPTY_SUMMARY: CampaignSummary = {
  activeInvites: 0,
  inviteCapacity: 0,
  inviteUses: 0,
  activeCoupons: 0,
  couponCapacity: null,
  couponUses: 0,
};

function isExpired(expiresAt: string | null): boolean {
  return Boolean(expiresAt && new Date(expiresAt).getTime() <= Date.now());
}

export default async function AdminCampaignsPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  let invites: BetaInvite[] = [];
  let coupons: AdminCoupon[] = [];
  let summary = EMPTY_SUMMARY;

  try {
    [invites, coupons] = await Promise.all([
      listBetaInvites(),
      listCoupons({ limit: 100 }),
    ]);
    summary = buildCampaignSummary({ invites, coupons });
  } catch {
    invites = [];
    coupons = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Growth"
        title="Campaign operations"
        description="Monitor beta invite capacity and coupon usage from one growth-control surface."
        actions={
          <>
            <Button render={<Link href="/admin/beta-invites" />} variant="outline">
              Beta invites
            </Button>
            <Button render={<Link href="/admin/payments" />}>Coupons</Button>
          </>
        }
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard label="Active invites" value={summary.activeInvites.toLocaleString()} />
        <StatCard label="Invite uses" value={summary.inviteUses.toLocaleString()} />
        <StatCard label="Active coupons" value={summary.activeCoupons.toLocaleString()} />
        <StatCard label="Coupon uses" value={summary.couponUses.toLocaleString()} />
      </section>

      <section className="grid gap-5 xl:grid-cols-2">
        <Panel title="Beta invite performance" padded={false}>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                  <th className="px-5 py-3 font-medium">Code</th>
                  <th className="px-5 py-3 text-right font-medium">Uses</th>
                  <th className="px-5 py-3 font-medium">Status</th>
                  <th className="px-5 py-3 font-medium">Expires</th>
                </tr>
              </thead>
              <tbody>
                {invites.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="px-5 py-10 text-center text-muted-foreground">
                      No beta invites yet.
                    </td>
                  </tr>
                ) : (
                  invites.map((invite) => {
                    const expired = isExpired(invite.expires_at);
                    const exhausted = invite.use_count >= invite.max_uses;
                    return (
                      <tr key={invite.id} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                        <td className="px-5 py-3 font-mono text-foreground">{invite.invite_code}</td>
                        <td className="px-5 py-3 text-right font-mono tabular-nums">
                          {invite.use_count}/{invite.max_uses}
                        </td>
                        <td className="px-5 py-3">
                          <StatusBadge tone={invite.is_active && !expired && !exhausted ? "success" : "neutral"}>
                            {expired ? "expired" : exhausted ? "full" : invite.is_active ? "active" : "inactive"}
                          </StatusBadge>
                        </td>
                        <td className="px-5 py-3 text-muted-foreground">
                          {invite.expires_at ? new Date(invite.expires_at).toLocaleDateString("en-KE") : "-"}
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </Panel>

        <Panel title="Coupon performance" padded={false}>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                  <th className="px-5 py-3 font-medium">Code</th>
                  <th className="px-5 py-3 font-medium">Discount</th>
                  <th className="px-5 py-3 text-right font-medium">Uses</th>
                  <th className="px-5 py-3 font-medium">Status</th>
                </tr>
              </thead>
              <tbody>
                {coupons.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="px-5 py-10 text-center text-muted-foreground">
                      No coupons configured yet.
                    </td>
                  </tr>
                ) : (
                  coupons.map((coupon) => {
                    const expired = isExpired(coupon.expiresAt);
                    return (
                      <tr key={coupon.id} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                        <td className="px-5 py-3 font-mono text-foreground">{coupon.code}</td>
                        <td className="px-5 py-3 text-muted-foreground">
                          {coupon.discountType === "percent"
                            ? `${coupon.discountValue}%`
                            : `KES ${coupon.discountValue.toLocaleString()}`}
                        </td>
                        <td className="px-5 py-3 text-right font-mono tabular-nums">
                          {coupon.usedCount}
                          {coupon.maxUses ? `/${coupon.maxUses}` : ""}
                        </td>
                        <td className="px-5 py-3">
                          <StatusBadge tone={coupon.isActive && !expired ? "success" : "neutral"}>
                            {expired ? "expired" : coupon.isActive ? "active" : "inactive"}
                          </StatusBadge>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </Panel>
      </section>
    </>
  );
}
