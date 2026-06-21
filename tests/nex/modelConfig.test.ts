import { describe, expect, it } from "vitest";

import {
  getGeminiTextModel,
  getGeminiTtsModel,
  getGeminiVisionModel,
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
  });

  it("allows model names to be overridden by environment variables", () => {
    const previousText = process.env.NEX_GEMINI_TEXT_MODEL;
    const previousVision = process.env.NEX_GEMINI_VISION_MODEL;
    const previousTts = process.env.NEX_GEMINI_TTS_MODEL;

    process.env.NEX_GEMINI_TEXT_MODEL = "gemini-flash-latest";
    process.env.NEX_GEMINI_VISION_MODEL = "gemini-3-flash-preview";
    process.env.NEX_GEMINI_TTS_MODEL = "gemini-3.1-flash-tts";

    expect(getGeminiTextModel()).toBe("gemini-flash-latest");
    expect(getGeminiVisionModel()).toBe("gemini-3-flash-preview");
    expect(getGeminiTtsModel()).toBe("gemini-3.1-flash-tts");

    restoreEnv("NEX_GEMINI_TEXT_MODEL", previousText);
    restoreEnv("NEX_GEMINI_VISION_MODEL", previousVision);
    restoreEnv("NEX_GEMINI_TTS_MODEL", previousTts);
  });
});
