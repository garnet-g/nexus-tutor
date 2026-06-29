import { describe, expect, it } from "vitest";

import { detectNexMode } from "@/lib/nex/detectNexMode";
import { transcribeVoiceAudio } from "@/lib/nex/voiceTranscribe";
import { synthesizeVoiceResponse } from "@/lib/nex/voiceSynthesize";
import { validateNexResponse } from "@/lib/nex/validateNexResponse";
import {
  isVoiceMimeType,
  studentHasVoiceAccess,
  VOICE_MAX_BYTES,
  VOICE_MAX_DURATION_SECONDS,
} from "@/schemas/voiceSchemas";

describe("voicePipeline", () => {
  it("enforces voice upload limits", () => {
    expect(VOICE_MAX_BYTES).toBe(2 * 1024 * 1024);
    expect(VOICE_MAX_DURATION_SECONDS).toBe(30);
    expect(isVoiceMimeType("audio/webm;codecs=opus")).toBe(true);
    expect(isVoiceMimeType("audio/wav")).toBe(false);
  });

  it("gates voice to premium and family plans", () => {
    expect(studentHasVoiceAccess("premium")).toBe(true);
    expect(studentHasVoiceAccess("family")).toBe(true);
    expect(studentHasVoiceAccess("free")).toBe(false);
  });

  it("returns mock transcript without provider keys", async () => {
    const previousGemini = process.env.GEMINI_API_KEY;
    const previousOpenAI = process.env.OPENAI_API_KEY;
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    const transcription = await transcribeVoiceAudio({
      audioBytes: new Uint8Array([1, 2, 3, 4]),
      mimeType: "audio/webm",
    });

    expect(transcription.provider).toBe("mock");
    expect(transcription.transcript.length).toBeGreaterThan(0);

    process.env.GEMINI_API_KEY = previousGemini;
    process.env.OPENAI_API_KEY = previousOpenAI;
  });

  it("returns mock speech audio without provider keys", async () => {
    const previousGemini = process.env.GEMINI_API_KEY;
    const previousOpenAI = process.env.OPENAI_API_KEY;
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    const speech = await synthesizeVoiceResponse({
      text: "Let's think about the numerator and denominator together.",
    });

    expect(speech.provider).toBe("mock");
    expect(speech.audioBase64.length).toBeGreaterThan(0);
    expect(speech.mimeType).toBe("audio/wav");

    process.env.GEMINI_API_KEY = previousGemini;
    process.env.OPENAI_API_KEY = previousOpenAI;
  });

  it("maps a voice transcript through Nex validation for explain mode", () => {
    const transcript = "Explain fractions to me";
    const mode = detectNexMode(transcript, "homework");

    expect(mode).toBe("explain");

    const nexResponse =
      "Fractions show parts of a whole. If you eat 1 slice from a pizza cut into 4 equal slices, what fraction did you eat?";

    const validation = validateNexResponse({
      mode,
      response: nexResponse,
      attemptCount: 0,
      hintLevel: 1,
      studentMessage: transcript,
    });

    expect(validation.status).toBe("pass");
  });
});
