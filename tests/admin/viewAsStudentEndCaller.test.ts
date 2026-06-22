import { readFileSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const viewPageSource = readFileSync(
  join(process.cwd(), "src/app/(super-admin)/admin/users/[id]/view/page.tsx"),
  "utf8",
);

describe("view-as student end caller", () => {
  it("renders a caller for DELETE /api/admin/users/[id]/impersonate", () => {
    expect(viewPageSource).toContain("ViewAsStudentEndButton");
    expect(viewPageSource).toContain("session.id");
  });
});
