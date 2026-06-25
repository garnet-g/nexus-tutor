import { Download } from "lucide-react";

import { OfflinePackButton } from "@/features/student/components/StudentExperienceActions";
import {
  EmptyStudentState,
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function OfflinePacksPage() {
  const experience = await requireStudentExperience();
  const recommendedTitle = experience.recommendedTopic?.title ?? "Practice essentials";

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Tools"
        title="Offline packs"
        description="Prepare lightweight study packs for low-data or unreliable connection windows."
      />

      <section className="rounded-2xl border border-nexus-border bg-nexus-surface p-4">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <p className="font-semibold text-foreground">{recommendedTitle}</p>
            <p className="text-sm text-muted-foreground">
              Includes the next topic, recent mistakes, and saved study notes.
            </p>
          </div>
          <OfflinePackButton
            packKey="recommended-study-pack"
            title={recommendedTitle}
            description="Next topic, saved notes, and recent review work."
            sizeKb={840}
          />
        </div>
      </section>

      <section className="grid gap-4 lg:grid-cols-2">
        {experience.offlinePacks.length > 0 ? (
          experience.offlinePacks.map((pack) => (
            <LinkedPanel
              key={pack.id}
              href="/offline"
              title={pack.title}
              description={pack.description ?? `${Math.round(pack.sizeKb / 1024)} MB pack`}
              eyebrow={pack.status}
              icon={Download}
            />
          ))
        ) : (
          <EmptyStudentState
            title="No packs prepared"
            description="Prepare your recommended pack and it will be tracked here."
          />
        )}
      </section>
    </div>
  );
}
