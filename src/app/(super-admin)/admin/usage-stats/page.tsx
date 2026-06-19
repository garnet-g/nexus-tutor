import { createAdminClient } from "@/lib/supabase/admin";

export const dynamic = "force-dynamic";

function getNairobiDateString(date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(date);
}

type StudentRow = {
  studentId: string;
  fullName: string;
  curriculum: string;
  gradeLevel: string;
  nexMessages: number;
  practiceSessions: number;
};

async function loadUsageStats() {
  const admin = createAdminClient();
  const today = getNairobiDateString();

  const { data: todayRows } = await admin
    .from("nex_daily_usage")
    .select(
      "student_id, nex_message_count, practice_session_count, student_profiles(full_name, curriculum, grade_level)",
    )
    .eq("usage_date", today)
    .order("nex_message_count", { ascending: false })
    .limit(100);

  const students: StudentRow[] = (todayRows ?? []).map((row) => {
    const profile =
      row.student_profiles &&
      typeof row.student_profiles === "object" &&
      !Array.isArray(row.student_profiles)
        ? (row.student_profiles as { full_name?: string; curriculum?: string; grade_level?: string })
        : null;

    return {
      studentId: row.student_id,
      fullName: profile?.full_name ?? "Unknown",
      curriculum: profile?.curriculum ?? "—",
      gradeLevel: profile?.grade_level ?? "—",
      nexMessages: row.nex_message_count ?? 0,
      practiceSessions: row.practice_session_count ?? 0,
    };
  });

  const totalNexMessages = students.reduce((sum, s) => sum + s.nexMessages, 0);
  const totalPracticeSessions = students.reduce((sum, s) => sum + s.practiceSessions, 0);

  return { today, students, totalNexMessages, totalPracticeSessions };
}

export default async function UsageStatsPage() {
  const { today, students, totalNexMessages, totalPracticeSessions } =
    await loadUsageStats();

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight">Usage stats</h1>
        <p className="text-muted-foreground">
          Per-student AI and practice activity for today ({today}, Nairobi time).
        </p>
      </div>

      <section className="grid gap-4 sm:grid-cols-3">
        <div className="rounded-2xl border border-border bg-primary p-5">
          <p className="text-sm text-muted-foreground">Active students today</p>
          <p className="mt-1 text-3xl font-semibold">{students.length}</p>
        </div>
        <div className="rounded-2xl border border-border bg-primary p-5">
          <p className="text-sm text-muted-foreground">Total Nex messages</p>
          <p className="mt-1 text-3xl font-semibold">{totalNexMessages}</p>
        </div>
        <div className="rounded-2xl border border-border bg-primary p-5">
          <p className="text-sm text-muted-foreground">Total practice sessions</p>
          <p className="mt-1 text-3xl font-semibold">{totalPracticeSessions}</p>
        </div>
      </section>

      <section className="rounded-2xl border border-border bg-primary">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-left text-muted-foreground">
                <th className="px-4 py-3 font-medium">Student</th>
                <th className="px-4 py-3 font-medium">Curriculum</th>
                <th className="px-4 py-3 font-medium">Grade</th>
                <th className="px-4 py-3 font-medium text-right">Nex msgs</th>
                <th className="px-4 py-3 font-medium text-right">Practice</th>
              </tr>
            </thead>
            <tbody>
              {students.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="px-4 py-8 text-center text-muted-foreground"
                  >
                    No activity recorded today yet.
                  </td>
                </tr>
              ) : (
                students.map((student) => (
                  <tr
                    key={student.studentId}
                    className="border-b border-border last:border-0 hover:bg-muted/30"
                  >
                    <td className="px-4 py-3 font-medium">{student.fullName}</td>
                    <td className="px-4 py-3 text-muted-foreground">
                      {student.curriculum}
                    </td>
                    <td className="px-4 py-3 text-muted-foreground">
                      {student.gradeLevel}
                    </td>
                    <td className="px-4 py-3 text-right font-mono">
                      {student.nexMessages}
                    </td>
                    <td className="px-4 py-3 text-right font-mono">
                      {student.practiceSessions}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
