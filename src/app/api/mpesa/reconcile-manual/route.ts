import "server-only";

import { NextResponse } from "next/server";

import { enforcePaymentBurstLimits } from "@/lib/rateLimit/paymentBurstLimit";
import { createClient } from "@/lib/supabase/server";
import { mpesaManualReconcileSchema } from "@/schemas/mpesaSchemas";
import { verifyManualMpesaCode } from "@/server/services/reconcileService";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "UNAUTHORIZED", message: "Missing or invalid session." },
        },
        { status: 401 },
      );
    }

    const { data: studentProfile, error: profileError } = await supabase
      .from("student_profiles")
      .select("id")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !studentProfile) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "FORBIDDEN", message: "Student profile required." },
        },
        { status: 403 },
      );
    }

    const body = await request.json();
    const parsed = mpesaManualReconcileSchema.safeParse(body);

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

    const burstError = await enforcePaymentBurstLimits({
      request,
      studentId: studentProfile.id,
      action: "manual-reconcile",
    });

    if (burstError) {
      return burstError;
    }

    const result = await verifyManualMpesaCode({
      studentId: studentProfile.id,
      subscriptionPlanId: parsed.data.subscriptionPlanId,
      mpesaCode: parsed.data.mpesaCode,
    });

    if (result.status === "rejected") {
      return NextResponse.json(
        {
          success: false,
          error: { code: "MANUAL_VERIFICATION_REJECTED", message: result.message },
        },
        { status: 422 },
      );
    }

    return NextResponse.json({
      success: true,
      data: {
        status: result.status,
        activated: result.activated,
        subscriptionId: result.subscriptionId,
        message: result.message,
      },
    });
  } catch (error) {
    console.error("MPESA_RECONCILE_MANUAL_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not verify this payment.",
        },
      },
      { status: 500 },
    );
  }
}
