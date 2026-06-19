import { ParentDashboard } from "@/features/parent-dashboard/components/ParentDashboard";
import { getSessionUser } from "@/server/services/authService";
import { getLinkedStudentsOverview } from "@/server/services/parentLinkService";

export default async function ParentDashboardPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.parentProfile;
  const linkedStudents = profile
    ? await getLinkedStudentsOverview(profile.id)
    : [];

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          Parent dashboard
        </h1>
        <p className="text-muted-foreground">
          Welcome{profile?.full_name ? `, ${profile.full_name.split(" ")[0]}` : ""}.
          View linked student progress and link new accounts.
        </p>
      </div>

      <ParentDashboard linkedStudents={linkedStudents} />
    </div>
  );
}
