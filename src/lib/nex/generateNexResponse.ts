import {
  buildLearningPreferenceHints,
  type LearningPreferences,
} from "@/schemas/profileSchemas";

import { assemblePrompt } from "./assemblePrompt";
import { callNexModel, streamNexModel } from "./callNexModel";
import { detectNexMode } from "./detectNexMode";
import { loadCurriculumContext } from "./loadCurriculumContext";
import { loadStudentMemory } from "./loadStudentMemory";
import {
  buildSocraticOverlays,
  recordHintDelivered,
  updateSocraticState,
} from "./socraticTutorEngine";
import type {
  GenerateNexResponseInput,
  GenerateNexResponseResult,
  NexMessageTurn,
} from "./types";
import {
  getValidationFallback,
  shouldRegenerate,
  validateNexResponseWithJudge,
} from "./validateNexResponse";

export interface GenerateNexResponseOptions extends GenerateNexResponseInput {
  studentProfile?: Parameters<typeof loadStudentMemory>[0];
  learningPreferences?: LearningPreferences | null;
  onChunk?: (chunk: string) => void | Promise<void>;
}

export async function generateNexResponse(
  input: GenerateNexResponseOptions,
): Promise<GenerateNexResponseResult> {
  const sessionMode = detectNexMode(input.studentMessage, input.sessionMode);

  let metadata = updateSocraticState(
    { ...input.sessionMetadata },
    input.studentMessage,
    sessionMode,
  );

  const [studentMemory, curriculumContext] = await Promise.all([
    input.studentMemory
      ? Promise.resolve(input.studentMemory)
      : input.studentProfile
        ? loadStudentMemory(input.studentProfile, input.topicId)
        : Promise.resolve(null),
    input.curriculumContext
      ? Promise.resolve(input.curriculumContext)
      : loadCurriculumContext(input.topicId),
  ]);

  const overlays = buildSocraticOverlays({
    sessionMode,
    metadata,
    misconceptionDetected: metadata.misconceptionDetected,
    commonErrors: studentMemory?.commonErrors,
  });

  const recentMessages: NexMessageTurn[] = [
    ...input.recentMessages,
    { role: "student" as const, content: input.studentMessage },
  ].slice(-10);

  const learningPreferenceHints = input.learningPreferences
    ? buildLearningPreferenceHints(input.learningPreferences)
    : null;

  const prompt = assemblePrompt({
    mode: sessionMode,
    studentMemory,
    curriculumContext,
    overlays,
    recentMessages,
    regenerateStrict: input.regenerateStrict,
    topic: curriculumContext?.topic,
    difficulty: metadata.difficulty,
    examCountdownDays: metadata.examCountdownDays,
    dailyGoalMinutes:
      input.learningPreferences?.sessionGoalMinutes ?? metadata.dailyGoalMinutes,
    learningPreferenceHints,
  });

  const invokeModel = async (
    systemPrompt: string,
    streamChunks: boolean,
  ) => {
    const modelInput = {
      systemPrompt,
      messages: recentMessages,
    };

    if (streamChunks && input.onChunk) {
      return streamNexModel(modelInput, (chunk) => {
        void input.onChunk?.(chunk);
      });
    }

    return callNexModel(modelInput);
  };

  const firstModel = await invokeModel(prompt.systemPrompt, Boolean(input.onChunk));

  let response = firstModel.content;
  let provider = firstModel.provider;

  let validation = await validateNexResponseWithJudge({
    mode: sessionMode,
    response,
    attemptCount: metadata.attemptCount,
    hintLevel: metadata.hintLevel,
    studentMessage: input.studentMessage,
  });

  if (shouldRegenerate(validation)) {
    const strictPrompt = assemblePrompt({
      mode: sessionMode,
      studentMemory,
      curriculumContext,
      overlays,
      recentMessages,
      regenerateStrict: true,
      topic: curriculumContext?.topic,
      difficulty: metadata.difficulty,
      examCountdownDays: metadata.examCountdownDays,
      dailyGoalMinutes:
        input.learningPreferences?.sessionGoalMinutes ?? metadata.dailyGoalMinutes,
      learningPreferenceHints,
    });

    const retryModel = await callNexModel({
      systemPrompt: strictPrompt.systemPrompt,
      messages: recentMessages,
    });

    response = retryModel.content;
    provider = retryModel.provider;

    validation = await validateNexResponseWithJudge({
      mode: sessionMode,
      response,
      attemptCount: metadata.attemptCount,
      hintLevel: metadata.hintLevel,
      studentMessage: input.studentMessage,
    });
  }

  const validationPassed = validation.status === "pass";

  if (!validationPassed) {
    response = getValidationFallback();
  } else if (sessionMode === "homework") {
    metadata = recordHintDelivered(metadata);
  }

  return {
    response,
    sessionMode,
    metadata,
    provider,
    validationPassed,
  };
}
