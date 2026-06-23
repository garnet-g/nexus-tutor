import "server-only";

import { callNexModel } from "@/lib/nex/callNexModel";
import { createAdminClient } from "@/lib/supabase/admin";
import type { LessonContentBlock } from "@/types/curriculum";
import {
  assistBlocksResponseSchema,
  assistDraftLessonResponseSchema,
  assistQuestionsResponseSchema,
  assistRewriteResponseSchema,
  type ContentAssistRequest,
} from "@/schemas/contentAssistSchemas";
import {
  getSubtopicAuthoringContext,
  produceLessonFromModel,
  produceQuestionsFromModel,
} from "@/server/services/contentGenerationService";

function extractJsonFromModelOutput(raw: string): unknown {
  const trimmed = raw.trim();
  const fenceMatch = trimmed.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const jsonText = fenceMatch ? fenceMatch[1].trim() : trimmed;
  return JSON.parse(jsonText);
}

async function callModelWithRetry<T>(input: {
  systemPrompt: string;
  userPrompt: string;
  parse: (value: unknown) => T;
}): Promise<{ data: T; model: string }> {
  let lastError: unknown;

  for (let attempt = 0; attempt < 2; attempt += 1) {
    const retrySuffix =
      attempt === 1
        ? "\n\nYour previous output was invalid JSON. Return ONLY valid JSON matching the schema."
        : "";

    const result = await callNexModel({
      systemPrompt: input.systemPrompt,
      messages: [{ role: "student", content: input.userPrompt + retrySuffix }],
      maxTokens: 4000,
      allowOpenAIFallback: false,
    });

    try {
      const parsed = extractJsonFromModelOutput(result.content);
      return { data: input.parse(parsed), model: result.provider };
    } catch (error) {
      lastError = error;
    }
  }

  throw new Error(
    lastError instanceof Error
      ? `GENERATION_INVALID_OUTPUT: ${lastError.message}`
      : "GENERATION_INVALID_OUTPUT",
  );
}

async function recordAssistJob(input: {
  adminId: string;
  scopeType: "subtopic" | "topic";
  scopeId: string;
  curriculumCode: string;
  action: string;
  status: "completed" | "failed";
  model: string | null;
  error: string | null;
}): Promise<void> {
  const admin = createAdminClient();

  await admin.from("content_generation_jobs").insert({
    admin_id: input.adminId,
    scope_type: input.scopeType,
    scope_id: input.scopeId,
    curriculum_code: input.curriculumCode,
    status: input.status,
    lessons_created: 0,
    questions_created: 0,
    model: input.model,
    error: input.error ? `${input.action}: ${input.error}` : input.action,
  });
}

function blockContextSnippet(blocks: LessonContentBlock[], blockId: string): {
  focusBlock: LessonContentBlock;
  neighbors: LessonContentBlock[];
} {
  const index = blocks.findIndex((block) => block.id === blockId);
  if (index < 0) {
    throw new Error("NOT_FOUND");
  }

  return {
    focusBlock: blocks[index],
    neighbors: blocks.slice(Math.max(0, index - 1), index + 2),
  };
}

export async function runContentAssist(
  input: ContentAssistRequest & { adminId: string },
): Promise<{ model: string; result: unknown }> {
  const scopeType = input.action === "generate_questions" ? "topic" : "subtopic";
  const scopeId =
    input.action === "generate_questions" ? input.topicId : input.subtopicId;
  const curriculumCode = input.curriculum;

  try {
    if (input.action === "draft_lesson") {
      const { lesson, model } = await produceLessonFromModel({
        subtopicId: input.subtopicId,
        curriculum: input.curriculum,
        gradeLevel: input.gradeLevel,
      });
      const validated = assistDraftLessonResponseSchema.parse(lesson);

      await recordAssistJob({
        adminId: input.adminId,
        scopeType,
        scopeId,
        curriculumCode,
        action: input.action,
        status: "completed",
        model,
        error: null,
      });

      return { model, result: validated };
    }

    if (input.action === "generate_questions") {
      const { questions, model } = await produceQuestionsFromModel({
        topicId: input.topicId,
        subtopicId: input.subtopicId,
        curriculum: input.curriculum,
        gradeLevel: input.gradeLevel,
        difficulty: input.difficulty,
        count: input.count,
      });
      const validated = assistQuestionsResponseSchema.parse({ questions });

      await recordAssistJob({
        adminId: input.adminId,
        scopeType,
        scopeId,
        curriculumCode,
        action: input.action,
        status: "completed",
        model,
        error: null,
      });

      return { model, result: validated };
    }

    const context = await getSubtopicAuthoringContext(input.subtopicId, input.curriculum);

    if (input.action === "expand_section") {
      const { focusBlock, neighbors } = blockContextSnippet(input.blocks, input.blockId);
      const { data, model } = await callModelWithRetry({
        systemPrompt: [
          `You expand lesson sections for Kenyan ${context.curriculumCode} ${context.subjectName}.`,
          "Return JSON ONLY: { \"blocks\": [ ... ] } with 1-4 NEW blocks that deepen the focused section.",
          "Do not repeat the input blocks verbatim. Use the extended block types already in the lesson.",
          "Do not wrap JSON in markdown fences.",
        ].join("\n"),
        userPrompt: [
          `Subtopic: ${context.subtopicTitle}`,
          `Topic: ${context.topicTitle}`,
          `Grade: ${input.gradeLevel}`,
          `Focused block: ${JSON.stringify(focusBlock)}`,
          `Nearby blocks: ${JSON.stringify(neighbors)}`,
        ].join("\n"),
        parse: (value) => assistBlocksResponseSchema.parse(value),
      });

      await recordAssistJob({
        adminId: input.adminId,
        scopeType,
        scopeId,
        curriculumCode,
        action: input.action,
        status: "completed",
        model,
        error: null,
      });

      return { model, result: data };
    }

    if (input.action === "simplify") {
      const { data, model } = await callModelWithRetry({
        systemPrompt: [
          `You simplify lessons for Kenyan ${context.curriculumCode} ${context.subjectName}.`,
          `Rewrite the lesson for ${input.targetGradeLevel} using simpler vocabulary while preserving accuracy.`,
          "Return JSON ONLY: { \"blocks\": [ ... ] } with the full simplified lesson blocks.",
          "Do not wrap JSON in markdown fences.",
        ].join("\n"),
        userPrompt: JSON.stringify({ blocks: input.blocks }),
        parse: (value) => assistBlocksResponseSchema.parse(value),
      });

      await recordAssistJob({
        adminId: input.adminId,
        scopeType,
        scopeId,
        curriculumCode,
        action: input.action,
        status: "completed",
        model,
        error: null,
      });

      return { model, result: data };
    }

    const instruction = input.instruction?.trim() || "Improve clarity for students.";
    const { data, model } = await callModelWithRetry({
      systemPrompt: [
        `You rewrite a single lesson block for Kenyan ${context.curriculumCode} ${context.subjectName}.`,
        "Return JSON ONLY: { \"block\": { ... } } keeping the same block type unless a type change is essential.",
        "Do not wrap JSON in markdown fences.",
      ].join("\n"),
      userPrompt: [
        `Grade: ${input.gradeLevel}`,
        `Instruction: ${instruction}`,
        `Block: ${JSON.stringify(input.block)}`,
      ].join("\n"),
      parse: (value) => assistRewriteResponseSchema.parse(value),
    });

    await recordAssistJob({
      adminId: input.adminId,
      scopeType,
      scopeId,
      curriculumCode,
      action: input.action,
      status: "completed",
      model,
      error: null,
    });

    return { model, result: data };
  } catch (error) {
    await recordAssistJob({
      adminId: input.adminId,
      scopeType,
      scopeId,
      curriculumCode,
      action: input.action,
      status: "failed",
      model: null,
      error: error instanceof Error ? error.message : "Unknown error",
    });
    throw error;
  }
}
