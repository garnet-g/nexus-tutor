import { redirect } from "next/navigation";

import { ThemeToggle } from "@/components/ThemeToggle";
import { ProfileForm } from "@/features/profile/components/ProfileForm";
import {
  ProfileAccountSummary,
  ProfileUsageSummary,
} from "@/features/profile/components/ProfileSummarySections";
import { getEffectiveSubscriptionConfigWithFallback } from "@/lib/platform/getPlatformSettings";
import {
  getFamilyGroupMembers,
  getFamilyInviteCodeForStudent,
} from "@/server/services/familySubscriptionService";
import { getSessionUser } from "@/server/services/authService";
import {
  getNexDailyUsageCount,
  getPracticeDailyUsageCount,
} from "@/server/services/nexUsageService";
import { getStudentPlanCode } from "@/server/services/subscriptionService";

export const dynamic = "force-dynamic";

export default async function ProfilePage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const profile = sessionUser.studentProfile;

  const [planCode, subscriptionConfig, nexUsage, practiceUsage] =
    await Promise.all([
      getStudentPlanCode(profile.id),
      getEffectiveSubscriptionConfigWithFallback(),
      getNexDailyUsageCount(profile.id),
      getPracticeDailyUsageCount(profile.id),
    ]);

  let familyInviteCode: string | null = null;
  let familyMembers: Array<{ studentId: string; fullName: string; joinedAt: string }> =
    [];

  if (planCode === "family") {
    try {
      familyInviteCode = await getFamilyInviteCodeForStudent(
        profile.id,
        sessionUser.id,
      );
      familyMembers = await getFamilyGroupMembers(profile.id);
    } catch {
      familyInviteCode = null;
    }
  } else {
    familyMembers = await getFamilyGroupMembers(profile.id).catch(() => []);
  }

  return (
    <div className="mx-auto w-full max-w-2xl space-y-6 nexus-enter">
      <div className="flex items-start justify-between gap-4">
        <div className="space-y-1">
          <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            Profile
          </p>
          <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
            Account & preferences
          </h1>
          <p className="text-sm text-muted-foreground">
            Manage your details, learning preferences, and subscription.
          </p>
        </div>
        <ThemeToggle />
      </div>

      <ProfileAccountSummary
        curriculum={profile.curriculum}
        gradeLevel={profile.grade_level}
        planCode={planCode}
        email={profile.email}
        fullName={profile.full_name}
      />

      <ProfileUsageSummary
        planCode={planCode}
        nexUsage={nexUsage}
        practiceUsage={practiceUsage}
        config={subscriptionConfig}
      />

      <ProfileForm
        profile={profile}
        planCode={planCode}
        familyInviteCode={familyInviteCode}
        familyMembers={familyMembers}
      />
    </div>
  );
}
