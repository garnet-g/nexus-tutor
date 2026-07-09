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

const REVIEW_INTERVALS_DAYS = [2, 4, 7, 14];

export function nextReviewIntervalDays(reviewCount: number): number {
  const index = Math.min(reviewCount, REVIEW_INTERVALS_DAYS.length - 1);
  return REVIEW_INTERVALS_DAYS[index];
}

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
  topicId: string | null = null,
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

  const { data: existingReview } = await admin
    .from("nex_misconception_reviews")
    .select("review_count")
    .eq("student_id", studentId)
    .eq("error_code", errorCode)
    .maybeSingle();

  const reviewCount = existingReview?.review_count ?? 0;
  const intervalDays = nextReviewIntervalDays(reviewCount);
  const nextReviewAt = new Date(
    Date.now() + intervalDays * 24 * 60 * 60 * 1000,
  ).toISOString();

  await admin.from("nex_misconception_reviews").upsert(
    {
      student_id: studentId,
      topic_id: topicId,
      error_code: errorCode,
      description: label,
      review_count: reviewCount + 1,
      next_review_at: nextReviewAt,
      last_reviewed_at: new Date().toISOString(),
      resolved_at: null,
    },
    { onConflict: "student_id,error_code" },
  );
}

export async function getDueMisconceptionReviews(
  studentId: string,
): Promise<Array<{ id: string; errorCode: string; description: string; topicId: string | null }>> {
  const admin = createAdminClient();

  const { data } = await admin
    .from("nex_misconception_reviews")
    .select("id, error_code, description, topic_id")
    .eq("student_id", studentId)
    .is("resolved_at", null)
    .lte("next_review_at", new Date().toISOString())
    .order("next_review_at", { ascending: true })
    .limit(5);

  return (data ?? []).map((row) => ({
    id: row.id,
    errorCode: row.error_code,
    description: row.description,
    topicId: row.topic_id,
  }));
}

export async function resolveMisconceptionReview(
  studentId: string,
  reviewId: string,
): Promise<void> {
  const admin = createAdminClient();

  await admin
    .from("nex_misconception_reviews")
    .update({ resolved_at: new Date().toISOString() })
    .eq("id", reviewId)
    .eq("student_id", studentId);
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
