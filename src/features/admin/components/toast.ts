import { Toast } from "@base-ui/react/toast";

/**
 * Global toast manager for the admin console. Importable from any client
 * component (or plain handler) without prop-drilling a context — the
 * `<AdminToaster>` mounted in the layout subscribes the UI to it.
 */
export const adminToast = Toast.createToastManager();

/** Convenience: success toast. */
export function toastSuccess(title: string, description?: string): string {
  return adminToast.add({ title, description, type: "success" });
}

/** Convenience: error toast (announced urgently). */
export function toastError(title: string, description?: string): string {
  return adminToast.add({
    title,
    description,
    type: "error",
    priority: "high",
  });
}

/** Convenience: neutral/informational toast. */
export function toastInfo(title: string, description?: string): string {
  return adminToast.add({ title, description, type: "info" });
}
