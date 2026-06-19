export const NEX_UPLOADS_BUCKET = "nex-uploads";

const GEMINI_VISION_MODEL = "gemini-2.0-flash";

const EXTRACTION_PROMPT = `You extract mathematics problem text from a student photo for a Kenyan CBC/KCSE learning app.

Rules:
- Return ONLY the problem text as plain text (no markdown).
- If the image contains a math question (printed or handwritten), transcribe it faithfully.
- If the image is not a math problem, reply exactly: OUT_OF_SCOPE
- Do not solve the problem.
- Mathematics only — no other subjects.`;

export interface ExtractImageTextInput {
  imageBytes: Uint8Array;
  mimeType: string;
}

export interface ExtractImageTextResult {
  extractedText: string;
  provider: "gemini" | "mock";
  inCurriculumScope: boolean;
}

function bytesToBase64(bytes: Uint8Array): string {
  if (typeof Buffer !== "undefined") {
    return Buffer.from(bytes).toString("base64");
  }

  let binary = "";
  for (const byte of bytes) {
    binary += String.fromCharCode(byte);
  }
  return btoa(binary);
}

export function normalizeExtractedProblemText(raw: string): ExtractImageTextResult {
  const extractedText = raw.trim();

  if (!extractedText || extractedText === "OUT_OF_SCOPE") {
    return {
      extractedText: "",
      provider: "mock",
      inCurriculumScope: false,
    };
  }

  return {
    extractedText,
    provider: "mock",
    inCurriculumScope: true,
  };
}

export function buildCameraStudentMessage(extractedText: string): string {
  return `Photo question:\n${extractedText}`;
}

export async function extractImageText(
  input: ExtractImageTextInput,
): Promise<ExtractImageTextResult> {
  const apiKey = process.env.GEMINI_API_KEY;

  if (!apiKey || process.env.NEX_MOCK_AI === "true") {
    return {
      extractedText: "Solve 3x + 5 = 20",
      provider: "mock",
      inCurriculumScope: true,
    };
  }

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_VISION_MODEL}:generateContent?key=${apiKey}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              { text: EXTRACTION_PROMPT },
              {
                inlineData: {
                  mimeType: input.mimeType,
                  data: bytesToBase64(input.imageBytes),
                },
              },
            ],
          },
        ],
        generationConfig: {
          temperature: 0.2,
          maxOutputTokens: 512,
        },
      }),
    },
  );

  if (!response.ok) {
    throw new Error(`Gemini vision request failed: ${response.status}`);
  }

  const payload = (await response.json()) as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };

  const text = payload.candidates?.[0]?.content?.parts?.[0]?.text?.trim() ?? "";

  const normalized = normalizeExtractedProblemText(text);
  return {
    ...normalized,
    provider: "gemini",
  };
}
