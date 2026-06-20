import type { NexChatStreamDonePayload } from "@/lib/nex/nexChatSse";
import { parseNexChatSseEvent } from "@/lib/nex/nexChatSse";

interface NexChatStreamHandlers {
  onChunk: (text: string) => void;
  onReplace: (text: string) => void;
  onDone: (payload: NexChatStreamDonePayload) => void;
  onError: (message: string, partial?: string) => void;
}

export async function consumeNexChatStream(
  response: Response,
  handlers: NexChatStreamHandlers,
): Promise<void> {
  if (!response.body) {
    throw new Error("Nex stream response had no body.");
  }

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
      const separator = buffer.indexOf("\n\n");
      if (separator === -1) {
        break;
      }

      const block = buffer.slice(0, separator);
      buffer = buffer.slice(separator + 2);
      const parsed = parseNexChatSseEvent(block);

      if (!parsed) {
        continue;
      }

      if (parsed.event === "chunk") {
        const payload = JSON.parse(parsed.data) as { text?: string };
        if (payload.text) {
          handlers.onChunk(payload.text);
        }
        continue;
      }

      if (parsed.event === "replace") {
        const payload = JSON.parse(parsed.data) as { text?: string };
        if (payload.text) {
          handlers.onReplace(payload.text);
        }
        continue;
      }

      if (parsed.event === "done") {
        handlers.onDone(JSON.parse(parsed.data) as NexChatStreamDonePayload);
        continue;
      }

      if (parsed.event === "error") {
        const payload = JSON.parse(parsed.data) as {
          message?: string;
          partial?: string;
        };
        handlers.onError(payload.message ?? "Nex could not respond.", payload.partial);
        throw new Error(payload.message ?? "Nex could not respond.");
      }
    }
  }
}
