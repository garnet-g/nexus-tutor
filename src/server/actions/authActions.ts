"use server";

import { redirect } from "next/navigation";

import { loginSchema, signupSchema } from "@/schemas/authSchemas";
import { createClient } from "@/lib/supabase/server";
import {
  isBetaInviteRequired,
  reserveBetaInvite,
  validateInviteCode,
} from "@/server/services/betaInviteService";
import {
  createParentProfile,
  createStudentProfile,
  getPostAuthRedirectPath,
  getSessionUser,
  setUserRole,
} from "@/server/services/authService";
import { rollbackFailedSignup } from "@/server/services/signupCompensation";

export type AuthActionState = {
  error?: string;
  success?: boolean;
};

export async function signupAction(
  _prevState: AuthActionState,
  formData: FormData,
): Promise<AuthActionState> {
  const parsed = signupSchema.safeParse({
    email: formData.get("email"),
    password: formData.get("password"),
    fullName: formData.get("fullName"),
    role: formData.get("role"),
    inviteCode: formData.get("inviteCode") || undefined,
  });

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? "Invalid signup data" };
  }

  const { email, password, fullName, role, inviteCode } = parsed.data;

  if (isBetaInviteRequired()) {
    if (!inviteCode?.trim()) {
      return { error: "A beta invite code is required to sign up." };
    }

    const inviteValidation = await validateInviteCode(inviteCode);
    if (!inviteValidation.valid) {
      return { error: inviteValidation.reason };
    }
  }

  const supabase = await createClient();

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: fullName,
      },
    },
  });

  if (error) {
    return { error: error.message };
  }

  if (!data.user) {
    return { error: "Signup failed. Please try again." };
  }

  const userId = data.user.id;
  let inviteReserved = false;

  try {
    if (isBetaInviteRequired() && inviteCode) {
      const reserved = await reserveBetaInvite(inviteCode, userId);
      if (!reserved.valid) {
        await rollbackFailedSignup({ userId, role, inviteCode });
        return { error: reserved.reason };
      }
      inviteReserved = true;
    }

    await setUserRole(userId, role);

    if (role === "student") {
      await createStudentProfile({
        userId,
        fullName,
        email,
      });
    } else {
      await createParentProfile({
        userId,
        fullName,
        email,
      });
    }
  } catch (profileError) {
    if (inviteReserved && inviteCode) {
      await rollbackFailedSignup({ userId, role, inviteCode });
    } else {
      await rollbackFailedSignup({ userId, role });
    }

    return {
      error:
        profileError instanceof Error
          ? profileError.message
          : "Failed to create profile",
    };
  }

  const sessionUser = await getSessionUser();

  if (sessionUser) {
    redirect(getPostAuthRedirectPath(sessionUser));
  }

  return { success: true };
}

export async function loginAction(
  _prevState: AuthActionState,
  formData: FormData,
): Promise<AuthActionState> {
  const parsed = loginSchema.safeParse({
    email: formData.get("email"),
    password: formData.get("password"),
  });

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? "Invalid login data" };
  }

  const supabase = await createClient();
  const { error } = await supabase.auth.signInWithPassword(parsed.data);

  if (error) {
    return { error: error.message };
  }

  const sessionUser = await getSessionUser();

  if (!sessionUser) {
    return { error: "Unable to load your account. Contact support." };
  }

  redirect(getPostAuthRedirectPath(sessionUser));
}

export async function signOutAction(): Promise<void> {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}

export async function signInWithGoogleAction(
  role: "student" | "parent",
  inviteCode?: string,
) {
  if (isBetaInviteRequired()) {
    if (!inviteCode?.trim()) {
      return { error: "A beta invite code is required to sign up." };
    }

    const inviteValidation = await validateInviteCode(inviteCode);
    if (!inviteValidation.valid) {
      return { error: inviteValidation.reason };
    }
  }

  const supabase = await createClient();
  const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? "http://localhost:3000";
  const inviteQuery =
    isBetaInviteRequired() && inviteCode
      ? `&invite=${encodeURIComponent(inviteCode.trim())}`
      : "";

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: `${appUrl}/auth/callback?role=${role}${inviteQuery}`,
      queryParams: {
        access_type: "offline",
        prompt: "consent",
      },
    },
  });

  if (error) {
    return { error: error.message };
  }

  if (data.url) {
    redirect(data.url);
  }

  return { error: "Unable to start Google sign-in." };
}
