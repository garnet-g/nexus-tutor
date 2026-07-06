import "server-only";

import { NextResponse } from "next/server";

import { clientStatusLabel, isTerminal, mapDarajaResultToHint } from "@/lib/mpesa/paymentStateMachine";
import { enforcePaymentBurstLimits } from "@/lib/rateLimit/paymentBurstLimit";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { mpesaStatusQuerySchema } from "@/schemas/mpesaSchemas";

export async function GET(request: Request) {
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
          error: {
            code: "UNAUTHORIZED",
            message: "Missing or invalid session.",
          },
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
          error: {
            code: "FORBIDDEN",
            message: "Student profile required.",
          },
        },
        { status: 403 },
      );
    }

    const burstError = await enforcePaymentBurstLimits({
      request,
      studentId: studentProfile.id,
      action: "status",
    });

    if (burstError) {
      return burstError;
    }

    const url = new URL(request.url);
    const parsed = mpesaStatusQuerySchema.safeParse({
      mpesaPaymentId: url.searchParams.get("mpesaPaymentId"),
    });

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid mpesaPaymentId.",
          },
        },
        { status: 400 },
      );
    }

    const admin = createAdminClient();
    const { data: payment, error: paymentError } = await admin
      .from("mpesa_payments")
      .select(
        "id, payment_status, expires_at, student_id, subscription_plans(name)",
      )
      .eq("id", parsed.data.mpesaPaymentId)
      .maybeSingle();

    if (paymentError || !payment) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "NOT_FOUND",
            message: "Payment not found.",
          },
        },
        { status: 404 },
      );
    }

    if (payment.student_id !== studentProfile.id) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "FORBIDDEN",
            message: "Payment does not belong to this student.",
          },
        },
        { status: 403 },
      );
    }

    const planName =
      payment.subscription_plans &&
      typeof payment.subscription_plans === "object" &&
      "name" in payment.subscription_plans
        ? String((payment.subscription_plans as { name?: string }).name)
        : "Premium";

    const status = payment.payment_status;
    const failureHint =
      status === "verified-failed" || status === "expired"
        ? mapDarajaResultToHint(status === "expired" ? 1037 : 1032)
        : null;

    return NextResponse.json({
      success: true,
      data: {
        status,
        statusLabel: clientStatusLabel(status),
        expiresAt: payment.expires_at,
        planName,
        isTerminal: isTerminal(status),
        failureHint,
      },
    });
  } catch (error) {
    console.error("MPESA_STATUS_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not fetch payment status.",
        },
      },
      { status: 500 },
    );
  }
}
