"use client";

import { AlertDialog } from "@base-ui/react/alert-dialog";
import { useCallback, useRef, useState } from "react";

import { Button } from "@/components/ui/Button";

interface ConfirmOptions {
  title: string;
  description?: string;
  confirmLabel?: string;
  cancelLabel?: string;
  /** Use the destructive button treatment for the confirm action. */
  destructive?: boolean;
}

interface ConfirmState extends ConfirmOptions {
  open: boolean;
}

const CLOSED: ConfirmState = { open: false, title: "" };

/**
 * Imperative confirmation dialog. Returns `confirm(options)` which resolves to
 * a boolean, plus a `dialog` element to render once in the component.
 *
 *   const { confirm, dialog } = useConfirm();
 *   if (await confirm({ title: "Deactivate coupon?", destructive: true })) { ... }
 *   return <>{dialog}{...}</>;
 */
export function useConfirm() {
  const [state, setState] = useState<ConfirmState>(CLOSED);
  const resolverRef = useRef<((value: boolean) => void) | null>(null);

  const confirm = useCallback((options: ConfirmOptions) => {
    setState({ ...options, open: true });
    return new Promise<boolean>((resolve) => {
      resolverRef.current = resolve;
    });
  }, []);

  const settle = useCallback((value: boolean) => {
    resolverRef.current?.(value);
    resolverRef.current = null;
    setState(CLOSED);
  }, []);

  const dialog = (
    <AlertDialog.Root
      open={state.open}
      onOpenChange={(open) => {
        if (!open) {
          settle(false);
        }
      }}
    >
      <AlertDialog.Portal>
        <AlertDialog.Backdrop className="fixed inset-0 z-[90] bg-black/50 backdrop-blur-sm data-[starting-style]:opacity-0 data-[ending-style]:opacity-0 transition-opacity duration-200" />
        <AlertDialog.Popup className="fixed left-1/2 top-1/2 z-[91] w-[min(28rem,calc(100vw-2rem))] -translate-x-1/2 -translate-y-1/2 rounded-2xl border border-nexus-border bg-nexus-surface p-6 shadow-2xl outline-none data-[starting-style]:scale-95 data-[starting-style]:opacity-0 data-[ending-style]:scale-95 data-[ending-style]:opacity-0 transition-all duration-200">
          <AlertDialog.Title className="font-heading text-lg font-semibold text-foreground">
            {state.title}
          </AlertDialog.Title>
          {state.description ? (
            <AlertDialog.Description className="mt-2 text-sm text-muted-foreground">
              {state.description}
            </AlertDialog.Description>
          ) : null}
          <div className="mt-6 flex justify-end gap-2">
            <Button variant="ghost" size="sm" onClick={() => settle(false)}>
              {state.cancelLabel ?? "Cancel"}
            </Button>
            <Button
              variant={state.destructive ? "destructive" : "primary"}
              size="sm"
              onClick={() => settle(true)}
            >
              {state.confirmLabel ?? "Confirm"}
            </Button>
          </div>
        </AlertDialog.Popup>
      </AlertDialog.Portal>
    </AlertDialog.Root>
  );

  return { confirm, dialog };
}
