import "server-only";

import { listUsers } from "@/server/services/adminUserReadService";
import { getAdminSearchItems } from "@/server/services/adminPlatformService";
import type { AdminRole } from "@/server/services/superAdminGuard";

export type AdminSearchResult = {
  title: string;
  href: string;
  type: string;
  description: string;
  snippet: string;
};

const SUPPORT_ALLOWED_TYPES = new Set([
  "page",
  "support",
  "approval",
  "saved view",
]);

export async function searchAdminEntities(input: {
  query: string;
  actorRole: AdminRole;
  roleFilter?: AdminRole;
}): Promise<AdminSearchResult[]> {
  const needle = input.query.trim().toLowerCase();
  const results: AdminSearchResult[] = [];

  if (needle.length >= 2) {
    const users = await listUsers({ limit: 25, query: needle });
    for (const user of users) {
      results.push({
        title: user.fullName,
        href: `/admin/users/${user.id}`,
        type: "user",
        description: user.type,
        snippet: `${user.curriculum ?? "—"} · ${user.subscriptionStatus ?? "none"}`,
      });
    }
  }

  const indexed = await getAdminSearchItems();
  for (const item of indexed) {
    if (input.actorRole === "support" && !SUPPORT_ALLOWED_TYPES.has(item.type)) {
      continue;
    }
    if (input.roleFilter && item.type !== input.roleFilter) {
      continue;
    }

    const haystack = `${item.title} ${item.description} ${item.type}`.toLowerCase();
    if (needle && !haystack.includes(needle)) {
      continue;
    }

    results.push({
      title: item.title,
      href: item.href,
      type: item.type,
      description: item.description,
      snippet: item.description,
    });
  }

  return results.slice(0, 50);
}
