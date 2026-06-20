import type { NexMode } from "./types";

/**
 * Homework gate: first turns (<3 attempts) must buffer fully for validateNexResponse
 * + callNexJudge before any tokens reach the client.
 */
export function shouldStreamNexResponse(
  sessionMode: NexMode,
  attemptCount: number,
): boolean {
  if (sessionMode === "homework" && attemptCount < 3) {
    return false;
  }

  return true;
}
