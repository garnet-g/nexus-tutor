import { redirect } from "next/navigation";

import { CouponManagerPanel } from "@/features/admin/components/CouponManagerPanel";
import { PaymentCallbackReplayPanel } from "@/features/admin/components/PaymentCallbackReplayPanel";
import { FilterTabs, PageHeader, Panel, StatCard } from "@/features/admin/components/adminUi";
import { PaymentsLedgerTable } from "@/features/admin/components/PaymentsLedgerTable";
import { paymentsQuerySchema } from "@/schemas/adminSchemas";
import {
  type AdminCoupon,
  listCoupons,
} from "@/server/services/adminCouponService";
import {
  type PaymentsDashboardData,
  getPaymentsDashboard,
} from "@/server/services/adminPaymentsReadService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const EMPTY_DASHBOARD: PaymentsDashboardData = {
  kpis: {
    totalCollectedKes: 0,
    paidCount: 0,
    pendingCount: 0,
    failedCount: 0,
    activePaidSubscriptions: 0,
    mrrEstimateKes: 0,
  },
  funnel: { trial: 0, premium: 0, family: 0, free: 0 },
  ledger: [],
};

const STATUS_FILTERS = [
  { value: "", label: "All" },
  { value: "paid", label: "Paid" },
  { value: "pending", label: "Pending" },
  { value: "failed", label: "Failed" },
] as const;

function formatKes(amount: number): string {
  return `KES ${amount.toLocaleString()}`;
}

type SearchParams = Promise<Record<string, string | string[] | undefined>>;

export default async function PaymentsPage({
  searchParams,
}: {
  searchParams: SearchParams;
}) {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  const params = await searchParams;
  const parsed = paymentsQuerySchema.safeParse({
    status: typeof params.status === "string" ? params.status : undefined,
    from: typeof params.from === "string" ? params.from : undefined,
    to: typeof params.to === "string" ? params.to : undefined,
    limit: typeof params.limit === "string" ? params.limit : undefined,
  });
  const filters = parsed.success ? parsed.data : {};
  const activeStatus = filters.status ?? "";

  let data: PaymentsDashboardData = EMPTY_DASHBOARD;
  let coupons: AdminCoupon[] = [];
  try {
    data = await getPaymentsDashboard(filters);
  } catch {
    data = EMPTY_DASHBOARD;
  }
  try {
    coupons = await listCoupons({ limit: 100 });
  } catch {
    coupons = [];
  }

  const { kpis, funnel, ledger } = data;

  return (
    <>
      <PageHeader
        eyebrow="Billing"
        title="Payments"
        description="M-Pesa collections, subscription funnel and recent ledger (Nairobi time). Read-only."
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <StatCard
          label="Total collected"
          value={formatKes(kpis.totalCollectedKes)}
          hint={`${kpis.paidCount.toLocaleString()} successful payments`}
        />
        <StatCard
          label="MRR estimate"
          value={formatKes(kpis.mrrEstimateKes)}
          hint="Active premium + family"
        />
        <StatCard
          label="Active paid subscriptions"
          value={kpis.activePaidSubscriptions.toLocaleString()}
        />
        <StatCard
          label="Pending payments"
          value={kpis.pendingCount.toLocaleString()}
        />
        <StatCard
          label="Failed payments"
          value={kpis.failedCount.toLocaleString()}
        />
      </section>

      <Panel title="Subscription funnel">
        <div className="grid gap-4 sm:grid-cols-4">
          <FunnelStat label="Active trials" value={funnel.trial} />
          <FunnelStat label="Premium" value={funnel.premium} />
          <FunnelStat label="Family" value={funnel.family} />
          <FunnelStat label="Free (active)" value={funnel.free} />
        </div>
      </Panel>

      <CouponManagerPanel
        initialCoupons={coupons}
        canWrite={auth.role === "super_admin"}
      />

      <PaymentCallbackReplayPanel canWrite={auth.role === "super_admin"} />

      <Panel
        title="Recent ledger"
        description="Most recent M-Pesa payment attempts."
        padded={false}
        action={
          <FilterTabs
            options={STATUS_FILTERS}
            activeValue={activeStatus}
            hrefFor={(value) =>
              value ? `/admin/payments?status=${value}` : "/admin/payments"
            }
          />
        }
      >
        <PaymentsLedgerTable rows={ledger} />
      </Panel>
    </>
  );
}

function FunnelStat({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
      <p className="text-sm text-muted-foreground">{label}</p>
      <p className="mt-1 font-heading text-2xl font-semibold tabular-nums text-foreground">
        {value.toLocaleString()}
      </p>
    </div>
  );
}
