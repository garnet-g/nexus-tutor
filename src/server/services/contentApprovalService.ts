import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { contentReviewActionSchema, type ContentReviewServiceInput } from "@/schemas/contentApprovalSchemas";
import { runContentQualityGates, runTopicProdReadyPublishGate, resolveTopicIdForContent } from "@/server/services/contentQualityGates";
import type { LessonContent } from "@/types/curriculum";

export type ReviewStatus = "draft" | "in_review" | "published" | "archived";

export type ContentReviewResult = {
  id: string;
  kind: "lesson" | "question";
  reviewStatus: ReviewStatus;
  isActive: boolean;
  gateErrors?: string[];
  autoPublished?: boolean;
};

export type LessonVersionSummary = {
  id: string;
  versionNumber: number;
  title: string;
  estimatedMinutes: number;
  publishedBy: string | null;
  createdAt: string;
};

async function loadPlatformSettingsMap(): Promise<Record<string, unknown>> {
  const admin = createAdminClient();
  const { data } = await admin.from("platform_settings").select("setting_key, setting_value");

  return (data ?? []).reduce<Record<string, unknown>>((acc, row) => {
    acc[row.setting_key] = row.setting_value;
    return acc;
  }, {});
}

export async function isContentAutoApproveEnabled(): Promise<boolean> {
  const settings = await loadPlatformSettingsMap();
  const value = settings.content_auto_approve_enabled;
  return typeof value === "boolean" ? value : false;
}

function contentTable(kind: "lesson" | "question"): "lessons" | "practice_questions" {
  return kind === "lesson" ? "lessons" : "practice_questions";
}

type ContentRow = {
  id: string;
  review_status: ReviewStatus;
  is_active: boolean;
  author_id: string | null;
  author_auto_approve_trusted: boolean;
  title?: string;
  content?: LessonContent;
  estimated_minutes?: number;
};

async function loadContentRow(kind: "lesson" | "question", id: string): Promise<ContentRow> {
  const admin = createAdminClient();

  if (kind === "lesson") {
    const { data, error } = await admin
      .from("lessons")
      .select(
        "id, review_status, is_active, author_id, author_auto_approve_trusted, title, content, estimated_minutes",
      )
      .eq("id", id)
      .maybeSingle();

    if (error || !data) {
      throw new Error("NOT_FOUND");
    }

    return {
      id: data.id,
      review_status: data.review_status as ReviewStatus,
      is_active: data.is_active,
      author_id: data.author_id,
      author_auto_approve_trusted: data.author_auto_approve_trusted,
      title: data.title,
      content: data.content as LessonContent,
      estimated_minutes: data.estimated_minutes,
    };
  }

  const { data, error } = await admin
    .from("practice_questions")
    .select("id, review_status, is_active, author_id, author_auto_approve_trusted")
    .eq("id", id)
    .maybeSingle();

  if (error || !data) {
    throw new Error("NOT_FOUND");
  }

  return {
    id: data.id,
    review_status: data.review_status as ReviewStatus,
    is_active: data.is_active,
    author_id: data.author_id,
    author_auto_approve_trusted: data.author_auto_approve_trusted,
  };
}

async function snapshotLessonVersion(input: {
  lessonId: string;
  title: string;
  content: LessonContent;
  estimatedMinutes: number;
  publishedBy: string;
}): Promise<void> {
  const admin = createAdminClient();

  const { data: latest } = await admin
    .from("lesson_versions")
    .select("version_number")
    .eq("lesson_id", input.lessonId)
    .order("version_number", { ascending: false })
    .limit(1)
    .maybeSingle();

  const nextVersion = (latest?.version_number ?? 0) + 1;

  const { error } = await admin.from("lesson_versions").insert({
    lesson_id: input.lessonId,
    version_number: nextVersion,
    title: input.title,
    content: input.content,
    estimated_minutes: input.estimatedMinutes,
    published_by: input.publishedBy,
  });

  if (error) {
    throw new Error(error.message);
  }
}

async function publishContent(input: {
  kind: "lesson" | "question";
  id: string;
  adminId: string;
}): Promise<ContentReviewResult> {
  const admin = createAdminClient();
  const table = contentTable(input.kind);
  const row = await loadContentRow(input.kind, input.id);

  if (row.review_status !== "in_review" && row.review_status !== "draft") {
    throw new Error("CONFLICT");
  }

  const gates = await runContentQualityGates({ kind: input.kind, id: input.id });
  if (!gates.passed) {
    const error = new Error("GATE_FAILED");
    (error as Error & { gateErrors: string[] }).gateErrors = gates.errors;
    throw error;
  }

  const topicId = await resolveTopicIdForContent({ kind: input.kind, id: input.id });
  const prodGate = await runTopicProdReadyPublishGate(topicId);
  if (!prodGate.passed) {
    const error = new Error("GATE_FAILED");
    (error as Error & { gateErrors: string[] }).gateErrors = prodGate.errors;
    throw error;
  }

  if (input.kind === "lesson") {
    if (!row.title || row.content == null || row.estimated_minutes == null) {
      throw new Error("NOT_FOUND");
    }

    await snapshotLessonVersion({
      lessonId: input.id,
      title: row.title,
      content: row.content,
      estimatedMinutes: row.estimated_minutes,
      publishedBy: input.adminId,
    });
  }

  const { error: updateError } = await admin
    .from(table)
    .update({
      review_status: "published",
      is_active: true,
      published_by: input.adminId,
      review_notes: null,
      ...(input.kind === "lesson" ? { updated_at: new Date().toISOString() } : {}),
    })
    .eq("id", input.id);

  if (updateError) {
    throw new Error(updateError.message);
  }

  return {
    id: input.id,
    kind: input.kind,
    reviewStatus: "published",
    isActive: true,
  };
}

export async function submitForReview(input: ContentReviewServiceInput): Promise<ContentReviewResult> {
  const parsed = contentReviewActionSchema.parse(input);
  const admin = createAdminClient();
  const table = contentTable(parsed.kind);
  const row = await loadContentRow(parsed.kind, parsed.id);

  if (row.review_status !== "draft") {
    throw new Error("CONFLICT");
  }

  const gates = await runContentQualityGates({ kind: parsed.kind, id: parsed.id });
  if (!gates.passed) {
    const error = new Error("GATE_FAILED");
    (error as Error & { gateErrors: string[] }).gateErrors = gates.errors;
    throw error;
  }

  const autoApproveEnabled = await isContentAutoApproveEnabled();
  const trusted = Boolean(row.author_auto_approve_trusted);

  if (autoApproveEnabled && trusted) {
    const published = await publishContent({
      kind: parsed.kind,
      id: parsed.id,
      adminId: input.adminId,
    });
    return { ...published, autoPublished: true };
  }

  const { error } = await admin
    .from(table)
    .update({
      review_status: "in_review",
      submitted_for_review_at: new Date().toISOString(),
      author_id: row.author_id ?? input.adminId,
    })
    .eq("id", parsed.id);

  if (error) {
    throw new Error(error.message);
  }

  return {
    id: parsed.id,
    kind: parsed.kind,
    reviewStatus: "in_review",
    isActive: false,
    autoPublished: false,
  };
}

export async function approveAndPublish(input: ContentReviewServiceInput): Promise<ContentReviewResult> {
  const parsed = contentReviewActionSchema.parse(input);
  const row = await loadContentRow(parsed.kind, parsed.id);

  if (row.review_status !== "in_review") {
    throw new Error("CONFLICT");
  }

  return publishContent({
    kind: parsed.kind,
    id: parsed.id,
    adminId: input.adminId,
  });
}

export async function requestChanges(input: ContentReviewServiceInput): Promise<ContentReviewResult> {
  const parsed = contentReviewActionSchema.parse(input);
  const admin = createAdminClient();
  const table = contentTable(parsed.kind);
  const row = await loadContentRow(parsed.kind, parsed.id);

  if (row.review_status !== "in_review") {
    throw new Error("CONFLICT");
  }

  const { error } = await admin
    .from(table)
    .update({
      review_status: "draft",
      review_notes: parsed.notes?.trim() || null,
      submitted_for_review_at: null,
      ...(parsed.kind === "lesson" ? { updated_at: new Date().toISOString() } : {}),
    })
    .eq("id", parsed.id);

  if (error) {
    throw new Error(error.message);
  }

  return {
    id: parsed.id,
    kind: parsed.kind,
    reviewStatus: "draft",
    isActive: false,
  };
}

export async function archiveReviewContent(input: ContentReviewServiceInput): Promise<ContentReviewResult> {
  const parsed = contentReviewActionSchema.parse(input);
  const admin = createAdminClient();
  const table = contentTable(parsed.kind);
  const row = await loadContentRow(parsed.kind, parsed.id);

  if (row.review_status !== "draft" && row.review_status !== "in_review") {
    throw new Error("CONFLICT");
  }

  const { error } = await admin
    .from(table)
    .update({
      review_status: "archived",
      is_active: false,
      submitted_for_review_at: null,
      ...(parsed.kind === "lesson" ? { updated_at: new Date().toISOString() } : {}),
    })
    .eq("id", parsed.id);

  if (error) {
    throw new Error(error.message);
  }

  return {
    id: parsed.id,
    kind: parsed.kind,
    reviewStatus: "archived",
    isActive: false,
  };
}

export async function listLessonVersions(lessonId: string): Promise<LessonVersionSummary[]> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("lesson_versions")
    .select("id, version_number, title, estimated_minutes, published_by, created_at")
    .eq("lesson_id", lessonId)
    .order("version_number", { ascending: false });

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []).map((row) => ({
    id: row.id,
    versionNumber: row.version_number,
    title: row.title,
    estimatedMinutes: row.estimated_minutes,
    publishedBy: row.published_by,
    createdAt: row.created_at,
  }));
}

export async function restoreLessonVersion(input: {
  lessonId: string;
  versionId: string;
  adminId: string;
}): Promise<{ id: string; title: string; estimatedMinutes: number; content: LessonContent }> {
  const admin = createAdminClient();

  const { data: lesson } = await admin
    .from("lessons")
    .select("id, review_status")
    .eq("id", input.lessonId)
    .maybeSingle();

  if (!lesson) {
    throw new Error("NOT_FOUND");
  }

  if (lesson.review_status !== "draft") {
    throw new Error("CONFLICT");
  }

  const { data: version } = await admin
    .from("lesson_versions")
    .select("id, lesson_id, title, content, estimated_minutes")
    .eq("id", input.versionId)
    .eq("lesson_id", input.lessonId)
    .maybeSingle();

  if (!version) {
    throw new Error("NOT_FOUND");
  }

  const { error } = await admin
    .from("lessons")
    .update({
      title: version.title,
      content: version.content,
      estimated_minutes: version.estimated_minutes,
      updated_at: new Date().toISOString(),
    })
    .eq("id", input.lessonId);

  if (error) {
    throw new Error(error.message);
  }

  return {
    id: input.lessonId,
    title: version.title,
    estimatedMinutes: version.estimated_minutes,
    content: version.content as LessonContent,
  };
}
