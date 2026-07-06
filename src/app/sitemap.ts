import type { MetadataRoute } from "next";

const SITE_URL =
  process.env.NEXT_PUBLIC_SITE_URL ?? "https://nexus.garnetlabs.africa";

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date();

  return [
    { url: `${SITE_URL}/`, lastModified: now, changeFrequency: "weekly", priority: 1 },
    { url: `${SITE_URL}/about`, lastModified: now, changeFrequency: "monthly", priority: 0.7 },
    { url: `${SITE_URL}/pricing`, lastModified: now, changeFrequency: "weekly", priority: 0.9 },
    {
      url: `${SITE_URL}/waitlist/teacher`,
      lastModified: now,
      changeFrequency: "monthly",
      priority: 0.5,
    },
    { url: `${SITE_URL}/login`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
    { url: `${SITE_URL}/signup`, lastModified: now, changeFrequency: "yearly", priority: 0.4 },
  ];
}
