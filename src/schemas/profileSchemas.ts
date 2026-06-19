import { z } from "zod";



export const explanationDepthSchema = z.enum(["quick", "standard", "detailed"]);



export const reminderChannelSchema = z.enum(["sms", "email", "off"]);



export const learningToneSchema = z.enum(["friendly", "focused", "encouraging"]);



export const learningPreferencesSchema = z.object({

  explanationDepth: explanationDepthSchema,

  sessionGoalMinutes: z.coerce

    .number()

    .int("Session goal must be a whole number")

    .min(5, "Session goal must be at least 5 minutes")

    .max(120, "Session goal must be at most 120 minutes"),

  reminderChannel: reminderChannelSchema,

  learningTone: learningToneSchema.optional(),

});



export type LearningPreferences = z.infer<typeof learningPreferencesSchema>;



export const DEFAULT_LEARNING_PREFERENCES: LearningPreferences = {

  explanationDepth: "standard",

  sessionGoalMinutes: 20,

  reminderChannel: "off",

};



export const profileUpdateSchema = z.object({

  fullName: z.string().min(2, "Name must be at least 2 characters"),

  schoolName: z.string().max(200).optional(),

  targetGrade: z.string().min(1, "Target grade is required"),

  phoneNumber: z

    .string()

    .regex(/^(\+254\d{9})?$/, "Use +254 format, e.g. +254712345678")

    .optional()

    .or(z.literal("")),

  learningPreferences: learningPreferencesSchema.optional(),

});



export function parseLearningPreferencesFromDb(

  raw: unknown,

): LearningPreferences {

  const parsed = learningPreferencesSchema.safeParse(raw);

  if (parsed.success) {

    return parsed.data;

  }



  return { ...DEFAULT_LEARNING_PREFERENCES };

}



export function learningPreferencesToDb(

  preferences: LearningPreferences,

): Record<string, unknown> {

  const payload: Record<string, unknown> = {

    explanationDepth: preferences.explanationDepth,

    sessionGoalMinutes: preferences.sessionGoalMinutes,

    reminderChannel: preferences.reminderChannel,

  };



  if (preferences.learningTone) {

    payload.learningTone = preferences.learningTone;

  }



  return payload;

}



export function parseLearningPreferencesFromFormData(

  formData: FormData,

) {

  const toneRaw = formData.get("learningTone");

  const learningTone =

    typeof toneRaw === "string" && toneRaw.length > 0 ? toneRaw : undefined;



  return learningPreferencesSchema.safeParse({

    explanationDepth: formData.get("explanationDepth"),

    sessionGoalMinutes: formData.get("sessionGoalMinutes"),

    reminderChannel: formData.get("reminderChannel"),

    ...(learningTone ? { learningTone } : {}),

  });

}



export function buildLearningPreferenceHints(

  preferences: LearningPreferences,

): string {

  const depthHints: Record<LearningPreferences["explanationDepth"], string> = {

    quick: "Keep explanations concise — key points only, minimal elaboration.",

    standard:

      "Use balanced explanations with one clear example per concept.",

    detailed:

      "Provide thorough explanations with multiple examples and step-by-step reasoning.",

  };



  const toneHints: Record<NonNullable<LearningPreferences["learningTone"]>, string> =

    {

      friendly: "Use a warm, conversational tone.",

      focused: "Stay direct and task-oriented.",

      encouraging: "Emphasize encouragement and growth mindset language.",

    };



  const lines = [

    "STUDENT LEARNING PREFERENCES:",

    `- Explanation depth: ${preferences.explanationDepth} — ${depthHints[preferences.explanationDepth]}`,

    `- Typical session goal: ${preferences.sessionGoalMinutes} minutes — pace responses accordingly.`,

    `- Reminder channel preference: ${preferences.reminderChannel} (product context only — do not mention unless relevant).`,

  ];



  if (preferences.learningTone) {

    lines.push(

      `- Preferred tone: ${preferences.learningTone} — ${toneHints[preferences.learningTone]}`,

    );

  }



  return lines.join("\n");

}


