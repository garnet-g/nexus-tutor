import type { Metadata } from "next";
import { Geist } from "next/font/google";

import { cn } from "@/lib/utils";

import "./globals.css";

const SITE_URL =
  process.env.NEXT_PUBLIC_SITE_URL ?? "https://nexus.garnetlabs.africa";

const geist = Geist({
  variable: "--font-geist",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Nexus — Your AI study companion",
    template: "%s | Nexus",
  },
  description:
    "Nexus is the trusted academic companion for CBC and KCSE students. Learn with Nex, diagnose your strengths, and practice Mathematics.",
  alternates: {
    canonical: "/",
  },
  openGraph: {
    type: "website",
    locale: "en_KE",
    url: SITE_URL,
    siteName: "Nexus",
    title: "Nexus — Your AI study companion",
    description:
      "Nexus is the trusted academic companion for CBC and KCSE students.",
  },
  twitter: {
    card: "summary_large_image",
    title: "Nexus — Your AI study companion",
    description:
      "Nexus is the trusted academic companion for CBC and KCSE students.",
  },
  manifest: "/manifest.webmanifest",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      suppressHydrationWarning
      className={cn("h-full antialiased", geist.variable)}
    >
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `(function(){try{var t=localStorage.getItem("nexus-theme");if(t==="dark"||(t!=="light"&&window.matchMedia("(prefers-color-scheme: dark)").matches)){document.documentElement.classList.add("dark");}}catch(e){}})();`,
          }}
        />
      </head>
      <body className="min-h-full flex flex-col font-sans">{children}</body>
    </html>
  );
}
