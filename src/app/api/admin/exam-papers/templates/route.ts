import "server-only";

import { NextResponse } from "next/server";

import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import { examPaperTemplateIntakeSchema } from "@/schemas/examPaperTemplateSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { createExamPaperTemplate, listExamPaperTemplates } from "@/server/services/examPaperAuthoringService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function GET() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      { success: false, error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message } },
      { status: auth.status },
    );
  }

  const templates = await listExamPaperTemplates();
  return NextResponse.json({ success: true, data: templates });
}

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

  const parsed = examPaperTemplateIntakeSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: { code: "VALIDATION_ERROR", message: parsed.error.issues.map((i) => i.message).join("; ") },
      },
      { status: 400 },
    );
  }

  try {
    const result = await createExamPaperTemplate(parsed.data);

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: "super_admin",
      action: "examPapers.template.create",
      targetType: "exam_paper_template",
      targetId: result.id,
      metadata: { paper: parsed.data.paper, section: parsed.data.section, formLevel: parsed.data.formLevel },
      request,
    });

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error.";
    return NextResponse.json({ success: false, error: { code: "INTERNAL_ERROR", message } }, { status: 500 });
  }
}
