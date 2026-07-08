import type { NexModelTier } from "./modelConfig";
import type { NexMode } from "./types";

const LITE_ELIGIBLE_MODES: ReadonlySet<NexMode> = new Set(["explain", "revision"]);
const LITE_MAX_MESSAGE_LENGTH = 220;

/**
 * Homework/practice/assessment always get the standard model — Socratic
 * guidance and misconception detection need the stronger model's reasoning.
 * Short explain/revision turns (definitions, "what is X") are routed to the
 * lite tier; anything long enough to need multi-step reasoning escalates.
 */
export function selectModelTier(mode: NexMode, studentMessage: string): NexModelTier {
  if (!LITE_ELIGIBLE_MODES.has(mode)) {
    return "standard";
  }

  return studentMessage.trim().length <= LITE_MAX_MESSAGE_LENGTH ? "lite" : "standard";
}
