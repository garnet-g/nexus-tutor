import "server-only";

import { enforceSameOrigin } from "@/lib/security/originCheck";
import { readJsonWithLimit } from "@/lib/security/bodySizeLimit";
import { chooseSectionTwoSchema } from "@/schemas/examPaperSchemas";
import { chooseSectionTwoQuestions } from "@/server/services/examPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

export async function POST(request: Request, context: { params: Promise<{ id: string }> }) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return apiErrorResponse("ORIGIN_FORBIDDEN", "Cross-origin request rejected.", 403);
    }

    const { id } = await context.params;

    const studentContext = await requireStudentProfile();
    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const bodyResult = await readJsonWithLimit(request);
    if (!bodyResult.ok) return bodyResult.response;

    const parsed = chooseSectionTwoSchema.safeParse(bodyResult.body);
    if (!parsed.success) {
      return apiErrorResponse("VALIDATION_ERROR", "Invalid request body.", 400, parsed.error.flatten());
    }

    await chooseSectionTwoQuestions(id, studentContext.profile.id, parsed.data.sessionQuestionIds);

    return Response.json({ success: true, data: { chosen: true } });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";
    const status = message === "NOT_FOUND" ? 404 : message === "CONFLICT" ? 409 : message === "VALIDATION" ? 400 : 500;
    return apiErrorResponse(message, "Could not update Section II choice.", status);
  }
}
