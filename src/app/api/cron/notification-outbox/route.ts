import { NextResponse } from "next/server";

import { processNotificationOutboxBatch } from "@/server/services/notificationOutboxService";

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
    const result = await processNotificationOutboxBatch();
    return NextResponse.json({ success: true, ...result });
  } catch (error) {
    console.error("CRON_NOTIFICATION_OUTBOX_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "CRON_JOB_FAILED",
          message: "Notification outbox job failed.",
        },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request): Promise<NextResponse> {
  return GET(request);
}
