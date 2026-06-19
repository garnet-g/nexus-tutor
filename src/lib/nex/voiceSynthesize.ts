const OPENAI_TTS_MODEL = "tts-1";
const OPENAI_TTS_VOICE = "alloy";

export interface VoiceSynthesizeInput {
  text: string;
}

export interface VoiceSynthesizeResult {
  audioBase64: string;
  mimeType: string;
  provider: "gemini" | "openai" | "mock";
}

function buildMockWavBase64(): string {
  const sampleRate = 8000;
  const numSamples = 800;
  const dataSize = numSamples;
  const buffer = new ArrayBuffer(44 + dataSize);
  const view = new DataView(buffer);

  function writeString(offset: number, value: string) {
    for (let index = 0; index < value.length; index += 1) {
      view.setUint8(offset + index, value.charCodeAt(index));
    }
  }

  writeString(0, "RIFF");
  view.setUint32(4, 36 + dataSize, true);
  writeString(8, "WAVE");
  writeString(12, "fmt ");
  view.setUint32(16, 16, true);
  view.setUint16(20, 1, true);
  view.setUint16(22, 1, true);
  view.setUint32(24, sampleRate, true);
  view.setUint32(28, sampleRate, true);
  view.setUint16(32, 1, true);
  view.setUint16(34, 8, true);
  writeString(36, "data");
  view.setUint32(40, dataSize, true);

  return Buffer.from(buffer).toString("base64");
}

async function synthesizeWithOpenAI(text: string): Promise<Uint8Array> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY not configured");
  }

  const response = await fetch("https://api.openai.com/v1/audio/speech", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: OPENAI_TTS_MODEL,
      voice: OPENAI_TTS_VOICE,
      input: text.slice(0, 4096),
      response_format: "mp3",
    }),
  });

  if (!response.ok) {
    throw new Error(`OpenAI TTS failed: ${response.status}`);
  }

  const audioBytes = new Uint8Array(await response.arrayBuffer());
  if (!audioBytes.length) {
    throw new Error("OpenAI TTS returned empty audio");
  }

  return audioBytes;
}

async function synthesizeWithGemini(text: string): Promise<Uint8Array> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY not configured");
  }

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-tts:generateContent?key=${apiKey}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              {
                text: `Read this tutoring response aloud in clear Kenyan English for a student:\n\n${text.slice(0, 2048)}`,
              },
            ],
          },
        ],
        generationConfig: {
          responseModalities: ["AUDIO"],
          speechConfig: {
            voiceConfig: {
              prebuiltVoiceConfig: { voiceName: "Kore" },
            },
          },
        },
      }),
    },
  );

  if (!response.ok) {
    throw new Error(`Gemini TTS failed: ${response.status}`);
  }

  const payload = (await response.json()) as {
    candidates?: Array<{
      content?: {
        parts?: Array<{
          inlineData?: { mimeType?: string; data?: string };
        }>;
      };
    }>;
  };

  const inlineData = payload.candidates?.[0]?.content?.parts?.find(
    (part) => part.inlineData?.data,
  )?.inlineData;

  if (!inlineData?.data) {
    throw new Error("Gemini TTS returned no audio");
  }

  return Uint8Array.from(Buffer.from(inlineData.data, "base64"));
}

export async function synthesizeVoiceResponse(
  input: VoiceSynthesizeInput,
): Promise<VoiceSynthesizeResult> {
  const trimmed = input.text.trim();
  if (!trimmed) {
    return {
      audioBase64: buildMockWavBase64(),
      mimeType: "audio/wav",
      provider: "mock",
    };
  }

  const hasGemini = Boolean(process.env.GEMINI_API_KEY);
  const hasOpenAI = Boolean(process.env.OPENAI_API_KEY);

  if (!hasGemini && !hasOpenAI) {
    return {
      audioBase64: buildMockWavBase64(),
      mimeType: "audio/wav",
      provider: "mock",
    };
  }

  if (hasGemini) {
    try {
      const audioBytes = await synthesizeWithGemini(trimmed);
      return {
        audioBase64: Buffer.from(audioBytes).toString("base64"),
        mimeType: "audio/wav",
        provider: "gemini",
      };
    } catch {
      if (hasOpenAI) {
        const audioBytes = await synthesizeWithOpenAI(trimmed);
        return {
          audioBase64: Buffer.from(audioBytes).toString("base64"),
          mimeType: "audio/mpeg",
          provider: "openai",
        };
      }
    }
  }

  if (hasOpenAI) {
    const audioBytes = await synthesizeWithOpenAI(trimmed);
    return {
      audioBase64: Buffer.from(audioBytes).toString("base64"),
      mimeType: "audio/mpeg",
      provider: "openai",
    };
  }

  return {
    audioBase64: buildMockWavBase64(),
    mimeType: "audio/wav",
    provider: "mock",
  };
}
