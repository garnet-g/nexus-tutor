/**
 * @vitest-environment jsdom
 */
import { describe, expect, it, vi } from "vitest";

import { MAX_IMAGE_DIMENSION, downscaleImageFile } from "@/features/nex/lib/downscaleImage";

// jsdom does not implement createImageBitmap, so the property doesn't exist
// on globalThis yet. vi.spyOn requires the property to already exist, so we
// polyfill a no-op stub here that the tests below then override per-case.
if (typeof globalThis.createImageBitmap === "undefined") {
  (globalThis as { createImageBitmap?: unknown }).createImageBitmap = () =>
    Promise.resolve(undefined);
}

function mockCanvas(width: number, height: number) {
  const toBlob = vi.fn((callback: BlobCallback) => {
    callback(new Blob(["fake-jpeg-bytes"], { type: "image/jpeg" }));
  });

  const context = {
    drawImage: vi.fn(),
  } as unknown as CanvasRenderingContext2D;

  const canvas = {
    width,
    height,
    getContext: () => context,
    toBlob,
  } as unknown as HTMLCanvasElement;

  vi.spyOn(document, "createElement").mockImplementation((tag: string) => {
    if (tag === "canvas") {
      return canvas as unknown as HTMLElement;
    }
    return document.createElement(tag);
  });
}

describe("downscaleImageFile", () => {
  it("returns the original file unchanged when already within the max dimension", async () => {
    const smallFile = new File(["bytes"], "photo.jpg", { type: "image/jpeg" });

    vi.spyOn(globalThis, "createImageBitmap").mockResolvedValue({
      width: 800,
      height: 600,
      close: vi.fn(),
    } as unknown as ImageBitmap);

    const result = await downscaleImageFile(smallFile);
    expect(result).toBe(smallFile);

    vi.restoreAllMocks();
  });

  it("downscales an oversized image to the max dimension and returns a JPEG file", async () => {
    const largeFile = new File(["bytes"], "photo.png", { type: "image/png" });

    vi.spyOn(globalThis, "createImageBitmap").mockResolvedValue({
      width: 4000,
      height: 3000,
      close: vi.fn(),
    } as unknown as ImageBitmap);

    mockCanvas(MAX_IMAGE_DIMENSION, Math.round((3000 / 4000) * MAX_IMAGE_DIMENSION));

    const result = await downscaleImageFile(largeFile);

    expect(result).not.toBe(largeFile);
    expect(result.type).toBe("image/jpeg");
    expect(result.name).toBe("photo.jpg");

    vi.restoreAllMocks();
  });
});
