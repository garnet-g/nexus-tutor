import { redirect } from "next/navigation";

import { NexChatPanel } from "@/features/nex/components/NexChatPanel";
import type { NexMode } from "@/lib/nex/types";
import { studentHasCameraAccess } from "@/schemas/cameraSchemas";
import { parseLearningPreferencesFromDb } from "@/schemas/profileSchemas";
import { studentHasVoiceAccess } from "@/schemas/voiceSchemas";
import { getSessionUser } from "@/server/services/authService";
import { getStudentPlanCode } from "@/server/services/nexUsageService";

const VALID_MODES: NexMode[] = [
  "explain",
  "practice",
  "homework",
  "revision",
  "assessment",
];

function parseMode(value: string | undefined): NexMode {
  if (value && VALID_MODES.includes(value as NexMode)) {
    return value as NexMode;
  }
  return "homework";
}

export default async function AssignmentHelpPage({
  searchParams,
}: {
  searchParams: Promise<{ mode?: string; topicId?: string }>;
}) {
  const sessionUser = await getSessionUser();
  const params = await searchParams;

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const planCode = await getStudentPlanCode(sessionUser.studentProfile.id);
  const cameraEnabled = studentHasCameraAccess(planCode);
  const voiceEnabled = studentHasVoiceAccess(planCode);
  const initialMode = parseMode(params.mode);
  const topicId = params.topicId ?? null;
  const learningPreferences = parseLearningPreferencesFromDb(
    sessionUser.studentProfile.learning_preferences,
  );

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground sm:text-3xl">
          Assignment Help
        </h1>
        <p className="text-sm text-muted-foreground sm:text-base">
          Get step-by-step guidance without revealing the final answer
          immediately. Nex will guide you through the thinking process.
        </p>
      </div>
      <NexChatPanel
        className="min-h-[calc(100dvh-14rem)] sm:min-h-[560px]"
        initialMode={initialMode}
        topicId={topicId}
        cameraEnabled={cameraEnabled}
        voiceEnabled={voiceEnabled}
        learningPreferences={learningPreferences}
      />
    </div>
  );
}
