import "server-only";

import { randomBytes } from "crypto";

import { createAdminClient } from "@/lib/supabase/admin";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";

function generateFamilyInviteCode(): string {
  return `FAMILY-${randomBytes(3).toString("hex").toUpperCase()}`;
}

export async function createFamilyGroupForPayment(input: {
  ownerUserId: string;
  ownerStudentId: string;
  studentSubscriptionId: string;
}): Promise<{ familyGroupId: string; inviteCode: string }> {
  const admin = createAdminClient();
  const config = await getEffectiveSubscriptionConfig();
  const inviteCode = generateFamilyInviteCode();

  // Group row + owner membership are created in a single transaction
  // (create_family_group_atomic) so a failure never leaves an orphan group
  // without its owner member (PR-093).
  const { data, error } = await admin.rpc("create_family_group_atomic", {
    p_owner_user_id: input.ownerUserId,
    p_owner_student_id: input.ownerStudentId,
    p_student_subscription_id: input.studentSubscriptionId,
    p_invite_code: inviteCode,
    p_max_seats: config.limits.familyMaxStudents,
  });

  if (error || !data || typeof data !== "object") {
    throw new Error(error?.message ?? "Could not create family group");
  }

  const result = data as Record<string, unknown>;

  return {
    familyGroupId: String(result.family_group_id),
    inviteCode: String(result.invite_code ?? inviteCode),
  };
}

export async function getFamilyInviteCodeForStudent(
  studentId: string,
  userId: string,
): Promise<string | null> {
  const admin = createAdminClient();

  const { data: group } = await admin
    .from("family_groups")
    .select("invite_code, owner_user_id, is_active, seat_count, max_seats")
    .eq("owner_student_id", studentId)
    .eq("is_active", true)
    .maybeSingle();

  if (!group || group.owner_user_id !== userId) {
    return null;
  }

  return group.invite_code;
}

/** Maps join_family_group RAISE tokens to the established user-facing strings. */
function mapFamilyJoinError(message: string): string {
  if (message.includes("NO_SEATS")) {
    return "Family plan has no seats remaining";
  }
  if (message.includes("ALREADY_MEMBER")) {
    return "Student is already on a family plan";
  }
  if (message.includes("INVALID_CODE")) {
    return "Invalid or expired family invite code";
  }
  return "Could not join family plan";
}

export async function joinFamilyGroupWithCode(input: {
  studentId: string;
  inviteCode: string;
}): Promise<{ familyGroupId: string; seatsRemaining: number }> {
  const admin = createAdminClient();

  // Seat check, membership check, seat bump, prior-subscription cancellation and
  // family-subscription insert all run inside one FOR UPDATE transaction
  // (join_family_group) so concurrent joins can never oversell seats (PR-016).
  const { data, error } = await admin.rpc("join_family_group", {
    p_invite_code: input.inviteCode,
    p_student_id: input.studentId,
  });

  if (error) {
    throw new Error(mapFamilyJoinError(error.message));
  }

  if (!data || typeof data !== "object") {
    throw new Error("Could not join family plan");
  }

  const result = data as Record<string, unknown>;

  return {
    familyGroupId: String(result.family_group_id),
    seatsRemaining:
      typeof result.seats_remaining === "number" ? result.seats_remaining : 0,
  };
}

export async function getFamilyGroupMembers(studentId: string): Promise<
  Array<{ studentId: string; fullName: string; joinedAt: string }>
> {
  const admin = createAdminClient();

  const { data: membership } = await admin
    .from("family_group_members")
    .select("family_group_id")
    .eq("student_id", studentId)
    .maybeSingle();

  if (!membership) {
    return [];
  }

  const { data: members } = await admin
    .from("family_group_members")
    .select("student_id, joined_at, student_profiles(full_name)")
    .eq("family_group_id", membership.family_group_id);

  return (
    members?.map((member) => ({
      studentId: member.student_id,
      fullName:
        (member.student_profiles as { full_name?: string } | null)?.full_name ??
        "Student",
      joinedAt: member.joined_at,
    })) ?? []
  );
}

export async function findReclaimedFamilyGroupForOwner(
  ownerStudentId: string,
): Promise<{ id: string; inviteCode: string } | null> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("family_groups")
    .select("id, invite_code")
    .eq("owner_student_id", ownerStudentId)
    .eq("is_active", false)
    .order("updated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error || !data) {
    return null;
  }

  return {
    id: data.id,
    inviteCode: data.invite_code,
  };
}

async function archiveDuplicateFamilyGroup(familyGroupId: string): Promise<void> {
  const admin = createAdminClient();
  const { error } = await admin
    .from("family_groups")
    .update({ is_active: false, seat_count: 0, updated_at: new Date().toISOString() })
    .eq("id", familyGroupId);

  if (error) {
    throw new Error(error.message);
  }
}

/** Called after a successful family-plan payment when the owner has a reclaimed group. */
export async function maybeReactivateFamilyGroupAfterFamilyPayment(input: {
  ownerStudentId: string;
  studentSubscriptionId: string;
  activatedFamilyGroupId?: string;
}): Promise<{ familyGroupId: string; inviteCode: string } | null> {
  const reclaimed = await findReclaimedFamilyGroupForOwner(input.ownerStudentId);
  if (!reclaimed) {
    return null;
  }

  const reactivated = await reactivateFamilyGroupOnResubscribe({
    studentSubscriptionId: input.studentSubscriptionId,
    ownerStudentId: input.ownerStudentId,
  });

  if (
    input.activatedFamilyGroupId &&
    input.activatedFamilyGroupId !== reactivated.familyGroupId
  ) {
    await archiveDuplicateFamilyGroup(input.activatedFamilyGroupId);
  }

  return reactivated;
}

export async function isFamilyGroupActiveForOwner(ownerStudentId: string): Promise<boolean> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("family_groups")
    .select("id")
    .eq("owner_student_id", ownerStudentId)
    .eq("is_active", true)
    .maybeSingle();

  return Boolean(data);
}

export async function reclaimFamilyGroupOnLapse(
  studentSubscriptionId: string,
): Promise<{ reclaimed: boolean; removedMembers: number }> {
  const admin = createAdminClient();
  const { data, error } = await admin.rpc("reclaim_family_group_on_lapse", {
    p_student_subscription_id: studentSubscriptionId,
  });

  if (error) {
    throw new Error(error.message);
  }

  const result = (data ?? {}) as Record<string, unknown>;

  return {
    reclaimed: Boolean(result.reclaimed),
    removedMembers:
      typeof result.removed_members === "number" ? result.removed_members : 0,
  };
}

export async function reactivateFamilyGroupOnResubscribe(input: {
  studentSubscriptionId: string;
  ownerStudentId: string;
}): Promise<{ familyGroupId: string; inviteCode: string }> {
  const admin = createAdminClient();
  const config = await getEffectiveSubscriptionConfig();

  const { data, error } = await admin.rpc("reactivate_family_group_on_resubscribe", {
    p_student_subscription_id: input.studentSubscriptionId,
    p_owner_student_id: input.ownerStudentId,
    p_max_seats: config.limits.familyMaxStudents,
  });

  if (error || !data || typeof data !== "object") {
    throw new Error(error?.message ?? "Could not reactivate family group");
  }

  const result = data as Record<string, unknown>;

  return {
    familyGroupId: String(result.family_group_id),
    inviteCode: String(result.invite_code),
  };
}

export async function processExpiredFamilySubscriptions(): Promise<{
  processed: number;
  reclaimed: number;
  removedMembers: number;
}> {
  const admin = createAdminClient();

  const { data: expiredFamilySubs, error } = await admin
    .from("student_subscriptions")
    .select("id, student_id, subscription_plans(plan_code)")
    .in("subscription_status", ["expired", "cancelled", "past_due"])
    .order("updated_at", { ascending: false });

  if (error) {
    throw new Error(error.message);
  }

  let processed = 0;
  let reclaimed = 0;
  let removedMembers = 0;

  for (const row of expiredFamilySubs ?? []) {
    const planCode =
      row.subscription_plans &&
      typeof row.subscription_plans === "object" &&
      "plan_code" in row.subscription_plans
        ? String((row.subscription_plans as { plan_code?: string }).plan_code ?? "")
        : "";

    if (planCode !== "family") {
      continue;
    }

    processed += 1;
    const result = await reclaimFamilyGroupOnLapse(row.id);
    if (result.reclaimed) {
      reclaimed += 1;
      removedMembers += result.removedMembers;
    }
  }

  return { processed, reclaimed, removedMembers };
}
