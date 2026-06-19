"use client";

interface FieldErrorProps {
  id: string;
  message?: string | null;
}

export function FieldError({ id, message }: FieldErrorProps) {
  if (!message) {
    return null;
  }

  return (
    <p
      id={id}
      role="alert"
      aria-live="assertive"
      className="text-sm text-destructive"
    >
      {message}
    </p>
  );
}
