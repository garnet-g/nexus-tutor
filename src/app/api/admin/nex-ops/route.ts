import "server-only";

import { NextResponse } from "next/server";

import { nexOpsQuerySchema } from "@/schemas/adminSchemas";
import { getNexOpsDashboard } from "@/server/services/adminNexOpsReadService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = nexOpsQuerySchema.safeParse({
      limit: searchParams.get("limit") ?? undefined,
    });

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid query parameters.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const data = await getNexOpsDashboard(parsed.data);

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("ADMIN_NEX_OPS_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load Nex ops." },
      },
      { status: 500 },
    );
  }
}
