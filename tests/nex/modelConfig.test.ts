import { describe, expect, it } from "vitest";

import {
  getGeminiTextModelForTier,
  getGeminiThinkingLevel,
  getGeminiTextModel,
  getGeminiTtsModel,
  getGeminiVisionModel,
  getNexModelMaxOutputTokens,
} from "@/lib/nex/modelConfig";

function restoreEnv(name: string, value: string | undefined): void {
  if (value === undefined) {
    delete process.env[name];
    return;
  }

  process.env[name] = value;
}

describe("Nex Gemini model config", () => {
  it("uses current Gemini defaults instead of shut-down Gemini 2.0 models", () => {
    expect(getGeminiTextModel()).toBe("gemini-3.5-flash");
    expect(getGeminiVisionModel()).toBe("gemini-3.5-flash");
    expect(getGeminiTtsModel()).toBe("gemini-3.1-flash-tts");
    expect(getGeminiThinkingLevel()).toBe("low");
    expect(getNexModelMaxOutputTokens()).toBe(1600);
  });

  it("allows model names to be overridden by environment variables", () => {
    const previousText = process.env.NEX_GEMINI_TEXT_MODEL;
    const previousVision = process.env.NEX_GEMINI_VISION_MODEL;
    const previousTts = process.env.NEX_GEMINI_TTS_MODEL;
    const previousThinking = process.env.NEX_GEMINI_THINKING_LEVEL;
    const previousMaxTokens = process.env.NEX_MODEL_MAX_OUTPUT_TOKENS;

    process.env.NEX_GEMINI_TEXT_MODEL = "gemini-flash-latest";
    process.env.NEX_GEMINI_VISION_MODEL = "gemini-3-flash-preview";
    process.env.NEX_GEMINI_TTS_MODEL = "gemini-3.1-flash-tts";
    process.env.NEX_GEMINI_THINKING_LEVEL = "medium";
    process.env.NEX_MODEL_MAX_OUTPUT_TOKENS = "2400";

    expect(getGeminiTextModel()).toBe("gemini-flash-latest");
    expect(getGeminiVisionModel()).toBe("gemini-3-flash-preview");
    expect(getGeminiTtsModel()).toBe("gemini-3.1-flash-tts");
    expect(getGeminiThinkingLevel()).toBe("medium");
    expect(getNexModelMaxOutputTokens()).toBe(2400);

    restoreEnv("NEX_GEMINI_TEXT_MODEL", previousText);
    restoreEnv("NEX_GEMINI_VISION_MODEL", previousVision);
    restoreEnv("NEX_GEMINI_TTS_MODEL", previousTts);
    restoreEnv("NEX_GEMINI_THINKING_LEVEL", previousThinking);
    restoreEnv("NEX_MODEL_MAX_OUTPUT_TOKENS", previousMaxTokens);
  });

  it("exposes a lite model tier separate from the standard text model", () => {
    expect(getGeminiTextModelForTier("standard")).toBe(getGeminiTextModel());
    expect(getGeminiTextModelForTier("lite")).toBe("gemini-3.5-flash-lite");
  });

  it("allows the lite model to be overridden by environment variable", () => {
    const previous = process.env.NEX_GEMINI_TEXT_MODEL_LITE;
    process.env.NEX_GEMINI_TEXT_MODEL_LITE = "gemini-flash-lite-latest";

    expect(getGeminiTextModelForTier("lite")).toBe("gemini-flash-lite-latest");

    restoreEnv("NEX_GEMINI_TEXT_MODEL_LITE", previous);
  });

  it("returns dynamic max output tokens depending on session/tutor mode", () => {
    expect(getNexModelMaxOutputTokens("hint")).toBe(400);
    expect(getNexModelMaxOutputTokens("quick-turn")).toBe(400);
    expect(getNexModelMaxOutputTokens("explain")).toBe(1000);
    expect(getNexModelMaxOutputTokens("exam")).toBe(1600);
    expect(getNexModelMaxOutputTokens("marking")).toBe(1600);
    expect(getNexModelMaxOutputTokens("assessment")).toBe(1600);
    expect(getNexModelMaxOutputTokens(undefined)).toBe(1600);
  });
});
