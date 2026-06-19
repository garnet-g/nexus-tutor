import type { Metadata } from "next";
import { DM_Sans, Fraunces } from "next/font/google";

import { cn } from "@/lib/utils";

import "./globals.css";

const dmSans = DM_Sans({
  variable: "--font-dm-sans",
  subsets: ["latin"],
});

const fraunces = Fraunces({
  variable: "--font-fraunces",
  subsets: ["latin"],
  axes: ["SOFT", "WONK", "opsz"],
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
      className={cn("h-full antialiased", dmSans.variable, fraunces.variable)}
    >
      <body className="min-h-full flex flex-col font-sans">{children}</body>
    </html>
  );
}
