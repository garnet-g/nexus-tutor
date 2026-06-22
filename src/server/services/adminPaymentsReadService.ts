import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { PaymentsQueryInput } from "@/schemas/adminSchemas";

/**
 * Read-only Payments ledger service for the super-admin dashboard (Phase 2).
 *
 * Source tables:
 *  - mpesa_payments (the ledger: amount_kes, payment_status, mpesa_receipt_number, paid_at)
 *  - student_subscriptions (active paid subscription + funnel by status)
 *  - subscription_trials (trial funnel)
 *  - subscription_plans (plan_code/name/amount_kes for MRR + plan labels)
 *  - student_profiles (full_name for ledger rows)
 */

type PaymentStatus =
  | "pending"
  | "processing"
  | "paid"
  | "failed"
  | "cancelled"
  | "expired"
  | "refunded";

export type PaymentLedgerRow = {
  id: string;
  createdAt: string;
  paidAt: string | null;
  studentName: string;
  phoneNumber: string;
  planName: string;
  amountKes: number;
  status: PaymentStatus;
  mpesaReceiptNumber: string | null;
  checkoutRequestId: string | null;
};

export type PaymentsKpis = {
  totalCollectedKes: number;
  paidCount: number;
  pendingCount: number;
  failedCount: number;
  activePaidSubscriptions: number;
  mrrEstimateKes: number;
};

export type SubscriptionFunnel = {
  trial: number;
  premium: number;
  family: number;
  free: number;
};

export type PaymentsDashboardData = {
  kpis: PaymentsKpis;
  funnel: SubscriptionFunnel;
  ledger: PaymentLedgerRow[];
};

const LEDGER_DEFAULT_LIMIT = 100;
// Payment statuses considered "successful" collected revenue.
const SUCCESS_STATUSES: ReadonlySet<PaymentStatus> = new Set(["paid"]);
const FAILED_STATUSES: ReadonlySet<PaymentStatus> = new Set([
  "failed",
  "cancelled",
  "expired",
]);
const PENDING_STATUSES: ReadonlySet<PaymentStatus> = new Set([
  "pending",
  "processing",
]);

type PlanLookup = Map<string, { planCode: string; name: string; amountKes: number }>;

async function loadPlans(
  admin: ReturnType<typeof createAdminClient>,
): Promise<PlanLookup> {
  const { data, error } = await admin
    .from("subscription_plans")
    .select("id, plan_code, name, amount_kes");

  if (error) {
    throw new Error(error.message);
  }

  const lookup: PlanLookup = new Map();
  for (const row of data ?? []) {
    lookup.set(row.id, {
      planCode: row.plan_code ?? "",
      name: row.name ?? "—",
      amountKes: row.amount_kes ?? 0,
    });
  }
  return lookup;
}

export async function getPaymentsDashboard(
  filters: PaymentsQueryInput = {},
): Promise<PaymentsDashboardData> {
  const admin = createAdminClient();
  const limit = filters.limit ?? LEDGER_DEFAULT_LIMIT;

  const plans = await loadPlans(admin);

  // --- Ledger (filtered) ---
  let ledgerQuery = admin
    .from("mpesa_payments")
    .select(
      "id, student_id, subscription_plan_id, phone_number, amount_kes, mpesa_receipt_number, checkout_request_id, payment_status, paid_at, created_at, student_profiles(full_name)",
    )
    .order("created_at", { ascending: false })
    .limit(limit);

  if (filters.status) {
    ledgerQuery = ledgerQuery.eq("payment_status", filters.status);
  }
  if (filters.from) {
    ledgerQuery = ledgerQuery.gte("created_at", filters.from);
  }
  if (filters.to) {
    ledgerQuery = ledgerQuery.lte("created_at", filters.to);
  }

  const { data: ledgerRows, error: ledgerError } = await ledgerQuery;
  if (ledgerError) {
    throw new Error(ledgerError.message);
  }

  const ledger: PaymentLedgerRow[] = (ledgerRows ?? []).map((row) => {
    const profile = unwrapSupabaseRelation<{ full_name?: string }>(
      row.student_profiles,
    );
    const plan = row.subscription_plan_id
      ? plans.get(row.subscription_plan_id)
      : undefined;

    return {
      id: row.id,
      createdAt: row.created_at,
      paidAt: row.paid_at ?? null,
      studentName: profile?.full_name ?? "Unknown",
      phoneNumber: row.phone_number ?? "—",
      planName: plan?.name ?? "—",
      amountKes: row.amount_kes ?? 0,
      status: (row.payment_status ?? "pending") as PaymentStatus,
      mpesaReceiptNumber: row.mpesa_receipt_number ?? null,
      checkoutRequestId: row.checkout_request_id ?? null,
    };
  });

  // --- KPIs: aggregate across ALL payments (status-only projection, bounded by paid_at window if provided) ---
  const { data: allPayments, error: allPaymentsError } = await admin
    .from("mpesa_payments")
    .select("amount_kes, payment_status");

  if (allPaymentsError) {
    throw new Error(allPaymentsError.message);
  }

  let totalCollectedKes = 0;
  let paidCount = 0;
  let pendingCount = 0;
  let failedCount = 0;

  for (const row of allPayments ?? []) {
    const status = (row.payment_status ?? "pending") as PaymentStatus;
    if (SUCCESS_STATUSES.has(status)) {
      totalCollectedKes += row.amount_kes ?? 0;
      paidCount += 1;
    } else if (FAILED_STATUSES.has(status)) {
      failedCount += 1;
    } else if (PENDING_STATUSES.has(status)) {
      pendingCount += 1;
    }
  }

  // --- Active paid subscriptions + funnel ---
  const { data: subs, error: subsError } = await admin
    .from("student_subscriptions")
    .select("subscription_plan_id, subscription_status");

  if (subsError) {
    throw new Error(subsError.message);
  }

  const funnel: SubscriptionFunnel = { trial: 0, premium: 0, family: 0, free: 0 };
  let activePaidSubscriptions = 0;
  let activePremium = 0;
  let activeFamily = 0;

  for (const row of subs ?? []) {
    const plan = row.subscription_plan_id
      ? plans.get(row.subscription_plan_id)
      : undefined;
    const code = plan?.planCode ?? "free";
    const status = row.subscription_status ?? "active";
    const isActive = status === "active" || status === "trialing";

    if (code === "premium") {
      funnel.premium += 1;
      if (status === "active") {
        activePaidSubscriptions += 1;
        activePremium += 1;
      }
    } else if (code === "family") {
      funnel.family += 1;
      if (status === "active") {
        activePaidSubscriptions += 1;
        activeFamily += 1;
      }
    } else if (isActive) {
      funnel.free += 1;
    }
  }

  // Trial funnel from subscription_trials (active trials).
  const { data: trialRows, error: trialError } = await admin
    .from("subscription_trials")
    .select("id")
    .eq("is_trial_active", true);

  if (trialError) {
    throw new Error(trialError.message);
  }
  funnel.trial = (trialRows ?? []).length;

  const premiumPrice = findPlanPrice(plans, "premium");
  const familyPrice = findPlanPrice(plans, "family");
  const mrrEstimateKes = activePremium * premiumPrice + activeFamily * familyPrice;

  return {
    kpis: {
      totalCollectedKes,
      paidCount,
      pendingCount,
      failedCount,
      activePaidSubscriptions,
      mrrEstimateKes,
    },
    funnel,
    ledger,
  };
}

function findPlanPrice(plans: PlanLookup, planCode: string): number {
  for (const plan of plans.values()) {
    if (plan.planCode === planCode) {
      return plan.amountKes;
    }
  }
  return 0;
}
