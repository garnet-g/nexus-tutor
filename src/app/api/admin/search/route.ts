import "server-only";

import { NextResponse } from "next/server";

import { searchAdminEntities } from "@/server/services/adminSearchService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES, type AdminRole } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const query = searchParams.get("q") ?? "";
    const roleFilter = searchParams.get("role") as AdminRole | null;

    const results = await searchAdminEntities({
      query,
      actorRole: auth.role,
      roleFilter: roleFilter ?? undefined,
    });

    return NextResponse.json({ success: true, data: { results } });
  } catch (error) {
    console.error("ADMIN_SEARCH_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not search admin index." },
      },
      { status: 500 },
    );
  }
}
