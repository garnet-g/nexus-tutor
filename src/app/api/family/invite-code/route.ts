import { NextResponse } from "next/server";

import { getSessionUser } from "@/server/services/authService";
import { getFamilyInviteCodeForStudent } from "@/server/services/familySubscriptionService";
import { getStudentPlanCode } from "@/server/services/subscriptionService";

export async function GET(): Promise<NextResponse> {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const planCode = await getStudentPlanCode(sessionUser.studentProfile.id);

  if (planCode !== "family") {
    return NextResponse.json(
      { error: "Family plan required to generate invite code" },
      { status: 403 },
    );
  }

  try {
    const inviteCode = await getFamilyInviteCodeForStudent(
      sessionUser.studentProfile.id,
      sessionUser.id,
    );

    return NextResponse.json({ success: true, inviteCode });
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Could not get invite code" },
      { status: 500 },
    );
  }
}
