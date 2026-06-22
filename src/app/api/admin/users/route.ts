import "server-only";

import { NextResponse } from "next/server";

import { usersQuerySchema } from "@/schemas/adminSchemas";
import { listUsers } from "@/server/services/adminUserReadService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = usersQuerySchema.safeParse({
      query: searchParams.get("query") ?? undefined,
      type: searchParams.get("type") ?? undefined,
      limit: searchParams.get("limit") ?? undefined,
      before: searchParams.get("before") ?? undefined,
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

    const users = await listUsers(parsed.data);

    return NextResponse.json({ success: true, data: { users } });
  } catch (error) {
    console.error("ADMIN_USERS_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load users." },
      },
      { status: 500 },
    );
  }
}
