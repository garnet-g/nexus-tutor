"use client";

import { useEffect, useRef, useState, type CSSProperties, type ReactNode } from "react";

import { cn } from "@/lib/utils";

interface RevealProps {
  children: ReactNode;
  className?: string;
  /** Delay before the reveal animates in, in milliseconds. */
  delay?: number;
  /** How much of the element must be visible before it triggers (0-1). */
  threshold?: number;
}

/**
 * Reveal-on-scroll wrapper for the marketing story. Animates opacity and
 * transform only (hardware accelerated) and honours prefers-reduced-motion by
 * snapping straight to the visible state. Motion is motivated: each beat of the
 * narrative settles as the reader arrives at it, never decoratively.
 */
export function Reveal({ children, className, delay = 0, threshold = 0.18 }: RevealProps) {
  const ref = useRef<HTMLDivElement>(null);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const node = ref.current;
    if (!node) return;

    if (typeof IntersectionObserver === "undefined") {
      const raf = requestAnimationFrame(() => setVisible(true));
      return () => cancelAnimationFrame(raf);
    }

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setVisible(true);
          observer.disconnect();
        }
      },
      { threshold, rootMargin: "0px 0px -8% 0px" },
    );

    observer.observe(node);
    return () => observer.disconnect();
  }, [threshold]);

  return (
    <div
      ref={ref}
      className={cn("nexus-reveal", visible && "is-visible", className)}
      style={{ "--reveal-delay": `${delay}ms` } as CSSProperties}
    >
      {children}
    </div>
  );
}
