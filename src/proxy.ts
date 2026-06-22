import { createServerClient } from "@supabase/ssr";

import { NextResponse, type NextRequest } from "next/server";



type UserRole = "student" | "parent" | "super_admin" | "support";



async function getAuthContext(request: NextRequest, response: NextResponse) {

  const supabase = createServerClient(

    process.env.NEXT_PUBLIC_SUPABASE_URL!,

    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,

    {

      cookies: {

        getAll() {

          return request.cookies.getAll();

        },

        setAll(cookiesToSet) {

          cookiesToSet.forEach(({ name, value, options }) => {

            request.cookies.set(name, value);

            response.cookies.set(name, value, options);

          });

        },

      },

    },

  );



  const {

    data: { user },

  } = await supabase.auth.getUser();



  const role = user?.app_metadata?.userRole as UserRole | undefined;



  let studentOnboardingComplete = true;

  let hasCompletedDiagnostic = true;



  if (user && role === "student") {

    const { data: profile } = await supabase

      .from("student_profiles")

      .select("grade_level, has_completed_diagnostic")

      .eq("user_id", user.id)

      .maybeSingle();



    studentOnboardingComplete =

      Boolean(profile?.grade_level && profile.grade_level.trim().length > 0);

    hasCompletedDiagnostic = Boolean(profile?.has_completed_diagnostic);

  }



  return {

    user,

    role: role ?? null,

    studentOnboardingComplete,

    hasCompletedDiagnostic,

  };

}



export async function proxy(request: NextRequest) {

  const { pathname } = request.nextUrl;

  const response = NextResponse.next({

    request,

  });



  const {

    user,

    role,

    studentOnboardingComplete,

    hasCompletedDiagnostic,

  } = await getAuthContext(request, response);



  const isPublicAuthRoute =

    pathname === "/login" ||

    pathname === "/signup" ||

    pathname.startsWith("/auth/");



  const isStudentRoute =

    pathname.startsWith("/dashboard") ||

    pathname.startsWith("/onboarding") ||

    pathname.startsWith("/diagnostic") ||

    pathname.startsWith("/learn") ||

    pathname.startsWith("/nex") ||

    pathname.startsWith("/practice") ||

    pathname.startsWith("/assignment-help") ||

    pathname.startsWith("/exam-prep") ||

    pathname.startsWith("/mock-exams") ||

    pathname.startsWith("/exam-simulator") ||

    pathname.startsWith("/progress") ||

    pathname.startsWith("/revision") ||

    pathname.startsWith("/study-plan") ||

    pathname.startsWith("/profile");



  const isParentRoute = pathname.startsWith("/parent");

  const isSuperAdminRoute = pathname.startsWith("/admin");



  const requiresDiagnostic =

    studentOnboardingComplete &&

    !hasCompletedDiagnostic &&

    (pathname.startsWith("/dashboard") ||

      pathname.startsWith("/practice") ||

      pathname.startsWith("/assignment-help") ||

      pathname.startsWith("/exam-prep") ||

      pathname.startsWith("/mock-exams") ||

      pathname.startsWith("/exam-simulator") ||

      pathname.startsWith("/progress") ||

      pathname.startsWith("/revision") ||

      pathname.startsWith("/study-plan"));



  if (isPublicAuthRoute && user && role) {

    const redirectPath =

      role === "super_admin" || role === "support"

        ? "/admin/platform-settings"

        : role === "parent"

          ? "/parent"

          : !studentOnboardingComplete

            ? "/onboarding"

            : !hasCompletedDiagnostic

              ? "/diagnostic"

              : "/dashboard";



    return NextResponse.redirect(new URL(redirectPath, request.url));

  }



  if (isStudentRoute) {

    if (!user) {

      return NextResponse.redirect(new URL("/login", request.url));

    }



    if (role !== "student") {

      return NextResponse.redirect(new URL("/login", request.url));

    }



    if (

      !studentOnboardingComplete &&

      pathname !== "/onboarding" &&

      !pathname.startsWith("/auth/")

    ) {

      return NextResponse.redirect(new URL("/onboarding", request.url));

    }



    if (studentOnboardingComplete && pathname === "/onboarding") {

      return NextResponse.redirect(

        new URL(

          hasCompletedDiagnostic ? "/dashboard" : "/diagnostic",

          request.url,

        ),

      );

    }



    if (requiresDiagnostic) {

      return NextResponse.redirect(new URL("/diagnostic", request.url));

    }



    if (

      hasCompletedDiagnostic &&

      pathname.startsWith("/diagnostic")

    ) {

      return NextResponse.redirect(new URL("/dashboard", request.url));

    }

  }



  if (isParentRoute) {

    if (!user) {

      return NextResponse.redirect(new URL("/login", request.url));

    }



    if (role !== "parent") {

      return NextResponse.redirect(new URL("/login", request.url));

    }

  }



  if (isSuperAdminRoute) {

    if (!user) {

      return NextResponse.redirect(new URL("/login", request.url));

    }



    if (role !== "super_admin" && role !== "support") {

      return NextResponse.redirect(new URL("/login", request.url));

    }

  }



  return response;

}



export const config = {

  matcher: [

    "/dashboard/:path*",

    "/onboarding/:path*",

    "/diagnostic/:path*",

    "/practice/:path*",

    "/assignment-help/:path*",

    "/exam-prep/:path*",

    "/mock-exams/:path*",

    "/exam-simulator/:path*",

    "/progress/:path*",

    "/revision/:path*",

    "/study-plan/:path*",

    "/profile/:path*",

    "/learn/:path*",

    "/nex/:path*",

    "/parent/:path*",

    "/admin/:path*",

    "/login",

    "/signup",

    "/auth/:path*",

  ],

};

