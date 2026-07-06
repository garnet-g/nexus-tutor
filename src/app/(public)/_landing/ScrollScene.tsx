"use client";

import {
  useEffect,
  useRef,
  useState,
  type CSSProperties,
  type ReactNode,
} from "react";

import { cn } from "@/lib/utils";

interface ScrollSceneProps {
  /** Scene scroll length in viewport heights (3 renders a 300vh section). */
  length: number;
  /** Shorter length used below the 640px breakpoint. */
  lengthSm?: number;
  className?: string;
  /** Stage content, driven by scene progress 0..1. */
  children: (progress: number) => ReactNode;
}

const prefersStatic = () =>
  typeof window.matchMedia !== "function" ||
  window.matchMedia("(prefers-reduced-motion: reduce)").matches;

/**
 * Scroll-locked scene. Renders a tall section whose stage pins below the
 * site header (sticky) while the reader scrubs; progress 0..1 reaches the
 * stage as a --p CSS variable and the render prop.
 *
 * Before hydration, without matchMedia, or under prefers-reduced-motion the
 * scene renders unpinned at natural height in its FINAL state (progress 1),
 * so the page still reads as complete static editorial.
 */
export function ScrollScene({
  length,
  lengthSm,
  className,
  children,
}: ScrollSceneProps) {
  const sectionRef = useRef<HTMLElement | null>(null);
  const [progress, setProgress] = useState(1);
  const [vhLength, setVhLength] = useState<number | null>(null);

  useEffect(() => {
    if (prefersStatic()) return;
    // Defer past the effect body (same pattern as Reveal.tsx) so pinning
    // does not trigger a cascading render during mount.
    const raf = requestAnimationFrame(() => {
      const small = window.innerWidth < 640;
      setVhLength(small && lengthSm ? lengthSm : length);
    });
    return () => cancelAnimationFrame(raf);
  }, [length, lengthSm]);

  useEffect(() => {
    if (vhLength === null) return;
    const section = sectionRef.current;
    if (!section) return;

    let raf = 0;
    const update = () => {
      raf = 0;
      const rect = section.getBoundingClientRect();
      const scrollable = rect.height - window.innerHeight;
      const p =
        scrollable > 0 ? Math.min(1, Math.max(0, -rect.top / scrollable)) : 1;
      setProgress(Math.round(p * 1000) / 1000);
    };
    const onScroll = () => {
      if (!raf) raf = requestAnimationFrame(update);
    };

    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    return () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
      if (raf) cancelAnimationFrame(raf);
    };
  }, [vhLength]);

  const pinned = vhLength !== null;

  return (
    <section
      ref={sectionRef}
      className={className}
      style={
        {
          height: pinned ? `${vhLength * 100}vh` : undefined,
          "--p": progress,
        } as CSSProperties
      }
    >
      <div
        className={cn(
          pinned && "sticky top-16 h-[calc(100dvh-4rem)] overflow-hidden",
        )}
      >
        {children(progress)}
      </div>
    </section>
  );
}
