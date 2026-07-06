/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const maybeSingle = vi.fn();
const update = vi.fn();
const select = vi.fn();

function createQueryBuilder() {
  const builder: Record<string, unknown> = {};
  const chain = () => builder;
  builder.select = vi.fn(chain);
  builder.eq = vi.fn(chain);
  builder.maybeSingle = maybeSingle;
  builder.update = update;
  builder.single = vi.fn(async () => ({ data: { id: "focus-1" }, error: null }));
  return builder;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => createQueryBuilder(),
  })),
}));

import {
  FocusSessionConflictError,
  FocusSessionInsufficientElapsedError,
  updateFocusSessionStatus,
} from "@/server/services/focusSessionService";

describe("focus session state machine", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    maybeSingle.mockReset();
    update.mockReset();
  });

  it("rejects cancel after complete with 409 conflict", async () => {
    maybeSingle.mockResolvedValue({
      data: {
        id: "focus-1",
        status: "completed",
        duration_minutes: 25,
        started_at: new Date(Date.now() - 30 * 60_000).toISOString(),
        completed_at: new Date().toISOString(),
      },
      error: null,
    });

    await expect(
      updateFocusSessionStatus("student-1", "focus-1", "cancelled"),
    ).rejects.toBeInstanceOf(FocusSessionConflictError);
  });

  it("rejects early completion before 80% elapsed", async () => {
    maybeSingle.mockResolvedValue({
      data: {
        id: "focus-1",
        status: "in_progress",
        duration_minutes: 25,
        started_at: new Date().toISOString(),
        completed_at: null,
      },
      error: null,
    });

    await expect(
      updateFocusSessionStatus("student-1", "focus-1", "completed"),
    ).rejects.toBeInstanceOf(FocusSessionInsufficientElapsedError);
  });

  it("credits minutes when timer has elapsed", async () => {
    const startedAt = new Date(Date.now() - 25 * 60_000).toISOString();

    maybeSingle.mockResolvedValue({
      data: {
        id: "focus-1",
        status: "in_progress",
        duration_minutes: 25,
        started_at: startedAt,
        completed_at: null,
      },
      error: null,
    });

    update.mockReturnValue({
      eq: vi.fn(() => ({
        eq: vi.fn(() => ({
          select: () => ({
            single: async () => ({
              data: {
                id: "focus-1",
                credited_minutes: 25,
                status: "completed",
              },
              error: null,
            }),
          }),
        })),
      })),
    });

    const result = await updateFocusSessionStatus("student-1", "focus-1", "completed");
    expect(result.credited_minutes).toBe(25);
    expect(update).toHaveBeenCalled();
  });
});
