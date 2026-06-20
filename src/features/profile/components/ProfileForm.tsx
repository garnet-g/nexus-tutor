"use client";



import { useActionState, useEffect, useRef } from "react";



import { AsyncActionButton } from "@/components/ui/async-action-button";
import { FieldError } from "@/components/ui/field-error";
import { FormStatus } from "@/components/ui/form-status";
import { SectionCard } from "@/components/ui/SectionCard";
import { Button } from "@/components/ui/Button";

import { track } from "@/lib/analytics/track";

import {

  DEFAULT_LEARNING_PREFERENCES,

  parseLearningPreferencesFromDb,

  type LearningPreferences,

} from "@/schemas/profileSchemas";

import {

  updateProfileAction,

  type ProfileActionState,

} from "@/server/actions/profileActions";

import { signOutAction } from "@/server/actions/authActions";

import type { StudentProfile } from "@/types/database";



interface ProfileFormProps {

  profile: StudentProfile;

  planCode: string;

  familyInviteCode: string | null;

  familyMembers: Array<{ studentId: string; fullName: string; joinedAt: string }>;

}



const initialState: ProfileActionState = {};



const inputClassName =

  "mt-1 min-h-12 w-full rounded-lg border border-border bg-card px-3 text-sm text-foreground outline-none transition-colors focus:border-ring";



export function ProfileForm({

  profile,

  planCode,

  familyInviteCode,

  familyMembers,

}: ProfileFormProps) {

  const [state, formAction, pending] = useActionState(

    updateProfileAction,

    initialState,

  );

  const lastPending = useRef(false);

  const preferences: LearningPreferences = parseLearningPreferencesFromDb(

    profile.learning_preferences ?? DEFAULT_LEARNING_PREFERENCES,

  );



  useEffect(() => {

    if (!lastPending.current && pending) {

      track("form_submit_started", { form: "profile" });

    }



    if (lastPending.current && !pending) {

      if (state.error) {

        track("form_submit_failed", { form: "profile" });

        track("api_error_shown", { form: "profile", message: state.error });

      } else if (state.success) {

        track("form_submit_succeeded", { form: "profile" });

      }

    }



    lastPending.current = pending;

  }, [pending, state.error, state.success]);



  return (

    <div className="space-y-6 sm:space-y-8">

      <SectionCard
        title="Edit profile"
        description="Update your details and how Nex teaches you."
      >

      <form

        action={formAction}

        className="space-y-6"

      >



        <FormStatus

          message={state.error}

          tone="error"

        />

        {state.success ? (

          <FormStatus message="Profile updated." tone="success" />

        ) : null}



        <div className="space-y-4">

          <label className="block text-sm text-muted-foreground">

            Full name

            <input

              name="fullName"

              defaultValue={profile.full_name}

              required

              className={inputClassName}

              aria-invalid={state.fieldErrors?.fullName ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.fullName ? "profile-fullName-error" : undefined

              }

            />

            <FieldError

              id="profile-fullName-error"

              message={state.fieldErrors?.fullName}

            />

          </label>



          <label className="block text-sm text-muted-foreground">

            School

            <input

              name="schoolName"

              defaultValue={profile.school_name ?? ""}

              className={inputClassName}

            />

          </label>



          <label className="block text-sm text-muted-foreground">

            Target grade

            <input

              name="targetGrade"

              defaultValue={profile.target_grade ?? ""}

              required

              className={inputClassName}

              aria-invalid={state.fieldErrors?.targetGrade ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.targetGrade ? "profile-targetGrade-error" : undefined

              }

            />

            <FieldError

              id="profile-targetGrade-error"

              message={state.fieldErrors?.targetGrade}

            />

          </label>



          <label className="block text-sm text-muted-foreground">

            Phone (+254)

            <input

              name="phoneNumber"

              defaultValue={profile.phone_number ?? ""}

              placeholder="+254712345678"

              className={inputClassName}

              aria-invalid={state.fieldErrors?.phoneNumber ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.phoneNumber ? "profile-phoneNumber-error" : undefined

              }

            />

            <FieldError

              id="profile-phoneNumber-error"

              message={state.fieldErrors?.phoneNumber}

            />

          </label>

        </div>



        <fieldset className="space-y-4 border-t border-border pt-4">

          <legend className="text-base font-semibold text-foreground">

            Learning preferences

          </legend>

          <p className="text-sm text-muted-foreground">

            Nex adapts explanations and pacing to match how you like to learn.

          </p>



          <label className="block text-sm text-muted-foreground">

            Explanation depth

            <select

              name="explanationDepth"

              defaultValue={preferences.explanationDepth}

              className={inputClassName}

              aria-invalid={state.fieldErrors?.explanationDepth ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.explanationDepth

                  ? "profile-explanationDepth-error"

                  : undefined

              }

            >

              <option value="quick">Quick — key points only</option>

              <option value="standard">Standard — balanced detail</option>

              <option value="detailed">Detailed — thorough walkthroughs</option>

            </select>

            <FieldError

              id="profile-explanationDepth-error"

              message={state.fieldErrors?.explanationDepth}

            />

          </label>



          <label className="block text-sm text-muted-foreground">

            Session goal (minutes)

            <input

              name="sessionGoalMinutes"

              type="number"

              min={5}

              max={120}

              step={5}

              defaultValue={preferences.sessionGoalMinutes}

              className={inputClassName}

              aria-invalid={state.fieldErrors?.sessionGoalMinutes ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.sessionGoalMinutes

                  ? "profile-sessionGoalMinutes-error"

                  : undefined

              }

            />

            <FieldError

              id="profile-sessionGoalMinutes-error"

              message={state.fieldErrors?.sessionGoalMinutes}

            />

          </label>



          <label className="block text-sm text-muted-foreground">

            Reminder channel

            <select

              name="reminderChannel"

              defaultValue={preferences.reminderChannel}

              className={inputClassName}

              aria-invalid={state.fieldErrors?.reminderChannel ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.reminderChannel

                  ? "profile-reminderChannel-error"

                  : undefined

              }

            >

              <option value="off">Off</option>

              <option value="sms">SMS</option>

              <option value="email">Email</option>

            </select>

            <FieldError

              id="profile-reminderChannel-error"

              message={state.fieldErrors?.reminderChannel}

            />

          </label>



          <label className="block text-sm text-muted-foreground">

            Learning tone <span className="text-xs">(optional)</span>

            <select

              name="learningTone"

              defaultValue={preferences.learningTone ?? ""}

              className={inputClassName}

              aria-invalid={state.fieldErrors?.learningTone ? "true" : "false"}

              aria-describedby={

                state.fieldErrors?.learningTone

                  ? "profile-learningTone-error"

                  : undefined

              }

            >

              <option value="">No preference</option>

              <option value="friendly">Friendly</option>

              <option value="focused">Focused</option>

              <option value="encouraging">Encouraging</option>

            </select>

            <FieldError

              id="profile-learningTone-error"

              message={state.fieldErrors?.learningTone}

            />

          </label>

        </fieldset>



        <AsyncActionButton

          type="submit"

          fullWidth

          isPending={pending}

          idleLabel="Save changes"

          pendingLabel="Saving…"

          className="min-h-12 sm:w-auto"

        />

      </form>
      </SectionCard>



      {planCode === "family" && familyInviteCode ? (

        <SectionCard title="Family plan">

          <p className="mt-2 text-sm text-muted-foreground">

            Share this code so up to 4 students can join your family plan:

          </p>

          <p className="mt-3 rounded-lg bg-muted px-4 py-3 font-mono text-lg font-semibold text-primary">

            {familyInviteCode}

          </p>

          {familyMembers.length > 0 ? (

            <ul className="mt-4 space-y-2 text-sm">

              {familyMembers.map((member) => (

                <li key={member.studentId} className="text-foreground">

                  {member.fullName}

                </li>

              ))}

            </ul>

          ) : null}

        </SectionCard>

      ) : null}



      {planCode === "free" || planCode === "premium" ? (

        <FamilyJoinSection />

      ) : null}



      <form action={signOutAction}>

        <Button

          type="submit"

          variant="outline"

          className="min-h-12 w-full sm:w-auto"

        >

          Sign out

        </Button>

      </form>

    </div>

  );

}



function FamilyJoinSection() {

  return (

    <SectionCard
      title="Join a family plan"
      description="Enter a family invite code from the plan owner."
    >

      <form

        className="mt-4 flex flex-col gap-3 sm:flex-row"

        onSubmit={async (event) => {

          event.preventDefault();

          const form = event.currentTarget;

          const inviteCode = new FormData(form).get("inviteCode") as string;

          const response = await fetch("/api/family/join", {

            method: "POST",

            headers: { "Content-Type": "application/json" },

            body: JSON.stringify({ inviteCode }),

          });

          const result = await response.json();

          if (result.success) {

            window.location.reload();

          } else {

            alert(result.error ?? "Could not join family plan");

          }

        }}

      >

        <input

          name="inviteCode"

          placeholder="FAMILY-ABC123"

          required

          className="min-h-12 flex-1 rounded-lg border border-border px-3 uppercase"

        />

        <button

          type="submit"

          className="min-h-12 rounded-lg bg-primary px-4 py-2 font-medium text-primary-foreground"

        >

          Join

        </button>

      </form>

    </SectionCard>

  );

}


