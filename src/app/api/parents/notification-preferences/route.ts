import "server-only";

import { NextResponse } from "next/server";

import {
  getParentNotificationPreferences,
  parentNotificationPreferencesSchema,
  updateParentNotificationPreferences,
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

  const preferences = await getParentNotificationPreferences(parentContext.parentId);
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

  const parsed = parentNotificationPreferencesSchema.safeParse(
    await request.json().catch(() => ({})),
  );

  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid notification preferences.",
          details: parsed.error.flatten(),
        },
      },
      { status: 400 },
    );
  }

  const preferences = await updateParentNotificationPreferences(
    parentContext.parentId,
    parsed.data,
  );

  return NextResponse.json({ success: true, data: { preferences } });
}
