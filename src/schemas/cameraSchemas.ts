import { z } from "zod";

export const CAMERA_MODES = ["homework", "explain"] as const;

export type CameraMode = (typeof CAMERA_MODES)[number];

export const cameraModeSchema = z.enum(CAMERA_MODES);

export const cameraUploadFieldsSchema = z.object({
  sessionMode: cameraModeSchema,
  nexSessionId: z.string().uuid().optional(),
  topicId: z.string().uuid().optional().nullable(),
});

export type CameraUploadFields = z.infer<typeof cameraUploadFieldsSchema>;

export const CAMERA_MAX_BYTES = 5 * 1024 * 1024;

export const CAMERA_ALLOWED_MIME_TYPES = [
  "image/jpeg",
  "image/png",
  "image/webp",
] as const;

export type CameraMimeType = (typeof CAMERA_ALLOWED_MIME_TYPES)[number];

export function isCameraMimeType(value: string): value is CameraMimeType {
  return (CAMERA_ALLOWED_MIME_TYPES as readonly string[]).includes(value);
}

export function studentHasCameraAccess(planCode: string): boolean {
  return planCode === "premium" || planCode === "family";
}
