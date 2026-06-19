import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  getSessionTopicScore,
  updateMasteryFromPractice,
} from "@/lib/mastery/masteryEngine";
import {
  misconceptionCodeFromMessage,
  isLikelyMisconception,
} from "@/lib/nex/detectNexMode";

import {
  describeMisconception,
  mergeCommonErrors,
} from "@/lib/nex/misconceptionPersistence";

export function resolveMisconceptionFromMessage(
  message: string,
): { errorCode: string; description: string } | null {
  const errorCode = misconceptionCodeFromMessage(message);
  if (!errorCode) {
    return null;
  }

  return {
    errorCode,
    description: describeMisconception(errorCode),
  };
}

export async function persistStudentMisconception(
  studentId: string,
  errorCode: string,
  description: string,
): Promise<void> {
  const admin = createAdminClient();

  const { data: profile } = await admin
    .from("student_profiles")
    .select("metadata")
    .eq("id", studentId)
    .maybeSingle();

  const metadata =
    profile?.metadata && typeof profile.metadata === "object"
      ? (profile.metadata as Record<string, unknown>)
      : {};

  const existingErrors = Array.isArray(metadata.commonErrors)
    ? metadata.commonErrors.filter((item): item is string => typeof item === "string")
    : [];

  const label = description.trim() || describeMisconception(errorCode);
  const nextErrors = mergeCommonErrors(existingErrors, label);

  await admin
    .from("student_profiles")
    .update({
      metadata: {
        ...metadata,
        commonErrors: nextErrors,
        lastMisconceptionCode: errorCode,
        lastMisconceptionAt: new Date().toISOString(),
      },
    })
    .eq("id", studentId);
}

export async function applyAssessmentMasteryUpdate(
  studentId: string,
  topicId: string | null,
  correctCount: number,
  questionCount: number,
): Promise<void> {
  if (!topicId || questionCount <= 0) {
    return;
  }

  const admin = createAdminClient();
  const sessionScore = getSessionTopicScore(correctCount, questionCount);

  const { data: existing } = await admin
    .from("topic_mastery")
    .select("mastery_percentage")
    .eq("student_id", studentId)
    .eq("topic_id", topicId)
    .maybeSingle();

  const previousMastery = Number(existing?.mastery_percentage ?? 0);
  const nextMastery = updateMasteryFromPractice(previousMastery, sessionScore);

  await admin.from("topic_mastery").upsert(
    {
      student_id: studentId,
      topic_id: topicId,
      mastery_percentage: nextMastery,
      last_practiced_at: new Date().toISOString(),
    },
    { onConflict: "student_id,topic_id" },
  );
}

export function shouldPersistMisconception(
  sessionMode: string,
  message: string,
  misconceptionDetected: boolean,
): boolean {
  if (!misconceptionDetected || !isLikelyMisconception(message)) {
    return false;
  }

  return sessionMode === "homework" || sessionMode === "assessment";
}
