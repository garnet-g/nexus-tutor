/**
 * @vitest-environment node
 *
 * PR-090: request bodies must be capped before they are fully buffered/parsed.
 */
import { describe, expect, it } from "vitest";

import {
  DEFAULT_JSON_LIMIT_BYTES,
  checkContentLength,
  readJsonWithLimit,
} from "@/lib/security/bodySizeLimit";

const URL = "https://app.nexus.co/api/thing";

describe("checkContentLength", () => {
  it("rejects a declared Content-Length over the cap with 413", () => {
    const res = checkContentLength(
      new Request(URL, {
        method: "POST",
        headers: { "content-length": String(DEFAULT_JSON_LIMIT_BYTES + 1) },
      }),
      DEFAULT_JSON_LIMIT_BYTES,
    );
    expect(res?.status).toBe(413);
  });

  it("passes when Content-Length is within the cap", () => {
    const res = checkContentLength(
      new Request(URL, {
        method: "POST",
        headers: { "content-length": "10" },
      }),
      DEFAULT_JSON_LIMIT_BYTES,
    );
    expect(res).toBeNull();
  });

  it("passes when no Content-Length is declared", () => {
    const res = checkContentLength(
      new Request(URL, { method: "POST" }),
      DEFAULT_JSON_LIMIT_BYTES,
    );
    expect(res).toBeNull();
  });
});

describe("readJsonWithLimit", () => {
  it("parses a small JSON body", async () => {
    const result = await readJsonWithLimit(
      new Request(URL, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ hello: "world" }),
      }),
    );

    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.body).toEqual({ hello: "world" });
    }
  });

  it("rejects a body whose declared Content-Length exceeds the cap", async () => {
    const result = await readJsonWithLimit(
      new Request(URL, {
        method: "POST",
        headers: { "content-length": "100" },
        body: JSON.stringify({ x: "y" }),
      }),
      16,
    );

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.response.status).toBe(413);
    }
  });

  it("rejects an oversized body even when Content-Length lies/absent (streamed cap)", async () => {
    const big = "x".repeat(2000);
    // Build a stream body so undici does not set an accurate Content-Length.
    const stream = new ReadableStream<Uint8Array>({
      start(controller) {
        controller.enqueue(new TextEncoder().encode(JSON.stringify({ big })));
        controller.close();
      },
    });

    const result = await readJsonWithLimit(
      new Request(URL, {
        method: "POST",
        body: stream,
        // @ts-expect-error duplex is required by undici for stream bodies
        duplex: "half",
      }),
      64,
    );

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.response.status).toBe(413);
    }
  });

  it("returns a null body for invalid JSON so the caller's schema shapes the 400", async () => {
    const result = await readJsonWithLimit(
      new Request(URL, { method: "POST", body: "{not json" }),
    );

    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.body).toBeNull();
    }
  });
});
