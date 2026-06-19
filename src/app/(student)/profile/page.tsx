import { ProfileForm } from "@/features/profile/components/ProfileForm";
import {
  getFamilyGroupMembers,
  getFamilyInviteCodeForStudent,
} from "@/server/services/familySubscriptionService";
import { getSessionUser } from "@/server/services/authService";
import { getStudentPlanCode } from "@/server/services/subscriptionService";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export default async function ProfilePage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const profile = sessionUser.studentProfile;
  const planCode = await getStudentPlanCode(profile.id);

  let familyInviteCode: string | null = null;
  let familyMembers: Array<{ studentId: string; fullName: string; joinedAt: string }> =
    [];

  if (planCode === "family") {
    try {
      familyInviteCode = await getFamilyInviteCodeForStudent(profile.id, sessionUser.id);
      familyMembers = await getFamilyGroupMembers(profile.id);
    } catch {
      familyInviteCode = null;
    }
  } else {
    familyMembers = await getFamilyGroupMembers(profile.id).catch(() => []);
  }

  return (
    <div className="mx-auto max-w-2xl space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-foreground">Profile</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Manage your account and subscription settings.
        </p>
      </div>

      <ProfileForm
        profile={profile}
        planCode={planCode}
        familyInviteCode={familyInviteCode}
        familyMembers={familyMembers}
      />
    </div>
  );
}
