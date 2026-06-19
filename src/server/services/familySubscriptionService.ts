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

  const { data: group, error } = await admin
    .from("family_groups")
    .insert({
      owner_user_id: input.ownerUserId,
      owner_student_id: input.ownerStudentId,
      student_subscription_id: input.studentSubscriptionId,
      invite_code: inviteCode,
      max_seats: config.limits.familyMaxStudents,
      seat_count: 1,
    })
    .select("id, invite_code")
    .single();

  if (error || !group) {
    throw new Error(error?.message ?? "Could not create family group");
  }

  await admin.from("family_group_members").insert({
    family_group_id: group.id,
    student_id: input.ownerStudentId,
  });

  return { familyGroupId: group.id, inviteCode: group.invite_code };
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

export async function joinFamilyGroupWithCode(input: {
  studentId: string;
  inviteCode: string;
}): Promise<{ familyGroupId: string; seatsRemaining: number }> {
  const admin = createAdminClient();
  const normalizedCode = input.inviteCode.trim().toUpperCase();

  const { data: group, error: groupError } = await admin
    .from("family_groups")
    .select("id, max_seats, seat_count, is_active")
    .eq("invite_code", normalizedCode)
    .eq("is_active", true)
    .maybeSingle();

  if (groupError || !group) {
    throw new Error("Invalid or expired family invite code");
  }

  if (group.seat_count >= group.max_seats) {
    throw new Error("Family plan has no seats remaining");
  }

  const { data: existingMember } = await admin
    .from("family_group_members")
    .select("id")
    .eq("student_id", input.studentId)
    .maybeSingle();

  if (existingMember) {
    throw new Error("Student is already on a family plan");
  }

  await admin.from("family_group_members").insert({
    family_group_id: group.id,
    student_id: input.studentId,
  });

  const newSeatCount = group.seat_count + 1;
  await admin
    .from("family_groups")
    .update({ seat_count: newSeatCount })
    .eq("id", group.id);

  const familyPlan = await admin
    .from("subscription_plans")
    .select("id")
    .eq("plan_code", "family")
    .maybeSingle();

  if (familyPlan.data) {
    await admin
      .from("student_subscriptions")
      .update({ subscription_status: "cancelled" })
      .eq("student_id", input.studentId)
      .in("subscription_status", ["active", "trialing"]);

    const { data: groupWithSub } = await admin
      .from("family_groups")
      .select("student_subscription_id")
      .eq("id", group.id)
      .single();

    let periodStart = new Date().toISOString();
    let periodEnd: string | null = null;

    if (groupWithSub?.student_subscription_id) {
      const { data: sub } = await admin
        .from("student_subscriptions")
        .select("current_period_start, current_period_end")
        .eq("id", groupWithSub.student_subscription_id)
        .maybeSingle();

      if (sub) {
        periodStart = sub.current_period_start ?? periodStart;
        periodEnd = sub.current_period_end;
      }
    }

    await admin.from("student_subscriptions").insert({
      student_id: input.studentId,
      subscription_plan_id: familyPlan.data.id,
      subscription_status: "active",
      current_period_start: periodStart,
      current_period_end: periodEnd,
    });
  }

  return {
    familyGroupId: group.id,
    seatsRemaining: group.max_seats - newSeatCount,
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
