import "server-only";

import { NextResponse } from "next/server";

import { parentNotifySchema } from "@/schemas/adminSchemas";
import { sendParentSms } from "@/server/services/adminParentNotifyService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const parsed = parentNotifySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid request body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const result = await sendParentSms({
      studentId: parsed.data.studentId,
      message: parsed.data.message,
      adminUserId: auth.userId,
      adminRole: auth.role,
      request,
    });

    if (!result.ok) {
      return NextResponse.json(
        {
          success: false,
          error: { code: result.code, message: result.message },
        },
        { status: 404 },
      );
    }

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    console.error("ADMIN_PARENT_SMS_POST_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not send parent SMS.",
        },
      },
      { status: 500 },
    );
  }
}
