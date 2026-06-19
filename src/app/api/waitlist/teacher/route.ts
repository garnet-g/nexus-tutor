import "server-only";

import { NextResponse } from "next/server";

import { createAdminClient } from "@/lib/supabase/admin";
import { teacherWaitlistSchema } from "@/schemas/waitlistSchemas";

const RATE_LIMIT_WINDOW_MS = 60_000;
const RATE_LIMIT_MAX = 5;
const rateLimitStore = new Map<string, { count: number; resetAt: number }>();

function getClientKey(request: Request): string {
  const forwarded = request.headers.get("x-forwarded-for");
  if (forwarded) {
    return forwarded.split(",")[0]?.trim() ?? "unknown";
  }
  return request.headers.get("x-real-ip") ?? "unknown";
}

function isRateLimited(key: string): boolean {
  const now = Date.now();
  const entry = rateLimitStore.get(key);

  if (!entry || now > entry.resetAt) {
    rateLimitStore.set(key, { count: 1, resetAt: now + RATE_LIMIT_WINDOW_MS });
    return false;
  }

  if (entry.count >= RATE_LIMIT_MAX) {
    return true;
  }

  entry.count += 1;
  return false;
}

export async function POST(request: Request) {
  try {
    const clientKey = getClientKey(request);

    if (isRateLimited(clientKey)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "RATE_LIMITED",
            message: "Too many requests. Please try again shortly.",
          },
        },
        { status: 429 },
      );
    }

    const body = await request.json();
    const parsed = teacherWaitlistSchema.safeParse(body);

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
