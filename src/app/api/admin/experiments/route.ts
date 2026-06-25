import "server-only";

import { NextResponse } from "next/server";

import { adminExperimentCreateSchema } from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createExperiment,
  listExperiments,
} from "@/server/services/adminPlatformService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const experiments = await listExperiments();
    return NextResponse.json({ success: true, data: { experiments } });
  } catch (error) {
    console.error("ADMIN_EXPERIMENTS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load experiments." },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const parsed = adminExperimentCreateSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid experiment body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const experiment = await createExperiment({
      experiment: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_experiment.create",
      targetType: "admin_experiment",
      targetId: experiment.id,
      metadata: {
        experimentKey: experiment.experimentKey,
        metricKey: experiment.metricKey,
      },
      request,
    });

    return NextResponse.json(
      { success: true, data: { experiment } },
      { status: 201 },
    );
  } catch (error) {
    console.error("ADMIN_EXPERIMENTS_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create experiment." },
      },
      { status: 500 },
    );
  }
}
