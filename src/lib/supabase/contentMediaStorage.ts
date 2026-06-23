import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export const CONTENT_MEDIA_BUCKET = "content-media";

export type ContentMediaUploadInput = {
  path: string;
  body: Buffer | ArrayBuffer | Blob;
  contentType: string;
  upsert?: boolean;
};

export function getContentMediaPublicUrl(path: string): string {
  const admin = createAdminClient();
  const { data } = admin.storage.from(CONTENT_MEDIA_BUCKET).getPublicUrl(path);
  return data.publicUrl;
}

export async function uploadContentMedia(
  input: ContentMediaUploadInput,
): Promise<{ path: string; publicUrl: string }> {
  const admin = createAdminClient();
  const { error } = await admin.storage
    .from(CONTENT_MEDIA_BUCKET)
    .upload(input.path, input.body, {
      contentType: input.contentType,
      upsert: input.upsert ?? false,
    });

  if (error) {
    throw new Error(`Content media upload failed: ${error.message}`);
  }

  return {
    path: input.path,
    publicUrl: getContentMediaPublicUrl(input.path),
  };
}

export async function deleteContentMedia(path: string): Promise<void> {
  const admin = createAdminClient();
  const { error } = await admin.storage.from(CONTENT_MEDIA_BUCKET).remove([path]);

  if (error) {
    throw new Error(`Content media delete failed: ${error.message}`);
  }
}
