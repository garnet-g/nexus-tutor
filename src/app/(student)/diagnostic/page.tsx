import { DiagnosticFlow } from "@/features/diagnostic/components/DiagnosticFlow";
import { getSessionUser } from "@/server/services/authService";
import { redirect } from "next/navigation";

export default async function DiagnosticPage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/dashboard");
  }

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          Diagnostic assessment
        </h1>
        <p className="text-muted-foreground">
          Answer 20 mathematics questions so Nexus can build your learning path.
        </p>
      </div>
      <DiagnosticFlow />
    </div>
  );
}
