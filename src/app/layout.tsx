import type { Metadata } from "next";
import { Hanken_Grotesk, Fraunces } from "next/font/google";

import { cn } from "@/lib/utils";

import "./globals.css";

const hanken = Hanken_Grotesk({
  variable: "--font-hanken",
  subsets: ["latin"],
});

const fraunces = Fraunces({
  variable: "--font-fraunces",
  subsets: ["latin"],
  axes: ["SOFT", "opsz"],
});

export const metadata: Metadata = {
  title: "Nexus — Your AI study companion",
  description:
    "Nexus is the trusted academic companion for CBC and KCSE students. Learn with Nex, diagnose your strengths, and practice Mathematics.",
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
      className={cn("h-full antialiased", hanken.variable, fraunces.variable)}
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
