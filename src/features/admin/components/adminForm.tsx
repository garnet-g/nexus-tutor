import type {
  InputHTMLAttributes,
  ReactNode,
  SelectHTMLAttributes,
  TextareaHTMLAttributes,
} from "react";

import { cn } from "@/lib/utils";

/**
 * Shared form vocabulary for the admin console. Every control sits on the
 * `bg-nexus-sunken` surface with one focus-ring treatment so forms across all
 * pages look identical.
 */

const controlClass =
  "w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm text-foreground outline-none transition-colors placeholder:text-muted-foreground/70 focus:border-primary focus:ring-2 focus:ring-primary/20 disabled:cursor-not-allowed disabled:opacity-60";

interface FieldProps {
  label: ReactNode;
  htmlFor?: string;
  hint?: ReactNode;
  error?: ReactNode;
  className?: string;
  children: ReactNode;
}

/** Label + control + optional hint/error, vertically stacked. */
export function Field({ label, htmlFor, hint, error, className, children }: FieldProps) {
  return (
    <label htmlFor={htmlFor} className={cn("block space-y-1.5 text-sm", className)}>
      <span className="font-medium text-muted-foreground">{label}</span>
      {children}
      {error ? (
        <span className="block text-xs text-nexus-danger">{error}</span>
      ) : hint ? (
        <span className="block text-xs text-muted-foreground">{hint}</span>
      ) : null}
    </label>
  );
}

export function Input({
  className,
  ...props
}: InputHTMLAttributes<HTMLInputElement>) {
  return <input className={cn(controlClass, className)} {...props} />;
}

export function Textarea({
  className,
  ...props
}: TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return (
    <textarea className={cn(controlClass, "resize-y", className)} {...props} />
  );
}

export function Select({
  className,
  children,
  ...props
}: SelectHTMLAttributes<HTMLSelectElement>) {
  return (
    <select className={cn(controlClass, "cursor-pointer", className)} {...props}>
      {children}
    </select>
  );
}

interface CheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, "type"> {
  label: ReactNode;
}

/** Inline checkbox with a label, styled to the admin accent. */
export function Checkbox({ label, className, ...props }: CheckboxProps) {
  return (
    <label className="flex cursor-pointer items-center gap-2.5 text-sm text-muted-foreground">
      <input
        type="checkbox"
        className={cn(
          "h-4 w-4 rounded border-nexus-border bg-nexus-sunken text-primary accent-primary focus:ring-2 focus:ring-primary/20",
          className,
        )}
        {...props}
      />
      {label}
    </label>
  );
}
