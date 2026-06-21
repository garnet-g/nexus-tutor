const DEFAULT_GEMINI_TEXT_MODEL = "gemini-3.5-flash";
const DEFAULT_GEMINI_VISION_MODEL = "gemini-3.5-flash";
const DEFAULT_GEMINI_TTS_MODEL = "gemini-3.1-flash-tts";

function getConfiguredModel(envName: string, fallback: string): string {
  const value = process.env[envName]?.trim();
  return value || fallback;
}

export function getGeminiTextModel(): string {
  return getConfiguredModel("NEX_GEMINI_TEXT_MODEL", DEFAULT_GEMINI_TEXT_MODEL);
}

export function getGeminiVisionModel(): string {
  return getConfiguredModel("NEX_GEMINI_VISION_MODEL", DEFAULT_GEMINI_VISION_MODEL);
}

export function getGeminiTtsModel(): string {
  return getConfiguredModel("NEX_GEMINI_TTS_MODEL", DEFAULT_GEMINI_TTS_MODEL);
}
