import "server-only";

import { NextResponse } from "next/server";

import { pastPaperMarkSchema } from "@/schemas/pastPaperSchemas";
import { markAttemptQuestionWithAI } from "@/server/services/pastPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ attemptId: string }>;
}

const MAX_IMAGE_BYTES = 8 * 1024 * 1024;

export async function POST(request: Request, context: RouteContext) {
  try {
    const { attemptId } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const body = await request.json();
    const parsed = pastPaperMarkSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    if (!parsed.data.studentAnswer && !parsed.data.imageBase64) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Provide a typed answer or a photo of your working.",
        400,
      );
    }

    let imageBytes: Uint8Array | undefined;
    if (parsed.data.imageBase64) {
      const buffer = Buffer.from(parsed.data.imageBase64, "base64");
      if (buffer.byteLength > MAX_IMAGE_BYTES) {
        return apiErrorResponse("VALIDATION_ERROR", "Image is too large.", 400);
      }
      imageBytes = new Uint8Array(buffer);
    }

    const result = await markAttemptQuestionWithAI(
      attemptId,
      parsed.data.questionId,
      studentContext.profile.id,
      {
        studentAnswer: parsed.data.studentAnswer,
        imageBytes,
        mimeType: parsed.data.mimeType,
      },
    );

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Attempt not found.", 404);
    }

    if (message === "QUESTION_NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Question not found.", 404);
    }

    console.error("PAST_PAPER_MARK_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not mark this answer.", 500);
  }
}
