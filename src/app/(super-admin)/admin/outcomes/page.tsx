import { redirect } from "next/navigation";

import { AtRiskParentSmsPanel } from "@/features/admin/components/AtRiskParentSmsPanel";
import { FilterTabs, PageHeader, Panel, StatCard } from "@/features/admin/components/adminUi";
import { outcomesQuerySchema } from "@/schemas/adminSchemas";
import {
  type OutcomesDashboardData,
  getOutcomesDashboard,
} from "@/server/services/adminOutcomesReadService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const EMPTY_DASHBOARD: OutcomesDashboardData = {
  kpis: {
    cohortHealthDelta: 0,
    avgCurrentHealthScore: 0,
    avgTopicMasteryPct: 0,
    activeLearners: 0,
    studentsWithScores: 0,
  },
  breakdown: [],
  atRisk: [],
  riskThreshold: 50,
};

const CURRICULUM_FILTERS = [
  { value: "", label: "All" },
  { value: "CBC", label: "CBC" },
  { value: "KCSE", label: "KCSE" },
] as const;

function formatDelta(value: number): string {
  const sign = value > 0 ? "+" : "";
  return `${sign}${value.toFixed(1)}`;
}

type SearchParams = Promise<Record<string, string | string[] | undefined>>;

export default async function OutcomesPage({
  searchParams,
}: {
  searchParams: SearchParams;
}) {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  const params = await searchParams;
  const parsed = outcomesQuerySchema.safeParse({
    curriculum:
      typeof params.curriculum === "string" ? params.curriculum : undefined,
    gradeLevel:
      typeof params.gradeLevel === "string" ? params.gradeLevel : undefined,
    riskThreshold:
      typeof params.riskThreshold === "string"
        ? params.riskThreshold
        : undefined,
    limit: typeof params.limit === "string" ? params.limit : undefined,
  });
  const filters = parsed.success ? parsed.data : {};
  const activeCurriculum = filters.curriculum ?? "";

  let data: OutcomesDashboardData = EMPTY_DASHBOARD;
  try {
    data = await getOutcomesDashboard(filters);
  } catch {
    data = EMPTY_DASHBOARD;
  }

  const { kpis, breakdown, atRisk, riskThreshold } = data;

  return (
    <>
      <PageHeader
        eyebrow="Learning"
        title="Outcomes"
        description="Cohort academic-health progression and at-risk learners. Read-only."
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Cohort health delta"
          value={formatDelta(kpis.cohortHealthDelta)}
          hint="Avg latest − baseline"
        />
        <StatCard
          label="Avg current health"
          value={kpis.avgCurrentHealthScore.toFixed(1)}
          hint={`${kpis.studentsWithScores.toLocaleString()} students scored`}
        />
        <StatCard
          label="Avg topic mastery"
          value={`${kpis.avgTopicMasteryPct.toFixed(1)}%`}
        />
        <StatCard
          label="Active learners"
          value={kpis.activeLearners.toLocaleString()}
        />
      </section>

      <Panel
        title="Breakdown by curriculum & grade"
        padded={false}
        action={
          <FilterTabs
            options={CURRICULUM_FILTERS}
            activeValue={activeCurriculum}
            hrefFor={(value) =>
              value ? `/admin/outcomes?curriculum=${value}` : "/admin/outcomes"
            }
          />
        }
      >
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Curriculum</th>
                <th className="px-5 py-3 font-medium">Grade</th>
                <th className="px-5 py-3 text-right font-medium">Avg health</th>
                <th className="px-5 py-3 text-right font-medium">Avg mastery</th>
                <th className="px-5 py-3 text-right font-medium">Students</th>
              </tr>
            </thead>
            <tbody>
              {breakdown.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="px-5 py-10 text-center text-muted-foreground"
                  >
                    No outcome data available yet.
                  </td>
                </tr>
              ) : (
                breakdown.map((row) => (
                  <tr
                    key={row.groupKey}
                    className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                  >
                    <td className="px-5 py-3 font-medium text-foreground">
                      {row.curriculum}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {row.gradeLevel}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.avgHealthScore.toFixed(1)}
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.avgMasteryPct.toFixed(1)}%
                    </td>
                    <td className="px-5 py-3 text-right font-mono tabular-nums">
                      {row.studentCount.toLocaleString()}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </Panel>

      <AtRiskParentSmsPanel
        students={atRisk}
        riskThreshold={riskThreshold}
        canWrite={auth.role === "super_admin"}
      />
    </>
  );
}
