import "server-only";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import { enforceSameOrigin } from "@/lib/security/originCheck";
import { readJsonWithLimit } from "@/lib/security/bodySizeLimit";
import { createAdminClient } from "@/lib/supabase/admin";
import { teacherWaitlistSchema } from "@/schemas/waitlistSchemas";

const RATE_LIMIT_WINDOW_SECONDS = 60;
const RATE_LIMIT_MAX = 5;

function getClientKey(request: Request): string {
  const forwarded = request.headers.get("x-forwarded-for");
  if (forwarded) {
    return forwarded.split(",")[0]?.trim() ?? "unknown";
  }
  return request.headers.get("x-real-ip") ?? "unknown";
}

export async function POST(request: Request) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return originError;
    }

    const clientKey = getClientKey(request);

    // Durable, multi-instance limiter (replaces the per-process Map that reset
    // on every cold start and never shared state across instances — PR-046).
    const limit = await checkRateLimit({
      key: `waitlist:teacher:${clientKey}`,
      windowSeconds: RATE_LIMIT_WINDOW_SECONDS,
      max: RATE_LIMIT_MAX,
    });

    if (!limit.allowed) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "RATE_LIMITED",
            message: "Too many requests. Please try again shortly.",
            details: { retryAfterSeconds: limit.retryAfterSeconds },
          },
        },
        { status: 429 },
      );
    }

    const bodyResult = await readJsonWithLimit(request);
    if (!bodyResult.ok) {
      return bodyResult.response;
    }

    const parsed = teacherWaitlistSchema.safeParse(bodyResult.body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid waitlist submission.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const admin = createAdminClient();
    const normalizedEmail = parsed.data.email.trim().toLowerCase();

    const { data: existing } = await admin
      .from("teacher_waitlist")
      .select("id")
      .ilike("email", normalizedEmail)
      .maybeSingle();

    if (existing) {
      return NextResponse.json({
        success: true,
        data: { alreadyRegistered: true },
      });
    }

    const { error: insertError } = await admin.from("teacher_waitlist").insert({
      email: normalizedEmail,
      full_name: parsed.data.fullName.trim(),
      school_name: parsed.data.schoolName.trim(),
      curriculum: parsed.data.curriculum ?? null,
    });

    if (insertError) {
      if (insertError.code === "23505") {
        return NextResponse.json({
          success: true,
          data: { alreadyRegistered: true },
        });
      }

      throw insertError;
    }

    return NextResponse.json({
      success: true,
      data: { alreadyRegistered: false },
    });
  } catch (error) {
    console.error("teacher waitlist error", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not submit waitlist request.",
        },
      },
      { status: 500 },
    );
  }
}
