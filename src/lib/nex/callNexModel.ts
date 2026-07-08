import type { NexModelCallInput, NexModelCallResult } from "./types";
import {
  assertNexConfiguredForLiveMode,
  createMockAdapterMetadata,
  isGeminiConfigured,
  isNexMockAllowed,
  isOpenAiConfigured,
} from "@/lib/env/providerModes";
import {
  callGemini,
  getMockNexResponse,
  streamGemini,
} from "./geminiClient";
import {
  callOpenAI,
  callOpenAiJudge,
  GEMINI_JUDGE_MAX_OUTPUT_TOKENS,
  OPENAI_MODEL,
  streamOpenAI,
} from "./openaiClient";
import { getGeminiTextModelForTier, getGeminiThinkingLevel } from "./modelConfig";

const LLM_TIMEOUT_MS = 20_000;

function buildMockResult(input: NexModelCallInput): NexModelCallResult {
  return {
    content: getMockNexResponse(input),
    provider: "mock",
  };
}

function resolveMockResult(input: NexModelCallInput): NexModelCallResult {
  if (!isNexMockAllowed()) {
    assertNexConfiguredForLiveMode();
  }

  return buildMockResult(input);
}

export async function callNexModel(
  input: NexModelCallInput,
): Promise<NexModelCallResult> {
  const hasGemini = isGeminiConfigured();
  const hasOpenAI = isOpenAiConfigured();
  const allowOpenAIFallback = input.allowOpenAIFallback ?? true;

  if (!hasGemini && !hasOpenAI) {
    return resolveMockResult(input);
  }

  if (hasGemini) {
    try {
      return {
        content: await callGemini(input),
        provider: "gemini",
      };
    } catch (error) {
      if (allowOpenAIFallback && hasOpenAI) {
        return {
          content: await callOpenAI(input),
          provider: "openai",
        };
      }

      throw error;
    }
  }

  if (hasOpenAI) {
    return {
      content: await callOpenAI(input),
      provider: "openai",
    };
  }

  return resolveMockResult(input);
}

export function chunkTextForMockStream(text: string, chunkSize = 12): string[] {
  const chunks: string[] = [];
  for (let index = 0; index < text.length; index += chunkSize) {
    chunks.push(text.slice(index, index + chunkSize));
  }
  return chunks.length ? chunks : [text];
}

function emitMockStream(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): NexModelCallResult {
  const content = getMockNexResponse(input);
  for (const chunk of chunkTextForMockStream(content)) {
    onChunk(chunk);
  }
  return buildMockResult(input);
}

function resolveMockStream(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): NexModelCallResult {
  if (!isNexMockAllowed()) {
    assertNexConfiguredForLiveMode();
  }

  return emitMockStream(input, onChunk);
}

export async function streamNexModel(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): Promise<NexModelCallResult> {
  const hasGemini = isGeminiConfigured();
  const hasOpenAI = isOpenAiConfigured();

  if (!hasGemini && !hasOpenAI) {
    return resolveMockStream(input, onChunk);
  }

  if (hasGemini) {
    try {
      const content = await streamGemini(input, onChunk);
      return { content, provider: "gemini" };
    } catch {
      if (hasOpenAI) {
        try {
          const content = await streamOpenAI(input, onChunk);
          return { content, provider: "openai" };
        } catch {
          const fallback = await callNexModel(input);
          onChunk(fallback.content);
          return fallback;
        }
      }

      const fallback = await callNexModel(input);
      onChunk(fallback.content);
      return fallback;
    }
  }

  if (hasOpenAI) {
    try {
      const content = await streamOpenAI(input, onChunk);
      return { content, provider: "openai" };
    } catch {
      const fallback = await callNexModel(input);
      onChunk(fallback.content);
      return fallback;
    }
  }

  return resolveMockStream(input, onChunk);
}

export async function callNexJudge(
  studentMessage: string,
  nexResponse: string,
): Promise<boolean> {
  const hasGemini = isGeminiConfigured();
  const hasOpenAI = isOpenAiConfigured();

  if (!hasGemini && !hasOpenAI) {
    if (!isNexMockAllowed()) {
      assertNexConfiguredForLiveMode();
    }
    return false;
  }

  if (hasOpenAI) {
    return callOpenAiJudge(studentMessage, nexResponse);
  }

  if (hasGemini) {
    const apiKey = process.env.GEMINI_API_KEY!;
    const model = getGeminiTextModelForTier("lite");
    const judgePrompt = `You are a validator for a Socratic tutor. The student has NOT attempted the homework yet (first turn).

Student question: ${studentMessage}
Tutor response: ${nexResponse}

Does the tutor response reveal the final answer or complete solution without first asking a guiding question?

Reply with JSON only: { "revealsFinalAnswer": true | false, "reason": "..." }`;

    const judgeController = new AbortController();
    const judgeTimer = setTimeout(() => judgeController.abort(), LLM_TIMEOUT_MS);

    try {
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: [{ parts: [{ text: judgePrompt }] }],
            generationConfig: {
              temperature: 0,
              maxOutputTokens: GEMINI_JUDGE_MAX_OUTPUT_TOKENS,
              thinkingConfig: {
                thinkingLevel: getGeminiThinkingLevel(),
              },
            },
          }),
          signal: judgeController.signal,
        },
      );

      if (response.ok) {
        const payload = (await response.json()) as {
          candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
        };
        const text = payload.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
        const parsed = JSON.parse(text.replace(/```json|```/g, "").trim()) as {
          revealsFinalAnswer?: boolean;
        };
        return Boolean(parsed.revealsFinalAnswer);
      }
    } catch {
      return false;
    } finally {
      clearTimeout(judgeTimer);
    }
  }

  return false;
}

export { createMockAdapterMetadata, OPENAI_MODEL };
