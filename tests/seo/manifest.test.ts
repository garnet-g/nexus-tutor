import { describe, expect, it } from "vitest";

import manifest from "@/app/manifest";

describe("web manifest", () => {
  it("exposes Nexus branding and start URL", () => {
    const webManifest = manifest();
    expect(webManifest.name).toBe("Nexus");
    expect(webManifest.start_url).toBe("/");
    expect(webManifest.display).toBe("standalone");
  });
});
