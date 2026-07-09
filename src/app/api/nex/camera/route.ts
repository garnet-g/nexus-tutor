import "server-only";

import { randomUUID } from "node:crypto";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import { enforceSameOrigin } from "@/lib/security/originCheck";
import {
  checkContentLength,
  MEDIA_UPLOAD_LIMIT_BYTES,
} from "@/lib/security/bodySizeLimit";
import {
  buildCameraStudentMessage,
  extractImageText,
  NEX_UPLOADS_BUCKET,
} from "@/lib/nex/extractImageText";
import { generateNexResponse } from "@/lib/nex/generateNexResponse";
import { parseSessionMetadata } from "@/lib/nex/socraticTutorEngine";
import type { NexMode } from "@/lib/nex/types";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getNexDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import {
  CAMERA_MAX_BYTES,
  cameraUploadFieldsSchema,
  isCameraMimeType,
  studentHasCameraAccess,
} from "@/schemas/cameraSchemas";
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
import { awardStudyActivity } from "@/server/services/studyActivityService";

const SIGNED_URL_TTL_SECONDS = 3600;
const NEX_SESSION_XP = 5;

export async function POST(request: Request) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return originError;
    }

    const sizeError = checkContentLength(request, MEDIA_UPLOAD_LIMIT_BYTES);
    if (sizeError) {
      return sizeError;
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
    if (!studentHasCameraAccess(planCode)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "PREMIUM_REQUIRED",
            message: "Camera tutoring is available on Premium and Family plans.",
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

    const burst = await checkRateLimit({
      key: `nex:camera:${studentProfile.id}`,
      windowSeconds: 60,
      max: 10,
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

    const formData = await request.formData();
    const imageEntry = formData.get("image");

    if (!(imageEntry instanceof File)) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "VALIDATION_ERROR", message: "Image file is required." },
        },
        { status: 400 },
      );
    }

    if (imageEntry.size > CAMERA_MAX_BYTES) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Image must be 5MB or smaller.",
          },
        },
        { status: 400 },
      );
    }

    const mimeType = imageEntry.type;
    if (!isCameraMimeType(mimeType)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Only JPEG, PNG, and WebP images are supported.",
          },
        },
        { status: 400 },
      );
    }

    const fieldsParsed = cameraUploadFieldsSchema.safeParse({
      sessionMode: formData.get("sessionMode"),
      nexSessionId: formData.get("nexSessionId") || undefined,
      topicId: formData.get("topicId") || undefined,
    });

    if (!fieldsParsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid camera metadata.",
            details: fieldsParsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const { sessionMode, nexSessionId, topicId } = fieldsParsed.data;
    const imageBytes = new Uint8Array(await imageEntry.arrayBuffer());
    const admin = createAdminClient();

    const extension = mimeType === "image/png" ? "png" : mimeType === "image/webp" ? "webp" : "jpg";
    const objectPath = `${studentProfile.id}/${randomUUID()}.${extension}`;

    const { error: uploadError } = await admin.storage
      .from(NEX_UPLOADS_BUCKET)
      .upload(objectPath, imageBytes, {
        contentType: mimeType,
        upsert: false,
      });

    if (uploadError) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "STORAGE_UPLOAD_FAILED",
            message: "Could not store the uploaded image.",
          },
        },
        { status: 502 },
      );
    }

    const { data: signedUrlData } = await admin.storage
      .from(NEX_UPLOADS_BUCKET)
      .createSignedUrl(objectPath, SIGNED_URL_TTL_SECONDS);

    const extraction = await extractImageText({ imageBytes, mimeType });

    if (!extraction.inCurriculumScope || !extraction.extractedText) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "OUT_OF_SCOPE",
            message:
              "Nex could not find a mathematics problem in that photo. Try a clearer image of your math question.",
          },
        },
        { status: 422 },
      );
    }

    const studentMessage = buildCameraStudentMessage(extraction.extractedText);
    let sessionId = nexSessionId ?? null;
    let sessionMetadata = parseSessionMetadata(undefined);
    let recentMessages: Array<{ role: "student" | "nex"; content: string }> = [];
    let activeTopicId = topicId ?? null;
    const resolvedMode = sessionMode as NexMode;

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

      const newSessionId = createdSession.id;
      sessionId = newSessionId;

      void awardStudyActivity({
        studentId: studentProfile.id,
        activityType: "nex",
        activityId: newSessionId,
        durationSeconds: 0,
        xpEarned: NEX_SESSION_XP,
      }).catch(() => undefined);
    }

    const messageMetadata = {
      source: "camera",
      storagePath: objectPath,
      signedUrlExpiresInSeconds: SIGNED_URL_TTL_SECONDS,
      visionProvider: extraction.provider,
      ...(signedUrlData?.signedUrl ? { signedUrl: signedUrlData.signedUrl } : {}),
    };

    await supabase.from("nex_messages").insert({
      nex_session_id: sessionId,
      student_id: studentProfile.id,
      role: "student",
      message_content: studentMessage,
      metadata: messageMetadata,
    });

    const previousAssessmentStatus = sessionMetadata.assessmentStatus;

    const nexResult = await generateNexResponse({
      studentId: studentProfile.id,
      studentMessage,
      sessionMode: resolvedMode,
      sessionMetadata,
      topicId: activeTopicId,
      recentMessages,
      studentProfile,
    });

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
          source: "camera",
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

    await incrementNexDailyUsage(studentProfile.id, dailyLimit);

    return NextResponse.json({
      success: true,
      data: {
        nexSessionId: sessionId,
        nexMessageId: nexMessage.id,
        nexResponse: nexResult.response,
        sessionMode: nexResult.sessionMode,
        provider: nexResult.provider,
        extractedText: extraction.extractedText,
        storagePath: objectPath,
      },
    });
  } catch (error) {
    console.error("NEX_CAMERA_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "NEX_CAMERA_FAILED",
          message: "Nex could not process the camera upload.",
        },
      },
      { status: 502 },
    );
  }
}
