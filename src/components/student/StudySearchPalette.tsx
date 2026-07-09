"use client";

import { Fragment, useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import {
  BarChart3,
  BookMarked,
  BookOpen,
  Brain,
  CalendarCheck,
  CalendarDays,
  Clock3,
  CornerDownLeft,
  Download,
  Home,
  Library,
  ListChecks,
  RotateCcw,
  Search,
  Sparkles,
  Target,
  User,
} from "lucide-react";

import { STUDENT_NAV_GROUPS } from "@/features/student/studentExperience";
import { cn } from "@/lib/utils";

type SearchItem = {
  id: string;
  label: string;
  group: "Pages" | "Actions";
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  keywords?: string;
};

const ICONS: Record<string, React.ComponentType<{ className?: string }>> = {
  "/dashboard": Home,
  "/continue": RotateCcw,
  "/tasks": ListChecks,
  "/learn": BookOpen,
  "/study-search": Search,
  "/library": Library,
  "/study-plan": CalendarDays,
  "/weekly-goal": CalendarCheck,
  "/practice": Target,
  "/revision": CalendarCheck,
  "/weak-areas": Target,
  "/mistakes": BookMarked,
  "/readiness": BarChart3,
  "/exam-prep": Clock3,
  "/assignment-help": Sparkles,
  "/nex": Sparkles,
  "/nex-memory": Brain,
  "/saved": BookMarked,
  "/focus": Clock3,
  "/offline": Download,
  "/progress": BarChart3,
  "/profile": User,
};

const PAGE_ITEMS: SearchItem[] = STUDENT_NAV_GROUPS.flatMap((group) =>
  group.items.map((item) => ({
    id: item.href,
    label: item.label,
    group: "Pages" as const,
    href: item.href,
    icon: ICONS[item.href] ?? Search,
    keywords: `${group.label} ${item.featureId ?? ""}`,
  })),
);

const ACTION_ITEMS: SearchItem[] = [
  {
    id: "ask-nex",
    label: "Ask Nex a question",
    group: "Actions",
    href: "/nex",
    icon: Sparkles,
    keywords: "help explain homework",
  },
  {
    id: "assignment-help",
    label: "Get assignment help",
    group: "Actions",
    href: "/assignment-help",
    icon: Sparkles,
    keywords: "homework help explain now",
  },
  {
    id: "start-exam-prep",
    label: "Start exam prep",
    group: "Actions",
    href: "/exam-prep",
    icon: Clock3,
    keywords: "kcse mock simulator",
  },
  {
    id: "start-practice",
    label: "Start practice",
    group: "Actions",
    href: "/practice",
    icon: Target,
    keywords: "quiz questions",
  },
  {
    id: "set-weekly-goal",
    label: "Set weekly goal",
    group: "Actions",
    href: "/weekly-goal",
    icon: CalendarCheck,
    keywords: "parent visible target",
  },
  {
    id: "start-focus",
    label: "Start focus session",
    group: "Actions",
    href: "/focus",
    icon: Clock3,
    keywords: "timer minutes",
  },
];

const SEARCH_ITEMS = [...PAGE_ITEMS, ...ACTION_ITEMS];

interface StudySearchPaletteProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function StudySearchPalette({
  open,
  onOpenChange,
}: StudySearchPaletteProps) {
  const router = useRouter();
  const [query, setQuery] = useState("");
  const [active, setActive] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return SEARCH_ITEMS;
    return SEARCH_ITEMS.filter((item) =>
      `${item.label} ${item.keywords ?? ""}`.toLowerCase().includes(q),
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

  function close() {
    onOpenChange(false);
    setQuery("");
    setActive(0);
  }

  function run(item: SearchItem) {
    close();
    router.push(item.href);
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
      const item = results[safeActive];
      if (item) run(item);
    } else if (event.key === "Escape") {
      close();
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center px-4 pt-[12vh]">
      <button
        type="button"
        aria-label="Close study search"
        onClick={close}
        className="absolute inset-0 bg-nexus-ink/30 backdrop-blur-sm"
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-label="Study search"
        onKeyDown={handleKeyDown}
        className="relative w-full max-w-xl overflow-hidden rounded-2xl border border-nexus-border bg-nexus-surface shadow-float"
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
            placeholder="Find lessons, topics, questions..."
            className="h-12 flex-1 bg-transparent text-sm text-foreground outline-none placeholder:text-nexus-text-muted"
          />
          <kbd className="rounded-md border border-nexus-border bg-nexus-sunken px-1.5 py-0.5 text-[10px] font-medium text-nexus-text-muted">
            Esc
          </kbd>
        </div>

        <div className="max-h-[360px] overflow-y-auto p-2">
          {results.length === 0 ? (
            <p className="px-3 py-6 text-center text-sm text-muted-foreground">
              No matches. Try practice, saved, or focus.
            </p>
          ) : (
            results.map((item, index) => {
              const showHeader =
                index === 0 || results[index - 1].group !== item.group;
              const Icon = item.icon;
              const isActive = index === safeActive;
              return (
                <Fragment key={item.id}>
                  {showHeader ? (
                    <p className="px-2 pb-1 pt-2 text-[11px] font-semibold uppercase tracking-wide text-nexus-text-muted">
                      {item.group}
                    </p>
                  ) : null}
                  <button
                    type="button"
                    onMouseEnter={() => setActive(index)}
                    onClick={() => run(item)}
                    className={cn(
                      "flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left text-sm transition-colors",
                      isActive
                        ? "bg-nexus-primary-soft text-nexus-primary"
                        : "text-foreground hover:bg-nexus-sunken",
                    )}
                  >
                    <Icon className="size-4 shrink-0" />
                    <span className="flex-1">{item.label}</span>
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
