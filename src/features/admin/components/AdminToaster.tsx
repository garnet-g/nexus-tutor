"use client";

import { Toast } from "@base-ui/react/toast";

import { cn } from "@/lib/utils";

import { adminToast } from "./toast";

/**
 * Mounts the toast viewport for the admin console. Place once in the
 * (super-admin) layout. Toasts are pushed via the `adminToast` singleton.
 */
export function AdminToaster() {
  return (
    <Toast.Provider toastManager={adminToast}>
      <Toast.Portal>
        <Toast.Viewport className="fixed bottom-4 right-4 z-[100] flex w-[min(24rem,calc(100vw-2rem))] flex-col gap-2 outline-none">
          <ToastList />
        </Toast.Viewport>
      </Toast.Portal>
    </Toast.Provider>
  );
}

function ToastList() {
  const { toasts } = Toast.useToastManager();

  return (
    <>
      {toasts.map((toast) => {
        const tone =
          toast.type === "error"
            ? "border-nexus-danger/40 bg-nexus-surface"
            : toast.type === "success"
              ? "border-primary/40 bg-nexus-surface"
              : "border-nexus-border bg-nexus-surface";
        const dot =
          toast.type === "error"
            ? "bg-nexus-danger"
            : toast.type === "success"
              ? "bg-primary"
              : "bg-muted-foreground";

        return (
          <Toast.Root
            key={toast.id}
            toast={toast}
            className={cn(
              "flex items-start gap-3 rounded-xl border p-4 shadow-lg",
              "data-[starting-style]:translate-y-2 data-[starting-style]:opacity-0",
              "data-[ending-style]:translate-y-2 data-[ending-style]:opacity-0",
              "transition-all duration-200",
              tone,
            )}
          >
            <span className={cn("mt-1.5 h-2 w-2 shrink-0 rounded-full", dot)} />
            <div className="min-w-0 flex-1">
              <Toast.Title className="text-sm font-semibold text-foreground" />
              <Toast.Description className="mt-0.5 text-sm text-muted-foreground" />
            </div>
            <Toast.Close
              aria-label="Dismiss"
              className="shrink-0 rounded-md px-1 text-muted-foreground transition-colors hover:text-foreground"
            >
              ✕
            </Toast.Close>
          </Toast.Root>
        );
      })}
    </>
  );
}
