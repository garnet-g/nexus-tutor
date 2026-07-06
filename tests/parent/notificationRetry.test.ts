/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

type OutboxRow = {
  id: string;
  idempotency_key: string;
  channel: "sms" | "email";
  status: "pending" | "retry_scheduled" | "sent" | "dead_letter";
  payload: Record<string, unknown>;
  attempt_count: number;
  max_attempts: number;
  next_attempt_at: string;
  last_error: string | null;
  sent_at: string | null;
};

const rows = new Map<string, OutboxRow>();

function rowById(id: string) {
  return [...rows.values()].find((row) => row.id === id);
}

function processableRows(now: Date) {
  return [...rows.values()].filter(
    (row) =>
      (row.status === "pending" || row.status === "retry_scheduled") &&
      new Date(row.next_attempt_at).getTime() <= now.getTime(),
  );
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table !== "notification_outbox") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: null, error: null }),
            }),
          }),
        };
      }

      return {
        insert: (row: Omit<OutboxRow, "id">) => ({
          select: () => ({
            single: async () => {
              if (rows.has(row.idempotency_key)) {
                return {
                  data: null,
                  error: { code: "23505", message: "duplicate key" },
                };
              }

              const created: OutboxRow = {
                id: `outbox-${rows.size + 1}`,
                ...row,
                attempt_count: row.attempt_count ?? 0,
                max_attempts: row.max_attempts ?? 5,
                next_attempt_at: row.next_attempt_at ?? new Date().toISOString(),
                last_error: row.last_error ?? null,
                sent_at: row.sent_at ?? null,
              };
              rows.set(created.idempotency_key, created);
              return { data: created, error: null };
            },
          }),
        }),
        select: (columns?: string, options?: { count?: string; head?: boolean }) => {
          if (options?.head) {
            return {
              eq: (_column: string, value: string) => {
                if (value === "dead_letter") {
                  const dead = [...rows.values()].filter((row) => row.status === "dead_letter");
                  return Promise.resolve({ count: dead.length, data: null, error: null });
                }

                return Promise.resolve({ count: 0, data: null, error: null });
              },
            };
          }

          const isCountOnly = columns === "id";
          const filters: Record<string, string> = {};

          const chain: Record<string, unknown> = {};
          chain.eq = (column: string, value: string) => {
            filters[column] = value;
            return chain;
          };
          chain.lte = () => chain;
          chain.in = () => chain;
          chain.order = () => chain;
          chain.limit = async () => {
            if (filters.status === "dead_letter") {
              const dead = [...rows.values()].filter((row) => row.status === "dead_letter");
              if (isCountOnly) {
                return { count: dead.length, data: null, error: null };
              }
              return { data: dead.slice(0, 5), error: null };
            }

            const due = processableRows(new Date());
            return { data: due, error: null };
          };
          chain.maybeSingle = async () => {
            const row = rows.get(filters.idempotency_key);
            return { data: row ?? null, error: null };
          };
          chain.single = async () => {
            const row = rowById(filters.id);
            if (!row) {
              return { data: null, error: { message: "not found" } };
            }
            return { data: row, error: null };
          };
          return chain;
        },
        update: (patch: Partial<OutboxRow>) => ({
          eq: (_column: string, id: string) => ({
            select: () => ({
              single: async () => {
                const existing = rowById(id);
                if (!existing) {
                  return { data: null, error: { message: "not found" } };
                }

                const updated = { ...existing, ...patch };
                rows.set(updated.idempotency_key, updated);
                return { data: updated, error: null };
              },
            }),
          }),
        }),
      };
    },
  })),
}));

describe("PR-129/PR-130 notification outbox state machine", () => {
  beforeEach(() => {
    rows.clear();
    vi.resetModules();
    vi.useRealTimers();
  });

  it("duplicate idempotency key does not create a second outbox row", async () => {
    const { enqueueNotificationOutbox } = await import(
      "@/server/services/notificationOutboxService"
    );

    const payload = {
      type: "sms" as const,
      phoneNumber: "+254700000001",
      smsBody: "Hello",
      templateCode: "parent_link_success",
      parentId: "parent-1",
    };

    const first = await enqueueNotificationOutbox({
      idempotencyKey: "link:parent-1:student-1",
      channel: "sms",
      payload,
    });
    const second = await enqueueNotificationOutbox({
      idempotencyKey: "link:parent-1:student-1",
      channel: "sms",
      payload,
    });

    expect(first.id).toBe(second.id);
    expect(rows.size).toBe(1);
  });

  it("provider failure schedules bounded retries then dead-letters", async () => {
    const {
      __setOutboxSendHandlerForTests,
      enqueueNotificationOutbox,
      processOutboxRow,
    } = await import("@/server/services/notificationOutboxService");

    __setOutboxSendHandlerForTests(async () => {
      throw new Error("provider down");
    });

    let row = await enqueueNotificationOutbox({
      idempotencyKey: "weekly:parent-1:2026-07-01",
      channel: "email",
      payload: {
        type: "email",
        recipientEmail: "parent@example.com",
        emailSubject: "Weekly report",
        emailBody: "Summary",
        templateCode: "weekly_parent_report",
        parentId: "parent-1",
      },
    });

    expect(row.status).toBe("pending");

    for (let attempt = 0; attempt < 5; attempt += 1) {
      row = await processOutboxRow(row);
    }

    expect(row.status).toBe("dead_letter");
    expect(row.attempt_count).toBe(5);
    expect(row.last_error).toContain("provider down");

    __setOutboxSendHandlerForTests(null);
  });

  it("successful send marks row sent without duplicate dispatch", async () => {
    const {
      __setOutboxSendHandlerForTests,
      enqueueNotificationOutbox,
      processNotificationOutboxBatch,
    } = await import("@/server/services/notificationOutboxService");

    let sendCount = 0;
    __setOutboxSendHandlerForTests(async () => {
      sendCount += 1;
    });

    await enqueueNotificationOutbox({
      idempotencyKey: "link:parent-2:student-2",
      channel: "sms",
      payload: {
        type: "sms",
        phoneNumber: "+254700000002",
        smsBody: "Linked",
        parentId: "parent-2",
      },
    });

    await processNotificationOutboxBatch(10);
    await processNotificationOutboxBatch(10);

    expect(sendCount).toBe(1);
    expect(rows.get("link:parent-2:student-2")?.status).toBe("sent");

    __setOutboxSendHandlerForTests(null);
  });

  it("DLQ rows surface in admin health summary", async () => {
    const { getNotificationOutboxHealthItem } = await import(
      "@/server/services/notificationOutboxService"
    );

    rows.set("dead-1", {
      id: "outbox-dead-1",
      idempotency_key: "dead-1",
      channel: "sms",
      status: "dead_letter",
      payload: { type: "sms" },
      attempt_count: 5,
      max_attempts: 5,
      next_attempt_at: new Date().toISOString(),
      last_error: "provider down",
      sent_at: null,
    });

    const healthItem = await getNotificationOutboxHealthItem();

    expect(healthItem.name).toBe("Notification dead letter");
    expect(healthItem.status).toBe("watch");
    expect(healthItem.detail).toContain("1");
  });
});
