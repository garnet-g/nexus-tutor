import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: ["/", "/about", "/pricing", "/waitlist/teacher"],
        disallow: [
          "/admin",
          "/admin/",
          "/dashboard",
          "/parent",
          "/learn",
          "/practice",
          "/nex",
          "/api/",
        ],
      },
    ],
    sitemap: `${process.env.NEXT_PUBLIC_SITE_URL ?? "https://nexus.garnetlabs.africa"}/sitemap.xml`,
  };
}
