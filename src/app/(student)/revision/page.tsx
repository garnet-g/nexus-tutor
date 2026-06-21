import { redirect } from "next/navigation";

import { KcseMathRevisionHub } from "@/features/revision/components/KcseMathRevisionHub";
import { getSessionUser } from "@/server/services/authService";
import { getKcseMathRevisionHub } from "@/server/services/kcseMathRevisionService";

export default async function RevisionPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  if (!profile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const model = await getKcseMathRevisionHub(profile);

  return <KcseMathRevisionHub model={model} />;
}
