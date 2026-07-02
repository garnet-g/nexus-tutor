import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import { NextResponse } from "next/server";

import {
  createParentProfile,
  createStudentProfile,
  getPostAuthRedirectPath,
  setUserRole,
} from "@/server/services/authService";
import {
  isBetaInviteRequired,
  reserveBetaInvite,
  validateInviteCode,
} from "@/server/services/betaInviteService";
import { rollbackFailedSignup } from "@/server/services/signupCompensation";

export async function GET(request: Request) {
  const requestUrl = new URL(request.url);
  const code = requestUrl.searchParams.get("code");
  const roleParam = requestUrl.searchParams.get("role");
  const inviteParam = requestUrl.searchParams.get("invite");
  const role = roleParam === "parent" ? "parent" : "student";

  if (!code) {
    return NextResponse.redirect(new URL("/login", requestUrl.origin));
  }

  const cookieStore = await cookies();
  let redirectPath = role === "parent" ? "/parent" : "/onboarding";

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) => {
            cookieStore.set(name, value, options);
          });
        },
      },
    },
  );

  const { error } = await supabase.auth.exchangeCodeForSession(code);

  if (error) {
    return NextResponse.redirect(
      new URL(`/login?error=${encodeURIComponent(error.message)}`, requestUrl.origin),
    );
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.redirect(new URL("/login", requestUrl.origin));
  }

  const existingRole = user.app_metadata?.userRole as
    | "student"
    | "parent"
    | "super_admin"
    | "support"
    | undefined;
  const isNewAccount = !existingRole;
  const effectiveRole = existingRole ?? role;

  const signupRole: "student" | "parent" =
    effectiveRole === "parent" ? "parent" : "student";

  if (isNewAccount && isBetaInviteRequired()) {
    if (!inviteParam?.trim()) {
      await rollbackFailedSignup({ userId: user.id, role: signupRole });
      return NextResponse.redirect(
        new URL("/signup?error=invite_required", requestUrl.origin),
      );
    }

    const inviteValidation = await validateInviteCode(inviteParam);
    if (!inviteValidation.valid) {
      await rollbackFailedSignup({
        userId: user.id,
        role: signupRole,
        inviteCode: inviteParam,
      });
      return NextResponse.redirect(
        new URL(
          `/signup?error=${encodeURIComponent(inviteValidation.reason)}`,
          requestUrl.origin,
        ),
      );
    }

    const reserved = await reserveBetaInvite(inviteParam, user.id);
    if (!reserved.valid) {
      await rollbackFailedSignup({
        userId: user.id,
        role: signupRole,
        inviteCode: inviteParam,
      });
      return NextResponse.redirect(
        new URL(
          `/signup?error=${encodeURIComponent(reserved.reason)}`,
          requestUrl.origin,
        ),
      );
    }
  }

  try {
    if (isNewAccount && effectiveRole !== "super_admin" && effectiveRole !== "support") {
      await setUserRole(user.id, effectiveRole);
    }

    const fullName =
      (typeof user.user_metadata.full_name === "string" &&
        user.user_metadata.full_name) ||
      user.email?.split("@")[0] ||
      (effectiveRole === "parent" ? "Parent" : "Student");
    const email = user.email ?? "";

    if (effectiveRole === "student") {
      const { data: existingProfile } = await supabase
        .from("student_profiles")
        .select("*")
        .eq("user_id", user.id)
        .maybeSingle();

      if (!existingProfile) {
        await createStudentProfile({ userId: user.id, fullName, email });
      }

      const profile =
        existingProfile ??
        (
          await supabase
            .from("student_profiles")
            .select("*")
            .eq("user_id", user.id)
            .maybeSingle()
        ).data;

      redirectPath = getPostAuthRedirectPath({
        id: user.id,
        email: user.email ?? null,
        role: "student",
        studentProfile: profile ?? null,
        parentProfile: null,
      });
    }

    if (effectiveRole === "parent") {
      const { data: existingProfile } = await supabase
        .from("parent_profiles")
        .select("*")
        .eq("user_id", user.id)
        .maybeSingle();

      if (!existingProfile) {
        await createParentProfile({ userId: user.id, fullName, email });
      }

      redirectPath = "/parent";
    }

    if (effectiveRole === "super_admin") {
      redirectPath = "/admin";
    }

    if (effectiveRole === "support") {
      redirectPath = "/admin/support";
    }
  } catch (callbackError) {
    if (isNewAccount) {
      await rollbackFailedSignup({
        userId: user.id,
        role: signupRole,
        inviteCode: inviteParam ?? undefined,
      });
    }

    const message =
      callbackError instanceof Error ? callbackError.message : "oauth_failed";
    return NextResponse.redirect(
      new URL(`/signup?error=${encodeURIComponent(message)}`, requestUrl.origin),
    );
  }

  return NextResponse.redirect(new URL(redirectPath, requestUrl.origin));
}
