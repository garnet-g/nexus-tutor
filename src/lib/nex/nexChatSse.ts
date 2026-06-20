export type NexChatStreamDonePayload = {
  nexSessionId: string;
  nexMessageId: string;
  nexResponse: string;
  sessionMode: string;
  provider: string;
  validationPassed: boolean;
};

export function encodeNexChatSseEvent(event: string, data: unknown): string {
  return `event: ${event}\ndata: ${JSON.stringify(data)}\n\n`;
}

export function parseNexChatSseEvent(block: string): {
  event: string;
  data: string;
} | null {
  const lines = block.split("\n");
  let event = "message";
  const dataLines: string[] = [];

  for (const line of lines) {
    if (line.startsWith("event:")) {
      event = line.slice(6).trim();
      continue;
    }

    if (line.startsWith("data:")) {
      dataLines.push(line.slice(5).trim());
    }
  }

  if (!dataLines.length) {
    return null;
  }

  return { event, data: dataLines.join("\n") };
}
