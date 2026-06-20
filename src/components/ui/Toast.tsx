"use client";

import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
} from "react";

import { cn } from "@/lib/utils";

type ToastTone = "success" | "info" | "error";

interface ToastItem {
  id: number;
  title: string;
  description?: string;
  tone: ToastTone;
}

interface ToastContextValue {
  toast: (input: Omit<ToastItem, "id">) => void;
}

const ToastContext = createContext<ToastContextValue | null>(null);

const toneStyles: Record<ToastTone, string> = {
  success: "border-nexus-success/30 bg-nexus-success-soft text-foreground",
  info: "border-nexus-border bg-nexus-surface text-foreground",
  error: "border-nexus-danger/30 bg-nexus-danger-soft text-foreground",
};

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [items, setItems] = useState<ToastItem[]>([]);

  const toast = useCallback((input: Omit<ToastItem, "id">) => {
    const id = Date.now();
    setItems((current) => [...current, { ...input, id }]);
    window.setTimeout(() => {
      setItems((current) => current.filter((item) => item.id !== id));
    }, 4200);
  }, []);

  const value = useMemo(() => ({ toast }), [toast]);

  return (
    <ToastContext.Provider value={value}>
      {children}
      <div
        aria-live="polite"
        className="pointer-events-none fixed inset-x-4 top-4 z-[100] flex flex-col gap-2 sm:inset-x-auto sm:right-5 sm:items-end"
      >
        {items.map((item) => (
          <div
            key={item.id}
            role="status"
            className={cn(
              "pointer-events-auto w-full max-w-sm rounded-2xl border px-4 py-3 shadow-float nexus-enter",
              toneStyles[item.tone],
            )}
          >
            <p className="text-sm font-semibold">{item.title}</p>
            {item.description ? (
              <p className="mt-1 text-sm text-muted-foreground">
                {item.description}
              </p>
            ) : null}
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastContextValue {
  const context = useContext(ToastContext);
  if (!context) {
    throw new Error("useToast must be used within ToastProvider");
  }
  return context;
}
