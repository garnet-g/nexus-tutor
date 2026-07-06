/**
 * @vitest-environment node
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const insert = vi.fn();
const update = vi.fn();
const eq = vi.fn();
const select = vi.fn();
const maybeSingle = vi.fn();
const from = vi.fn();

const claimedKeys = new Set<string>();
const storedRows = new Map<string, Record<string, unknown>>();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

vi.mock("@/server/services/adminParentNotifyService", () => ({
  sendParentSms: vi.fn(async () => ({ ok: true, code: "SENT", message: "sent" })),
}));

import { sendOperationalTemplate } from "@/server/services/adminCommunicationsService";

function resetStore() {
  claimedKeys.clear();
  storedRows.clear();
}

function buildQuery(table: string) {
  const state: { filters: Record<string, string> } = { filters: {} };

  const builder = {
    select: select.mockImplementation(() => builder),
    eq: eq.mockImplementation((column: string, value: string) => {
      state.filters[column] = value;
      return builder;
    }),
    maybeSingle: maybeSingle.mockImplementation(async () => {
      if (table !== "admin_communication_logs") {
        return { data: null, error: null };
      }
      const key = state.filters.idempotency_key;
      const row = key ? storedRows.get(key) ?? null : null;
      return { data: row, error: null };
    }),
    insert: insert.mockImplementation(async (row: Record<string, unknown>) => {
      const key = String(row.idempotency_key ?? "");
      if (claimedKeys.has(key)) {
        return {
          error: { code: "23505", message: "duplicate key value violates unique constraint" },
        };
      }
      claimedKeys.add(key);
      storedRows.set(key, row);
      return { error: null };
    }),
    update: update.mockImplementation((patch: Record<string, unknown>) => ({
      eq: vi.fn(async (column: string, value: string) => {
        const row = storedRows.get(String(value));
        if (row) {
          storedRows.set(String(value), { ...row, ...patch });
        }
        return { error: null };
      }),
    })),
  };

  return builder;
}

beforeEach(() => {
  vi.clearAllMocks();
  resetStore();

  from.mockImplementation((table: string) => {
    if (table === "admin_communication_templates") {
      return {
        select: vi.fn(() => ({
          eq: vi.fn(() => ({
            eq: vi.fn(() => ({
              maybeSingle: vi.fn(async () => ({
                data: {
                  id: "template-1",
                  template_key: "parent_outreach",
                  channel: "sms",
                  body: "Hello parent",
                },
                error: null,
              })),
            })),
          })),
        })),
      };
    }

    return buildQuery(table);
  });
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("PR-067 admin communication send idempotency", () => {
  it("treats concurrent duplicate idempotency_key inserts as replay", async () => {
    const payload = {
      send: {
        templateKey: "parent_outreach",
        studentIds: ["11111111-1111-4111-8111-111111111111"],
        idempotencyKey: "send-batch-2026-07-06",
      },
      actorUserId: "admin-1",
    };

    const [first, second] = await Promise.all([
      sendOperationalTemplate(payload),
      sendOperationalTemplate(payload),
    ]);

    const replay = first.idempotentReplay || second.idempotentReplay;
    expect(replay).toBe(true);
    expect(first.sent + second.sent).toBeGreaterThan(0);
    expect(claimedKeys.size).toBe(1);
    expect(insert).toHaveBeenCalledTimes(2);
  });
});
