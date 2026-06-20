import "server-only";

import { NextResponse } from "next/server";

import { generateContentRequestSchema } from "@/schemas/contentGenerationSchemas";
import {
  generateLessonDraft,
  generateQuestionBankDraft,
} from "@/server/services/contentGenerationService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

function mapServiceError(error: unknown): { status: number; code: string; message: string } {
  const message = error instanceof Error ? error.message : "Unexpected error.";

  if (message === "NOT_FOUND") {
    return { status: 404, code: "NOT_FOUND", message: "Scope not found." };
  }

  if (message === "SCOPE_VIOLATION") {
    return {
      status: 403,
      code: "SCOPE_VIOLATION",
      message: "Content generation is limited to Mathematics (V1).",
    };
  }

  if (message === "CURRICULUM_MISMATCH") {
    return {
      status: 400,
      code: "CURRICULUM_MISMATCH",
      message: "Scope does not belong to the requested curriculum.",
    };
  }

  if (message.startsWith("GENERATION_INVALID_OUTPUT")) {
    return {
      status: 422,
      code: "GENERATION_INVALID_OUTPUT",
      message: "Model output failed validation. No draft was saved.",
    };
  }

  if (message === "GENERATION_DEDUPED") {
    return {
      status: 409,
      code: "GENERATION_DEDUPED",
      message: "All generated questions were duplicates of existing items.",
    };
  }

  return { status: 500, code: "INTERNAL_ERROR", message };
}

export async function POST(request: Request) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      {
        success: false,
        error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message },
      },
      { status: auth.status },
    );
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json(
      {
        success: false,
        error: { code: "INVALID_JSON", message: "Request body must be valid JSON." },
      },
      { status: 400 },
    );
  }

  const parsed = generateContentRequestSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "VALIDATION_ERROR",
          message: parsed.error.issues.map((issue) => issue.message).join("; "),
        },
      },
      { status: 400 },
    );
  }

  try {
    if (parsed.data.type === "lesson") {
      const result = await generateLessonDraft({
        subtopicId: parsed.data.subtopicId,
        curriculum: parsed.data.curriculum,
        gradeLevel: parsed.data.gradeLevel,
        adminId: auth.userId,
      });

      return NextResponse.json({ success: true, data: result });
    }

    const result = await generateQuestionBankDraft({
      topicId: parsed.data.topicId,
      subtopicId: parsed.data.subtopicId,
      difficulty: parsed.data.difficulty,
      count: parsed.data.count,
      curriculum: parsed.data.curriculum,
      gradeLevel: parsed.data.gradeLevel,
      adminId: auth.userId,
    });

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const mapped = mapServiceError(error);
    return NextResponse.json(
      {
        success: false,
        error: { code: mapped.code, message: mapped.message },
      },
      { status: mapped.status },
    );
  }
}
