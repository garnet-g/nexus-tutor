import { NexOpsReviewPanel } from "@/features/admin/components/NexOpsReviewPanel";
import {
  loadNexOpsSnapshot,
  type NexOpsModeSummary,
  type NexOpsProviderSummary,
} from "@/server/services/nexOpsService";

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

function StatCard({
  label,
  value,
  note,
}: {
  label: string;
  value: string;
  note?: string;
}) {
  return (
    <div className="rounded-lg border border-border bg-card p-5">
      <p className="text-sm text-muted-foreground">{label}</p>
      <p className="mt-3 font-heading text-3xl font-semibold tracking-tight">
        {value}
      </p>
      {note ? <p className="mt-2 text-xs text-muted-foreground">{note}</p> : null}
    </div>
  );
}

function ProviderTable({ rows }: { rows: NexOpsProviderSummary[] }) {
  return (
    <section className="overflow-hidden rounded-lg border border-border bg-card">
      <div className="border-b border-border px-5 py-4">
        <h2 className="font-heading text-lg font-semibold">
          Cost by model (last 7 days)
        </h2>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full min-w-[720px] text-sm">
          <thead>
            <tr className="border-b border-border text-left text-xs uppercase tracking-wide text-muted-foreground">
              <th className="px-5 py-3 font-medium">Provider</th>
              <th className="px-5 py-3 text-right font-medium">Messages</th>
              <th className="px-5 py-3 text-right font-medium">Est. tokens</th>
              <th className="px-5 py-3 text-right font-medium">Est. cost (KES)</th>
            </tr>
          </thead>
          <tbody>
            {rows.length === 0 ? (
              <tr>
                <td
                  colSpan={4}
                  className="px-5 py-8 text-center text-muted-foreground"
                >
                  No Nex model calls recorded in the last 7 days.
                </td>
              </tr>
            ) : (
              rows.map((row) => (
                <tr key={row.providerKey} className="border-b border-border last:border-0">
                  <td className="px-5 py-4 font-medium">{row.provider}</td>
                  <td className="px-5 py-4 text-right font-mono">
                    {formatNumber(row.messages)}
                  </td>
                  <td className="px-5 py-4 text-right font-mono">
                    {formatNumber(row.estimatedTokens)}
                  </td>
                  <td className="px-5 py-4 text-right font-mono">
                    {formatKes(row.estimatedCostKes)}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </section>
  );
}

function ModeGrid({ rows }: { rows: NexOpsModeSummary[] }) {
  return (
    <section className="rounded-lg border border-border bg-card">
      <div className="border-b border-border px-5 py-4">
        <h2 className="font-heading text-lg font-semibold">
          Usage by mode (last 7 days)
        </h2>
      </div>
      <div className="grid gap-4 p-5 sm:grid-cols-2 lg:grid-cols-4">
        {rows.length === 0 ? (
          <p className="text-sm text-muted-foreground">
            No mode activity recorded yet.
          </p>
        ) : (
          rows.map((row) => (
            <div key={row.mode} className="rounded-lg border border-border bg-background p-4">
              <p className="text-sm text-muted-foreground">{row.mode}</p>
              <p className="mt-2 font-heading text-2xl font-semibold">
                {formatNumber(row.messages)}
              </p>
            </div>
          ))
        )}
      </div>
    </section>
  );
}

export default async function UsageStatsPage() {
  const snapshot = await loadNexOpsSnapshot();

  return (
    <div className="space-y-7">
      <div className="space-y-3 border-b border-border pb-6">
        <p className="text-xs font-semibold uppercase tracking-[0.22em] text-muted-foreground">
          Operations
        </p>
        <div className="space-y-2">
          <h1 className="font-heading text-3xl font-semibold tracking-tight">
            Nex ops
          </h1>
          <p className="max-w-3xl text-sm leading-6 text-muted-foreground">
            Nex message volume, estimated token spend, fallback rate, and flagged
            conversation review ({snapshot.date}, Nairobi time).
          </p>
        </div>
      </div>

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
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
          note={`~${snapshot.pricing.charsPerToken} chars/token estimate`}
        />
        <StatCard
          label="Est. cost (7d)"
          value={formatKes(snapshot.summary.estimatedCostKes)}
          note={formatUsd(snapshot.summary.estimatedCostUsd)}
        />
        <StatCard
          label="Fallback rate"
          value={`${snapshot.summary.fallbackRatePercent.toFixed(1)}%`}
          note="OpenAI fallback vs Gemini primary"
        />
        <StatCard
          label="Open reviews"
          value={formatNumber(snapshot.summary.openFlaggedCount)}
          note="Validation failures still needing review"
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
    </div>
  );
}
