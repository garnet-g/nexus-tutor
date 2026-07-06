/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const maybeSingle = vi.fn();
const insert = vi.fn();

function createQueryBuilder() {
  const builder: Record<string, unknown> = {};
  const chain = () => builder;
  builder.select = vi.fn(chain);
  builder.eq = vi.fn(chain);
  builder.order = vi.fn(chain);
  builder.limit = vi.fn(async () => ({ data: [], error: null }));
  builder.maybeSingle = maybeSingle;
  builder.insert = (...args: unknown[]) => {
    insert(...args);
    return {
      select: () => ({
        single: async () => ({
          data: {
            id: "saved-1",
            item_type: "lesson",
            item_id: "00000000-0000-4000-8000-000000000010",
            title: "Algebra intro",
            description: null,
            href: "/learn/topic/lesson",
            metadata: {},
            created_at: "2026-07-06T00:00:00.000Z",
            updated_at: "2026-07-06T00:00:00.000Z",
          },
          error: null,
        }),
      }),
    };
  };
  return builder;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => createQueryBuilder(),
  })),
}));

import { saveStudentItem } from "@/server/services/studentExperienceService";

describe("saved items server persistence", () => {
  beforeEach(() => {
    maybeSingle.mockReset();
    insert.mockReset();
  });

  it("returns existing row without inserting duplicate lesson bookmarks", async () => {
    maybeSingle.mockResolvedValueOnce({ data: { id: "saved-existing" }, error: null });

    const listBuilder = createQueryBuilder();
    listBuilder.limit = vi.fn(async () => ({
      data: [
        {
          id: "saved-existing",
          item_type: "lesson",
          item_id: "00000000-0000-4000-8000-000000000010",
          title: "Algebra intro",
          description: null,
          href: "/learn/topic/lesson",
          metadata: {},
          created_at: "2026-07-06T00:00:00.000Z",
          updated_at: "2026-07-06T00:00:00.000Z",
        },
      ],
      error: null,
    }));

    const adminModule = await import("@/lib/supabase/admin");
    let callCount = 0;
    vi.mocked(adminModule.createAdminClient).mockImplementation(
      () =>
        ({
          from: () => {
            callCount += 1;
            return callCount === 1 ? createQueryBuilder() : listBuilder;
          },
        }) as unknown as ReturnType<typeof adminModule.createAdminClient>,
    );

    const item = await saveStudentItem("student-1", {
      itemType: "lesson",
      itemId: "00000000-0000-4000-8000-000000000010",
      title: "Algebra intro",
      href: "/learn/topic/lesson",
      metadata: {},
    });

    expect(item.id).toBe("saved-existing");
    expect(insert).not.toHaveBeenCalled();
  });
});
