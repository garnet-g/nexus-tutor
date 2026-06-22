import { redirect } from "next/navigation";

import { CouponManagerPanel } from "@/features/admin/components/CouponManagerPanel";
import { PageHeader, Panel, StatCard } from "@/features/admin/components/adminUi";
import { cn } from "@/lib/utils";
import { paymentsQuerySchema } from "@/schemas/adminSchemas";
import {
  type AdminCoupon,
  listCoupons,
} from "@/server/services/adminCouponService";
import {
  type PaymentLedgerRow,
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

function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date(iso));
}

function StatusPill({ status }: { status: PaymentLedgerRow["status"] }) {
  const isSuccess = status === "paid";
  const isFailed =
    status === "failed" || status === "cancelled" || status === "expired";

  const className = isSuccess
    ? "bg-primary/15 text-primary"
    : isFailed
      ? "bg-nexus-danger/15 text-nexus-danger"
      : "bg-nexus-sunken text-muted-foreground";

  return (
    <span
      className={cn(
        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium capitalize",
        className,
      )}
    >
      {status}
    </span>
  );
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

      <Panel
        title="Recent ledger"
        description="Most recent M-Pesa payment attempts."
        padded={false}
        action={
          <div className="flex flex-wrap gap-1">
            {STATUS_FILTERS.map((filter) => {
              const href = filter.value
                ? `/admin/payments?status=${filter.value}`
                : "/admin/payments";
              const isActive = activeStatus === filter.value;
              return (
                <a
                  key={filter.value || "all"}
                  href={href}
                  className={cn(
                    "rounded-lg px-3 py-1.5 text-xs font-medium transition-colors",
                    isActive
                      ? "bg-primary/15 text-foreground"
                      : "text-muted-foreground hover:bg-nexus-sunken hover:text-foreground",
                  )}
                >
                  {filter.label}
                </a>
              );
            })}
          </div>
        }
      >
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Date</th>
                <th className="px-5 py-3 font-medium">Student</th>
                <th className="px-5 py-3 font-medium">Phone</th>
                <th className="px-5 py-3 font-medium">Plan</th>
                <th className="px-5 py-3 text-right font-medium">Amount</th>
                <th className="px-5 py-3 font-medium">Status</th>
                <th className="px-5 py-3 font-medium">Receipt / Ref</th>
              </tr>
            </thead>
            <tbody>
              {ledger.length === 0 ? (
                <tr>
                  <td
                    colSpan={7}
                    className="px-5 py-10 text-center text-muted-foreground"
                  >
                    No payments match these filters yet.
                  </td>
                </tr>
              ) : (
                ledger.map((row) => (
                  <tr
                    key={row.id}
                    className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                  >
                    <td className="px-5 py-3 tabular-nums text-muted-foreground">
                      {formatDate(row.createdAt)}
                    </td>
                    <td className="px-5 py-3 font-medium text-foreground">
                      {row.studentName}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {row.phoneNumber}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {row.planName}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums text-foreground">
                      {row.amountKes.toLocaleString()}
                    </td>
                    <td className="px-5 py-3">
                      <StatusPill status={row.status} />
                    </td>
                    <td className="px-5 py-3 font-mono text-xs text-muted-foreground">
                      {row.mpesaReceiptNumber ?? row.checkoutRequestId ?? "—"}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
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
