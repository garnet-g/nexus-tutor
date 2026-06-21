import { getGeminiTextModel } from "./modelConfig";

const KENYA_ENGLISH_LOCALE_HINT =
  "The speaker is a Kenyan student using English (en-KE). Transcribe clearly.";

export interface VoiceTranscribeInput {
  audioBytes: Uint8Array;
  mimeType: string;
  localeHint?: string;
}

export interface VoiceTranscribeResult {
  transcript: string;
  provider: "gemini" | "openai" | "mock";
}

function bytesToBase64(bytes: Uint8Array): string {
  return Buffer.from(bytes).toString("base64");
}

function getMockTranscript(): string {
  return "Explain fractions to me step by step.";
}

async function transcribeWithGemini(
  input: VoiceTranscribeInput,
): Promise<string> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY not configured");
  }

  const mimeType = input.mimeType.split(";")[0] || "audio/webm";
  const prompt = `${input.localeHint ?? KENYA_ENGLISH_LOCALE_HINT}

Return only the spoken transcript with no commentary.`;

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${getGeminiTextModel()}:generateContent?key=${apiKey}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              { text: prompt },
              {
                inline_data: {
                  mime_type: mimeType,
                  data: bytesToBase64(input.audioBytes),
                },
              },
            ],
          },
        ],
        generationConfig: {
          temperature: 0,
          maxOutputTokens: 256,
        },
      }),
    },
  );

  if (!response.ok) {
    throw new Error(`Gemini transcription failed: ${response.status}`);
  }

  const payload = (await response.json()) as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };

  const transcript = payload.candidates?.[0]?.content?.parts?.[0]?.text?.trim();
  if (!transcript) {
    throw new Error("Gemini returned an empty transcript");
  }

  return transcript;
}

async function transcribeWithWhisper(
  input: VoiceTranscribeInput,
): Promise<string> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY not configured");
  }

  const mimeType = input.mimeType.split(";")[0] || "audio/webm";
  const extension = mimeType.includes("ogg")
    ? "ogg"
    : mimeType.includes("mp4")
      ? "mp4"
      : mimeType.includes("mpeg")
        ? "mp3"
        : "webm";

  const audioCopy = Uint8Array.from(input.audioBytes);
  const formData = new FormData();
  formData.append(
    "file",
    new Blob([audioCopy], { type: mimeType }),
    `voice.${extension}`,
  );
  formData.append("model", "whisper-1");
  formData.append("language", "en");
  formData.append("prompt", KENYA_ENGLISH_LOCALE_HINT);

  const response = await fetch("https://api.openai.com/v1/audio/transcriptions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
    },
    body: formData,
  });

  if (!response.ok) {
    throw new Error(`Whisper transcription failed: ${response.status}`);
  }

  const payload = (await response.json()) as { text?: string };
  const transcript = payload.text?.trim();

  if (!transcript) {
    throw new Error("Whisper returned an empty transcript");
  }

  return transcript;
}

export async function transcribeVoiceAudio(
  input: VoiceTranscribeInput,
): Promise<VoiceTranscribeResult> {
  const hasGemini = Boolean(process.env.GEMINI_API_KEY);
  const hasOpenAI = Boolean(process.env.OPENAI_API_KEY);

  if (!hasGemini && !hasOpenAI) {
    return {
      transcript: getMockTranscript(),
      provider: "mock",
    };
  }

  if (hasGemini) {
    try {
      return {
        transcript: await transcribeWithGemini(input),
        provider: "gemini",
      };
    } catch {
      if (hasOpenAI) {
        return {
          transcript: await transcribeWithWhisper(input),
          provider: "openai",
        };
      }
    }
  }

  if (hasOpenAI) {
    return {
      transcript: await transcribeWithWhisper(input),
      provider: "openai",
    };
  }

  return {
    transcript: getMockTranscript(),
    provider: "mock",
  };
}
