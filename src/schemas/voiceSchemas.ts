import { z } from "zod";

import { nexModeSchema } from "@/schemas/nexSchemas";

export const VOICE_MAX_BYTES = 2 * 1024 * 1024;
export const VOICE_MAX_DURATION_SECONDS = 30;

export const VOICE_ALLOWED_MIME_TYPES = [
  "audio/webm",
  "audio/webm;codecs=opus",
  "audio/ogg",
  "audio/ogg;codecs=opus",
  "audio/mp4",
  "audio/mpeg",
] as const;

export type VoiceMimeType = (typeof VOICE_ALLOWED_MIME_TYPES)[number];

export const voiceUploadFieldsSchema = z.object({
  sessionMode: nexModeSchema.optional(),
  nexSessionId: z.string().uuid().optional(),
  topicId: z.string().uuid().optional().nullable(),
  durationSeconds: z.coerce.number().min(0).max(VOICE_MAX_DURATION_SECONDS).optional(),
});

export type VoiceUploadFields = z.infer<typeof voiceUploadFieldsSchema>;

export function normalizeVoiceMimeType(value: string): string {
  return value.split(";")[0]?.trim().toLowerCase() ?? value;
}

export function isVoiceMimeType(value: string): boolean {
  const normalized = value.toLowerCase();
  const normalizedBase = normalizeVoiceMimeType(normalized);

  return VOICE_ALLOWED_MIME_TYPES.some((allowed) => {
    const allowedBase = normalizeVoiceMimeType(allowed);
    return normalized === allowed || normalizedBase === allowedBase;
  });
}

export function studentHasVoiceAccess(planCode: string): boolean {
  return planCode === "premium" || planCode === "family";
}
