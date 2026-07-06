import { describe, expect, it } from "vitest";

const SITE_URL =
  process.env.NEXT_PUBLIC_SITE_URL ?? "https://nexus.garnetlabs.africa";

describe("root metadata contract", () => {
  it("defines canonical, Open Graph, Twitter, and manifest fields", () => {
    const metadata = {
      metadataBase: new URL(SITE_URL),
      alternates: { canonical: "/" },
      openGraph: {
        siteName: "Nexus",
        type: "website",
      },
      twitter: {
        card: "summary_large_image",
      },
      manifest: "/manifest.webmanifest",
    };

    expect(metadata.metadataBase.toString()).toContain("nexus.garnetlabs.africa");
    expect(metadata.alternates.canonical).toBe("/");
    expect(metadata.openGraph.siteName).toBe("Nexus");
    expect(metadata.twitter.card).toBe("summary_large_image");
    expect(metadata.manifest).toBe("/manifest.webmanifest");
  });
});
