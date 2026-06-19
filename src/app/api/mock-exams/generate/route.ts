import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";
import { generateMockExamSchema } from "@/schemas/mockExamSchemas";
import { generateMockExamSession } from "@/server/services/mockExamService";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        { success: false, error: { code: "UNAUTHORIZED", message: "Missing session." } },
        { status: 401 },
      );
    }

    const { data: profile } = await supabase
      .from("student_profiles")
      .select("*")
      .eq("user_id", user.id)
      .maybeSingle();

    if (!profile) {
      return NextResponse.json(
        { success: false, error: { code: "FORBIDDEN", message: "Student profile required." } },
        { status: 403 },
      );
    }

    const body = await request.json();
    const parsed = generateMockExamSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid mock exam request.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const result = await generateMockExamSession(profile, parsed.data);

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";
    const status =
      message === "NOT_FOUND"
        ? 404
        : message === "VALIDATION" || message === "NO_QUESTIONS"
          ? 400
          : 500;

    return NextResponse.json(
      {
        success: false,
        error: {
          code: message,
          message:
            message === "NO_QUESTIONS"
              ? "Not enough practice questions to build this mock exam yet."
              : "Could not generate mock exam.",
        },
      },
      { status },
    );
  }
}
