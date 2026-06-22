import Link from "next/link";
import { redirect } from "next/navigation";

import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { cn } from "@/lib/utils";
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

function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date(iso));
}

function SubscriptionPill({ status }: { status: string | null }) {
  if (!status) {
    return <span className="text-muted-foreground">—</span>;
  }

  const isActive = status === "active";
  const isTrial = status === "trialing";
  const className = isActive
    ? "bg-primary/15 text-primary"
    : isTrial
      ? "bg-nexus-accent-soft text-nexus-warning"
      : "bg-nexus-sunken text-muted-foreground";

  return (
    <span
      className={cn(
        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium capitalize",
        className,
      )}
    >
      {status}
    </span>
  );
}

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
            <div className="flex flex-wrap gap-1">
              {TYPE_FILTERS.map((filter) => {
                const isActive = activeType === filter.value;
                return (
                  <a
                    key={filter.value || "all"}
                    href={filterHref(filter.value)}
                    className={cn(
                      "rounded-lg px-3 py-1.5 text-xs font-medium transition-colors",
                      isActive
                        ? "bg-primary/15 text-foreground"
                        : "text-muted-foreground hover:bg-nexus-sunken hover:text-foreground",
                    )}
                  >
                    {filter.label}
                  </a>
                );
              })}
            </div>
          </div>
        }
      >
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Name</th>
                <th className="px-5 py-3 font-medium">Type</th>
                <th className="px-5 py-3 font-medium">Grade / Curriculum</th>
                <th className="px-5 py-3 font-medium">Subscription</th>
                <th className="px-5 py-3 font-medium">Status</th>
                <th className="px-5 py-3 font-medium">Joined</th>
              </tr>
            </thead>
            <tbody>
              {users.length === 0 ? (
                <tr>
                  <td
                    colSpan={6}
                    className="px-5 py-10 text-center text-muted-foreground"
                  >
                    No accounts match these filters.
                  </td>
                </tr>
              ) : (
                users.map((user) => (
                  <tr
                    key={`${user.type}-${user.id}`}
                    className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                  >
                    <td className="px-5 py-3 font-medium text-foreground">
                      {user.type === "student" ? (
                        <Link
                          href={`/admin/users/${user.id}`}
                          className="hover:text-primary hover:underline"
                        >
                          {user.fullName}
                        </Link>
                      ) : (
                        user.fullName
                      )}
                    </td>
                    <td className="px-5 py-3 capitalize text-muted-foreground">
                      {user.type}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {user.type === "student"
                        ? `${user.gradeLevel || "—"} · ${user.curriculum || "—"}`
                        : "—"}
                    </td>
                    <td className="px-5 py-3">
                      <SubscriptionPill status={user.subscriptionStatus} />
                    </td>
                    <td className="px-5 py-3">
                      <span
                        className={cn(
                          "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
                          user.isActive
                            ? "bg-primary/15 text-primary"
                            : "bg-nexus-border/40 text-muted-foreground",
                        )}
                      >
                        {user.isActive ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-5 py-3 tabular-nums text-muted-foreground">
                      {formatDate(user.createdAt)}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </Panel>
    </>
  );
}
