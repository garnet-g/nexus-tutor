import "server-only";

import { NextResponse } from "next/server";

import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  buildAdminReportCsv,
  isAdminReportExportKey,
} from "@/server/services/adminReportExportService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const exportKey = new URL(request.url).searchParams.get("key") ?? "";
    if (!isAdminReportExportKey(exportKey)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid report export key.",
          },
        },
        { status: 400 },
      );
    }

    const report = await buildAdminReportCsv(exportKey);

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_report_export",
      targetType: "admin_report",
      targetId: exportKey,
      metadata: {
        exportKey,
        rowCount: report.rowCount,
        filename: report.filename,
      },
      request,
    });

    return new NextResponse(report.csv, {
      status: 200,
      headers: {
        "Content-Type": "text/csv; charset=utf-8",
        "Content-Disposition": `attachment; filename="${report.filename}"`,
        "Cache-Control": "no-store",
      },
    });
  } catch (error) {
    console.error("ADMIN_REPORT_EXPORT_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "EXPORT_FAILED",
          message: "Could not export admin report.",
        },
      },
      { status: 500 },
    );
  }
}
