import { redirect } from "next/navigation";

import { FilterTabs, PageHeader, Panel } from "@/features/admin/components/adminUi";
import { UsersTable } from "@/features/admin/components/UsersTable";
import { usersQuerySchema } from "@/schemas/adminSchemas";
import {
  type DirectoryUserRow,
  listUsers,
} from "@/server/services/adminUserReadService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const TYPE_FILTERS = [
  { value: "", label: "All" },
  { value: "student", label: "Students" },
  { value: "parent", label: "Parents" },
] as const;

type SearchParams = Promise<Record<string, string | string[] | undefined>>;

export default async function UsersPage({
  searchParams,
}: {
  searchParams: SearchParams;
}) {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  const params = await searchParams;
  const parsed = usersQuerySchema.safeParse({
    query: typeof params.q === "string" ? params.q : undefined,
    type: typeof params.type === "string" ? params.type : undefined,
  });
  const filters = parsed.success ? parsed.data : {};
  const activeType = filters.type ?? "";
  const queryValue = filters.query ?? "";

  let users: DirectoryUserRow[] = [];
  try {
    users = await listUsers(filters);
  } catch {
    users = [];
  }

  function filterHref(type: string): string {
    const search = new URLSearchParams();
    if (queryValue) {
      search.set("q", queryValue);
    }
    if (type) {
      search.set("type", type);
    }
    const qs = search.toString();
    return qs ? `/admin/users?${qs}` : "/admin/users";
  }

  return (
    <>
      <PageHeader
        eyebrow="Accounts"
        title="Users"
        description="Search students and parents, review subscription status and open account detail (Nairobi time)."
      />

      <Panel
        title="Directory"
        description={`${users.length} account${users.length === 1 ? "" : "s"}`}
        padded={false}
        action={
          <div className="flex flex-wrap items-center gap-3">
            <form method="get" action="/admin/users" className="flex gap-2">
              {activeType ? (
                <input type="hidden" name="type" value={activeType} />
              ) : null}
              <input
                type="search"
                name="q"
                defaultValue={queryValue}
                placeholder="Search by name…"
                className="w-48 rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-1.5 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              />
            </form>
            <FilterTabs
              options={TYPE_FILTERS}
              activeValue={activeType}
              hrefFor={filterHref}
            />
          </div>
        }
      >
        <UsersTable rows={users} />
      </Panel>
    </>
  );
}
