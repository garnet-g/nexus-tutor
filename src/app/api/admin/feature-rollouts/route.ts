import "server-only";

import { NextResponse } from "next/server";

import { adminFeatureRolloutUpsertSchema } from "@/schemas/adminOpsSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  listFeatureRollouts,
  upsertFeatureRollout,
} from "@/server/services/adminOpsService";
import { clearFeatureRolloutCache } from "@/server/services/featureRolloutService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const rollouts = await listFeatureRollouts();
    return NextResponse.json({ success: true, data: { rollouts } });
  } catch (error) {
    console.error("ADMIN_FEATURE_ROLLOUTS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load rollouts." },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const parsed = adminFeatureRolloutUpsertSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid rollout body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const rollout = await upsertFeatureRollout({
      rollout: parsed.data,
      actorUserId: auth.userId,
    });

    // Bust the 30-second in-memory cache so the change is visible immediately
    clearFeatureRolloutCache();

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "feature_rollout.upsert",
      targetType: "admin_feature_rollout",
      targetId: rollout.id,
      metadata: {
        featureKey: rollout.featureKey,
        isEnabled: rollout.isEnabled,
        scope: rollout.scope,
        scopeValue: rollout.scopeValue,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { rollout } });
  } catch (error) {
    console.error("ADMIN_FEATURE_ROLLOUTS_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not save rollout." },
      },
      { status: 500 },
    );
  }
}
