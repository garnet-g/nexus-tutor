import { describe, expect, it } from "vitest";

import { detectNexMode } from "@/lib/nex/detectNexMode";
import { transcribeVoiceAudio } from "@/lib/nex/voiceTranscribe";
import { validateNexResponse } from "@/lib/nex/validateNexResponse";

describe("voice golden — mock transcript to Nex validation", () => {
  it("uses the mock STT transcript and passes explain-mode validation", async () => {
    const previousGemini = process.env.GEMINI_API_KEY;
    const previousOpenAI = process.env.OPENAI_API_KEY;
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    const transcription = await transcribeVoiceAudio({
      audioBytes: new Uint8Array([1, 2, 3, 4]),
      mimeType: "audio/webm",
    });

    expect(transcription.provider).toBe("mock");

    const mode = detectNexMode(transcription.transcript, "homework");
    expect(mode).toBe("explain");

    const nexResponse =
      "Fractions show parts of a whole. If you eat 1 slice from a pizza cut into 4 equal slices, what fraction did you eat?";

    const validation = validateNexResponse({
      mode,
      response: nexResponse,
      attemptCount: 0,
      hintLevel: 1,
      studentMessage: transcription.transcript,
    });

    expect(validation.status).toBe("pass");

    process.env.GEMINI_API_KEY = previousGemini;
    process.env.OPENAI_API_KEY = previousOpenAI;
  });
});
