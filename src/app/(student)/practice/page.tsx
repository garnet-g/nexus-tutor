import { Suspense } from "react";
import { redirect } from "next/navigation";

import { PracticeTopicPicker } from "@/features/practice/components/PracticeSession";
import { getSessionUser } from "@/server/services/authService";
import { listPracticeTopics } from "@/server/services/practiceService";

export default async function PracticePage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const topics = await listPracticeTopics(sessionUser.studentProfile.curriculum);

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          Practice
        </h1>
        <p className="text-muted-foreground">
          Choose a topic and complete a focused 10-question session.
        </p>
      </div>

      <Suspense
        fallback={
          <div className="rounded-2xl border border-border bg-card p-6 text-muted-foreground">
            Loading practice topics...
          </div>
        }
      >
        <PracticeTopicPicker topics={topics} />
      </Suspense>
    </div>
  );
}
