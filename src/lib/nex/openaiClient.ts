import "server-only";

import type { NexModelCallInput } from "@/lib/nex/types";
import { getNexModelMaxOutputTokens } from "@/lib/nex/modelConfig";
import { isOpenAiConfigured } from "@/lib/env/providerModes";

const OPENAI_MODEL = "gpt-4o-mini";
const LLM_TIMEOUT_MS = 20_000;
const GEMINI_JUDGE_MAX_OUTPUT_TOKENS = 512;

export function openAiClientConfigured(): boolean {
  return isOpenAiConfigured();
}

export async function callOpenAI(input: NexModelCallInput): Promise<string> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY not configured");
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), LLM_TIMEOUT_MS);

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: OPENAI_MODEL,
        temperature: 0.7,
        max_tokens: input.maxTokens ?? getNexModelMaxOutputTokens(),
        messages: [
          { role: "system", content: input.systemPrompt },
          ...input.messages.map((message) => ({
            role: message.role === "student" ? "user" : "assistant",
            content: message.content,
          })),
        ],
      }),
      signal: controller.signal,
    });

    if (!response.ok) {
      throw new Error(`OpenAI request failed: ${response.status}`);
    }

    const payload = (await response.json()) as {
      choices?: Array<{ message?: { content?: string } }>;
    };

    const text = payload.choices?.[0]?.message?.content?.trim();
    if (!text) {
      throw new Error("OpenAI returned an empty response");
    }

    return text;
  } finally {
    clearTimeout(timer);
  }
}

function extractOpenAiStreamDelta(payload: unknown): string {
  const data = payload as {
    choices?: Array<{ delta?: { content?: string } }>;
  };
  return data.choices?.[0]?.delta?.content ?? "";
}

export async function streamOpenAI(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): Promise<string> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY not configured");
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), LLM_TIMEOUT_MS);

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: OPENAI_MODEL,
        temperature: 0.7,
        max_tokens: input.maxTokens ?? getNexModelMaxOutputTokens(),
        stream: true,
        messages: [
          { role: "system", content: input.systemPrompt },
          ...input.messages.map((message) => ({
            role: message.role === "student" ? "user" : "assistant",
            content: message.content,
          })),
        ],
      }),
      signal: controller.signal,
    });

    if (!response.ok || !response.body) {
      throw new Error(`OpenAI stream request failed: ${response.status}`);
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
          const piece = extractOpenAiStreamDelta(JSON.parse(jsonText));
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
      throw new Error("OpenAI stream returned an empty response");
    }

    return trimmed;
  } finally {
    clearTimeout(timer);
  }
}

export async function callOpenAiJudge(
  studentMessage: string,
  nexResponse: string,
): Promise<boolean> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY not configured");
  }

  const judgePrompt = `You are a validator for a Socratic tutor. The student has NOT attempted the homework yet (first turn).

Student question: ${studentMessage}
Tutor response: ${nexResponse}

Does the tutor response reveal the final answer or complete solution without first asking a guiding question?

Reply with JSON only: { "revealsFinalAnswer": true | false, "reason": "..." }`;

  const judgeController = new AbortController();
  const judgeTimer = setTimeout(() => judgeController.abort(), LLM_TIMEOUT_MS);

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: OPENAI_MODEL,
        temperature: 0,
        max_tokens: 120,
        messages: [{ role: "user", content: judgePrompt }],
      }),
      signal: judgeController.signal,
    });

    if (!response.ok) {
      return false;
    }

    const payload = (await response.json()) as {
      choices?: Array<{ message?: { content?: string } }>;
    };
    const text = payload.choices?.[0]?.message?.content ?? "";
    const parsed = JSON.parse(text.replace(/```json|```/g, "").trim()) as {
      revealsFinalAnswer?: boolean;
    };
    return Boolean(parsed.revealsFinalAnswer);
  } catch {
    return false;
  } finally {
    clearTimeout(judgeTimer);
  }
}

export { GEMINI_JUDGE_MAX_OUTPUT_TOKENS, OPENAI_MODEL };
