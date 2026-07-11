import "server-only";

import { getExamPaperSessionForSitting } from "@/server/services/examPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

export async function GET(request: Request, context: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await context.params;

    const studentContext = await requireStudentProfile();
    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const view = await getExamPaperSessionForSitting(id, studentContext.profile.id);
    if (!view) {
      return apiErrorResponse("NOT_FOUND", "Exam paper session not found.", 404);
    }

    return Response.json({ success: true, data: view });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";
    return apiErrorResponse("INTERNAL_ERROR", "Could not load exam paper session.", 500, { message });
  }
}
