import "server-only";

import { NextResponse } from "next/server";

export function mapReviewServiceError(error: unknown): {
  status: number;
  code: string;
  message: string;
  gateErrors?: string[];
} {
  const message = error instanceof Error ? error.message : "Unexpected error.";

  if (message === "NOT_FOUND") {
    return { status: 404, code: "NOT_FOUND", message: "Content item not found." };
  }

  if (message === "CONFLICT") {
    return {
      status: 409,
      code: "CONFLICT",
      message: "This transition is not allowed for the current review status.",
    };
  }

  if (message === "GATE_FAILED") {
    const gateErrors =
      error instanceof Error && "gateErrors" in error
        ? (error as Error & { gateErrors?: string[] }).gateErrors
        : undefined;

    return {
      status: 422,
      code: "GATE_FAILED",
      message: "Quality gates failed.",
      gateErrors,
    };
  }

  if (message === "PENDING_REVIEW") {
    return {
      status: 202,
      code: "PENDING_REVIEW",
      message: "Submitted for review. Approve from the review queue to publish.",
    };
  }

  return { status: 500, code: "INTERNAL_ERROR", message };
}

export function reviewErrorResponse(error: unknown) {
  const mapped = mapReviewServiceError(error);
  return NextResponse.json(
    {
      success: false,
      error: {
        code: mapped.code,
        message: mapped.message,
        gateErrors: mapped.gateErrors,
      },
    },
    { status: mapped.status },
  );
}
