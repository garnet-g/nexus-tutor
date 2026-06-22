import "server-only";

import { NextResponse } from "next/server";

import { createAdminClient } from "@/lib/supabase/admin";
import { adminStudentProfileUpdateSchema } from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

type StudentProfileSnapshot = {
  id: string;
  user_id: string;
  full_name: string | null;
  email: string | null;
  phone_number: string | null;
  curriculum: string | null;
  grade_level: string | null;
  school_name: string | null;
  target_grade: string | null;
  is_active: boolean | null;
};

function nullable(value: string | null | undefined): string | null {
  return value && value.trim().length > 0 ? value.trim() : null;
}

function changedFields(
  before: StudentProfileSnapshot,
  after: {
    fullName: string;
    email: string | null;
    phoneNumber: string | null;
    curriculum: string;
    gradeLevel: string;
    schoolName: string | null;
    targetGrade: string | null;
    isActive: boolean;
  },
): string[] {
  const fields: Array<[string, unknown, unknown]> = [
    ["fullName", before.full_name ?? "", after.fullName],
    ["email", before.email ?? null, after.email],
    ["phoneNumber", before.phone_number ?? null, after.phoneNumber],
    ["curriculum", before.curriculum ?? null, after.curriculum],
    ["gradeLevel", before.grade_level ?? null, after.gradeLevel],
    ["schoolName", before.school_name ?? null, after.schoolName],
    ["targetGrade", before.target_grade ?? null, after.targetGrade],
    ["isActive", before.is_active ?? true, after.isActive],
  ];

  return fields
    .filter(([, current, next]) => current !== next)
    .map(([field]) => field);
}

export async function PATCH(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const parsed = adminStudentProfileUpdateSchema.safeParse(body);

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

    const { id: studentId } = await context.params;
    const admin = createAdminClient();

    const { data: current, error: currentError } = await admin
      .from("student_profiles")
      .select(
        "id, user_id, full_name, email, phone_number, curriculum, grade_level, school_name, target_grade, is_active",
      )
      .eq("id", studentId)
      .maybeSingle();

    if (currentError) {
      throw new Error(currentError.message);
    }

    if (!current) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Student not found." },
        },
        { status: 404 },
      );
    }

    const nextProfile = {
      fullName: parsed.data.fullName,
      email: nullable(parsed.data.email),
      phoneNumber: nullable(parsed.data.phoneNumber),
      curriculum: parsed.data.curriculum,
      gradeLevel: parsed.data.gradeLevel,
      schoolName: nullable(parsed.data.schoolName),
      targetGrade: nullable(parsed.data.targetGrade),
      isActive: parsed.data.isActive,
    };

    const changed = changedFields(current as StudentProfileSnapshot, nextProfile);

    const { data: updated, error: updateError } = await admin
      .from("student_profiles")
      .update({
        full_name: nextProfile.fullName,
        email: nextProfile.email,
        phone_number: nextProfile.phoneNumber,
        curriculum: nextProfile.curriculum,
        grade_level: nextProfile.gradeLevel,
        school_name: nextProfile.schoolName,
        target_grade: nextProfile.targetGrade,
        is_active: nextProfile.isActive,
        updated_at: new Date().toISOString(),
      })
      .eq("id", studentId)
      .select(
        "id, user_id, full_name, email, phone_number, curriculum, grade_level, school_name, target_grade, is_active",
      )
      .single();

    if (updateError) {
      throw new Error(updateError.message);
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "user.profile.update",
      targetType: "student",
      targetId: studentId,
      metadata: {
        studentId,
        reason: parsed.data.changeReason,
        changedFields: changed,
        curriculum: {
          before: current.curriculum ?? null,
          after: nextProfile.curriculum,
        },
        gradeLevel: {
          before: current.grade_level ?? null,
          after: nextProfile.gradeLevel,
        },
        isActive: {
          before: current.is_active ?? true,
          after: nextProfile.isActive,
        },
      },
      request,
    });

    return NextResponse.json({
      success: true,
      data: {
        id: updated.id,
        fullName: updated.full_name,
        curriculum: updated.curriculum,
        gradeLevel: updated.grade_level,
        isActive: updated.is_active,
        changedFields: changed,
      },
    });
  } catch (error) {
    console.error("ADMIN_USER_PROFILE_PATCH_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not update student profile.",
        },
      },
      { status: 500 },
    );
  }
}
