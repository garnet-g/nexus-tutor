"use client";

import { useMemo, useState } from "react";

import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { inputVariants } from "@/components/ui/Input";
import { CameraCaptureButton } from "@/features/nex/components/CameraCaptureButton";
import { VoicePushToTalk } from "@/features/nex/components/VoicePushToTalk";
import type { NexMode } from "@/lib/nex/types";
import type { LearningPreferences } from "@/schemas/profileSchemas";
import { cn } from "@/lib/utils";

type ChatRole = "student" | "nex";

interface ChatMessage {
  id: string;
  role: ChatRole;
  content: string;
}

interface NexChatPanelProps {
  initialSessionId?: string | null;
  initialMode?: NexMode;
  topicId?: string | null;
  cameraEnabled?: boolean;
  voiceEnabled?: boolean;
  learningPreferences?: LearningPreferences | null;
  className?: string;
}

const MODE_OPTIONS: Array<{ value: NexMode; label: string }> = [
  { value: "explain", label: "Explain" },
  { value: "practice", label: "Practice" },
  { value: "homework", label: "Homework" },
  { value: "revision", label: "Revision" },
  { value: "assessment", label: "Assessment" },
];

export function NexChatPanel({
  initialSessionId = null,
  initialMode = "homework",
  topicId = null,
  cameraEnabled = false,
  voiceEnabled = false,
  learningPreferences = null,
  className,
}: NexChatPanelProps) {
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: "welcome",
      role: "nex",
      content:
        "Hi — I'm Nex. Ask me to explain a concept, quiz you, help with homework, run a quick assessment, or build a revision plan.",
    },
  ]);
  const [input, setInput] = useState("");
  const [sessionId, setSessionId] = useState<string | null>(initialSessionId);
  const [sessionMode, setSessionMode] = useState<NexMode>(initialMode);
  const [isSending, setIsSending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const canSend = useMemo(
    () => input.trim().length > 0 && !isSending,
    [input, isSending],
  );

  async function handleSend(event?: React.FormEvent) {
    event?.preventDefault();
    const studentMessage = input.trim();
    if (!studentMessage || isSending) {
      return;
    }

    const studentId = crypto.randomUUID();
    setMessages((current) => [
      ...current,
      { id: studentId, role: "student", content: studentMessage },
    ]);
    setInput("");
    setIsSending(true);
    setError(null);

    try {
      const response = await fetch("/api/nex/chat", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          nexSessionId: sessionId,
          studentMessage,
          sessionMode,
          topicId,
          ...(learningPreferences
            ? { learningPreferences }
            : {}),
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          nexSessionId: string;
          nexMessageId: string;
          nexResponse: string;
          sessionMode: NexMode;
        };
        error?: { message?: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        throw new Error(payload.error?.message ?? "Nex could not respond.");
      }

      setSessionId(payload.data.nexSessionId);
      setSessionMode(payload.data.sessionMode);
      setMessages((current) => [
        ...current,
        {
          id: payload.data!.nexMessageId,
          role: "nex",
          content: payload.data!.nexResponse,
        },
      ]);
    } catch (sendError) {
      setError(
        sendError instanceof Error
          ? sendError.message
          : "Something went wrong.",
      );
    } finally {
      setIsSending(false);
    }
  }

  return (
    <Card
      className={cn(
        "flex h-full min-h-[520px] flex-col p-0",
        className,
      )}
    >
      <header className="border-b border-border px-4 py-3">
        <div className="flex items-center justify-between gap-3">
          <div>
            <p className="text-sm font-semibold text-foreground">Nex</p>
            <p className="text-xs text-muted-foreground">Your AI teacher</p>
          </div>
          <label className="text-xs text-muted-foreground">
            Mode
            <select
              value={sessionMode}
              onChange={(event) =>
                setSessionMode(event.target.value as NexMode)
              }
              className="ml-2 rounded-lg border border-border bg-card px-2 py-1 text-sm text-foreground"
            >
              {MODE_OPTIONS.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </label>
        </div>
      </header>

      <div className="flex-1 space-y-3 overflow-y-auto px-4 py-4">
        {messages.map((message) => (
          <article
            key={message.id}
            className={cn(
              "max-w-[90%] rounded-2xl px-4 py-3 text-sm leading-6 whitespace-pre-wrap",
              message.role === "student"
                ? "ml-auto rounded-br-sm bg-primary text-nexus-text-inverse"
                : "rounded-bl-sm border border-border bg-card text-foreground",
            )}
          >
            {message.content}
          </article>
        ))}
        {isSending ? (
          <p className="text-xs text-muted-foreground">Nex is thinking...</p>
        ) : null}
      </div>

      {error ? (
        <p className="px-4 pb-2 text-sm text-nexus-danger" role="alert">
          {error}
        </p>
      ) : null}

      <form
        onSubmit={handleSend}
        className="border-t border-border px-4 py-3"
      >
        <CameraCaptureButton
          sessionMode={sessionMode}
          sessionId={sessionId}
          topicId={topicId}
          cameraEnabled={cameraEnabled}
          disabled={isSending}
          className="mb-3"
          onPhotoProcessed={(payload) => {
            setSessionId(payload.nexSessionId);
            setSessionMode(payload.sessionMode);
            setMessages((current) => [
              ...current,
              {
                id: crypto.randomUUID(),
                role: "student",
                content: payload.studentMessage,
              },
              {
                id: payload.nexMessageId,
                role: "nex",
                content: payload.nexResponse,
              },
            ]);
            setError(null);
          }}
          onError={(message) => setError(message)}
        />
        <VoicePushToTalk
          sessionMode={sessionMode}
          sessionId={sessionId}
          topicId={topicId}
          voiceEnabled={voiceEnabled}
          disabled={isSending}
          className="mb-3"
          onVoiceProcessed={(payload) => {
            setSessionId(payload.nexSessionId);
            setSessionMode(payload.sessionMode);
            setMessages((current) => [
              ...current,
              {
                id: crypto.randomUUID(),
                role: "student",
                content: payload.transcript,
              },
              {
                id: payload.nexMessageId,
                role: "nex",
                content: payload.nexResponse,
              },
            ]);
            setError(null);
          }}
          onError={(message) => setError(message)}
        />
        <div className="flex items-end gap-2">
          <textarea
            value={input}
            onChange={(event) => setInput(event.target.value)}
            rows={2}
            placeholder="Ask Nex about Mathematics, Science, or English..."
            className={cn(
              inputVariants(),
              "min-h-[48px] flex-1 resize-none py-2",
            )}
          />
          <Button type="submit" disabled={!canSend} size="sm" className="min-h-10">
            Send
          </Button>
        </div>
      </form>
    </Card>
  );
}
