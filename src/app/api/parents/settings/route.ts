import "server-only";

import { NextResponse } from "next/server";

import { parentProductPreferencesSchema } from "@/server/services/parentPreferencesService";
import {
  getParentProductPreferences,
  updateParentProductPreferences,
} from "@/server/services/parentPreferencesService";
import { parentApiError, requireParentProfile } from "@/server/services/parentContext";

export const dynamic = "force-dynamic";

export async function GET() {
  const parentContext = await requireParentProfile();
  if (!parentContext.ok) {
    return parentApiError(
      parentContext.status,
      parentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
      parentContext.message,
    );
  }

  const preferences = await getParentProductPreferences(parentContext.parentId);
  return NextResponse.json({ success: true, data: { preferences } });
}

export async function PATCH(request: Request) {
  const parentContext = await requireParentProfile();
  if (!parentContext.ok) {
    return parentApiError(
      parentContext.status,
      parentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
      parentContext.message,
    );
  }

  const parsed = parentProductPreferencesSchema.safeParse(
    await request.json().catch(() => ({})),
  );

  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid parent settings.",
          details: parsed.error.flatten(),
        },
      },
      { status: 400 },
    );
  }

  const preferences = await updateParentProductPreferences(
    parentContext.parentId,
    parsed.data,
  );

  return NextResponse.json({ success: true, data: { preferences } });
}
