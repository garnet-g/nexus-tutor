"use client";

import {
  useActionState,
  useEffect,
  useMemo,
  useRef,
  useState,
  type FormEvent,
} from "react";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import { FieldError } from "@/components/ui/field-error";
import { FormStatus } from "@/components/ui/form-status";
import { track } from "@/lib/analytics/track";
import { cn } from "@/lib/utils";
import {
  completeOnboardingAction,
  type OnboardingActionState,
} from "@/server/actions/onboardingActions";

const GRADE_OPTIONS = {
  CBC: [
    "Grade 4",
    "Grade 5",
    "Grade 6",
    "Grade 7",
    "Grade 8",
    "Grade 9",
  ],
  KCSE: ["Form 1", "Form 2", "Form 3", "Form 4"],
} as const;

const TARGET_GRADE_OPTIONS = ["A", "A-", "B+", "B", "B-", "C+", "C", "C-"];

const initialState: OnboardingActionState = {};

export function OnboardingForm() {
  const [curriculum, setCurriculum] = useState<"CBC" | "KCSE">("CBC");
  const [state, formAction, isPending] = useActionState(
    completeOnboardingAction,
    initialState,
  );
  const [fieldErrors, setFieldErrors] = useState<{
    curriculum?: string;
    gradeLevel?: string;
    targetGrade?: string;
  }>({});
  const [submitStarted, setSubmitStarted] = useState(false);
  const [submitPassedClientValidation, setSubmitPassedClientValidation] =
    useState(false);
  const lastPending = useRef(false);

  const gradeOptions = useMemo(() => GRADE_OPTIONS[curriculum], [curriculum]);

  useEffect(() => {
    if (!lastPending.current && isPending) {
      track("form_submit_started", { form: "onboarding" });
    }

    if (lastPending.current && !isPending) {
      if (state.error) {
        track("form_submit_failed", { form: "onboarding" });
        track("api_error_shown", { form: "onboarding", message: state.error });
      } else if (state.success) {
        track("form_submit_succeeded", { form: "onboarding" });
      }
    }

    lastPending.current = isPending;
  }, [isPending, state.error, state.success]);

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    setSubmitStarted(true);
    setSubmitPassedClientValidation(false);
    const formData = new FormData(event.currentTarget);
    const curriculumValue = String(formData.get("curriculum") ?? "");
    const gradeLevel = String(formData.get("gradeLevel") ?? "");
    const targetGrade = String(formData.get("targetGrade") ?? "");
    const nextErrors: typeof fieldErrors = {};

    if (!curriculumValue) {
      nextErrors.curriculum = "Select your curriculum.";
    }
    if (!gradeLevel) {
      nextErrors.gradeLevel = "Select your current grade.";
    }
    if (!targetGrade) {
      nextErrors.targetGrade = "Select your target grade.";
    }

    setFieldErrors(nextErrors);
    if (Object.keys(nextErrors).length > 0) {
      event.preventDefault();
      return;
    }
    setSubmitPassedClientValidation(true);
  }

  return (
    <div className="mx-auto w-full max-w-lg space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground">
          Set up your learning profile
        </h1>
        <p className="text-sm text-muted-foreground">
          Tell us about your curriculum and goals so Nexus can personalize your
          experience.
        </p>
      </div>

      <div className="rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-950">
        <p className="font-medium">Beta expectations</p>
        <ul className="mt-2 list-disc space-y-1 pl-5">
          <li>
            Nexus beta focuses on <strong>mathematics only</strong> — other subjects
            will arrive in later releases.
          </li>
          <li>
            Study plans, streaks, and weekly reports use{" "}
            <strong>Kenya time (EAT, UTC+3)</strong> for daily and weekly boundaries.
          </li>
        </ul>
      </div>

      <form action={formAction} onSubmit={handleSubmit} className="space-y-5">
        <div className="space-y-2">
          <label htmlFor="curriculum" className="text-sm font-medium text-foreground">
            Curriculum
          </label>
          <select
            id="curriculum"
            name="curriculum"
            value={curriculum}
            onChange={(event) =>
              setCurriculum(event.target.value as "CBC" | "KCSE")
            }
            className={inputClassName}
            aria-invalid={fieldErrors.curriculum ? "true" : "false"}
            aria-describedby={fieldErrors.curriculum ? "curriculum-error" : undefined}
          >
            <option value="CBC">CBC (Competency Based Curriculum)</option>
            <option value="KCSE">KCSE (Secondary)</option>
          </select>
          <FieldError id="curriculum-error" message={fieldErrors.curriculum} />
        </div>

        <div className="space-y-2">
          <label htmlFor="gradeLevel" className="text-sm font-medium text-foreground">
            Current grade
          </label>
          <select
            id="gradeLevel"
            name="gradeLevel"
            required
            defaultValue=""
            className={inputClassName}
            aria-invalid={fieldErrors.gradeLevel ? "true" : "false"}
            aria-describedby={fieldErrors.gradeLevel ? "gradeLevel-error" : undefined}
          >
            <option value="" disabled>
              Select your grade
            </option>
            {gradeOptions.map((grade) => (
              <option key={grade} value={grade}>
                {grade}
              </option>
            ))}
          </select>
          <FieldError id="gradeLevel-error" message={fieldErrors.gradeLevel} />
        </div>

        <div className="space-y-2">
          <label htmlFor="schoolName" className="text-sm font-medium text-foreground">
            School name <span className="text-muted-foreground">(optional)</span>
          </label>
          <input
            id="schoolName"
            name="schoolName"
            type="text"
            className={inputClassName}
            placeholder="Alliance High School"
          />
        </div>

        <div className="space-y-2">
          <label htmlFor="targetGrade" className="text-sm font-medium text-foreground">
            Target grade
          </label>
          <select
            id="targetGrade"
            name="targetGrade"
            required
            defaultValue=""
            className={inputClassName}
            aria-invalid={fieldErrors.targetGrade ? "true" : "false"}
            aria-describedby={fieldErrors.targetGrade ? "targetGrade-error" : undefined}
          >
            <option value="" disabled>
              Select your target grade
            </option>
            {TARGET_GRADE_OPTIONS.map((grade) => (
              <option key={grade} value={grade}>
                {grade}
              </option>
            ))}
          </select>
          <FieldError id="targetGrade-error" message={fieldErrors.targetGrade} />
        </div>

        <FormStatus message={state.error} tone="error" />
        <FormStatus
          message={
            submitStarted && submitPassedClientValidation && isPending
              ? "Saving your profile..."
              : null
          }
          tone="info"
        />
        <FormStatus
          message={
            submitStarted &&
            submitPassedClientValidation &&
            !isPending &&
            state.success
              ? "Profile saved. Redirecting to your dashboard..."
              : null
          }
          tone="success"
        />

        <AsyncActionButton
          type="submit"
          className={cn(
            "flex h-11 w-full items-center justify-center rounded-lg bg-primary text-sm font-medium text-primary-foreground transition-colors",
            "hover:bg-primary/90 disabled:cursor-not-allowed disabled:opacity-60",
          )}
          isPending={isPending}
          idleLabel="Continue to dashboard"
          pendingLabel="Saving..."
        />
      </form>

      <p className="text-center text-sm text-muted-foreground">
        Are you a CBC teacher?{" "}
        <a
          href="/waitlist/teacher"
          onClick={() =>
            track("cta_clicked", {
              location: "onboarding_form",
              target: "/waitlist/teacher",
            })
          }
          className="font-medium text-primary underline-offset-4 hover:underline"
        >
          Join the waitlist
        </a>
      </p>
    </div>
  );
}

const inputClassName =
  "flex h-11 w-full rounded-lg border border-border bg-card px-3 text-sm text-foreground outline-none transition-colors placeholder:text-muted-foreground focus:border-ring";
