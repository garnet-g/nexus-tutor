import { describe, expect, it } from "vitest";

import sitemap from "@/app/sitemap";

describe("sitemap", () => {
  it("lists public routes only", () => {
    const entries = sitemap();
    const paths = entries.map((entry) => new URL(entry.url).pathname);

    expect(paths).toEqual(
      expect.arrayContaining(["/", "/about", "/pricing", "/login", "/signup"]),
    );
    expect(paths).not.toEqual(expect.arrayContaining(["/dashboard", "/admin", "/nex"]));
  });
});
