#!/usr/bin/env tsx
/**
 * Creates fixed local dev accounts after db:reset.
 * Safe to re-run — upserts users and profiles.
 */
import { existsSync, readFileSync } from "fs";
import { join } from "path";

import { createClient } from "@supabase/supabase-js";

const ROOT = join(import.meta.dirname, "..");

const DEV_STUDENT = {
  id: "a0000000-0000-4000-8000-000000000001",
  email: "student@nexus.local",
  password: "NexusDev1",
  fullName: "Dev Student",
  curriculum: "CBC" as const,
  gradeLevel: "grade_7",
  schoolName: "Nexus Dev School",
};

const DEV_SUPPORT = {
  id: "a0000000-0000-4000-8000-000000000003",
  email: "support@nexus.local",
  password: "NexusDev1",
  fullName: "Dev Support",
};

const DEV_ADMIN = {
  id: "a0000000-0000-4000-8000-000000000002",
  email: "admin@nexus.local",
  password: "NexusDev1",
  fullName: "Dev Admin",
};

function loadEnvLocal() {
  const envPath = join(ROOT, ".env.local");
  if (!existsSync(envPath)) {
    return;
  }

  for (const line of readFileSync(envPath, "utf-8").split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) {
      continue;
    }

    const separator = trimmed.indexOf("=");
    if (separator === -1) {
      continue;
    }

    const key = trimmed.slice(0, separator).trim();
    let value = trimmed.slice(separator + 1).trim();

    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }

    if (!process.env[key]) {
      process.env[key] = value;
    }
  }
}

function getAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceRoleKey || serviceRoleKey.includes("your-")) {
    throw new Error(
      "Set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in .env.local (run npm run supabase:status after supabase start).",
    );
  }

  return createClient(url, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

async function findUserIdByEmail(
  admin: ReturnType<typeof getAdminClient>,
  email: string,
): Promise<string | null> {
  const { data, error } = await admin.auth.admin.listUsers({ perPage: 200 });

  if (error) {
    throw new Error(error.message);
  }

  const match = data.users.find(
    (user) => user.email?.toLowerCase() === email.toLowerCase(),
  );

  return match?.id ?? null;
}

async function ensureAuthUser(
  admin: ReturnType<typeof getAdminClient>,
  input: {
    id: string;
    email: string;
    password: string;
    fullName: string;
    role: "student" | "super_admin" | "support";
  },
) {
  const existingId = await findUserIdByEmail(admin, input.email);

  if (existingId) {
    const { error } = await admin.auth.admin.updateUserById(existingId, {
      password: input.password,
      email_confirm: true,
      app_metadata: { userRole: input.role },
      user_metadata: { full_name: input.fullName },
    });

    if (error) {
      throw new Error(`Failed to update ${input.email}: ${error.message}`);
    }

    return existingId;
  }

  const { data, error } = await admin.auth.admin.createUser({
    id: input.id,
    email: input.email,
    password: input.password,
    email_confirm: true,
    app_metadata: { userRole: input.role },
    user_metadata: { full_name: input.fullName },
  });

  if (error || !data.user) {
    throw new Error(
      `Failed to create ${input.email}: ${error?.message ?? "Unknown error"}`,
    );
  }

  return data.user.id;
}

async function ensureStudentProfile(
  admin: ReturnType<typeof getAdminClient>,
  userId: string,
) {
  const { data: existing } = await admin
    .from("student_profiles")
    .select("id")
    .eq("user_id", userId)
    .maybeSingle();

  const profilePayload = {
    user_id: userId,
    full_name: DEV_STUDENT.fullName,
    email: DEV_STUDENT.email,
    curriculum: DEV_STUDENT.curriculum,
    grade_level: DEV_STUDENT.gradeLevel,
    school_name: DEV_STUDENT.schoolName,
    has_completed_diagnostic: true,
    learning_preferences: {
      explanationDepth: "standard",
      sessionGoalMinutes: 20,
      reminderChannel: "off",
    },
  };

  if (existing) {
    const { error } = await admin
      .from("student_profiles")
      .update(profilePayload)
      .eq("user_id", userId);

    if (error) {
      throw new Error(`Failed to update student profile: ${error.message}`);
    }

    return existing.id;
  }

  const { data, error } = await admin
    .from("student_profiles")
    .insert(profilePayload)
    .select("id")
    .single();

  if (error || !data) {
    throw new Error(
      `Failed to create student profile: ${error?.message ?? "Unknown error"}`,
    );
  }

  return data.id as string;
}

async function ensureFreeSubscription(
  admin: ReturnType<typeof getAdminClient>,
  studentId: string,
) {
  const { data: existing } = await admin
    .from("student_subscriptions")
    .select("id")
    .eq("student_id", studentId)
    .limit(1)
    .maybeSingle();

  if (existing) {
    return;
  }

  const { data: freePlan, error: planError } = await admin
    .from("subscription_plans")
    .select("id")
    .eq("plan_code", "free")
    .maybeSingle();

  if (planError || !freePlan) {
    throw new Error("Free subscription plan not found — run db:reset first.");
  }

  const { error } = await admin.from("student_subscriptions").insert({
    student_id: studentId,
    subscription_plan_id: freePlan.id,
    subscription_status: "active",
    current_period_start: new Date().toISOString(),
    current_period_end: null,
  });

  if (error) {
    throw new Error(`Failed to create free subscription: ${error.message}`);
  }
}

async function ensureSuperAdminProfile(
  admin: ReturnType<typeof getAdminClient>,
  userId: string,
) {
  const { data: existing } = await admin
    .from("super_admin_profiles")
    .select("id")
    .eq("user_id", userId)
    .maybeSingle();

  if (existing) {
    return;
  }

  const { error } = await admin.from("super_admin_profiles").insert({
    user_id: userId,
    full_name: DEV_ADMIN.fullName,
    email: DEV_ADMIN.email,
  });

  if (error) {
    throw new Error(`Failed to create super admin profile: ${error.message}`);
  }
}

async function main() {
  loadEnvLocal();
  const admin = getAdminClient();

  const studentUserId = await ensureAuthUser(admin, {
    ...DEV_STUDENT,
    role: "student",
  });
  const studentProfileId = await ensureStudentProfile(admin, studentUserId);
  await ensureFreeSubscription(admin, studentProfileId);

  const adminUserId = await ensureAuthUser(admin, {
    ...DEV_ADMIN,
    role: "super_admin",
  });
  await ensureSuperAdminProfile(admin, adminUserId);

  const supportUserId = await ensureAuthUser(admin, {
    ...DEV_SUPPORT,
    role: "support",
  });

  console.log("\nDev accounts ready:\n");
  console.log(`  Student:     ${DEV_STUDENT.email} / ${DEV_STUDENT.password}`);
  console.log(`  Super admin: ${DEV_ADMIN.email} / ${DEV_ADMIN.password}`);
  console.log(`  Support:     ${DEV_SUPPORT.email} / ${DEV_SUPPORT.password}`);
  console.log("\nLogin at http://localhost:3000/login");
  console.log(
    "Student lands on /dashboard (onboarding + diagnostic already complete).\n",
  );

  if (!supportUserId) {
    throw new Error("Support dev user was not created.");
  }
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
