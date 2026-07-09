const DEFAULT_GEMINI_TEXT_MODEL = "gemini-3.5-flash";
const DEFAULT_GEMINI_TEXT_MODEL_LITE = "gemini-3.5-flash-lite";
const DEFAULT_GEMINI_VISION_MODEL = "gemini-3.5-flash";
const DEFAULT_GEMINI_TTS_MODEL = "gemini-3.1-flash-tts";
const DEFAULT_GEMINI_THINKING_LEVEL = "low";
const DEFAULT_NEX_MODEL_MAX_OUTPUT_TOKENS = 1600;

function getConfiguredModel(envName: string, fallback: string): string {
  const value = process.env[envName]?.trim();
  return value || fallback;
}

export function getGeminiTextModel(): string {
  return getConfiguredModel("NEX_GEMINI_TEXT_MODEL", DEFAULT_GEMINI_TEXT_MODEL);
}

export type NexModelTier = "standard" | "lite";

export function getGeminiTextModelForTier(tier: NexModelTier): string {
  if (tier === "lite") {
    return getConfiguredModel(
      "NEX_GEMINI_TEXT_MODEL_LITE",
      DEFAULT_GEMINI_TEXT_MODEL_LITE,
    );
  }

  return getGeminiTextModel();
}

export function getGeminiVisionModel(): string {
  return getConfiguredModel("NEX_GEMINI_VISION_MODEL", DEFAULT_GEMINI_VISION_MODEL);
}

export function getGeminiTtsModel(): string {
  return getConfiguredModel("NEX_GEMINI_TTS_MODEL", DEFAULT_GEMINI_TTS_MODEL);
}

export function getGeminiThinkingLevel(): string {
  return getConfiguredModel(
    "NEX_GEMINI_THINKING_LEVEL",
    DEFAULT_GEMINI_THINKING_LEVEL,
  );
}

export function getNexModelMaxOutputTokens(mode?: string): number {
  const envValue = Number(process.env.NEX_MODEL_MAX_OUTPUT_TOKENS);
  if (Number.isFinite(envValue) && envValue >= 500) {
    return Math.floor(envValue);
  }

  if (mode === "hint" || mode === "quick-turn") {
    return 400;
  }
  if (mode === "explain") {
    return 1000;
  }
  if (mode === "exam" || mode === "marking" || mode === "assessment") {
    return 1600;
  }

  return DEFAULT_NEX_MODEL_MAX_OUTPUT_TOKENS;
}
