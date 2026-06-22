import "server-only";

import { NextResponse } from "next/server";

import { outcomesQuerySchema } from "@/schemas/adminSchemas";
import { getOutcomesDashboard } from "@/server/services/adminOutcomesReadService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = outcomesQuerySchema.safeParse({
      curriculum: searchParams.get("curriculum") ?? undefined,
      gradeLevel: searchParams.get("gradeLevel") ?? undefined,
      riskThreshold: searchParams.get("riskThreshold") ?? undefined,
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

    const data = await getOutcomesDashboard(parsed.data);

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("ADMIN_OUTCOMES_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load outcomes." },
      },
      { status: 500 },
    );
  }
}
