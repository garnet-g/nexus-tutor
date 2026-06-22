import { redirect } from "next/navigation";

import { NexFlagReviewPanel } from "@/features/admin/components/NexFlagReviewPanel";
import { PageHeader, Panel, StatCard } from "@/features/admin/components/adminUi";
import {
  type NexOpsDashboardData,
  getNexOpsDashboard,
} from "@/server/services/adminNexOpsReadService";
import {
  type NexFlag,
  listFlags,
} from "@/server/services/adminNexReviewService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const EMPTY_DASHBOARD: NexOpsDashboardData = {
  messagesToday: 0,
  messagesLast7d: 0,
  estimatedTokensLast7d: 0,
  estimatedCostUsdLast7d: 0,
  estimatedCostKesLast7d: 0,
  costByProvider: [],
  usageByMode: [],
  fallbackRate: null,
  topStudents: [],
};

export default async function NexOpsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  let data: NexOpsDashboardData = EMPTY_DASHBOARD;
  let flags: NexFlag[] = [];
  try {
    data = await getNexOpsDashboard({});
  } catch {
    data = EMPTY_DASHBOARD;
  }
  try {
    flags = await listFlags({ status: "open", limit: 100 });
  } catch {
    flags = [];
  }

  const {
    messagesToday,
    messagesLast7d,
    estimatedTokensLast7d,
    estimatedCostUsdLast7d,
    estimatedCostKesLast7d,
    costByProvider,
    usageByMode,
    fallbackRate,
    topStudents,
  } = data;

  return (
    <>
      <PageHeader
        eyebrow="Operations"
        title="Nex ops"
        description="Nex message volume, estimated token spend and fallback rate (Nairobi time). Read-only. Token counts and cost are estimates — see notes."
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Messages today"
          value={messagesToday.toLocaleString()}
        />
        <StatCard
          label="Messages (7d)"
          value={messagesLast7d.toLocaleString()}
        />
        <StatCard
          label="Est. tokens (7d)"
          value={estimatedTokensLast7d.toLocaleString()}
          hint="~4 chars/token estimate"
        />
        <StatCard
          label="Est. cost (7d)"
          value={`KES ${estimatedCostKesLast7d.toLocaleString()}`}
          hint={`~$${estimatedCostUsdLast7d.toFixed(2)} USD`}
        />
        <StatCard
          label="Fallback rate"
          value={
            fallbackRate === null ? "—" : `${(fallbackRate * 100).toFixed(1)}%`
          }
          hint="OpenAI fallback vs Gemini primary"
        />
      </section>

      <Panel title="Cost by model (last 7 days)" padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Provider</th>
                <th className="px-5 py-3 text-right font-medium">Messages</th>
                <th className="px-5 py-3 text-right font-medium">Est. tokens</th>
                <th className="px-5 py-3 text-right font-medium">Est. cost (KES)</th>
              </tr>
            </thead>
            <tbody>
              {costByProvider.length === 0 ? (
                <tr>
                  <td
                    colSpan={4}
                    className="px-5 py-10 text-center text-muted-foreground"
                  >
                    No Nex responses in the last 7 days.
                  </td>
                </tr>
              ) : (
                costByProvider.map((row) => (
                  <tr
                    key={row.provider}
                    className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                  >
                    <td className="px-5 py-3 font-medium capitalize text-foreground">
                      {row.provider}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.messageCount.toLocaleString()}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.estimatedTokens.toLocaleString()}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.estimatedCostKes.toLocaleString()}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </Panel>

      <Panel title="Usage by mode (last 7 days)">
        {usageByMode.length === 0 ? (
          <p className="text-sm text-muted-foreground">
            No Nex sessions in the last 7 days.
          </p>
        ) : (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
            {usageByMode.map((row) => (
              <div
                key={row.mode}
                className="rounded-xl border border-nexus-border bg-nexus-sunken p-4"
              >
                <p className="text-sm capitalize text-muted-foreground">
                  {row.mode}
                </p>
                <p className="mt-1 font-heading text-2xl font-semibold tabular-nums text-foreground">
                  {row.sessionCount.toLocaleString()}
                </p>
              </div>
            ))}
          </div>
        )}
      </Panel>

      <NexFlagReviewPanel
        initialFlags={flags}
        canWrite={auth.role === "super_admin"}
      />

      <Panel
        title="Top students by Nex usage (today)"
        padded={false}
      >
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Student</th>
                <th className="px-5 py-3 font-medium">Curriculum</th>
                <th className="px-5 py-3 font-medium">Grade</th>
                <th className="px-5 py-3 text-right font-medium">Nex msgs</th>
              </tr>
            </thead>
            <tbody>
              {topStudents.length === 0 ? (
                <tr>
                  <td
                    colSpan={4}
                    className="px-5 py-10 text-center text-muted-foreground"
                  >
                    No Nex activity recorded today yet.
                  </td>
                </tr>
              ) : (
                topStudents.map((row) => (
                  <tr
                    key={row.studentId}
                    className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                  >
                    <td className="px-5 py-3 font-medium text-foreground">
                      {row.studentName}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {row.curriculum}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {row.gradeLevel}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.nexMessages.toLocaleString()}
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
