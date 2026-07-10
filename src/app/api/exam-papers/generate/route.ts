import "server-only";

import { enforceSameOrigin } from "@/lib/security/originCheck";
import { readJsonWithLimit } from "@/lib/security/bodySizeLimit";
import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import { generateExamPaperSchema } from "@/schemas/examPaperSchemas";
import { generateExamPaperSession } from "@/server/services/examPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

export async function POST(request: Request) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return apiErrorResponse("ORIGIN_FORBIDDEN", "Cross-origin request rejected.", 403);
    }

    const studentContext = await requireStudentProfile();
    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const burst = await checkRateLimit({
      key: `exam-papers:generate:${studentContext.profile.id}`,
      windowSeconds: 60,
      max: 10,
    });
    if (!burst.allowed) {
      return apiErrorResponse("RATE_LIMITED", "Too many requests. Please slow down.", 429, {
        retryAfterSeconds: burst.retryAfterSeconds,
      });
    }

    const bodyResult = await readJsonWithLimit(request);
    if (!bodyResult.ok) return bodyResult.response;

    const parsed = generateExamPaperSchema.safeParse(bodyResult.body);
    if (!parsed.success) {
      return apiErrorResponse("VALIDATION_ERROR", "Invalid request body.", 400, parsed.error.flatten());
    }

    const result = await generateExamPaperSession(studentContext.profile, parsed.data);

    return Response.json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";
    return apiErrorResponse("INTERNAL_ERROR", "Could not generate exam paper.", 500, { message });
  }
}
