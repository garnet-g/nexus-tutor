"use server";



import { redirect } from "next/navigation";



import { createClient } from "@/lib/supabase/server";

import {

  learningPreferencesToDb,

  parseLearningPreferencesFromFormData,

  profileUpdateSchema,

} from "@/schemas/profileSchemas";

import { getSessionUser } from "@/server/services/authService";



export type ProfileActionState = {

  error?: string;

  success?: boolean;

  fieldErrors?: {

    fullName?: string;

    targetGrade?: string;

    phoneNumber?: string;

    explanationDepth?: string;

    sessionGoalMinutes?: string;

    reminderChannel?: string;

    learningTone?: string;

  };

};



export async function updateProfileAction(

  _prevState: ProfileActionState,

  formData: FormData,

): Promise<ProfileActionState> {

  const sessionUser = await getSessionUser();



  if (!sessionUser || sessionUser.role !== "student" || !sessionUser.studentProfile) {

    return { error: "You must be signed in as a student." };

  }



  const preferencesResult = parseLearningPreferencesFromFormData(formData);

  if (!preferencesResult.success) {

    const fieldErrors: ProfileActionState["fieldErrors"] = {};

    for (const issue of preferencesResult.error.issues) {

      const field = issue.path[0];

      if (field === "explanationDepth") {

        fieldErrors.explanationDepth = issue.message;

      } else if (field === "sessionGoalMinutes") {

        fieldErrors.sessionGoalMinutes = issue.message;

      } else if (field === "reminderChannel") {

        fieldErrors.reminderChannel = issue.message;

      } else if (field === "learningTone") {

        fieldErrors.learningTone = issue.message;

      }

    }



    return {

      error: preferencesResult.error.issues[0]?.message ?? "Invalid preferences",

      fieldErrors,

    };

  }



  const parsed = profileUpdateSchema.safeParse({

    fullName: formData.get("fullName"),

    schoolName: formData.get("schoolName") ?? "",

    targetGrade: formData.get("targetGrade"),

    phoneNumber: formData.get("phoneNumber") ?? "",

    learningPreferences: preferencesResult.data,

  });



  if (!parsed.success) {

    const fieldErrors: ProfileActionState["fieldErrors"] = {};

    for (const issue of parsed.error.issues) {

      const field = issue.path[0];

      if (field === "fullName") {

        fieldErrors.fullName = issue.message;

      } else if (field === "targetGrade") {

        fieldErrors.targetGrade = issue.message;

      } else if (field === "phoneNumber") {

        fieldErrors.phoneNumber = issue.message;

      }

    }



    return {

      error: parsed.error.issues[0]?.message ?? "Invalid profile data",

      fieldErrors,

    };

  }



  const supabase = await createClient();

  const { error } = await supabase

    .from("student_profiles")

    .update({

      full_name: parsed.data.fullName,

      school_name: parsed.data.schoolName || null,

      target_grade: parsed.data.targetGrade,

      phone_number: parsed.data.phoneNumber || null,

      learning_preferences: learningPreferencesToDb(preferencesResult.data),

    })

    .eq("user_id", sessionUser.id);



  if (error) {

    return { error: error.message };

  }



  return { success: true };

}



export async function redirectToProfile(): Promise<void> {

  redirect("/profile");

}


