import "server-only";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import { enforceSameOrigin } from "@/lib/security/originCheck";
import { readJsonWithLimit } from "@/lib/security/bodySizeLimit";
import { generateNexResponse } from "@/lib/nex/generateNexResponse";
import { detectNexMode } from "@/lib/nex/detectNexMode";
import { encodeNexChatSseEvent } from "@/lib/nex/nexChatSse";
import { parseSessionMetadata, updateSocraticState } from "@/lib/nex/socraticTutorEngine";
import { shouldStreamNexResponse } from "@/lib/nex/shouldStreamNexResponse";
import type { NexMode } from "@/lib/nex/types";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getNexDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import { createClient } from "@/lib/supabase/server";
import { nexChatRequestSchema } from "@/schemas/nexSchemas";
import { parseLearningPreferencesFromDb } from "@/schemas/profileSchemas";
import {
  getNexDailyUsageCount,
  getSecondsUntilNairobiMidnight,
  getStudentPlanCode,
  incrementNexDailyUsage,
} from "@/server/services/nexUsageService";
import {
  applyAssessmentMasteryUpdate,
  persistStudentMisconception,
  resolveMisconceptionFromMessage,
  shouldPersistMisconception,
} from "@/server/services/misconceptionService";

/** Per-student burst ceiling above the daily quota (PR-048). */
const NEX_CHAT_BURST_PER_MINUTE = 20;

export async function POST(request: Request) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return originError;
    }

    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "UNAUTHORIZED",
            message: "Missing or invalid session.",
          },
        },
        { status: 401 },
      );
    }

    const { data: studentProfile, error: profileError } = await supabase
      .from("student_profiles")
      .select("*")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !studentProfile) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "FORBIDDEN",
            message: "Student profile required.",
          },
        },
        { status: 403 },
      );
    }

    const burst = await checkRateLimit({
      key: `nex:chat:${studentProfile.id}`,
      windowSeconds: 60,
      max: NEX_CHAT_BURST_PER_MINUTE,
    });

    if (!burst.allowed) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "RATE_LIMITED",
            message: "Too many requests. Please slow down.",
            details: { retryAfterSeconds: burst.retryAfterSeconds },
          },
        },
        { status: 429 },
      );
    }

    const bodyResult = await readJsonWithLimit(request);
    if (!bodyResult.ok) {
      return bodyResult.response;
    }

    const parsed = nexChatRequestSchema.safeParse(bodyResult.body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid request body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const subscriptionConfig = await getEffectiveSubscriptionConfigWithFallback();
    const planCode = await getStudentPlanCode(studentProfile.id);
    const dailyLimit = getNexDailyLimit(subscriptionConfig, planCode);
    const currentUsage = await getNexDailyUsageCount(studentProfile.id);

    if (currentUsage >= dailyLimit) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "RATE_LIMITED",
            message: "Daily Nex message limit reached.",
            details: {
              retryAfterSeconds: getSecondsUntilNairobiMidnight(),
              dailyLimit,
              currentUsage,
            },
          },
        },
        { status: 429 },
      );
    }

    const { studentMessage, nexSessionId, topicId } = parsed.data;
    let sessionMode: NexMode =
      parsed.data.sessionMode ??
      detectNexMode(studentMessage, "homework");

    let sessionId = nexSessionId ?? null;
    let sessionMetadata = parseSessionMetadata(undefined);
    let recentMessages: Array<{ role: "student" | "nex"; content: string }> = [];
    let activeTopicId = topicId ?? null;

    if (sessionId) {
      const { data: existingSession, error: sessionError } = await supabase
        .from("nex_sessions")
        .select("id, session_mode, metadata, topic_id, student_id, is_active")
        .eq("id", sessionId)
        .maybeSingle();

      if (
        sessionError ||
        !existingSession ||
        existingSession.student_id !== studentProfile.id
      ) {
        return NextResponse.json(
          {
            success: false,
            error: {
              code: "NOT_FOUND",
              message: "Nex session not found.",
            },
          },
          { status: 404 },
        );
      }

      sessionMode = detectNexMode(
        studentMessage,
        (parsed.data.sessionMode ??
          existingSession.session_mode) as NexMode,
      );
      sessionMetadata = parseSessionMetadata(
        existingSession.metadata as Record<string, unknown>,
      );
      activeTopicId = existingSession.topic_id ?? activeTopicId;

      const { data: messages } = await supabase
        .from("nex_messages")
        .select("role, message_content")
        .eq("nex_session_id", sessionId)
        .order("created_at", { ascending: true })
        .limit(10);

      recentMessages =
        messages?.map((message) => ({
          role: message.role as "student" | "nex",
          content: message.message_content,
        })) ?? [];
    } else {
      const { data: createdSession, error: createSessionError } = await supabase
        .from("nex_sessions")
        .insert({
          student_id: studentProfile.id,
          session_mode: sessionMode,
          topic_id: activeTopicId,
          metadata: sessionMetadata,
          is_active: true,
        })
        .select("id")
        .single();

      if (createSessionError || !createdSession) {
        return NextResponse.json(
          {
            success: false,
            error: {
              code: "INTERNAL_ERROR",
              message: "Could not create Nex session.",
            },
          },
          { status: 500 },
        );
      }

      sessionId = createdSession.id;
    }

    const { error: studentMessageError } = await supabase
      .from("nex_messages")
      .insert({
        nex_session_id: sessionId,
        student_id: studentProfile.id,
        role: "student",
        message_content: studentMessage,
        metadata: {},
      });

    if (studentMessageError) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "INTERNAL_ERROR",
            message: "Could not save student message.",
          },
        },
        { status: 500 },
      );
    }

    const previousAssessmentStatus = sessionMetadata.assessmentStatus;

    const learningPreferences = parseLearningPreferencesFromDb(
      studentProfile.learning_preferences,
    );

    const metadataForRequest = updateSocraticState(
      { ...sessionMetadata },
      studentMessage,
      sessionMode,
    );

    const useStreaming = shouldStreamNexResponse(
      sessionMode,
      metadataForRequest.attemptCount,
    );

    const generationInput = {
      studentId: studentProfile.id,
      studentMessage,
      sessionMode,
      sessionMetadata,
      topicId: activeTopicId,
      recentMessages,
      studentProfile,
      learningPreferences,
    };

    if (useStreaming) {
      const stream = new ReadableStream<Uint8Array>({
        start(controller) {
          const encoder = new TextEncoder();
          const enqueue = (event: string, data: unknown) => {
            controller.enqueue(encoder.encode(encodeNexChatSseEvent(event, data)));
          };

          void (async () => {
            let streamedText = "";

            try {
              const nexResult = await generateNexResponse({
                ...generationInput,
                onChunk: (chunk) => {
                  streamedText += chunk;
                  enqueue("chunk", { text: chunk });
                },
              });

              if (nexResult.response !== streamedText) {
                enqueue("replace", { text: nexResult.response });
              }

              if (
                shouldPersistMisconception(
                  nexResult.sessionMode,
                  studentMessage,
                  nexResult.metadata.misconceptionDetected,
                )
              ) {
                const misconception = resolveMisconceptionFromMessage(studentMessage);
                if (misconception) {
                  await persistStudentMisconception(
                    studentProfile.id,
                    misconception.errorCode,
                    misconception.description,
                  ).catch(() => undefined);
                }
              }

              if (
                nexResult.sessionMode === "assessment" &&
                nexResult.metadata.assessmentStatus === "completed" &&
                previousAssessmentStatus !== "completed"
              ) {
                await applyAssessmentMasteryUpdate(
                  studentProfile.id,
                  activeTopicId,
                  nexResult.metadata.correctCount ?? 0,
                  nexResult.metadata.assessmentQuestionCount ?? 3,
                ).catch(() => undefined);
              }

              const { data: nexMessage, error: nexMessageError } = await supabase
                .from("nex_messages")
                .insert({
                  nex_session_id: sessionId,
                  student_id: studentProfile.id,
                  role: "nex",
                  message_content: nexResult.response,
                  metadata: {
                    provider: nexResult.provider,
                    validationPassed: nexResult.validationPassed,
                  },
                })
                .select("id")
                .single();

              if (nexMessageError || !nexMessage) {
                enqueue("error", {
                  message: "Could not save Nex response.",
                  partial: nexResult.response,
                });
                controller.close();
                return;
              }

              await supabase
                .from("nex_sessions")
                .update({
                  session_mode: nexResult.sessionMode,
                  metadata: nexResult.metadata,
                  topic_id: activeTopicId,
                  is_active: true,
                })
                .eq("id", sessionId);

              await incrementNexDailyUsage(studentProfile.id, dailyLimit);

              enqueue("done", {
                nexSessionId: sessionId,
                nexMessageId: nexMessage.id,
                nexResponse: nexResult.response,
                sessionMode: nexResult.sessionMode,
                provider: nexResult.provider,
                validationPassed: nexResult.validationPassed,
              });
            } catch (error) {
              console.error("NEX_STREAM_FAILED", error);
              enqueue("error", {
                message: "Nex could not generate a response.",
                partial: streamedText || undefined,
              });
            } finally {
              controller.close();
            }
          })();
        },
      });

      return new Response(stream, {
        headers: {
          "Content-Type": "text/event-stream; charset=utf-8",
          "Cache-Control": "no-cache, no-transform",
          Connection: "keep-alive",
        },
      });
    }

    const nexResult = await generateNexResponse(generationInput);

    if (
      shouldPersistMisconception(
        nexResult.sessionMode,
        studentMessage,
        nexResult.metadata.misconceptionDetected,
      )
    ) {
      const misconception = resolveMisconceptionFromMessage(studentMessage);
      if (misconception) {
        await persistStudentMisconception(
          studentProfile.id,
          misconception.errorCode,
          misconception.description,
        ).catch(() => undefined);
      }
    }

    if (
      nexResult.sessionMode === "assessment" &&
      nexResult.metadata.assessmentStatus === "completed" &&
      previousAssessmentStatus !== "completed"
    ) {
      await applyAssessmentMasteryUpdate(
        studentProfile.id,
        activeTopicId,
        nexResult.metadata.correctCount ?? 0,
        nexResult.metadata.assessmentQuestionCount ?? 3,
      ).catch(() => undefined);
    }

    const { data: nexMessage, error: nexMessageError } = await supabase
      .from("nex_messages")
      .insert({
        nex_session_id: sessionId,
        student_id: studentProfile.id,
        role: "nex",
        message_content: nexResult.response,
        metadata: {
          provider: nexResult.provider,
          validationPassed: nexResult.validationPassed,
        },
      })
      .select("id")
      .single();

    if (nexMessageError || !nexMessage) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "NEX_RESPONSE_FAILED",
            message: "Could not save Nex response.",
          },
        },
        { status: 502 },
      );
    }

    await supabase
      .from("nex_sessions")
      .update({
        session_mode: nexResult.sessionMode,
        metadata: nexResult.metadata,
        topic_id: activeTopicId,
        is_active: true,
      })
      .eq("id", sessionId);

    await incrementNexDailyUsage(studentProfile.id, dailyLimit);

    return NextResponse.json({
      success: true,
      data: {
        nexSessionId: sessionId,
        nexMessageId: nexMessage.id,
        nexResponse: nexResult.response,
        sessionMode: nexResult.sessionMode,
        provider: nexResult.provider,
      },
    });
  } catch (error) {
    console.error("NEX_RESPONSE_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "NEX_RESPONSE_FAILED",
          message: "Nex could not generate a response.",
        },
      },
      { status: 502 },
    );
  }
}
