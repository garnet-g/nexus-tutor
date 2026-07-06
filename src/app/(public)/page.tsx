import Link from "next/link";

import { Button } from "@/components/ui/Button";

import { Reveal } from "./_landing/Reveal";
import { SceneHero } from "./_landing/SceneHero";
import { SceneMarksAndYears } from "./_landing/SceneMarksAndYears";
import { SceneSession } from "./_landing/SceneSession";

// The page is a playable diagnosis: three pinned scenes the reader scrubs
// through, then a deliberately unpinned release. Scene copy lives with each
// scene component; this file only composes the story.

export default function LandingPage() {
  return (
    <div className="overflow-x-clip bg-[#171814] text-nexus-text-inverse">
      <SceneHero />
      <SceneSession />
      <SceneMarksAndYears />
      <Release />
    </div>
  );
}

/* The release. After three locked scenes this one scrolls normally: the
   diagnosis is done, the reader is free to move. */
function Release() {
  return (
    <section className="relative overflow-hidden px-5 py-32 sm:px-8 lg:px-10 lg:py-48">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_82%_18%,rgba(224,136,59,0.18),transparent_36rem),linear-gradient(180deg,#141510_0%,#0e0f0c_100%)]" />
      <div className="relative mx-auto max-w-[1100px]">
        <Reveal>
          <p className="font-mono text-xs uppercase tracking-[0.24em] text-[#e0883b]">
            11 days to the mock
          </p>
          <h2 className="mt-7 max-w-4xl font-heading text-[clamp(2.8rem,7vw,6rem)] font-medium leading-[0.9] tracking-[-0.055em] text-[#fbf8f3]">
            This time you walk in knowing exactly what you fixed.
          </h2>
        </Reveal>
        <Reveal
          delay={140}
          className="mt-12 flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between"
        >
          <p className="max-w-md text-lg leading-8 text-white/60">
            Give Nex one revision session tonight. Get the next move before
            you close the books.
          </p>
          <Button
            render={<Link href="/signup" />}
            className="min-h-14 w-full shrink-0 rounded-none bg-[#fbf8f3] px-7 text-[#0e0f0c] transition-all duration-300 ease-[cubic-bezier(0.16,1,0.3,1)] hover:-translate-y-0.5 hover:bg-white sm:w-auto"
          >
            Start your diagnosis
            <span className="ml-3 flex size-7 items-center justify-center bg-[#0e0f0c] text-[#fbf8f3]">
              &rarr;
            </span>
          </Button>
        </Reveal>
      </div>
    </section>
  );
}
