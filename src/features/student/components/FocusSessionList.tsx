"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { Clock3 } from "lucide-react";

type ApiState = "idle" | "saving" | "saved" | "error";

function useApiAction() {
  const router = useRouter();
  const [state, setState] = useState<ApiState>("idle");

  async function run(url: string, init: RequestInit) {
    setState("saving");
    const response = await fetch(url, {
      ...init,
      headers: {
        "Content-Type": "application/json",
        ...(init.headers ?? {}),
      },
    });
    if (!response.ok) {
      setState("error");
      return false;
    }
    setState("saved");
    router.refresh();
    return true;
  }

  return { state, run };
}

type FocusSession = {
  id: string;
  subject: string | null;
  topicTitle: string | null;
  durationMinutes: number;
  creditedMinutes?: number;
  status: "planned" | "in_progress" | "completed" | "cancelled";
  startedAt: string | null;
  completedAt: string | null;
};

function FocusSessionTimer({
  session,
}: {
  session: FocusSession;
}) {
  const router = useRouter();
  const { state, run } = useApiAction();
  const [now, setNow] = useState(() => Date.now());

  const endAt = useMemo(() => {
    if (!session.startedAt) {
      return null;
    }

    return new Date(session.startedAt).getTime() + session.durationMinutes * 60_000;
  }, [session.durationMinutes, session.startedAt]);

  useEffect(() => {
    const timer = window.setInterval(() => setNow(Date.now()), 1000);
    return () => window.clearInterval(timer);
  }, []);

  const remainingMs = endAt ? Math.max(0, endAt - now) : session.durationMinutes * 60_000;
  const remainingMinutes = Math.floor(remainingMs / 60_000);
  const remainingSeconds = Math.floor((remainingMs % 60_000) / 1000);
  const canComplete = endAt ? remainingMs <= 0 : false;

  useEffect(() => {
    if (!canComplete || state === "saving") {
      return;
    }

    void run("/api/students/focus-sessions", {
      method: "PATCH",
      body: JSON.stringify({ id: session.id, status: "completed" }),
    }).then(() => router.refresh());
  }, [canComplete, router, run, session.id, state]);

  return (
    <div className="mt-3 space-y-2">
      <p className="font-mono text-2xl font-semibold tabular text-foreground">
        {String(remainingMinutes).padStart(2, "0")}:
        {String(remainingSeconds).padStart(2, "0")}
      </p>
      <p className="text-xs text-muted-foreground">
        {canComplete
          ? "Timer finished — saving your focus credit…"
          : "Stay on task until the timer reaches zero to earn credit."}
      </p>
      <button
        type="button"
        disabled={state === "saving"}
        onClick={() =>
          void run("/api/students/focus-sessions", {
            method: "PATCH",
            body: JSON.stringify({ id: session.id, status: "cancelled" }),
          }).then(() => router.refresh())
        }
        className="rounded-xl border border-nexus-border px-3 py-1.5 text-xs font-semibold text-foreground transition-colors hover:bg-nexus-sunken"
      >
        Cancel
      </button>
    </div>
  );
}

export function FocusSessionList({ sessions }: { sessions: FocusSession[] }) {
  const router = useRouter();
  const { state, run } = useApiAction();

  return (
    <section className="space-y-3">
      {sessions.map((session) => (
        <article
          key={session.id}
          className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
        >
          <div className="flex items-start gap-3">
            <span className="flex size-10 flex-none items-center justify-center rounded-xl bg-nexus-sunken text-nexus-primary">
              <Clock3 className="size-5" />
            </span>
            <div className="min-w-0 flex-1">
              <p className="font-semibold text-foreground">
                {session.subject || session.topicTitle || "Focus session"}
              </p>
              <p className="text-sm text-muted-foreground">
                {session.durationMinutes} minutes · {session.status.replace("_", " ")}
                {session.status === "completed"
                  ? ` · ${session.creditedMinutes ?? 0}m credited`
                  : null}
              </p>

              {session.status === "in_progress" ? (
                <FocusSessionTimer session={session} />
              ) : null}

              {session.status === "planned" ? (
                <div className="mt-3 flex flex-wrap gap-2">
                  <button
                    type="button"
                    disabled={state === "saving"}
                    onClick={() =>
                      void run("/api/students/focus-sessions", {
                        method: "PATCH",
                        body: JSON.stringify({ id: session.id, status: "cancelled" }),
                      }).then(() => router.refresh())
                    }
                    className="rounded-xl border border-nexus-border px-3 py-1.5 text-xs font-semibold text-foreground transition-colors hover:bg-nexus-sunken"
                  >
                    Cancel
                  </button>
                </div>
              ) : null}
            </div>
          </div>
        </article>
      ))}
    </section>
  );
}
