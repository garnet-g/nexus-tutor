import { z } from "zod";

import {
  NEX_WORKFLOW_ACTIONS,
  NEX_WORKFLOW_SOURCES,
} from "@/lib/nex/workflowContext";

const optionalUuid = z.string().uuid().optional();

export const nexWorkflowContextSchema = z
  .object({
    version: z.literal(1),
    source: z.enum(NEX_WORKFLOW_SOURCES),
    label: z.string().min(1).max(120),
    subjectId: optionalUuid,
    topicId: optionalUuid,
    subtopicId: optionalUuid,
    lessonId: optionalUuid,
    sessionId: optionalUuid,
    questionId: optionalUuid,
    attemptId: optionalUuid,
    misconceptionId: optionalUuid,
    allowedActions: z.array(z.enum(NEX_WORKFLOW_ACTIONS)).max(10),
    protectedAssessment: z.boolean(),
  })
  .strict();

export type NexWorkflowContextInput = z.infer<typeof nexWorkflowContextSchema>;
