import "server-only";

import { NextResponse } from "next/server";

import { detectNexMode } from "@/lib/nex/detectNexMode";
import { generateNexResponse } from "@/lib/nex/generateNexResponse";
import { parseSessionMetadata } from "@/lib/nex/socraticTutorEngine";
import type { NexMode } from "@/lib/nex/types";
import { transcribeVoiceAudio } from "@/lib/nex/voiceTranscribe";
import { synthesizeVoiceResponse } from "@/lib/nex/voiceSynthesize";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getNexDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import { createClient } from "@/lib/supabase/server";
import {
  applyAssessmentMasteryUpdate,
  persistStudentMisconception,
  resolveMisconceptionFromMessage,
  shouldPersistMisconception,
} from "@/server/services/misconceptionService";
import {
  getNexDailyUsageCount,
  getSecondsUntilNairobiMidnight,
  getStudentPlanCode,
  incrementNexDailyUsage,
} from "@/server/services/nexUsageService";
import {
  isVoiceMimeType,
  studentHasVoiceAccess,
  VOICE_MAX_BYTES,
  VOICE_MAX_DURATION_SECONDS,
  voiceUploadFieldsSchema,
} from "@/schemas/voiceSchemas";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "UNAUTHORIZED", message: "Missing or invalid session." },
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
          error: { code: "FORBIDDEN", message: "Student profile required." },
        },
        { status: 403 },
      );
    }

    const planCode = await getStudentPlanCode(studentProfile.id);
    if (!studentHasVoiceAccess(planCode)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "PREMIUM_REQUIRED",
            message: "Voice tutoring is available on Premium and Family plans.",
            details: { upgradeUrl: "/pricing" },
          },
        },
        { status: 403 },
      );
    }

    const subscriptionConfig = await getEffectiveSubscriptionConfigWithFallback();
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

    const formData = await request.formData();
    const audioEntry = formData.get("audio");

    if (!(audioEntry instanceof File)) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "VALIDATION_ERROR", message: "Audio file is required." },
        },
        { status: 400 },
      );
    }

    if (audioEntry.size > VOICE_MAX_BYTES) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Audio must be 2MB or smaller.",
          },
        },
        { status: 400 },
      );
    }

    const mimeType = audioEntry.type || "audio/webm";
    if (!isVoiceMimeType(mimeType)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Only WebM/Opus, OGG, or MP4 audio is supported.",
          },
        },
        { status: 400 },
      );
    }

    const fieldsParsed = voiceUploadFieldsSchema.safeParse({
      sessionMode: formData.get("sessionMode") || undefined,
      nexSessionId: formData.get("nexSessionId") || undefined,
      topicId: formData.get("topicId") || undefined,
      durationSeconds: formData.get("durationSeconds") || undefined,
    });

    if (!fieldsParsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid voice metadata.",
            details: fieldsParsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    if (
      fieldsParsed.data.durationSeconds !== undefined &&
      fieldsParsed.data.durationSeconds > VOICE_MAX_DURATION_SECONDS
    ) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Voice clips must be 30 seconds or shorter.",
          },
        },
        { status: 400 },
      );
    }

    const audioBytes = new Uint8Array(await audioEntry.arrayBuffer());
    const transcription = await transcribeVoiceAudio({
      audioBytes,
      mimeType,
    });

    const transcript = transcription.transcript.trim();
    if (!transcript) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "TRANSCRIPTION_FAILED",
            message: "Nex could not understand that audio. Try again closer to the microphone.",
          },
        },
        { status: 422 },
      );
    }

    const { sessionMode: requestedMode, nexSessionId, topicId } = fieldsParsed.data;
    let sessionId = nexSessionId ?? null;
    let sessionMetadata = parseSessionMetadata(undefined);
    let recentMessages: Array<{ role: "student" | "nex"; content: string }> = [];
    let activeTopicId = topicId ?? null;
    let resolvedMode: NexMode =
      requestedMode ?? detectNexMode(transcript, "homework");

    if (sessionId) {
      const { data: existingSession, error: sessionError } = await supabase
        .from("nex_sessions")
        .select("id, session_mode, metadata, topic_id, student_id")
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
            error: { code: "NOT_FOUND", message: "Nex session not found." },
          },
          { status: 404 },
        );
      }

      resolvedMode = detectNexMode(
        transcript,
        (requestedMode ?? existingSession.session_mode) as NexMode,
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
          session_mode: resolvedMode,
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
            error: { code: "INTERNAL_ERROR", message: "Could not create Nex session." },
          },
          { status: 500 },
        );
      }

      sessionId = createdSession.id;
    }

    await supabase.from("nex_messages").insert({
      nex_session_id: sessionId,
      student_id: studentProfile.id,
      role: "student",
      message_content: transcript,
      metadata: {
        inputType: "voice",
        transcriptionProvider: transcription.provider,
        durationSeconds: fieldsParsed.data.durationSeconds ?? null,
      },
    });

    const previousAssessmentStatus = sessionMetadata.assessmentStatus;

    const nexResult = await generateNexResponse({
      studentId: studentProfile.id,
      studentMessage: transcript,
      sessionMode: resolvedMode,
      sessionMetadata,
      topicId: activeTopicId,
      recentMessages,
      studentProfile,
    });

    if (
      shouldPersistMisconception(
        nexResult.sessionMode,
        transcript,
        nexResult.metadata.misconceptionDetected,
      )
    ) {
      const misconception = resolveMisconceptionFromMessage(transcript);
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

    const speech = await synthesizeVoiceResponse({ text: nexResult.response });

    const { data: nexMessage, error: nexMessageError } = await supabase
      .from("nex_messages")
      .insert({
        nex_session_id: sessionId,
        student_id: studentProfile.id,
        role: "nex",
        message_content: nexResult.response,
        metadata: {
          inputType: "voice",
          provider: nexResult.provider,
          validationPassed: nexResult.validationPassed,
          speechProvider: speech.provider,
          audioMimeType: speech.mimeType,
        },
      })
      .select("id")
      .single();

    if (nexMessageError || !nexMessage) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NEX_RESPONSE_FAILED", message: "Could not save Nex response." },
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

    await incrementNexDailyUsage(studentProfile.id);

    return NextResponse.json({
      success: true,
      data: {
        nexSessionId: sessionId,
        nexMessageId: nexMessage.id,
        nexResponse: nexResult.response,
        transcript,
        sessionMode: nexResult.sessionMode,
        provider: nexResult.provider,
        transcriptionProvider: transcription.provider,
        speechProvider: speech.provider,
        audioBase64: speech.audioBase64,
        audioMimeType: speech.mimeType,
      },
    });
  } catch (error) {
    console.error("NEX_VOICE_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "NEX_VOICE_FAILED",
          message: "Nex could not process the voice message.",
        },
      },
      { status: 502 },
    );
  }
}
