import { afterEach, describe, expect, it, vi } from "vitest";

import { callNexModel } from "@/lib/nex/callNexModel";

describe("callNexModel", () => {
  afterEach(() => {
    vi.unstubAllGlobals();
    vi.restoreAllMocks();
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;
    delete process.env.NEX_MODEL_MAX_OUTPUT_TOKENS;
    delete process.env.NEX_GEMINI_THINKING_LEVEL;
  });

  it("gives Gemini enough output budget and uses low thinking for tutor replies", async () => {
    process.env.GEMINI_API_KEY = "test-gemini-key";

    const fetchMock = vi.fn(async () =>
      Response.json({
        candidates: [
          {
            content: {
              parts: [{ text: "CONCEPT\nA complete tutor response." }],
            },
          },
        ],
      }),
    );
    vi.stubGlobal("fetch", fetchMock);

    const result = await callNexModel({
      systemPrompt: "You are Nex.",
      messages: [{ role: "student", content: "Explain fractions." }],
    });

    expect(result.provider).toBe("gemini");
    const [, init] = fetchMock.mock.calls[0] as unknown as [
      string,
      RequestInit,
    ];
    const body = JSON.parse(String(init.body)) as {
      generationConfig?: {
        maxOutputTokens?: number;
        thinkingConfig?: { thinkingLevel?: string };
      };
    };

    expect(body.generationConfig?.maxOutputTokens).toBe(1600);
    expect(body.generationConfig?.thinkingConfig?.thinkingLevel).toBe("low");
  });

  it("can disable OpenAI fallback so Gemini failures stay visible", async () => {
    process.env.GEMINI_API_KEY = "test-gemini-key";
    process.env.OPENAI_API_KEY = "test-openai-key";

    const fetchMock = vi.fn(async (url: string | URL | Request) => {
      const urlText = String(url);
      if (urlText.includes("generativelanguage.googleapis.com")) {
        return new Response("bad gateway", { status: 502 });
      }

      return new Response("unauthorized", { status: 401 });
    });
    vi.stubGlobal("fetch", fetchMock);

    await expect(
      callNexModel({
        systemPrompt: "You are Nex.",
        messages: [{ role: "student", content: "Generate content." }],
        allowOpenAIFallback: false,
      }),
    ).rejects.toThrow("Gemini request failed: 502");

    expect(fetchMock).toHaveBeenCalledTimes(1);
  });
});
