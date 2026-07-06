import "server-only";

import { NextResponse } from "next/server";
import { z } from "zod";

import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import { createClient } from "@/lib/supabase/server";
import {
  createBetaInvite,
  listBetaInvites,
} from "@/server/services/betaInviteService";

function getRoleFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): string | null {
  const role = appMetadata?.userRole;
  return typeof role === "string" ? role : null;
}

const createInviteSchema = z.object({
  maxUses: z.number().int().min(1).max(1000).optional(),
  expiresAt: z.string().datetime().nullable().optional(),
});

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

    const invites = await listBetaInvites();

    return NextResponse.json({ success: true, data: { invites } });
  } catch (error) {
    console.error("BETA_INVITES_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load beta invites." },
      },
      { status: 500 },
    );
  }
}

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

    if (getRoleFromAppMetadata(user.app_metadata) !== "super_admin") {
      return NextResponse.json(
        {
          success: false,
          error: { code: "FORBIDDEN", message: "Super admin access required." },
        },
        { status: 403 },
      );
    }

    const guardError = await enforceAdminMutationGuards(request, user.id);
    if (guardError) {
      return guardError;
    }

    const body = await request.json();
    const parsed = createInviteSchema.safeParse(body);

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

    const invite = await createBetaInvite({
      maxUses: parsed.data.maxUses,
      expiresAt: parsed.data.expiresAt ?? null,
    });

    return NextResponse.json({ success: true, data: { invite } });
  } catch (error) {
    console.error("BETA_INVITES_POST_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create beta invite." },
      },
      { status: 500 },
    );
  }
}
