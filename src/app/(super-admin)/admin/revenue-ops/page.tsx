import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import {
  PageHeader,
  Panel,
  StatCard,
  StatusBadge,
} from "@/features/admin/components/adminUi";
import { getRevenueOpsDashboard } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminRevenueOpsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const data = await getRevenueOpsDashboard().catch(() => ({
    payments: null,
    coupons: [],
  }));

  const kpis = data.payments?.kpis;

  return (
    <>
      <PageHeader
        eyebrow="Revenue"
        title="Revenue ops"
        description="Payment health, failed transaction follow-up, and coupon capacity for the current M-Pesa-led billing model."
        actions={<Button render={<Link href="/admin/payments" />} variant="outline">Payment ledger</Button>}
      />
      <section className="grid gap-4 sm:grid-cols-4">
        <StatCard label="Paid" value={(kpis?.paidCount ?? 0).toLocaleString()} />
        <StatCard label="Failed" value={(kpis?.failedCount ?? 0).toLocaleString()} />
        <StatCard label="Gross KES" value={(kpis?.totalCollectedKes ?? 0).toLocaleString()} />
        <StatCard label="Coupons" value={data.coupons.length.toLocaleString()} />
      </section>
      <section className="grid gap-5 lg:grid-cols-2">
        <Panel title="Recent payments" description={`${data.payments?.ledger.length ?? 0} ledger row${data.payments?.ledger.length === 1 ? "" : "s"}`}>
          <div className="space-y-2">
            {!data.payments || data.payments.ledger.length === 0 ? (
              <p className="text-sm text-muted-foreground">No payment ledger rows available.</p>
            ) : data.payments.ledger.slice(0, 8).map((payment) => (
              <div key={payment.id} className="flex items-start justify-between gap-3 rounded-xl bg-nexus-sunken p-3">
                <div>
                  <p className="text-sm font-medium text-foreground">{payment.studentName}</p>
                  <p className="text-xs text-muted-foreground">KES {payment.amountKes.toLocaleString()} / {payment.planName}</p>
                </div>
                <StatusBadge tone={payment.status === "paid" ? "success" : payment.status === "failed" ? "danger" : "warning"}>{payment.status}</StatusBadge>
              </div>
            ))}
          </div>
        </Panel>
        <Panel title="Coupons" description={`${data.coupons.length} coupon${data.coupons.length === 1 ? "" : "s"}`}>
          <div className="space-y-2">
            {data.coupons.length === 0 ? (
              <p className="text-sm text-muted-foreground">No coupons configured.</p>
            ) : data.coupons.slice(0, 8).map((coupon) => (
              <div key={coupon.id} className="flex items-start justify-between gap-3 rounded-xl bg-nexus-sunken p-3">
                <div>
                  <p className="font-mono text-sm font-medium text-foreground">{coupon.code}</p>
                  <p className="text-xs text-muted-foreground">{coupon.usedCount.toLocaleString()} uses / {coupon.appliesToPlan}</p>
                </div>
                <StatusBadge tone={coupon.isActive ? "success" : "neutral"}>{coupon.isActive ? "active" : "off"}</StatusBadge>
              </div>
            ))}
          </div>
        </Panel>
      </section>
    </>
  );
}
