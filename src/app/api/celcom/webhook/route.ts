import "server-only";

import { NextResponse } from "next/server";

import { handleCelcomDeliveryReport } from "@/server/services/notificationService";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    await handleCelcomDeliveryReport(body);

    return NextResponse.json({
      success: true,
      data: { received: true },
    });
  } catch (error) {
    console.error("CELCOM_WEBHOOK_FAILED", error);

    return NextResponse.json({
      success: true,
      data: { received: true },
    });
  }
}
