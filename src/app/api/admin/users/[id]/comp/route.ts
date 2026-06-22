import "server-only";

import { NextResponse } from "next/server";

import { createAdminClient } from "@/lib/supabase/admin";
import { compGrantSchema } from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  try {
    // WRITE/SENSITIVE: super_admin only. support must get 403.
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const { id: studentId } = await context.params;

    const body = await request.json();
    const parsed = compGrantSchema.safeParse(body);

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

    const { planCode, reason, expiresAt } = parsed.data;
    const admin = createAdminClient();

    // Confirm the student exists before granting.
    const { data: student, error: studentError } = await admin
      .from("student_profiles")
      .select("id")
      .eq("id", studentId)
      .maybeSingle();

    if (studentError) {
      throw new Error(studentError.message);
    }
    if (!student) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Student not found." },
        },
        { status: 404 },
      );
    }

    // Resolve the target plan by plan_code.
    const { data: plan, error: planError } = await admin
      .from("subscription_plans")
      .select("id, plan_code")
      .eq("plan_code", planCode)
      .maybeSingle();

    if (planError) {
      throw new Error(planError.message);
    }
    if (!plan) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "PLAN_NOT_FOUND",
            message: `No subscription plan found for code "${planCode}".`,
          },
        },
        { status: 400 },
      );
    }

    const expiresAtIso = expiresAt ?? null;

    // UPSERT current subscription to active on the chosen plan. This is a manual
    // comp only — it NEVER touches mpesa/payments tables (no money is moved).
    const { data: existingSub, error: existingError } = await admin
      .from("student_subscriptions")
      .select("id")
      .eq("student_id", studentId)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (existingError) {
      throw new Error(existingError.message);
    }

    if (existingSub) {
      const { error: updateError } = await admin
        .from("student_subscriptions")
        .update({
          subscription_plan_id: plan.id,
          subscription_status: "active",
          current_period_end: expiresAtIso,
          cancelled_at: null,
          updated_at: new Date().toISOString(),
        })
        .eq("id", existingSub.id);

      if (updateError) {
        throw new Error(updateError.message);
      }
    } else {
      const { error: insertError } = await admin
        .from("student_subscriptions")
        .insert({
          student_id: studentId,
          subscription_plan_id: plan.id,
          subscription_status: "active",
          current_period_end: expiresAtIso,
        });

      if (insertError) {
        throw new Error(insertError.message);
      }
    }

    // Append-only comp grant trail.
    const { error: grantError } = await admin
      .from("admin_subscription_grants")
      .insert({
        admin_user_id: auth.userId,
        student_id: studentId,
        plan_code: planCode,
        reason,
        expires_at: expiresAtIso,
      });

    if (grantError) {
      throw new Error(grantError.message);
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "subscription.comp",
      targetType: "student",
      targetId: studentId,
      metadata: { studentId, planCode, reason, expiresAt: expiresAtIso },
      request,
    });

    return NextResponse.json({
      success: true,
      data: { studentId, planCode, status: "active", expiresAt: expiresAtIso },
    });
  } catch (error) {
    console.error("ADMIN_USER_COMP_POST_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not apply comp subscription.",
        },
      },
      { status: 500 },
    );
  }
}
