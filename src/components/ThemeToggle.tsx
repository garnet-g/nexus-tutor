"use client";

import { Moon, Sun } from "lucide-react";
import { useEffect, useState } from "react";

import { cn } from "@/lib/utils";

const STORAGE_KEY = "nexus-theme";

type ThemeChoice = "light" | "dark";

function getPreferredTheme(): ThemeChoice {
  if (typeof window === "undefined") {
    return "light";
  }

  const stored = window.localStorage.getItem(STORAGE_KEY);
  if (stored === "light" || stored === "dark") {
    return stored;
  }

  return window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light";
}

function applyTheme(theme: ThemeChoice) {
  document.documentElement.classList.toggle("dark", theme === "dark");
}

interface ThemeToggleProps {
  className?: string;
}

export function ThemeToggle({ className }: ThemeToggleProps) {
  // Start from a stable value that matches the server render ("light" → Moon),
  // then resolve the real preference after mount to avoid a hydration mismatch.
  const [mounted, setMounted] = useState(false);
  const [theme, setTheme] = useState<ThemeChoice>("light");

  useEffect(() => {
    const frame = requestAnimationFrame(() => {
      setMounted(true);
      setTheme(getPreferredTheme());
    });

    return () => cancelAnimationFrame(frame);
  }, []);

  useEffect(() => {
    if (mounted) {
      applyTheme(theme);
    }
  }, [theme, mounted]);

  function toggleTheme() {
    const nextTheme: ThemeChoice = theme === "dark" ? "light" : "dark";
    setTheme(nextTheme);
    applyTheme(nextTheme);
    window.localStorage.setItem(STORAGE_KEY, nextTheme);
  }

  const showDark = mounted && theme === "dark";

  return (
    <button
      type="button"
      onClick={toggleTheme}
      aria-label={showDark ? "Switch to light mode" : "Switch to dark mode"}
      className={cn(
        "flex size-9 items-center justify-center rounded-xl border border-nexus-border bg-nexus-surface text-nexus-text-secondary transition-colors hover:bg-nexus-sunken hover:text-foreground focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
        className,
      )}
    >
      {showDark ? <Sun className="size-4" /> : <Moon className="size-4" />}
    </button>
  );
}
