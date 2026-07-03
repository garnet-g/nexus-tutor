import "server-only";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import { enforceSameOrigin } from "@/lib/security/originCheck";
import { readJsonWithLimit } from "@/lib/security/bodySizeLimit";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getPracticeDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import { practiceStartSchema } from "@/schemas/practiceSchemas";
import { startPracticeSession } from "@/server/services/practiceService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import {
  getPracticeDailyUsageCount,
  getSecondsUntilNairobiMidnight,
  getStudentPlanCode,
  incrementPracticeDailyUsage,
} from "@/server/services/nexUsageService";

export async function POST(request: Request) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return apiErrorResponse(
        "ORIGIN_FORBIDDEN",
        "Cross-origin request rejected.",
        403,
      );
    }

    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    if (!studentContext.profile.has_completed_diagnostic) {
      return apiErrorResponse(
        "DIAGNOSTIC_NOT_COMPLETED",
        "Complete your diagnostic assessment before practicing.",
        403,
      );
    }

    const burst = await checkRateLimit({
      key: `practice:start:${studentContext.profile.id}`,
      windowSeconds: 60,
      max: 30,
    });

    if (!burst.allowed) {
      return apiErrorResponse(
        "RATE_LIMITED",
        "Too many requests. Please slow down.",
        429,
        { retryAfterSeconds: burst.retryAfterSeconds },
      );
    }

    const bodyResult = await readJsonWithLimit(request);
    if (!bodyResult.ok) {
      return bodyResult.response;
    }

    const parsed = practiceStartSchema.safeParse(bodyResult.body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const [subscriptionConfig, planCode] = await Promise.all([
      getEffectiveSubscriptionConfigWithFallback(),
      getStudentPlanCode(studentContext.profile.id),
    ]);

    const practiceLimit = getPracticeDailyLimit(subscriptionConfig, planCode);
    const practiceUsage = await getPracticeDailyUsageCount(studentContext.profile.id);

    if (practiceUsage >= practiceLimit) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "RATE_LIMITED",
            message: "Daily practice session limit reached.",
            details: {
              retryAfterSeconds: getSecondsUntilNairobiMidnight(),
              dailyLimit: practiceLimit,
              currentUsage: practiceUsage,
            },
          },
        },
        { status: 429 },
      );
    }

    const data = await startPracticeSession(studentContext.profile, parsed.data);

    await incrementPracticeDailyUsage(studentContext.profile.id, practiceLimit);

    return NextResponse.json(
      {
        success: true,
        data,
      },
      { status: 201 },
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Topic not found.", 404);
    }

    if (message === "INVALID_SUBTOPIC") {
      return apiErrorResponse(
        "INVALID_SUBTOPIC",
        "The selected subtopic does not belong to this topic.",
        400,
      );
    }

    if (message === "NO_QUESTIONS_FOR_SUBTOPIC") {
      return apiErrorResponse(
        "NO_QUESTIONS_FOR_SUBTOPIC",
        "No practice questions are available for this subtopic at the selected difficulty.",
        404,
      );
    }

    if (message === "NO_QUESTIONS_FOR_TOPIC") {
      return apiErrorResponse(
        "NO_QUESTIONS_FOR_TOPIC",
        "No practice questions are available for this topic at the selected difficulty.",
        404,
      );
    }

    if (message === "NO_QUESTIONS") {
      return apiErrorResponse(
        "NOT_FOUND",
        "No practice questions are available for this topic.",
        404,
      );
    }

    console.error("PRACTICE_START_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not start practice session.",
      500,
    );
  }
}
