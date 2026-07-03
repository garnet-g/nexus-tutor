import "server-only";

import { NextResponse } from "next/server";

/** Default cap for JSON API bodies. */
export const DEFAULT_JSON_LIMIT_BYTES = 64 * 1024;

/** Cap for admin JSON mutations (lesson drafts can carry rich content). */
export const ADMIN_JSON_LIMIT_BYTES = 1024 * 1024;

/**
 * Cap for camera/voice multipart uploads: 5MB payload ceiling plus a small
 * allowance for multipart framing. Routes still enforce their own per-file
 * limits (5MB image / 2MB audio) with friendlier messages.
 */
export const MEDIA_UPLOAD_LIMIT_BYTES = 5 * 1024 * 1024 + 64 * 1024;

export type ReadJsonResult<T = unknown> =
  | { ok: true; body: T | null }
  | { ok: false; response: NextResponse };

function payloadTooLargeResponse(maxBytes: number): NextResponse {
  return NextResponse.json(
    {
      success: false,
      error: {
        code: "PAYLOAD_TOO_LARGE",
        message: "Request body exceeds the allowed size.",
        details: { maxBytes },
      },
    },
    { status: 413 },
  );
}

/**
 * Non-consuming guard: rejects with 413 when a declared Content-Length
 * exceeds the cap. Use before `request.formData()` / streaming bodies where
 * fully buffering is handled elsewhere. Returns null when within limits or
 * when no Content-Length is declared.
 */
export function checkContentLength(
  request: Request,
  maxBytes: number,
): NextResponse | null {
  const contentLength = request.headers.get("content-length");

  if (!contentLength) {
    return null;
  }

  const declaredBytes = Number(contentLength);

  if (Number.isFinite(declaredBytes) && declaredBytes > maxBytes) {
    return payloadTooLargeResponse(maxBytes);
  }

  return null;
}

/**
 * Reads and parses a JSON body with a hard byte cap. Checks Content-Length
 * first, then streams with an enforced ceiling so a lying or absent
 * Content-Length cannot smuggle an oversized body.
 *
 * Returns `{ ok: true, body }` on success (body is `null` for invalid JSON so
 * callers' schema validation produces their route-shaped 400), or
 * `{ ok: false, response }` carrying a 413 NextResponse.
 */
export async function readJsonWithLimit<T = unknown>(
  request: Request,
  maxBytes: number = DEFAULT_JSON_LIMIT_BYTES,
): Promise<ReadJsonResult<T>> {
  const contentLengthError = checkContentLength(request, maxBytes);

  if (contentLengthError) {
    return { ok: false, response: contentLengthError };
  }

  if (!request.body) {
    return { ok: true, body: null };
  }

  const reader = request.body.getReader();
  const chunks: Uint8Array[] = [];
  let receivedBytes = 0;

  try {
    for (;;) {
      const { done, value } = await reader.read();

      if (done) {
        break;
      }

      receivedBytes += value.byteLength;

      if (receivedBytes > maxBytes) {
        await reader.cancel().catch(() => undefined);
        return { ok: false, response: payloadTooLargeResponse(maxBytes) };
      }

      chunks.push(value);
    }
  } finally {
    reader.releaseLock();
  }

  if (receivedBytes === 0) {
    return { ok: true, body: null };
  }

  const merged = new Uint8Array(receivedBytes);
  let offset = 0;

  for (const chunk of chunks) {
    merged.set(chunk, offset);
    offset += chunk.byteLength;
  }

  try {
    return { ok: true, body: JSON.parse(new TextDecoder().decode(merged)) as T };
  } catch {
    return { ok: true, body: null };
  }
}
