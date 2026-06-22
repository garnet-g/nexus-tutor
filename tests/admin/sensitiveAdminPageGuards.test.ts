import { readFileSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const sensitivePages = [
  "src/app/(super-admin)/admin/beta-invites/page.tsx",
  "src/app/(super-admin)/admin/platform-settings/page.tsx",
] as const;

describe("sensitive admin page guards", () => {
  it.each(sensitivePages)("%s has an in-page super-admin guard", (pagePath) => {
    const source = readFileSync(join(process.cwd(), pagePath), "utf8");

    expect(source).toContain("requireSuperAdmin");
    expect(source).toContain('redirect("/login")');
  });
});
