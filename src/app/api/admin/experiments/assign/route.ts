import "server-only";

import { NextResponse } from "next/server";
import { z } from "zod";

import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  assignExperimentVariant,
  getExperimentExposureMetrics,
  isExperimentFeatureEnabled,
} from "@/server/services/adminExperimentsService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const assignSchema = z.object({
  experimentKey: z.string().trim().min(3).max(80),
  subjectId: z.string().trim().min(1).max(120),
  recordExposure: z.boolean().optional(),
});

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const experimentKey =
      new URL(request.url).searchParams.get("experimentKey") ?? "";
    if (!experimentKey) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "experimentKey is required.",
          },
        },
        { status: 400 },
      );
    }

    const metrics = await getExperimentExposureMetrics(experimentKey);
    return NextResponse.json({ success: true, data: { metrics } });
  } catch (error) {
    console.error("ADMIN_EXPERIMENT_METRICS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not load experiment metrics.",
        },
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

    const parsed = assignSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid experiment assignment body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const assignment = await assignExperimentVariant(parsed.data);
    const gate = await isExperimentFeatureEnabled({
      featureKey: parsed.data.experimentKey,
      subjectId: parsed.data.subjectId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_experiment.assign",
      targetType: "admin_experiment",
      targetId: parsed.data.experimentKey,
      metadata: {
        subjectId: parsed.data.subjectId,
        variant: assignment?.variant ?? null,
        gateSource: gate.source,
        gateEnabled: gate.enabled,
      },
      request,
    });

    return NextResponse.json({
      success: true,
      data: { assignment, gate },
    });
  } catch (error) {
    console.error("ADMIN_EXPERIMENT_ASSIGN_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not assign experiment variant.",
        },
      },
      { status: 500 },
    );
  }
}
