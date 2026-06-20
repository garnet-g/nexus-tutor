import { redirect } from "next/navigation";

import { NexMark } from "@/components/NexMark";
import { NexChatPanel } from "@/features/nex/components/NexChatPanel";
import type { NexMode } from "@/lib/nex/types";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getNexDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import { parseLearningPreferencesFromDb } from "@/schemas/profileSchemas";
import { getSessionUser } from "@/server/services/authService";
import { studentHasCameraAccess } from "@/schemas/cameraSchemas";
import { studentHasVoiceAccess } from "@/schemas/voiceSchemas";
import {
  getNexDailyUsageCount,
  getSecondsUntilNairobiMidnight,
  getStudentPlanCode,
} from "@/server/services/nexUsageService";

const VALID_MODES: NexMode[] = [
  "explain",
  "practice",
  "homework",
  "revision",
  "assessment",
];

function parseMode(value: string | undefined): NexMode | undefined {
  if (value && VALID_MODES.includes(value as NexMode)) {
    return value as NexMode;
  }
  return undefined;
}

export default async function NexPage({
  searchParams,
}: {
  searchParams: Promise<{ mode?: string; topicId?: string }>;
}) {
  const sessionUser = await getSessionUser();
  const params = await searchParams;

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const profile = sessionUser.studentProfile;

  const [planCode, subscriptionConfig, dailyUsage] = await Promise.all([
    getStudentPlanCode(profile.id),
    getEffectiveSubscriptionConfigWithFallback(),
    getNexDailyUsageCount(profile.id),
  ]);

  const cameraEnabled = studentHasCameraAccess(planCode);
  const voiceEnabled = studentHasVoiceAccess(planCode);
  const initialMode = parseMode(params.mode);
  const topicId = params.topicId ?? null;
  const learningPreferences = parseLearningPreferencesFromDb(
    profile.learning_preferences,
  );
  const dailyLimit = getNexDailyLimit(subscriptionConfig, planCode);

  return (
    <div className="mx-auto w-full max-w-2xl space-y-6">
      <div className="flex items-start gap-3">
        <NexMark size={48} />
        <div className="space-y-1">
          <h1 className="font-heading text-2xl font-medium tracking-tight text-foreground sm:text-3xl">
            Nex
          </h1>
          <p className="text-sm text-muted-foreground sm:text-base">
            Ask for explanations, practice questions, homework help, or a
            revision plan — by text, camera, or push-to-talk voice.
          </p>
        </div>
      </div>
      <NexChatPanel
        className="min-h-[calc(100dvh-14rem)] sm:min-h-[560px]"
        initialMode={initialMode}
        topicId={topicId}
        cameraEnabled={cameraEnabled}
        voiceEnabled={voiceEnabled}
        learningPreferences={learningPreferences}
        dailyUsage={dailyUsage}
        dailyLimit={dailyLimit}
        retryAfterSeconds={getSecondsUntilNairobiMidnight()}
        planCode={planCode}
      />
    </div>
  );
}
