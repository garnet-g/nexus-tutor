import type { NexModelCallInput, NexModelCallResult } from "./types";

const GEMINI_MODEL = "gemini-2.0-flash";
const OPENAI_MODEL = "gpt-4o-mini";
const LLM_TIMEOUT_MS = 20_000;

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

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: input.maxTokens ?? 500,
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
        max_tokens: input.maxTokens ?? 500,
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
    } catch {
      if (hasOpenAI) {
        return {
          content: await callOpenAI(input),
          provider: "openai",
        };
      }
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
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${apiKey}`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: [{ parts: [{ text: judgePrompt }] }],
            generationConfig: { temperature: 0, maxOutputTokens: 120 },
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
