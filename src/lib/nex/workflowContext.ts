export const NEX_WORKFLOW_SOURCES = [
  "global",
  "lesson",
  "practice",
  "revision",
  "exam_review",
  "results",
] as const;

export type NexWorkflowSource = (typeof NEX_WORKFLOW_SOURCES)[number];

export const NEX_WORKFLOW_ACTIONS = [
  "explain",
  "simplify",
  "hint",
  "review",
  "similar_question",
] as const;

export type NexWorkflowAction = (typeof NEX_WORKFLOW_ACTIONS)[number];

export interface NexWorkflowContext {
  version: 1;
  source: NexWorkflowSource;
  label: string;
  subjectId?: string;
  topicId?: string;
  subtopicId?: string;
  lessonId?: string;
  sessionId?: string;
  questionId?: string;
  attemptId?: string;
  misconceptionId?: string;
  allowedActions: NexWorkflowAction[];
  protectedAssessment: boolean;
}

export type ResolvedNexWorkflowContext = NexWorkflowContext & {
  correlationHints?: {
    subjectTitle?: string | null;
    topicTitle?: string | null;
  };
};

/** Client-safe builder for optional workflow context payloads. */
export function buildNexWorkflowContext(
  input: NexWorkflowContext,
): NexWorkflowContext {
  return {
    version: 1,
    source: input.source,
    label: input.label.slice(0, 120),
    ...(input.subjectId ? { subjectId: input.subjectId } : {}),
    ...(input.topicId ? { topicId: input.topicId } : {}),
    ...(input.subtopicId ? { subtopicId: input.subtopicId } : {}),
    ...(input.lessonId ? { lessonId: input.lessonId } : {}),
    ...(input.sessionId ? { sessionId: input.sessionId } : {}),
    ...(input.questionId ? { questionId: input.questionId } : {}),
    ...(input.attemptId ? { attemptId: input.attemptId } : {}),
    ...(input.misconceptionId ? { misconceptionId: input.misconceptionId } : {}),
    allowedActions: [...input.allowedActions],
    protectedAssessment: input.protectedAssessment,
  };
}
