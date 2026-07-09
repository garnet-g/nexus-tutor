import "server-only";

import type { NexModelCallInput } from "@/lib/nex/types";
import {
  getGeminiTextModel,
  getGeminiThinkingLevel,
  getNexModelMaxOutputTokens,
} from "@/lib/nex/modelConfig";
import { isGeminiConfigured } from "@/lib/env/providerModes";
import { getOrCreateContextCache } from "@/server/services/contextCacheService";

const LLM_TIMEOUT_MS = 20_000;

export interface GeminiContentPart {
  role: "user" | "model";
  parts: [{ text: string }];
}

export function buildGeminiContents(
  messages: NexModelCallInput["messages"],
): GeminiContentPart[] {
  return messages.map((message) => ({
    role: message.role === "student" ? "user" : "model",
    parts: [{ text: message.content }],
  }));
}

export function getMockNexResponse(input: NexModelCallInput): string {
  const lastStudentMessage =
    [...input.messages].reverse().find((message) => message.role === "student")
      ?.content ?? "";

  if (/explain/i.test(lastStudentMessage)) {
    return [
      "CONCEPT",
      "Fractions show parts of a whole.",
      "",
      "EXAMPLE",
      "If you eat 1 slice from a pizza cut into 4 equal slices, you ate 1/4 of the pizza.",
      "",
      "GUIDED CHECK",
      "If a chapati is cut into 8 equal pieces and you eat 3, what fraction did you eat?",
    ].join("\n");
  }

  if (/quiz|test|practice/i.test(lastStudentMessage)) {
    return "QUESTION\nWhat is 3/4 + 1/4?\n\nTake your time — reply with your answer and I'll give you feedback.";
  }

  if (/exam|revision|study plan/i.test(lastStudentMessage)) {
    return "Let's build your revision plan. How many days until your exam, and how many minutes can you study each day?";
  }

  return "Let's work through this step by step. What do you already know about this problem, and what is the question asking you to find?";
}

export function geminiClientConfigured(): boolean {
  return isGeminiConfigured();
}

export async function callGemini(input: NexModelCallInput): Promise<string> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY not configured");
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), LLM_TIMEOUT_MS);

  try {
    const model = input.modelOverride ?? getGeminiTextModel();

    if (input.messages.length === 0) {
      throw new Error("Gemini request requires at least one conversation message");
    }

    let cacheName: string | null = null;
    if (input.sessionId && input.messages.length >= 6) {
      cacheName = await getOrCreateContextCache({
        sessionId: input.sessionId,
        systemPrompt: input.systemPrompt,
        messages: input.messages,
        model,
      });
    }

    const requestBody: Record<string, unknown> = {
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: input.maxTokens ?? getNexModelMaxOutputTokens(input.mode),
        thinkingConfig: {
          thinkingLevel: getGeminiThinkingLevel(),
        },
      },
    };

    if (cacheName) {
      requestBody.cachedContent = cacheName;
      requestBody.contents = buildGeminiContents(input.messages.slice(6));
    } else {
      requestBody.systemInstruction = { parts: [{ text: input.systemPrompt }] };
      requestBody.contents = buildGeminiContents(input.messages);
    }

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(requestBody),
        signal: controller.signal,
      },
    );

    if (!response.ok) {
      throw new Error(`Gemini request failed: ${response.status}`);
    }

    const payload = (await response.json()) as {
      candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
    };

    const text = payload.candidates?.[0]?.content?.parts?.[0]?.text?.trim();
    if (!text) {
      throw new Error("Gemini returned an empty response");
    }

    return text;
  } finally {
    clearTimeout(timer);
  }
}

function extractGeminiStreamText(payload: unknown): string {
  const data = payload as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };
  return data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
}

export async function streamGemini(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): Promise<string> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY not configured");
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), LLM_TIMEOUT_MS);

  try {
    const model = input.modelOverride ?? getGeminiTextModel();

    if (input.messages.length === 0) {
      throw new Error("Gemini request requires at least one conversation message");
    }

    let cacheName: string | null = null;
    if (input.sessionId && input.messages.length >= 6) {
      cacheName = await getOrCreateContextCache({
        sessionId: input.sessionId,
        systemPrompt: input.systemPrompt,
        messages: input.messages,
        model,
      });
    }

    const requestBody: Record<string, unknown> = {
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: input.maxTokens ?? getNexModelMaxOutputTokens(input.mode),
        thinkingConfig: {
          thinkingLevel: getGeminiThinkingLevel(),
        },
      },
    };

    if (cacheName) {
      requestBody.cachedContent = cacheName;
      requestBody.contents = buildGeminiContents(input.messages.slice(6));
    } else {
      requestBody.systemInstruction = { parts: [{ text: input.systemPrompt }] };
      requestBody.contents = buildGeminiContents(input.messages);
    }

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?alt=sse&key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(requestBody),
        signal: controller.signal,
      },
    );

    if (!response.ok || !response.body) {
      throw new Error(`Gemini stream request failed: ${response.status}`);
    }

    let content = "";
    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = "";

    while (true) {
      const { done, value } = await reader.read();
      if (done) {
        break;
      }

      buffer += decoder.decode(value, { stream: true });

      while (true) {
        const lineBreak = buffer.indexOf("\n");
        if (lineBreak === -1) {
          break;
        }

        const line = buffer.slice(0, lineBreak).trim();
        buffer = buffer.slice(lineBreak + 1);

        if (!line.startsWith("data:")) {
          continue;
        }

        const jsonText = line.slice(5).trim();
        if (!jsonText || jsonText === "[DONE]") {
          continue;
        }

        try {
          const piece = extractGeminiStreamText(JSON.parse(jsonText));
          if (piece) {
            content += piece;
            onChunk(piece);
          }
        } catch {
          // Ignore malformed SSE frames.
        }
      }
    }

    const trimmed = content.trim();
    if (!trimmed) {
      throw new Error("Gemini stream returned an empty response");
    }

    return trimmed;
  } finally {
    clearTimeout(timer);
  }
}
