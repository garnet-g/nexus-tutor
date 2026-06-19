"use client";

import { useActionState, useEffect, useRef, useState, type FormEvent } from "react";
import Link from "next/link";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import { Button } from "@/components/ui/Button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import { FieldError } from "@/components/ui/field-error";
import { FormStatus } from "@/components/ui/form-status";
import { Input } from "@/components/ui/Input";
import { Separator } from "@/components/ui/separator";
import { track } from "@/lib/analytics/track";
import { cn } from "@/lib/utils";
import {
  loginAction,
  signInWithGoogleAction,
  signupAction,
  type AuthActionState,
} from "@/server/actions/authActions";

type AuthMode = "login" | "signup";

interface AuthFormProps {
  mode: AuthMode;
  role?: "student" | "parent";
  betaInviteRequired?: boolean;
}

const initialState: AuthActionState = {};

export function AuthForm({
  mode,
  role = "student",
  betaInviteRequired = false,
}: AuthFormProps) {
  const action = mode === "login" ? loginAction : signupAction;
  const [state, formAction, isPending] = useActionState(action, initialState);
  const [fieldErrors, setFieldErrors] = useState<{
    fullName?: string;
    inviteCode?: string;
    email?: string;
    password?: string;
  }>({});
  const [isGooglePending, setIsGooglePending] = useState(false);
  const lastPending = useRef(false);

  useEffect(() => {
    if (!lastPending.current && isPending) {
      track("form_submit_started", { form: "auth", mode, role });
    }

    if (lastPending.current && !isPending) {
      if (state.error) {
        track("form_submit_failed", { form: "auth", mode, role });
        track("api_error_shown", { form: "auth", mode, message: state.error });
      } else if (state.success) {
        track("form_submit_succeeded", { form: "auth", mode, role });
      }
    }

    lastPending.current = isPending;
  }, [isPending, mode, role, state.error, state.success]);

  function validateFields(formData: FormData) {
    const nextErrors: typeof fieldErrors = {};
    const email = String(formData.get("email") ?? "").trim();
    const password = String(formData.get("password") ?? "");
    const fullName = String(formData.get("fullName") ?? "").trim();
    const inviteCode = String(formData.get("inviteCode") ?? "").trim();

    if (mode === "signup" && !fullName) {
      nextErrors.fullName = "Full name is required.";
    }
    if (mode === "signup" && betaInviteRequired && !inviteCode) {
      nextErrors.inviteCode = "Invite code is required.";
    }
    if (!email) {
      nextErrors.email = "Email is required.";
    }
    if (!password) {
      nextErrors.password = "Password is required.";
    } else if (mode === "signup" && password.length < 8) {
      nextErrors.password = "Password must be at least 8 characters.";
    }

    setFieldErrors(nextErrors);
    return Object.keys(nextErrors).length === 0;
  }

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    if (!validateFields(new FormData(event.currentTarget))) {
      event.preventDefault();
    }
  }

  async function handleGoogleSignIn() {
    if (isGooglePending) {
      return;
    }
    setIsGooglePending(true);
    track("cta_clicked", { location: "auth_form", action: "google_sign_in", role });
    try {
      await signInWithGoogleAction(role);
    } finally {
      setIsGooglePending(false);
    }
  }

  return (
    <Card className="mx-auto w-full max-w-md nexus-card-elevated">
      <CardHeader className="items-center text-center">
        <div className="mx-auto flex size-14 items-center justify-center rounded-2xl bg-primary/10 font-heading text-xl font-bold text-primary">
          N
        </div>
        <CardTitle className="font-heading text-2xl">
          {mode === "login" ? "Welcome back" : "Join Nexus"}
        </CardTitle>
        <CardDescription>
          {mode === "login"
            ? "Sign in to continue your learning journey."
            : betaInviteRequired
              ? `Create your ${role} account with a beta invite code.`
              : `Create your ${role} account — free forever.`}
        </CardDescription>
      </CardHeader>

      <CardContent className="flex flex-col gap-6">
        {mode === "signup" ? (
          <div className="flex rounded-xl border border-border bg-muted p-1 text-sm">
            <Link
              href="/signup"
              className={cn(
                "flex-1 rounded-lg py-2 text-center font-medium transition-colors",
                role === "student"
                  ? "bg-card text-foreground shadow-sm"
                  : "text-muted-foreground hover:text-foreground",
              )}
            >
              Student
            </Link>
            <Link
              href="/signup?role=parent"
              className={cn(
                "flex-1 rounded-lg py-2 text-center font-medium transition-colors",
                role === "parent"
                  ? "bg-card text-foreground shadow-sm"
                  : "text-muted-foreground hover:text-foreground",
              )}
            >
              Parent
            </Link>
          </div>
        ) : null}

        <form action={formAction} onSubmit={handleSubmit} className="flex flex-col gap-4">
          {mode === "signup" && (
            <>
              <input type="hidden" name="role" value={role} />
              <div className="flex flex-col gap-2">
                <label htmlFor="fullName" className="text-sm font-medium text-foreground">
                  Full name
                </label>
                <Input
                  id="fullName"
                  name="fullName"
                  type="text"
                  required
                  autoComplete="name"
                  placeholder="Your full name"
                  aria-invalid={fieldErrors.fullName ? "true" : "false"}
                  aria-describedby={fieldErrors.fullName ? "fullName-error" : undefined}
                />
                <FieldError id="fullName-error" message={fieldErrors.fullName} />
              </div>
              {betaInviteRequired ? (
                <div className="flex flex-col gap-2">
                  <label htmlFor="inviteCode" className="text-sm font-medium text-foreground">
                    Beta invite code
                  </label>
                  <Input
                    id="inviteCode"
                    name="inviteCode"
                    type="text"
                    required
                    autoComplete="off"
                    placeholder="BETA-XXXXXX"
                    aria-invalid={fieldErrors.inviteCode ? "true" : "false"}
                    aria-describedby={
                      fieldErrors.inviteCode ? "inviteCode-error" : undefined
                    }
                  />
                  <FieldError id="inviteCode-error" message={fieldErrors.inviteCode} />
                </div>
              ) : null}
            </>
          )}

          <div className="flex flex-col gap-2">
            <label htmlFor="email" className="text-sm font-medium text-foreground">
              Email
            </label>
            <Input
              id="email"
              name="email"
              type="email"
              required
              autoComplete="email"
              placeholder="you@example.com"
              aria-invalid={fieldErrors.email ? "true" : "false"}
              aria-describedby={fieldErrors.email ? "email-error" : undefined}
            />
            <FieldError id="email-error" message={fieldErrors.email} />
          </div>

          <div className="flex flex-col gap-2">
            <label htmlFor="password" className="text-sm font-medium text-foreground">
              Password
            </label>
            <Input
              id="password"
              name="password"
              type="password"
              required
              autoComplete={mode === "login" ? "current-password" : "new-password"}
              minLength={mode === "signup" ? 8 : undefined}
              placeholder="••••••••"
              aria-invalid={fieldErrors.password ? "true" : "false"}
              aria-describedby={fieldErrors.password ? "password-error" : undefined}
            />
            <FieldError id="password-error" message={fieldErrors.password} />
          </div>

          <FormStatus message={state.error} tone="error" />

          <AsyncActionButton
            type="submit"
            fullWidth
            isPending={isPending}
            idleLabel={mode === "login" ? "Sign in" : "Create account"}
          />
        </form>

        {mode === "signup" && !betaInviteRequired ? (
          <>
            <div className="relative">
              <Separator />
              <span className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-card px-2 text-xs uppercase text-muted-foreground">
                Or continue with
              </span>
            </div>

            <Button
              type="button"
              variant="outline"
              fullWidth
              onClick={handleGoogleSignIn}
              disabled={isGooglePending}
              aria-busy={isGooglePending}
            >
              {isGooglePending ? "Redirecting to Google..." : "Continue with Google"}
            </Button>
          </>
        ) : null}

        <p className="text-center text-sm text-muted-foreground">
          {mode === "login" ? (
            <>
              Don&apos;t have an account?{" "}
              <Link
                href={role === "parent" ? "/signup?role=parent" : "/signup"}
                className="font-medium text-primary underline-offset-4 hover:underline"
              >
                Sign up
              </Link>
            </>
          ) : (
            <>
              Already have an account?{" "}
              <Link
                href={role === "parent" ? "/login?role=parent" : "/login"}
                className="font-medium text-primary underline-offset-4 hover:underline"
              >
                Sign in
              </Link>
            </>
          )}
        </p>

        {mode === "signup" && role === "student" ? (
          <p className="text-center text-sm text-muted-foreground">
            Are you a teacher?{" "}
            <Link
              href="/waitlist/teacher"
              className="font-medium text-primary underline-offset-4 hover:underline"
            >
              Join the teacher waitlist
            </Link>
          </p>
        ) : null}
      </CardContent>
    </Card>
  );
}
