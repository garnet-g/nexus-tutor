import type { NexModelCallInput, NexModelCallResult } from "./types";
import {
  getGeminiTextModel,
  getGeminiThinkingLevel,
  getNexModelMaxOutputTokens,
} from "./modelConfig";

const OPENAI_MODEL = "gpt-4o-mini";
const LLM_TIMEOUT_MS = 20_000;
const GEMINI_JUDGE_MAX_OUTPUT_TOKENS = 512;

function buildConversationText(messages: NexModelCallInput["messages"]): string {
  return messages
    .map((message) => `${message.role === "student" ? "Student" : "Nex"}: ${message.content}`)
    .join("\n\n");
}

function getMockResponse(input: NexModelCallInput): string {
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

async function callGemini(input: NexModelCallInput): Promise<string> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY not configured");
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), LLM_TIMEOUT_MS);

  try {
    const conversation = buildConversationText(input.messages);
    const prompt = `${input.systemPrompt}\n\nConversation so far:\n${conversation}\n\nNex:`;
    const model = getGeminiTextModel();

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: input.maxTokens ?? getNexModelMaxOutputTokens(),
            thinkingConfig: {
              thinkingLevel: getGeminiThinkingLevel(),
            },
          },
        }),
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

async function callOpenAI(input: NexModelCallInput): Promise<string> {
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

export async function callNexModel(
  input: NexModelCallInput,
): Promise<NexModelCallResult> {
  const hasGemini = Boolean(process.env.GEMINI_API_KEY);
  const hasOpenAI = Boolean(process.env.OPENAI_API_KEY);
  const allowOpenAIFallback = input.allowOpenAIFallback ?? true;

  if (!hasGemini && !hasOpenAI) {
    return {
      content: getMockResponse(input),
      provider: "mock",
    };
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

  return {
    content: getMockResponse(input),
    provider: "mock",
  };
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
  const content = getMockResponse(input);
  for (const chunk of chunkTextForMockStream(content)) {
    onChunk(chunk);
  }
  return { content, provider: "mock" };
}

function extractGeminiStreamText(payload: unknown): string {
  const data = payload as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };
  return data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
}

async function streamGemini(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): Promise<NexModelCallResult> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY not configured");
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), LLM_TIMEOUT_MS);

  try {
    const conversation = buildConversationText(input.messages);
    const prompt = `${input.systemPrompt}\n\nConversation so far:\n${conversation}\n\nNex:`;
    const model = getGeminiTextModel();

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?alt=sse&key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: input.maxTokens ?? getNexModelMaxOutputTokens(),
            thinkingConfig: {
              thinkingLevel: getGeminiThinkingLevel(),
            },
          },
        }),
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

    return { content: trimmed, provider: "gemini" };
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

async function streamOpenAI(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): Promise<NexModelCallResult> {
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

    return { content: trimmed, provider: "openai" };
  } finally {
    clearTimeout(timer);
  }
}

/**
 * Stream model tokens via onChunk while accumulating the full response.
 * Falls back to the other provider or non-streaming callNexModel on early failure.
 */
export async function streamNexModel(
  input: NexModelCallInput,
  onChunk: (chunk: string) => void,
): Promise<NexModelCallResult> {
  const hasGemini = Boolean(process.env.GEMINI_API_KEY);
  const hasOpenAI = Boolean(process.env.OPENAI_API_KEY);

  if (!hasGemini && !hasOpenAI) {
    return emitMockStream(input, onChunk);
  }

  if (hasGemini) {
    try {
      return await streamGemini(input, onChunk);
    } catch {
      if (hasOpenAI) {
        try {
          return await streamOpenAI(input, onChunk);
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
      return await streamOpenAI(input, onChunk);
    } catch {
      const fallback = await callNexModel(input);
      onChunk(fallback.content);
      return fallback;
    }
  }

  return emitMockStream(input, onChunk);
}

export async function callNexJudge(
  studentMessage: string,
  nexResponse: string,
): Promise<boolean> {
  const hasGemini = Boolean(process.env.GEMINI_API_KEY);
  const hasOpenAI = Boolean(process.env.OPENAI_API_KEY);

  if (!hasGemini && !hasOpenAI) {
    return false;
  }

  const judgePrompt = `You are a validator for a Socratic tutor. The student has NOT attempted the homework yet (first turn).

Student question: ${studentMessage}
Tutor response: ${nexResponse}

Does the tutor response reveal the final answer or complete solution without first asking a guiding question?

Reply with JSON only: { "revealsFinalAnswer": true | false, "reason": "..." }`;

  const judgeController = new AbortController();
  const judgeTimer = setTimeout(() => judgeController.abort(), LLM_TIMEOUT_MS);

  try {
    // Prefer OpenAI for the judge so it is independent of the primary Gemini generation.
    // If only Gemini is available, fall back to it.
    if (hasOpenAI) {
      const apiKey = process.env.OPENAI_API_KEY!;
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

      if (response.ok) {
        const payload = (await response.json()) as {
          choices?: Array<{ message?: { content?: string } }>;
        };
        const text = payload.choices?.[0]?.message?.content ?? "";
        const parsed = JSON.parse(text.replace(/```json|```/g, "").trim()) as {
          revealsFinalAnswer?: boolean;
        };
        return Boolean(parsed.revealsFinalAnswer);
      }
    }

    if (hasGemini) {
      const apiKey = process.env.GEMINI_API_KEY!;
      const model = getGeminiTextModel();
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
    }
  } catch {
    return false;
  } finally {
    clearTimeout(judgeTimer);
  }

  return false;
}
