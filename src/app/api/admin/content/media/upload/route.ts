import "server-only";

import { randomUUID } from "node:crypto";

import { NextResponse } from "next/server";

import {
  CONTENT_MEDIA_BUCKET,
  uploadContentMedia,
} from "@/lib/supabase/contentMediaStorage";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

const ALLOWED_MIME_TYPES = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif",
  "application/pdf",
  "video/mp4",
]);

const MAX_BYTES = 10 * 1024 * 1024;

export async function POST(request: Request) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      {
        success: false,
        error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message },
      },
      { status: auth.status },
    );
  }

  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return NextResponse.json(
      {
        success: false,
        error: { code: "INVALID_FORM", message: "Expected multipart form data." },
      },
      { status: 400 },
    );
  }

  const file = formData.get("file");
  if (!(file instanceof File)) {
    return NextResponse.json(
      {
        success: false,
        error: { code: "VALIDATION_ERROR", message: "Missing file field." },
      },
      { status: 400 },
    );
  }

  if (!ALLOWED_MIME_TYPES.has(file.type)) {
    return NextResponse.json(
      {
        success: false,
        error: { code: "VALIDATION_ERROR", message: "Unsupported file type." },
      },
      { status: 400 },
    );
  }

  if (file.size > MAX_BYTES) {
    return NextResponse.json(
      {
        success: false,
        error: { code: "VALIDATION_ERROR", message: "File exceeds 10 MB limit." },
      },
      { status: 400 },
    );
  }

  const extension = file.name.includes(".") ? file.name.split(".").pop() : "bin";
  const objectPath = `lessons/${randomUUID()}.${extension}`;

  try {
    const buffer = Buffer.from(await file.arrayBuffer());
    const uploaded = await uploadContentMedia({
      path: objectPath,
      body: buffer,
      contentType: file.type,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: "super_admin",
      action: "content.media.upload",
      targetType: "storage_object",
      targetId: objectPath,
      metadata: {
        bucket: CONTENT_MEDIA_BUCKET,
        path: objectPath,
        contentType: file.type,
        sizeBytes: file.size,
      },
    });

    return NextResponse.json({
      success: true,
      data: {
        path: uploaded.path,
        publicUrl: uploaded.publicUrl,
        contentType: file.type,
        fileName: file.name,
      },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Upload failed.";
    return NextResponse.json(
      {
        success: false,
        error: { code: "UPLOAD_FAILED", message },
      },
      { status: 500 },
    );
  }
}
