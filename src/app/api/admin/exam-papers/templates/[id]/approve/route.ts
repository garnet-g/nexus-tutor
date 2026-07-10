import "server-only";

import { NextResponse } from "next/server";

import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { approveExamPaperTemplate } from "@/server/services/examPaperAuthoringService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function POST(request: Request, context: { params: Promise<{ id: string }> }) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      { success: false, error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message } },
      { status: auth.status },
    );
  }

  const guardError = await enforceAdminMutationGuards(request, auth.userId);
  if (guardError) return guardError;

  const { id } = await context.params;

  try {
    await approveExamPaperTemplate(id);

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: "super_admin",
      action: "examPapers.template.approve",
      targetType: "exam_paper_template",
      targetId: id,
      request,
    });

    return NextResponse.json({ success: true, data: { approved: true } });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error.";
    const status = message === "NOT_FOUND" ? 404 : message.startsWith("VALIDATION_FAILED") ? 422 : 500;
    return NextResponse.json({ success: false, error: { code: "APPROVE_FAILED", message } }, { status });
  }
}
