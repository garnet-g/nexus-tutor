"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

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
      return;
    }
    setState("saved");
    router.refresh();
  }

  return { state, run };
}

export function SaveQuickNoteForm() {
  const { state, run } = useApiAction();

  return (
    <form
      className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
      onSubmit={(event) => {
        event.preventDefault();
        const form = new FormData(event.currentTarget);
        void run("/api/students/saved-items", {
          method: "POST",
          body: JSON.stringify({
            itemType: "note",
            title: String(form.get("title") ?? ""),
            description: String(form.get("description") ?? ""),
            href: "/saved",
          }),
        });
        event.currentTarget.reset();
      }}
    >
      <p className="font-semibold text-foreground">Save a quick note</p>
      <label className="mt-3 block text-sm font-medium text-foreground">
        Title
        <input
          name="title"
          required
          minLength={2}
          maxLength={160}
          className="mt-1 h-10 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 text-sm outline-none focus:border-nexus-primary"
        />
      </label>
      <label className="mt-3 block text-sm font-medium text-foreground">
        Why save it?
        <textarea
          name="description"
          maxLength={500}
          className="mt-1 min-h-20 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 py-2 text-sm outline-none focus:border-nexus-primary"
        />
      </label>
      <button
        type="submit"
        className="mt-3 h-10 rounded-xl bg-nexus-primary px-4 text-sm font-semibold text-nexus-text-inverse"
      >
        {state === "saving" ? "Saving..." : "Save note"}
      </button>
      {state === "error" ? (
        <p className="mt-2 text-xs text-nexus-danger">Could not save this note.</p>
      ) : null}
    </form>
  );
}

export function MistakeStatusButton({
  id,
  status,
  label,
}: {
  id: string;
  status: "open" | "retried" | "mastered";
  label: string;
}) {
  const { state, run } = useApiAction();
  return (
    <button
      type="button"
      onClick={() =>
        run("/api/students/mistakes", {
          method: "PATCH",
          body: JSON.stringify({ id, status }),
        })
      }
      className="rounded-xl border border-nexus-border px-3 py-1.5 text-xs font-semibold text-foreground transition-colors hover:bg-nexus-sunken"
    >
      {state === "saving" ? "Saving..." : label}
    </button>
  );
}

export function WeeklyGoalForm({
  targetMinutes,
  targetTasks,
  parentVisible,
  note,
}: {
  targetMinutes: number;
  targetTasks: number;
  parentVisible: boolean;
  note?: string | null;
}) {
  const { state, run } = useApiAction();
  return (
    <form
      className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
      onSubmit={(event) => {
        event.preventDefault();
        const form = new FormData(event.currentTarget);
        void run("/api/students/weekly-goal", {
          method: "POST",
          body: JSON.stringify({
            targetMinutes: Number(form.get("targetMinutes")),
            targetTasks: Number(form.get("targetTasks")),
            parentVisible: form.get("parentVisible") === "on",
            note: String(form.get("note") ?? ""),
          }),
        });
      }}
    >
      <div className="grid gap-3 sm:grid-cols-2">
        <label className="block text-sm font-medium text-foreground">
          Study minutes
          <input
            name="targetMinutes"
            type="number"
            min={15}
            max={3000}
            defaultValue={targetMinutes}
            className="mt-1 h-10 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 text-sm outline-none focus:border-nexus-primary"
          />
        </label>
        <label className="block text-sm font-medium text-foreground">
          Tasks
          <input
            name="targetTasks"
            type="number"
            min={1}
            max={200}
            defaultValue={targetTasks}
            className="mt-1 h-10 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 text-sm outline-none focus:border-nexus-primary"
          />
        </label>
      </div>
      <label className="mt-3 block text-sm font-medium text-foreground">
        Note
        <textarea
          name="note"
          defaultValue={note ?? ""}
          maxLength={500}
          className="mt-1 min-h-20 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 py-2 text-sm outline-none focus:border-nexus-primary"
        />
      </label>
      <label className="mt-3 flex items-center gap-2 text-sm text-foreground">
        <input
          name="parentVisible"
          type="checkbox"
          defaultChecked={parentVisible}
          className="size-4 rounded border-nexus-border"
        />
        Share this weekly goal with linked parents
      </label>
      <button
        type="submit"
        className="mt-3 h-10 rounded-xl bg-nexus-primary px-4 text-sm font-semibold text-nexus-text-inverse"
      >
        {state === "saving" ? "Saving..." : "Save weekly goal"}
      </button>
    </form>
  );
}

export function FocusSessionForm() {
  const { state, run } = useApiAction();
  return (
    <form
      className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
      onSubmit={(event) => {
        event.preventDefault();
        const form = new FormData(event.currentTarget);
        void run("/api/students/focus-sessions", {
          method: "POST",
          body: JSON.stringify({
            subject: String(form.get("subject") ?? ""),
            durationMinutes: Number(form.get("durationMinutes")),
            status: "in_progress",
          }),
        });
      }}
    >
      <div className="grid gap-3 sm:grid-cols-[1fr_140px]">
        <label className="block text-sm font-medium text-foreground">
          Focus
          <input
            name="subject"
            placeholder="Algebra, Biology, revision..."
            className="mt-1 h-10 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 text-sm outline-none focus:border-nexus-primary"
          />
        </label>
        <label className="block text-sm font-medium text-foreground">
          Minutes
          <input
            name="durationMinutes"
            type="number"
            min={5}
            max={240}
            defaultValue={25}
            className="mt-1 h-10 w-full rounded-xl border border-nexus-border bg-nexus-background px-3 text-sm outline-none focus:border-nexus-primary"
          />
        </label>
      </div>
      <button
        type="submit"
        className="mt-3 h-10 rounded-xl bg-nexus-primary px-4 text-sm font-semibold text-nexus-text-inverse"
      >
        {state === "saving" ? "Starting..." : "Start focus session"}
      </button>
    </form>
  );
}

export function FocusStatusButton({
  id,
  status,
  label,
}: {
  id: string;
  status: "planned" | "in_progress" | "completed" | "cancelled";
  label: string;
}) {
  const { state, run } = useApiAction();
  return (
    <button
      type="button"
      onClick={() =>
        run("/api/students/focus-sessions", {
          method: "PATCH",
          body: JSON.stringify({ id, status }),
        })
      }
      className="rounded-xl border border-nexus-border px-3 py-1.5 text-xs font-semibold text-foreground transition-colors hover:bg-nexus-sunken"
    >
      {state === "saving" ? "Saving..." : label}
    </button>
  );
}

export function OfflinePackButton({
  packKey,
  title,
  description,
  sizeKb,
}: {
  packKey: string;
  title: string;
  description: string;
  sizeKb: number;
}) {
  const { state, run } = useApiAction();
  return (
    <button
      type="button"
      onClick={() =>
        run("/api/students/offline-packs", {
          method: "POST",
          body: JSON.stringify({
            packKey,
            title,
            description,
            status: "downloaded",
            sizeKb,
          }),
        })
      }
      className="rounded-xl bg-nexus-primary px-3 py-1.5 text-xs font-semibold text-nexus-text-inverse"
    >
      {state === "saving" ? "Preparing..." : "Prepare pack"}
    </button>
  );
}
