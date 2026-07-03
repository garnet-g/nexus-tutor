import "server-only";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import { enforceSameOrigin } from "@/lib/security/originCheck";
import { createClient } from "@/lib/supabase/server";
import { startFreeTrial } from "@/server/services/subscriptionService";

export async function POST(request: Request) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return originError;
    }

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

    const burst = await checkRateLimit({
      key: `subscriptions:trial:${studentProfile.id}`,
      windowSeconds: 60,
      max: 5,
    });

    if (!burst.allowed) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "RATE_LIMITED",
            message: "Too many requests. Please slow down.",
            details: { retryAfterSeconds: burst.retryAfterSeconds },
          },
        },
        { status: 429 },
      );
    }

    const trial = await startFreeTrial(studentProfile.id);

    return NextResponse.json({
      success: true,
      data: trial,
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Could not start trial.";

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "TRIAL_FAILED",
          message,
        },
      },
      { status: 400 },
    );
  }
}
