import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export interface ContextCacheInput {
  sessionId: string;
  systemPrompt: string;
  messages: Array<{ role: "student" | "nex"; content: string }>;
  model: string;
}

export async function getOrCreateContextCache(
  input: ContextCacheInput,
): Promise<string | null> {
  const admin = createAdminClient();

  // 1. Check if the session already has an active, unexpired cache
  const { data: session } = await admin
    .from("nex_sessions")
    .select("metadata")
    .eq("id", input.sessionId)
    .maybeSingle();

  const metadata = (session?.metadata as Record<string, unknown>) ?? {};
  if (
    typeof metadata.contextCacheName === "string" &&
    typeof metadata.contextCacheExpiresAt === "string"
  ) {
    const expiresAt = new Date(metadata.contextCacheExpiresAt).getTime();
    if (expiresAt > Date.now() + 15_000) {
      return metadata.contextCacheName;
    }
  }

  // Only cache if there's enough history to make it cost-efficient (>= 6 messages)
  if (input.messages.length < 6) {
    return null;
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return null;
  }

  // Cache the system instructions and the first 6 messages of history
  const cacheMessages = input.messages.slice(0, 6);
  const cacheContents = cacheMessages.map((message) => ({
    role: message.role === "student" ? "user" : "model",
    parts: [{ text: message.content }],
  }));

  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/cachedContents?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          model: `models/${input.model}`,
          contents: cacheContents,
          systemInstruction: { parts: [{ text: input.systemPrompt }] },
          ttl: "300s",
        }),
      },
    );

    if (!response.ok) {
      return null;
    }

    const payload = (await response.json()) as { name: string; expireTime: string };
    const cacheName = payload.name;

    const updatedMetadata = {
      ...metadata,
      contextCacheName: cacheName,
      contextCacheExpiresAt: payload.expireTime,
    };

    await admin
      .from("nex_sessions")
      .update({ metadata: updatedMetadata })
      .eq("id", input.sessionId);

    return cacheName;
  } catch {
    return null;
  }
}
