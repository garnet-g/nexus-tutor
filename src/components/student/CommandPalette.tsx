"use client";

import { Fragment, useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import {
  BarChart3,
  BookOpen,
  CalendarDays,
  CornerDownLeft,
  Home,
  Search,
  Sparkles,
  Target,
  User,
} from "lucide-react";

import { cn } from "@/lib/utils";

interface CommandItem {
  id: string;
  label: string;
  group: "Go to" | "Actions";
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  keywords?: string;
}

const COMMANDS: CommandItem[] = [
  { id: "dashboard", label: "Today", group: "Go to", href: "/dashboard", icon: Home, keywords: "dashboard home" },
  { id: "learn", label: "Learn", group: "Go to", href: "/learn", icon: BookOpen, keywords: "topics lessons" },
  { id: "nex", label: "Nex", group: "Go to", href: "/nex", icon: Sparkles, keywords: "tutor ai chat" },
  { id: "practice", label: "Practice", group: "Go to", href: "/practice", icon: Target, keywords: "questions session" },
  { id: "progress", label: "Progress", group: "Go to", href: "/progress", icon: BarChart3, keywords: "mastery health score" },
  { id: "study-plan", label: "Study Plan", group: "Go to", href: "/study-plan", icon: CalendarDays, keywords: "daily goal" },
  { id: "profile", label: "Profile", group: "Go to", href: "/profile", icon: User, keywords: "account settings" },
  { id: "ask-nex", label: "Ask Nex a question", group: "Actions", href: "/nex", icon: Sparkles, keywords: "help explain homework" },
  { id: "start-practice", label: "Start a practice session", group: "Actions", href: "/practice", icon: Target, keywords: "quiz" },
];

interface CommandPaletteProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function CommandPalette({ open, onOpenChange }: CommandPaletteProps) {
  const router = useRouter();
  const [query, setQuery] = useState("");
  const [active, setActive] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return COMMANDS;
    return COMMANDS.filter((command) =>
      `${command.label} ${command.keywords ?? ""}`.toLowerCase().includes(q),
    );
  }, [query]);

  const safeActive = Math.min(active, Math.max(0, results.length - 1));

  useEffect(() => {
    if (open) {
      const id = window.setTimeout(() => inputRef.current?.focus(), 20);
      return () => window.clearTimeout(id);
    }
    return undefined;
  }, [open]);

  if (!open) return null;

  function closePalette() {
    onOpenChange(false);
    setQuery("");
    setActive(0);
  }

  function run(command: CommandItem) {
    closePalette();
    router.push(command.href);
  }

  function handleKeyDown(event: React.KeyboardEvent) {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      setActive((index) => Math.min(index + 1, results.length - 1));
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      setActive((index) => Math.max(index - 1, 0));
    } else if (event.key === "Enter") {
      event.preventDefault();
      const command = results[safeActive];
      if (command) run(command);
    } else if (event.key === "Escape") {
      closePalette();
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center px-4 pt-[12vh]">
      <button
        type="button"
        aria-label="Close command palette"
        onClick={closePalette}
        className="absolute inset-0 bg-nexus-ink/30 backdrop-blur-sm"
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-label="Command palette"
        onKeyDown={handleKeyDown}
        className="relative w-full max-w-lg overflow-hidden rounded-2xl border border-nexus-border bg-nexus-surface shadow-float"
      >
        <div className="flex items-center gap-2.5 border-b border-nexus-border px-4">
          <Search className="size-4 text-nexus-text-muted" />
          <input
            ref={inputRef}
            value={query}
            onChange={(event) => {
              setQuery(event.target.value);
              setActive(0);
            }}
            placeholder="Search or jump to…"
            className="h-12 flex-1 bg-transparent text-sm text-foreground outline-none placeholder:text-nexus-text-muted"
          />
          <kbd className="rounded-md border border-nexus-border bg-nexus-sunken px-1.5 py-0.5 text-[10px] font-medium text-nexus-text-muted">
            Esc
          </kbd>
        </div>

        <div className="max-h-[320px] overflow-y-auto p-2">
          {results.length === 0 ? (
            <p className="px-3 py-6 text-center text-sm text-muted-foreground">
              No matches. Try “practice” or “Nex”.
            </p>
          ) : (
            results.map((command, index) => {
              const showHeader =
                index === 0 || results[index - 1].group !== command.group;
              const Icon = command.icon;
              const isActive = index === safeActive;
              return (
                <Fragment key={command.id}>
                  {showHeader ? (
                    <p className="px-2 pb-1 pt-2 text-[11px] font-semibold uppercase tracking-wide text-nexus-text-muted">
                      {command.group}
                    </p>
                  ) : null}
                  <button
                    type="button"
                    onMouseEnter={() => setActive(index)}
                    onClick={() => run(command)}
                    className={cn(
                      "flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left text-sm transition-colors",
                      isActive
                        ? "bg-nexus-primary-soft text-nexus-primary"
                        : "text-foreground hover:bg-nexus-sunken",
                    )}
                  >
                    <Icon className="size-4 shrink-0" />
                    <span className="flex-1">{command.label}</span>
                    {isActive ? (
                      <CornerDownLeft className="size-3.5 text-nexus-text-muted" />
                    ) : null}
                  </button>
                </Fragment>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
}
