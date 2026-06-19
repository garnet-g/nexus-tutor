import "server-only";

import { NextResponse } from "next/server";

import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

function getRoleFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): string | null {
  const role = appMetadata?.userRole;
  return typeof role === "string" ? role : null;
}

function getNairobiDateString(date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(date);
}

export async function GET() {
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

    if (getRoleFromAppMetadata(user.app_metadata) !== "super_admin") {
      return NextResponse.json(
        {
          success: false,
          error: { code: "FORBIDDEN", message: "Super admin access required." },
        },
        { status: 403 },
      );
    }

    const admin = createAdminClient();
    const today = getNairobiDateString();

    const { data: todayRows, error: todayError } = await admin
      .from("nex_daily_usage")
      .select(
        "student_id, nex_message_count, practice_session_count, usage_date, student_profiles(full_name, curriculum, grade_level)",
      )
      .eq("usage_date", today)
      .order("nex_message_count", { ascending: false })
      .limit(100);

    if (todayError) {
      throw todayError;
    }

    const { data: totalRows, error: totalError } = await admin
      .from("nex_daily_usage")
      .select("nex_message_count, practice_session_count")
      .eq("usage_date", today);

    if (totalError) {
      throw totalError;
    }

    const totalNexMessages = (totalRows ?? []).reduce(
      (sum, row) => sum + (row.nex_message_count ?? 0),
      0,
    );
    const totalPracticeSessions = (totalRows ?? []).reduce(
      (sum, row) => sum + (row.practice_session_count ?? 0),
      0,
    );
    const activeStudentsToday = (totalRows ?? []).length;

    const students = (todayRows ?? []).map((row) => {
      const profile =
        row.student_profiles &&
        typeof row.student_profiles === "object" &&
        !Array.isArray(row.student_profiles)
          ? (row.student_profiles as { full_name?: string; curriculum?: string; grade_level?: string })
          : null;

      return {
        studentId: row.student_id,
        fullName: profile?.full_name ?? "Unknown",
        curriculum: profile?.curriculum ?? "—",
        gradeLevel: profile?.grade_level ?? "—",
        nexMessages: row.nex_message_count ?? 0,
        practiceSessions: row.practice_session_count ?? 0,
      };
    });

    return NextResponse.json({
      success: true,
      data: {
        date: today,
        summary: {
          activeStudentsToday,
          totalNexMessages,
          totalPracticeSessions,
        },
        students,
      },
    });
  } catch (error) {
    console.error("ADMIN_USAGE_STATS_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load usage stats." },
      },
      { status: 500 },
    );
  }
}
