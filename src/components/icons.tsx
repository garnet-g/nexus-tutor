import type { SVGProps } from "react";

type IconProps = SVGProps<SVGSVGElement> & { size?: number };

function base({ size = 22, ...props }: IconProps) {
  return {
    width: size,
    height: size,
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: 2,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
    ...props,
  };
}

export function HomeIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
      <path d="M9 22V12h6v10" />
    </svg>
  );
}

export function BookIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
      <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2Z" />
    </svg>
  );
}

export function ChartIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="M3 3v18h18" />
      <path d="m7 14 4-4 3 3 5-6" />
    </svg>
  );
}

export function SparkleIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="m12 3-1.9 5.8a2 2 0 0 1-1.3 1.3L3 12l5.8 1.9a2 2 0 0 1 1.3 1.3L12 21l1.9-5.8a2 2 0 0 1 1.3-1.3L21 12l-5.8-1.9a2 2 0 0 1-1.3-1.3Z" />
    </svg>
  );
}

export function ChevronRightIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="m9 18 6-6-6-6" />
    </svg>
  );
}

export function SendIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="m22 2-7 20-4-9-9-4Z" />
      <path d="M22 2 11 13" />
    </svg>
  );
}

export function TrendUpIcon(props: IconProps) {
  return (
    <svg {...base(props)} aria-hidden>
      <path d="M16 7h6v6" />
      <path d="m22 7-8.5 8.5-5-5L2 17" />
    </svg>
  );
}

export function FlameIcon({ size = 22, ...props }: IconProps) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      aria-hidden
      {...props}
    >
      <path
        d="M12 2c1.5 3 4.5 4.5 4.5 8.5a4.5 4.5 0 0 1-9 0c0-1 .3-1.8.8-2.6C8 9.5 9 11 10 11c.7 0 .5-1.2.3-2C9.8 6.7 10.5 4 12 2Z"
        fill="var(--nexus-accent)"
        stroke="var(--nexus-warning)"
        strokeWidth="1.1"
        strokeLinejoin="round"
      />
    </svg>
  );
}
