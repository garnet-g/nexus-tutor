import { redirect } from "next/navigation";

import { NexOpsReviewPanel } from "@/features/admin/components/NexOpsReviewPanel";
import {
  EmptyState,
  PageHeader,
  Panel,
  StatCard,
} from "@/features/admin/components/adminUi";
import {
  loadNexOpsSnapshot,
  type NexOpsModeSummary,
  type NexOpsProviderSummary,
} from "@/server/services/nexOpsService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function formatNumber(value: number): string {
  return new Intl.NumberFormat("en-US").format(value);
}

function formatKes(value: number): string {
  if (value === 0) {
    return "KES 0";
  }

  if (value > 0 && value < 1) {
    return `KES ${value.toFixed(2)}`;
  }

  return `KES ${new Intl.NumberFormat("en-US", {
    maximumFractionDigits: 2,
  }).format(value)}`;
}

function formatUsd(value: number): string {
  return `~$${value < 0.01 ? value.toFixed(4) : value.toFixed(2)} USD`;
}

function ProviderTable({ rows }: { rows: NexOpsProviderSummary[] }) {
  return (
    <Panel title="Cost by model (last 7 days)" padded={rows.length === 0}>
      {rows.length === 0 ? (
        <EmptyState title="No Nex model calls recorded in the last 7 days." />
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full min-w-[720px] text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Provider</th>
                <th className="px-5 py-3 text-right font-medium">Messages</th>
                <th className="px-5 py-3 text-right font-medium">Est. tokens</th>
                <th className="px-5 py-3 text-right font-medium">Est. cost (KES)</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr
                  key={row.providerKey}
                  className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                >
                  <td className="px-5 py-3 font-medium">{row.provider}</td>
                  <td className="px-5 py-3 text-right font-mono tabular-nums">
                    {formatNumber(row.messages)}
                  </td>
                  <td className="px-5 py-3 text-right font-mono tabular-nums">
                    {formatNumber(row.estimatedTokens)}
                  </td>
                  <td className="px-5 py-3 text-right font-mono tabular-nums">
                    {formatKes(row.estimatedCostKes)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </Panel>
  );
}

function ModeGrid({ rows }: { rows: NexOpsModeSummary[] }) {
  return (
    <Panel title="Usage by mode (last 7 days)">
      {rows.length === 0 ? (
        <p className="text-sm text-muted-foreground">
          No mode activity recorded yet.
        </p>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {rows.map((row) => (
            <div
              key={row.mode}
              className="rounded-xl border border-nexus-border bg-nexus-sunken p-4"
            >
              <p className="text-sm capitalize text-muted-foreground">{row.mode}</p>
              <p className="mt-1 font-heading text-2xl font-semibold tabular-nums text-foreground">
                {formatNumber(row.messages)}
              </p>
            </div>
          ))}
        </div>
      )}
    </Panel>
  );
}

export default async function UsageStatsPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const snapshot = await loadNexOpsSnapshot();

  return (
    <>
      <PageHeader
        eyebrow="Operations"
        title="Usage stats"
        description={`Nex message volume, estimated token spend, fallback rate, and flagged conversation review (${snapshot.date}, Nairobi time).`}
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Messages today"
          value={formatNumber(snapshot.summary.messagesToday)}
        />
        <StatCard
          label="Messages (7d)"
          value={formatNumber(snapshot.summary.messages7d)}
        />
        <StatCard
          label="Est. tokens (7d)"
          value={formatNumber(snapshot.summary.estimatedTokens7d)}
          hint={`~${snapshot.pricing.charsPerToken} chars/token estimate`}
        />
        <StatCard
          label="Est. cost (7d)"
          value={formatKes(snapshot.summary.estimatedCostKes)}
          hint={formatUsd(snapshot.summary.estimatedCostUsd)}
        />
        <StatCard
          label="Fallback rate"
          value={`${snapshot.summary.fallbackRatePercent.toFixed(1)}%`}
          hint="OpenAI fallback vs Gemini primary"
        />
        <StatCard
          label="Open reviews"
          value={formatNumber(snapshot.summary.openFlaggedCount)}
          hint="Validation failures still needing review"
        />
      </section>

      <ProviderTable rows={snapshot.byProvider} />
      <ModeGrid rows={snapshot.byMode} />
      <NexOpsReviewPanel initialItems={snapshot.flagged} />

      <p className="text-xs leading-5 text-muted-foreground">
        Token and cost values are estimates from stored prompt/response text. Override
        pricing with NEX_GEMINI_INPUT_USD_PER_MILLION,
        NEX_GEMINI_OUTPUT_USD_PER_MILLION, NEX_OPENAI_INPUT_USD_PER_MILLION,
        NEX_OPENAI_OUTPUT_USD_PER_MILLION, and NEX_USD_TO_KES_RATE.
      </p>
    </>
  );
}
