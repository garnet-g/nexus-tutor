import { NextResponse } from "next/server";

import { enforceSameOrigin } from "@/lib/security/originCheck";
import { readJsonWithLimit } from "@/lib/security/bodySizeLimit";
import { familyJoinSchema } from "@/schemas/familySchemas";
import { getSessionUser } from "@/server/services/authService";
import { joinFamilyGroupWithCode } from "@/server/services/familySubscriptionService";

export async function POST(request: Request): Promise<NextResponse> {
  if (enforceSameOrigin(request)) {
    return NextResponse.json(
      { error: "Cross-origin request rejected" },
      { status: 403 },
    );
  }

  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const bodyResult = await readJsonWithLimit(request);
  if (!bodyResult.ok) {
    return NextResponse.json(
      { error: "Request body is too large" },
      { status: 413 },
    );
  }

  const parsed = familyJoinSchema.safeParse(bodyResult.body);

  if (!parsed.success) {
    return NextResponse.json(
      { error: parsed.error.issues[0]?.message ?? "Invalid request" },
      { status: 400 },
    );
  }

  try {
    const result = await joinFamilyGroupWithCode({
      studentId: sessionUser.studentProfile.id,
      inviteCode: parsed.data.inviteCode,
    });

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Could not join family plan" },
      { status: 400 },
    );
  }
}
