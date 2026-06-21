"use client";

import { RotateCcw } from "lucide-react";
import { useMemo, useRef, useState } from "react";

import { NexMark } from "@/components/NexMark";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { inputVariants } from "@/components/ui/Input";
import { CameraCaptureButton } from "@/features/nex/components/CameraCaptureButton";
import { NexChatEmptyState } from "@/features/nex/components/NexChatEmptyState";
import { NexDailyLimitBanner } from "@/features/nex/components/NexDailyLimitBanner";
import {
  NexModeSelector,
  toVisibleMode,
  type NexVisibleMode,
} from "@/features/nex/components/NexModeSelector";
import { NexFollowUpChips } from "@/features/nex/components/NexFollowUpChips";
import { NexMessageContent } from "@/features/nex/components/NexMessageContent";
import { NexScratchpad } from "@/features/nex/components/NexScratchpad";
import { NexThinkingIndicator } from "@/features/nex/components/NexThinkingIndicator";
import { consumeNexChatStream } from "@/features/nex/lib/consumeNexChatStream";
import { VoicePushToTalk } from "@/features/nex/components/VoicePushToTalk";
import type { NexMode } from "@/lib/nex/types";
import type { LearningPreferences } from "@/schemas/profileSchemas";
import { cn } from "@/lib/utils";

type ChatRole = "student" | "nex";

interface ChatMessage {
  id: string;
  role: ChatRole;
  content: string;
  isStreaming?: boolean;
}

interface NexChatPanelProps {
  initialSessionId?: string | null;
  initialMode?: NexMode;
  initialMessages?: ChatMessage[];
  topicId?: string | null;
  cameraEnabled?: boolean;
  voiceEnabled?: boolean;
  learningPreferences?: LearningPreferences | null;
  dailyUsage: number;
  dailyLimit: number;
  retryAfterSeconds: number;
  planCode: string;
  className?: string;
}

export function NexChatPanel({
  initialSessionId = null,
  initialMode = "homework",
  initialMessages = [],
  topicId = null,
  cameraEnabled = false,
  voiceEnabled = false,
  learningPreferences = null,
  dailyUsage: initialDailyUsage,
  dailyLimit,
  retryAfterSeconds,
  planCode,
  className,
}: NexChatPanelProps) {
  const [messages, setMessages] = useState<ChatMessage[]>(() =>
    initialMessages.map((message) => ({ ...message, isStreaming: false })),
  );
  const [input, setInput] = useState("");
  const [sessionId, setSessionId] = useState<string | null>(initialSessionId);
  const [sessionMode, setSessionMode] = useState<NexVisibleMode>(
    toVisibleMode(initialMode),
  );
  const [dailyUsage, setDailyUsage] = useState(initialDailyUsage);
  const [isSending, setIsSending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const atLimit = dailyUsage >= dailyLimit;

  const canSend = useMemo(
    () => input.trim().length > 0 && !isSending && !atLimit,
    [atLimit, input, isSending],
  );

  const lastMessage = messages[messages.length - 1];
  const showFollowUps =
    !isSending &&
    !atLimit &&
    lastMessage?.role === "nex" &&
    messages.length > 0;

  async function sendMessage(studentMessage: string) {
    const trimmed = studentMessage.trim();
    if (!trimmed || isSending || atLimit) {
      return;
    }

    const studentId = crypto.randomUUID();
    const streamingNexId = crypto.randomUUID();
    setMessages((current) => [
      ...current,
      { id: studentId, role: "student", content: trimmed },
      { id: streamingNexId, role: "nex", content: "", isStreaming: true },
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
          studentMessage: trimmed,
          sessionMode,
          topicId,
          ...(learningPreferences ? { learningPreferences } : {}),
        }),
      });

      const contentType = response.headers.get("content-type") ?? "";

      if (contentType.includes("text/event-stream")) {
        await consumeNexChatStream(response, {
          onChunk: (text) => {
            setMessages((current) =>
              current.map((message) =>
                message.id === streamingNexId
                  ? { ...message, content: message.content + text }
                  : message,
              ),
            );
          },
          onReplace: (text) => {
            setMessages((current) =>
              current.map((message) =>
                message.id === streamingNexId ? { ...message, content: text } : message,
              ),
            );
          },
          onDone: (payload) => {
            setSessionId(payload.nexSessionId);
            setSessionMode(toVisibleMode(payload.sessionMode as NexMode));
            setDailyUsage((count) => Math.min(dailyLimit, count + 1));
            setMessages((current) =>
              current.map((message) =>
                message.id === streamingNexId
                  ? {
                      id: payload.nexMessageId,
                      role: "nex",
                      content: payload.nexResponse,
                    }
                  : message,
              ),
            );
          },
          onError: (message, partial) => {
            if (partial) {
              setMessages((current) =>
                current.map((item) =>
                  item.id === streamingNexId
                    ? { ...item, content: partial, isStreaming: false }
                    : item,
                ),
              );
            } else {
              setMessages((current) =>
                current.filter((item) => item.id !== streamingNexId),
              );
            }
            throw new Error(message);
          },
        });

        return;
      }

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          nexSessionId: string;
          nexMessageId: string;
          nexResponse: string;
          sessionMode: NexMode;
        };
        error?: {
          message?: string;
          code?: string;
          details?: {
            retryAfterSeconds?: number;
            dailyLimit?: number;
            currentUsage?: number;
          };
        };
      };

      if (response.status === 429 || payload.error?.code === "RATE_LIMITED") {
        setMessages((current) => current.filter((item) => item.id !== streamingNexId));
        setDailyUsage(payload.error?.details?.currentUsage ?? dailyLimit);
        throw new Error(
          payload.error?.message ?? "Daily Nex message limit reached.",
        );
      }

      if (!response.ok || !payload.success || !payload.data) {
        setMessages((current) => current.filter((item) => item.id !== streamingNexId));
        throw new Error(payload.error?.message ?? "Nex could not respond.");
      }

      setSessionId(payload.data.nexSessionId);
      setSessionMode(toVisibleMode(payload.data.sessionMode));
      setDailyUsage((count) => Math.min(dailyLimit, count + 1));
      setMessages((current) =>
        current.map((message) =>
          message.id === streamingNexId
            ? {
                id: payload.data!.nexMessageId,
                role: "nex",
                content: payload.data!.nexResponse,
              }
            : message,
        ),
      );
    } catch (sendError) {
      setMessages((current) =>
        current.filter(
          (message) =>
            !(message.id === streamingNexId && message.content.length === 0),
        ),
      );
      setError(
        sendError instanceof Error
          ? sendError.message
          : "Something went wrong.",
      );
    } finally {
      setIsSending(false);
    }
  }

  async function handleSend(event?: React.FormEvent) {
    event?.preventDefault();
    await sendMessage(input);
  }

  function handleFollowUp(prompt: string) {
    void sendMessage(prompt);
  }

  function handleStarterPrompt(prompt: string) {
    void sendMessage(prompt);
  }

  function handleNewChat() {
    setMessages([]);
    setSessionId(null);
    setInput("");
    setError(null);
  }

  return (
    <Card
      className={cn(
        "flex h-full min-h-[520px] flex-col overflow-hidden p-0",
        className,
      )}
    >
      <header className="space-y-3 border-b border-border px-4 py-3">
        <div className="flex items-center justify-between gap-3">
          <div className="flex min-w-0 items-center gap-3">
            <NexMark size={32} />
            <div>
              <p className="font-heading text-sm font-semibold text-foreground">
                Nex
              </p>
              <p className="text-xs text-muted-foreground">Your AI teacher</p>
            </div>
          </div>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleNewChat}
            disabled={isSending}
          >
            <RotateCcw className="size-3.5" aria-hidden="true" />
            New chat
          </Button>
        </div>
        <NexModeSelector
          value={sessionMode}
          onChange={setSessionMode}
          disabled={isSending || atLimit}
        />
      </header>

      <NexDailyLimitBanner
        dailyUsage={dailyUsage}
        dailyLimit={dailyLimit}
        retryAfterSeconds={retryAfterSeconds}
        planCode={planCode}
        atLimit={atLimit}
      />

      <div className="flex-1 space-y-4 overflow-y-auto px-4 py-4 no-scrollbar">
        {messages.length === 0 && !isSending ? (
          <NexChatEmptyState
            mode={sessionMode}
            onSelectPrompt={handleStarterPrompt}
            disabled={atLimit}
          />
        ) : (
          messages.map((message, index) => {
            const isLatestNex =
              message.role === "nex" && index === messages.length - 1;

            return (
              <div key={message.id} className="space-y-2">
                <article
                  className={cn(
                    "max-w-[92%] rounded-2xl px-4 py-3 text-sm",
                    message.role === "student"
                      ? "ml-auto rounded-br-sm bg-nexus-primary text-nexus-text-inverse"
                      : "rounded-bl-sm border border-nexus-border bg-nexus-primary-soft shadow-nex",
                  )}
                >
                  {message.role === "nex" ? (
                    <div className="mb-2 flex items-center gap-2">
                      <NexMark size={20} />
                      <span className="text-xs font-semibold uppercase tracking-wide text-nexus-primary">
                        Nex
                      </span>
                    </div>
                  ) : null}
                  {message.role === "nex" &&
                  message.isStreaming &&
                  message.content.length === 0 ? (
                    <NexThinkingIndicator />
                  ) : (
                    <NexMessageContent
                      content={message.content}
                      variant={message.role === "student" ? "student" : "nex"}
                      isStreaming={message.isStreaming}
                    />
                  )}
                </article>
                {isLatestNex && showFollowUps ? (
                  <NexFollowUpChips onSelect={handleFollowUp} />
                ) : null}
              </div>
            );
          })
        )}
        {isSending &&
        !messages.some(
          (message) => message.role === "nex" && message.isStreaming,
        ) ? (
          <NexThinkingIndicator />
        ) : null}
      </div>

      {error ? (
        <p className="px-4 pb-2 text-sm text-nexus-danger" role="alert">
          {error}
        </p>
      ) : null}

      <NexScratchpad />

      <form
        onSubmit={handleSend}
        className="border-t border-border px-4 py-3"
      >
        <CameraCaptureButton
          sessionMode={sessionMode}
          sessionId={sessionId}
          topicId={topicId}
          cameraEnabled={cameraEnabled}
          disabled={isSending || atLimit}
          className="mb-3"
          onPhotoProcessed={(payload) => {
            setSessionId(payload.nexSessionId);
            setSessionMode(toVisibleMode(payload.sessionMode));
            setDailyUsage((count) => Math.min(dailyLimit, count + 1));
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
          disabled={isSending || atLimit}
          className="mb-3"
          onVoiceProcessed={(payload) => {
            setSessionId(payload.nexSessionId);
            setSessionMode(toVisibleMode(payload.sessionMode));
            setDailyUsage((count) => Math.min(dailyLimit, count + 1));
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
            ref={textareaRef}
            value={input}
            onChange={(event) => setInput(event.target.value)}
            rows={2}
            placeholder={
              atLimit
                ? "Daily message limit reached — try again after reset."
                : "Ask Nex about Mathematics, Science, or English..."
            }
            disabled={atLimit}
            className={cn(
              inputVariants(),
              "min-h-[48px] flex-1 resize-none py-2",
              atLimit && "opacity-60",
            )}
          />
          <Button
            type="submit"
            disabled={!canSend}
            size="sm"
            className="min-h-12 min-w-[72px]"
          >
            Send
          </Button>
        </div>
      </form>
    </Card>
  );
}
