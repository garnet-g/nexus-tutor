import { NextResponse } from "next/server";

import { enforceDataRetentionPolicies } from "@/server/services/retentionEnforcementService";
import { processExpiredFamilySubscriptions } from "@/server/services/familySubscriptionService";

export async function GET(request: Request): Promise<NextResponse> {
  const cronSecret = process.env.CRON_SECRET;

  if (!cronSecret) {
    return NextResponse.json(
      { error: "CRON_SECRET not configured" },
      { status: 503 },
    );
  }

  const authHeader = request.headers.get("authorization");
  if (authHeader !== `Bearer ${cronSecret}`) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const [retention, familyLifecycle] = await Promise.all([
      enforceDataRetentionPolicies(),
      processExpiredFamilySubscriptions(),
    ]);

    return NextResponse.json({
      success: true,
      retention,
      familyLifecycle,
    });
  } catch (error) {
    console.error("CRON_DATA_RETENTION_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "CRON_JOB_FAILED",
          message: "Data retention job failed.",
        },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request): Promise<NextResponse> {
  return GET(request);
}
