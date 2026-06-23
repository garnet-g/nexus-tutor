import { describe, expect, it } from "vitest";

import { CONTENT_MEDIA_BUCKET } from "@/lib/supabase/contentMediaStorage";

describe("contentMediaStorage", () => {
  it("uses the content-media bucket id expected by the migration", () => {
    expect(CONTENT_MEDIA_BUCKET).toBe("content-media");
  });
});
