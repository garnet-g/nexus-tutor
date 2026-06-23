import { redirect } from "next/navigation";

import { ContentReviewQueuePanel } from "@/features/admin/studio/components/ContentReviewQueuePanel";
import { getContentReviewQueue } from "@/server/services/contentAdminReadService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

export const dynamic = "force-dynamic";

export default async function StudioReviewPage() {
  const auth = await requireContentAuthor();
  if (!auth.ok) {
    redirect("/login");
  }

  const queue = await getContentReviewQueue();

  return <ContentReviewQueuePanel initialQueue={queue} />;
}
