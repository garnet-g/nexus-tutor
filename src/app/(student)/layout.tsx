import { StudentAppShell } from "@/components/student/StudentAppShell";
import { getSessionUser } from "@/server/services/authService";
import { getStudentChromeData } from "@/server/services/studentExperienceService";

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
  let planCode = "free";
  let navBadges: Record<string, string> = {};

  if (profile && diagnosticComplete) {
    try {
      const chrome = await getStudentChromeData(profile);
      currentStreak = chrome.currentStreak;
      totalXp = chrome.totalXp;
      planCode = chrome.planCode;
      navBadges = chrome.navBadges;
    } catch {
      // Non-fatal: the student shell simply starts with empty counts.
    }
  }

  return (
    <StudentAppShell
      studentName={profile?.full_name ?? "Student"}
      currentStreak={currentStreak}
      totalXp={totalXp}
      planCode={planCode}
      navBadges={navBadges}
      diagnosticComplete={diagnosticComplete}
    >
      {children}
    </StudentAppShell>
  );
}
