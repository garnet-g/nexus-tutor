import "server-only";

import { NextResponse } from "next/server";

import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import { validateTemplateBody } from "@/lib/examPapers/templateValidation";
import { examPaperTemplateBodySchema } from "@/schemas/examPaperTemplateSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { previewTemplateSamples } from "@/server/services/examPaperAuthoringService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function POST(request: Request) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      { success: false, error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message } },
      { status: auth.status },
    );
  }

  const guardError = await enforceAdminMutationGuards(request, auth.userId);
  if (guardError) return guardError;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json(
      { success: false, error: { code: "INVALID_JSON", message: "Request body must be valid JSON." } },
      { status: 400 },
    );
  }

  const parsed = examPaperTemplateBodySchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: { code: "VALIDATION_ERROR", message: parsed.error.issues.map((i) => i.message).join("; ") },
      },
      { status: 400 },
    );
  }

  const validation = validateTemplateBody(parsed.data);
  const samples = validation.ok ? previewTemplateSamples(parsed.data) : [];

  await recordAdminAudit({
    actorUserId: auth.userId,
    actorRole: "super_admin",
    action: "examPapers.template.preview",
    targetType: "exam_paper_template",
    metadata: { valid: validation.ok, sampleCount: samples.length },
    request,
  });

  return NextResponse.json({ success: true, data: { validation, samples } });
}
