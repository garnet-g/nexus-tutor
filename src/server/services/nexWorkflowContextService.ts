import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type {
  NexWorkflowContext,
  ResolvedNexWorkflowContext,
} from "@/lib/nex/workflowContext";

export type ResolvedWorkflowContextResult =
  | { status: "none" }
  | { status: "resolved"; context: ResolvedNexWorkflowContext }
  | { status: "dropped"; reason: "not_found" | "stale" | "not_owned" }
  | { status: "rejected"; reason: "protected_assessment" };

interface ResolveInput {
  studentId: string;
  context: NexWorkflowContext | null | undefined;
}

async function loadTopic(
  admin: ReturnType<typeof createAdminClient>,
  topicId: string,
): Promise<{ id: string; title: string; subject_id: string } | null> {
  const { data } = await admin
    .from("topics")
    .select("id, title, subject_id")
    .eq("id", topicId)
    .maybeSingle();

  return data as { id: string; title: string; subject_id: string } | null;
}

async function loadPracticeAttemptOwnership(
  admin: ReturnType<typeof createAdminClient>,
  attemptId: string,
): Promise<{
  id: string;
  practice_question_id: string;
  practice_session_id: string;
  student_id: string | null;
} | null> {
  const { data: attempt } = await admin
    .from("practice_attempts")
    .select("id, practice_question_id, practice_session_id")
    .eq("id", attemptId)
    .maybeSingle();

  if (!attempt) {
    return null;
  }

  const { data: session } = await admin
    .from("practice_sessions")
    .select("id, student_id")
    .eq("id", attempt.practice_session_id)
    .maybeSingle();

  return {
    id: attempt.id,
    practice_question_id: attempt.practice_question_id,
    practice_session_id: attempt.practice_session_id,
    student_id: session?.student_id ?? null,
  };
}

async function loadNexSessionOwnership(
  admin: ReturnType<typeof createAdminClient>,
  sessionId: string,
): Promise<{ id: string; student_id: string } | null> {
  const { data } = await admin
    .from("nex_sessions")
    .select("id, student_id")
    .eq("id", sessionId)
    .maybeSingle();

  return data as { id: string; student_id: string } | null;
}

async function loadMockExamSession(
  admin: ReturnType<typeof createAdminClient>,
  sessionId: string,
): Promise<{ id: string; student_id: string; status?: string | null } | null> {
  const { data } = await admin
    .from("mock_exam_sessions")
    .select("id, student_id, status")
    .eq("id", sessionId)
    .maybeSingle();

  return data as {
    id: string;
    student_id: string;
    status?: string | null;
  } | null;
}

function buildAuthoritativeLabel(input: {
  source: NexWorkflowContext["source"];
  topicTitle?: string | null;
  fallback: string;
}): string {
  if (input.topicTitle) {
    if (input.source === "practice") {
      return `${input.topicTitle} · Practice`;
    }
    if (input.source === "lesson") {
      return `${input.topicTitle} · Lesson`;
    }
    return input.topicTitle.slice(0, 120);
  }

  return input.fallback.slice(0, 120);
}

/**
 * Reconstructs workflow context from allowlisted identifiers.
 * Does not trust client labels, answer keys, or cross-student IDs.
 */
export async function resolveNexWorkflowContext(
  input: ResolveInput,
): Promise<ResolvedWorkflowContextResult> {
  if (!input.context) {
    return { status: "none" };
  }

  if (input.context.protectedAssessment) {
    return { status: "rejected", reason: "protected_assessment" };
  }

  const admin = createAdminClient();
  const context = input.context;

  let topicTitle: string | null = null;
  let subjectTitle: string | null = null;
  let resolvedSubjectId = context.subjectId;
  let resolvedTopicId = context.topicId;

  if (context.topicId) {
    const topic = await loadTopic(admin, context.topicId);
    if (!topic) {
      return { status: "dropped", reason: "not_found" };
    }
    topicTitle = topic.title;
    resolvedTopicId = topic.id;
    resolvedSubjectId = topic.subject_id;
  }

  if (context.attemptId) {
    const attempt = await loadPracticeAttemptOwnership(admin, context.attemptId);
    if (!attempt) {
      return { status: "dropped", reason: "not_found" };
    }
    if (attempt.student_id !== input.studentId) {
      return { status: "dropped", reason: "not_owned" };
    }
    if (context.questionId && attempt.practice_question_id !== context.questionId) {
      return { status: "dropped", reason: "stale" };
    }
  }

  if (context.questionId && !context.attemptId) {
    const { data: question } = await admin
      .from("practice_questions")
      .select("id, topic_id")
      .eq("id", context.questionId)
      .maybeSingle();

    if (!question) {
      return { status: "dropped", reason: "not_found" };
    }

    if (context.topicId && question.topic_id !== context.topicId) {
      return { status: "dropped", reason: "stale" };
    }

    if (!resolvedTopicId) {
      resolvedTopicId = question.topic_id;
      const topic = await loadTopic(admin, question.topic_id);
      topicTitle = topic?.title ?? null;
      resolvedSubjectId = topic?.subject_id ?? resolvedSubjectId;
    }
  }

  if (context.sessionId) {
    const nexSession = await loadNexSessionOwnership(admin, context.sessionId);
    if (nexSession) {
      if (nexSession.student_id !== input.studentId) {
        return { status: "dropped", reason: "not_owned" };
      }
    } else {
      const mockSession = await loadMockExamSession(admin, context.sessionId);
      if (mockSession) {
        if (mockSession.student_id !== input.studentId) {
          return { status: "dropped", reason: "not_owned" };
        }
        if (mockSession.status === "in_progress") {
          return { status: "rejected", reason: "protected_assessment" };
        }
      } else {
        return { status: "dropped", reason: "not_found" };
      }
    }
  }

  if (context.lessonId) {
    const { data: lesson } = await admin
      .from("lessons")
      .select("id, topic_id, title")
      .eq("id", context.lessonId)
      .maybeSingle();

    if (!lesson) {
      return { status: "dropped", reason: "not_found" };
    }

    if (context.topicId && lesson.topic_id !== context.topicId) {
      return { status: "dropped", reason: "stale" };
    }

    if (!resolvedTopicId) {
      resolvedTopicId = lesson.topic_id;
      const topic = await loadTopic(admin, lesson.topic_id);
      topicTitle = topic?.title ?? null;
      resolvedSubjectId = topic?.subject_id ?? resolvedSubjectId;
    }
  }

  const resolved: ResolvedNexWorkflowContext = {
    version: 1,
    source: context.source,
    label: buildAuthoritativeLabel({
      source: context.source,
      topicTitle,
      fallback: context.label,
    }),
    ...(resolvedSubjectId ? { subjectId: resolvedSubjectId } : {}),
    ...(resolvedTopicId ? { topicId: resolvedTopicId } : {}),
    ...(context.subtopicId ? { subtopicId: context.subtopicId } : {}),
    ...(context.lessonId ? { lessonId: context.lessonId } : {}),
    ...(context.sessionId ? { sessionId: context.sessionId } : {}),
    ...(context.questionId ? { questionId: context.questionId } : {}),
    ...(context.attemptId ? { attemptId: context.attemptId } : {}),
    ...(context.misconceptionId
      ? { misconceptionId: context.misconceptionId }
      : {}),
    allowedActions: [...context.allowedActions],
    protectedAssessment: false,
    correlationHints: {
      subjectTitle,
      topicTitle,
    },
  };

  return { status: "resolved", context: resolved };
}
