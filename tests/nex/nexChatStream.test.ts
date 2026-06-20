import { describe, expect, it } from "vitest";

import { chunkTextForMockStream } from "@/lib/nex/callNexModel";
import {
  encodeNexChatSseEvent,
  parseNexChatSseEvent,
} from "@/lib/nex/nexChatSse";
import { shouldStreamNexResponse } from "@/lib/nex/shouldStreamNexResponse";

describe("shouldStreamNexResponse", () => {
  it("blocks streaming for homework before three attempts", () => {
    expect(shouldStreamNexResponse("homework", 0)).toBe(false);
    expect(shouldStreamNexResponse("homework", 1)).toBe(false);
    expect(shouldStreamNexResponse("homework", 2)).toBe(false);
  });

  it("allows streaming for homework after three attempts", () => {
    expect(shouldStreamNexResponse("homework", 3)).toBe(true);
  });

  it("allows streaming for non-homework modes", () => {
    expect(shouldStreamNexResponse("explain", 0)).toBe(true);
    expect(shouldStreamNexResponse("practice", 0)).toBe(true);
  });
});

describe("nex chat SSE helpers", () => {
  it("round-trips encoded events", () => {
    const encoded = encodeNexChatSseEvent("chunk", { text: "Hello" });
    const parsed = parseNexChatSseEvent(encoded.trim());

    expect(parsed?.event).toBe("chunk");
    expect(JSON.parse(parsed!.data)).toEqual({ text: "Hello" });
  });
});

describe("chunkTextForMockStream", () => {
  it("splits mock output into progressive chunks", () => {
    const chunks = chunkTextForMockStream("Hello world", 3);
    expect(chunks.join("")).toBe("Hello world");
    expect(chunks.length).toBeGreaterThan(1);
  });
});
