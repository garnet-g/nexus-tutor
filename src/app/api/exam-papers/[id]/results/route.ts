import "server-only";

import { getExamPaperResults } from "@/server/services/examPaperService";
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

    const results = await getExamPaperResults(id, studentContext.profile.id);
    if (!results) {
      return apiErrorResponse("NOT_FOUND", "Results not available yet.", 404);
    }

    return Response.json({ success: true, data: results });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";
    return apiErrorResponse("INTERNAL_ERROR", "Could not load exam paper results.", 500, { message });
  }
}
