import { readFileSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const middlewareSource = readFileSync(
  join(process.cwd(), "src/proxy.ts"),
  "utf8",
);
const databaseTypesSource = readFileSync(
  join(process.cwd(), "src/types/database.ts"),
  "utf8",
);

describe("admin support role middleware contract", () => {
  it("models support as an admin-capable user role", () => {
    expect(middlewareSource).toContain(
      'type UserRole = "student" | "parent" | "super_admin" | "support"',
    );
    expect(databaseTypesSource).toContain(
      'export type UserRole = "student" | "parent" | "super_admin" | "support"',
    );
  });

  it("allows support users through /admin middleware protection", () => {
    const adminRouteBlock = middlewareSource.slice(
      middlewareSource.indexOf("if (isSuperAdminRoute)"),
      middlewareSource.indexOf("return response;"),
    );

    expect(adminRouteBlock).toContain(
      'role !== "super_admin" && role !== "support"',
    );
  });

  it("redirects support users from auth pages into the admin console", () => {
    const publicAuthBlock = middlewareSource.slice(
      middlewareSource.indexOf("if (isPublicAuthRoute"),
      middlewareSource.indexOf("if (isStudentRoute)"),
    );

    expect(publicAuthBlock).toContain(
      'role === "super_admin" || role === "support"',
    );
    expect(publicAuthBlock).toContain('"/admin/platform-settings"');
  });
});
