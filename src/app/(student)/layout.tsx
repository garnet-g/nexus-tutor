import { StudentAppShell } from "@/components/student/StudentAppShell";
import { getSessionUser } from "@/server/services/authService";
import { getProgressSummary } from "@/server/services/practiceService";

export default async function StudentLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;
  const diagnosticComplete = profile?.has_completed_diagnostic ?? false;

  let currentStreak = 0;
  let totalXp = 0;

  if (profile && diagnosticComplete) {
    try {
      const progress = await getProgressSummary(profile.id);
      currentStreak = progress.currentStreak;
      totalXp = progress.totalXp;
    } catch {
      // Non-fatal: the you-strip simply starts at zero.
    }
  }

  return (
    <StudentAppShell
      studentName={profile?.full_name ?? "Student"}
      currentStreak={currentStreak}
      totalXp={totalXp}
      diagnosticComplete={diagnosticComplete}
    >
      {children}
    </StudentAppShell>
  );
}
