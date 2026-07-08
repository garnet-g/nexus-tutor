import { redirect } from "next/navigation";

import { PracticePapersLanding } from "@/features/practice-papers/components/PracticePapersLanding";
import { getSessionUser } from "@/server/services/authService";
import { listPastPapers } from "@/server/services/pastPaperService";

export default async function PracticePapersPage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const profile = sessionUser.studentProfile;
  const papers = await listPastPapers(profile.curriculum);

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          Practice Papers
        </h1>
        <p className="text-muted-foreground">
          Practice full CBC/KCSE-style exam papers under timed conditions, then
          get step-by-step AI marking on your working.
        </p>
      </div>

      <PracticePapersLanding papers={papers} />
    </div>
  );
}
