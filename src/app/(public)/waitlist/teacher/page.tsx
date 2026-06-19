"use client";

import { useState } from "react";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import { FieldError } from "@/components/ui/field-error";
import { FormStatus } from "@/components/ui/form-status";
import { MarketingSection } from "@/features/marketing/components/PublicShell";
import { track } from "@/lib/analytics/track";

export default function TeacherWaitlistPage() {
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [schoolName, setSchoolName] = useState("");
  const [curriculum, setCurriculum] = useState<"CBC" | "KCSE" | "">("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [fieldErrors, setFieldErrors] = useState<{
    fullName?: string;
    email?: string;
    schoolName?: string;
  }>({});

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const nextFieldErrors: typeof fieldErrors = {};
    if (!fullName.trim()) {
      nextFieldErrors.fullName = "Full name is required.";
    }
    if (!email.trim()) {
      nextFieldErrors.email = "Email is required.";
    }
    if (!schoolName.trim()) {
      nextFieldErrors.schoolName = "School name is required.";
    }
    setFieldErrors(nextFieldErrors);
    if (Object.keys(nextFieldErrors).length > 0) {
      return;
    }

    setLoading(true);
    setError(null);
    track("form_submit_started", { form: "teacher_waitlist" });

    try {
      const response = await fetch("/api/waitlist/teacher", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          fullName,
          email,
          schoolName,
          ...(curriculum ? { curriculum } : {}),
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { alreadyRegistered: boolean };
        error?: { code?: string; message?: string; details?: unknown };
      };

      if (!response.ok || !payload.success) {
        throw new Error(payload.error?.message ?? "Could not join waitlist.");
      }

      track("form_submit_succeeded", {
        form: "teacher_waitlist",
        alreadyRegistered: payload.data?.alreadyRegistered ?? false,
      });
      setSubmitted(true);
    } catch (submitError) {
      const message =
        submitError instanceof Error
          ? submitError.message
          : "Something went wrong.";
      setError(message);
      track("form_submit_failed", { form: "teacher_waitlist" });
      track("api_error_shown", { form: "teacher_waitlist", message });
    } finally {
      setLoading(false);
    }
  }

  return (
    <MarketingSection className="py-16">
      <div className="mx-auto w-full max-w-lg px-4">
        <Card className="nexus-card-elevated">
          <CardHeader>
            <CardTitle as="h1" className="font-heading text-2xl">
              Teacher waitlist
            </CardTitle>
            <CardDescription>
              Nexus is building teacher tools for CBC classrooms. Join the
              waitlist and we will notify you when early access opens.
            </CardDescription>
          </CardHeader>
          <CardContent>
            {submitted ? (
              <p className="text-sm text-muted-foreground">
                Thank you — you are on the waitlist. We will be in touch.
              </p>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
                <label className="block text-sm text-muted-foreground">
                  Full name
                  <input
                    required
                    value={fullName}
                    onChange={(event) => setFullName(event.target.value)}
                    className={inputClassName}
                    aria-invalid={fieldErrors.fullName ? "true" : "false"}
                    aria-describedby={
                      fieldErrors.fullName ? "waitlist-fullName-error" : undefined
                    }
                  />
                  <FieldError id="waitlist-fullName-error" message={fieldErrors.fullName} />
                </label>
                <label className="block text-sm text-muted-foreground">
                  Email
                  <input
                    required
                    type="email"
                    value={email}
                    onChange={(event) => setEmail(event.target.value)}
                    className={inputClassName}
                    aria-invalid={fieldErrors.email ? "true" : "false"}
                    aria-describedby={fieldErrors.email ? "waitlist-email-error" : undefined}
                  />
                  <FieldError id="waitlist-email-error" message={fieldErrors.email} />
                </label>
                <label className="block text-sm text-muted-foreground">
                  School name
                  <input
                    required
                    value={schoolName}
                    onChange={(event) => setSchoolName(event.target.value)}
                    className={inputClassName}
                    aria-invalid={fieldErrors.schoolName ? "true" : "false"}
                    aria-describedby={
                      fieldErrors.schoolName ? "waitlist-schoolName-error" : undefined
                    }
                  />
                  <FieldError
                    id="waitlist-schoolName-error"
                    message={fieldErrors.schoolName}
                  />
                </label>
                <label className="block text-sm text-muted-foreground">
                  Curriculum <span className="text-xs">(optional)</span>
                  <select
                    value={curriculum}
                    onChange={(event) =>
                      setCurriculum(event.target.value as "CBC" | "KCSE" | "")
                    }
                    className={inputClassName}
                  >
                    <option value="">Select curriculum</option>
                    <option value="CBC">CBC</option>
                    <option value="KCSE">KCSE</option>
                  </select>
                </label>
                <FormStatus message={error} tone="error" className="text-nexus-danger" />
                <AsyncActionButton
                  type="submit"
                  fullWidth
                  isPending={loading}
                  idleLabel="Join waitlist"
                  pendingLabel="Joining..."
                />
              </form>
            )}
          </CardContent>
        </Card>
      </div>
    </MarketingSection>
  );
}

const inputClassName =
  "mt-2 flex h-11 w-full rounded-lg border border-border bg-card px-3 text-sm text-foreground outline-none transition-colors placeholder:text-muted-foreground focus:border-ring";
