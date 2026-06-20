import { cn } from "@/lib/utils";

interface ProgressRingProps {
  value: number;
  max?: number;
  label?: string;
  unit?: string;
  size?: number;
  strokeWidth?: number;
  className?: string;
}

export function ProgressRing({
  value,
  max = 100,
  label,
  unit,
  size = 96,
  strokeWidth = 9,
  className,
}: ProgressRingProps) {
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const pct = max > 0 ? Math.min(1, Math.max(0, value / max)) : 0;
  const offset = circumference * (1 - pct);

  return (
    <div
      className={cn("relative flex items-center justify-center", className)}
      style={{ width: size, height: size }}
      role="img"
      aria-label={label ? `${value}${unit ?? ""} ${label}` : `${Math.round(pct * 100)} percent`}
    >
      <svg width={size} height={size} className="-rotate-90" aria-hidden>
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="var(--nexus-sunken)"
          strokeWidth={strokeWidth}
        />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="var(--nexus-primary)"
          strokeWidth={strokeWidth}
          strokeLinecap="round"
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          className="transition-[stroke-dashoffset] duration-700 ease-out"
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="font-heading text-xl font-medium tabular leading-none text-foreground">
          {Math.round(value)}
          {unit ? (
            <span className="text-xs text-muted-foreground">{unit}</span>
          ) : null}
        </span>
        {label ? (
          <span className="mt-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {label}
          </span>
        ) : null}
      </div>
    </div>
  );
}

interface BarMeterProps {
  value: number;
  max?: number;
  label?: string;
  showValue?: boolean;
  className?: string;
}

export function BarMeter({
  value,
  max = 100,
  label,
  showValue = true,
  className,
}: BarMeterProps) {
  const pct = max > 0 ? Math.min(100, Math.max(0, (value / max) * 100)) : 0;

  return (
    <div className={cn("space-y-1.5", className)}>
      {label || showValue ? (
        <div className="flex items-center justify-between gap-2 text-sm">
          {label ? <span className="text-foreground">{label}</span> : <span />}
          {showValue ? (
            <span className="tabular text-muted-foreground">{Math.round(pct)}%</span>
          ) : null}
        </div>
      ) : null}
      <div className="h-2 overflow-hidden rounded-full bg-nexus-sunken">
        <div
          className="h-full rounded-full bg-nexus-primary transition-[width] duration-700"
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}

interface SparklineProps {
  points: number[];
  width?: number;
  height?: number;
  className?: string;
}

export function Sparkline({
  points,
  width = 120,
  height = 36,
  className,
}: SparklineProps) {
  if (points.length < 2) {
    return null;
  }

  const min = Math.min(...points);
  const max = Math.max(...points);
  const range = max - min || 1;
  const step = width / (points.length - 1);
  const path = points
    .map((point, index) => {
      const x = index * step;
      const y = height - ((point - min) / range) * (height - 4) - 2;
      return `${index === 0 ? "M" : "L"}${x},${y}`;
    })
    .join(" ");

  return (
    <svg
      width={width}
      height={height}
      viewBox={`0 0 ${width} ${height}`}
      className={className}
      aria-hidden
    >
      <path
        d={path}
        fill="none"
        stroke="var(--nexus-primary)"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

interface LineChartProps {
  points: Array<{ label: string; value: number }>;
  width?: number;
  height?: number;
  className?: string;
}

export function LineChart({
  points,
  width = 320,
  height = 120,
  className,
}: LineChartProps) {
  if (points.length < 2) {
    return null;
  }

  const values = points.map((point) => point.value);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const range = max - min || 1;
  const step = width / (points.length - 1);
  const path = points
    .map((point, index) => {
      const x = index * step;
      const y = height - 16 - ((point.value - min) / range) * (height - 32);
      return `${index === 0 ? "M" : "L"}${x},${y}`;
    })
    .join(" ");

  return (
    <svg
      width="100%"
      height={height}
      viewBox={`0 0 ${width} ${height}`}
      className={className}
      role="img"
      aria-label="Line chart"
    >
      <path
        d={`${path} L ${width} ${height} L 0 ${height} Z`}
        fill="var(--nexus-primary-soft)"
        stroke="none"
      />
      <path
        d={path}
        fill="none"
        stroke="var(--nexus-primary)"
        strokeWidth="2.5"
        strokeLinecap="round"
      />
    </svg>
  );
}

interface RadarChartProps {
  labels: string[];
  values: number[];
  size?: number;
  className?: string;
}

export function RadarChart({
  labels,
  values,
  size = 220,
  className,
}: RadarChartProps) {
  if (labels.length === 0 || labels.length !== values.length) {
    return null;
  }

  const center = size / 2;
  const radius = size * 0.34;
  const angleStep = (Math.PI * 2) / labels.length;

  const toPoint = (index: number, value: number) => {
    const angle = -Math.PI / 2 + index * angleStep;
    const distance = (Math.min(100, Math.max(0, value)) / 100) * radius;
    return {
      x: center + Math.cos(angle) * distance,
      y: center + Math.sin(angle) * distance,
    };
  };

  const polygon = values
    .map((value, index) => {
      const point = toPoint(index, value);
      return `${index === 0 ? "M" : "L"}${point.x},${point.y}`;
    })
    .join(" ");

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${size} ${size}`}
      className={className}
      role="img"
      aria-label="Radar chart"
    >
      {[0.25, 0.5, 0.75, 1].map((scale) => (
        <polygon
          key={scale}
          points={labels
            .map((_, index) => {
              const point = toPoint(index, scale * 100);
              return `${point.x},${point.y}`;
            })
            .join(" ")}
          fill="none"
          stroke="var(--nexus-border)"
          strokeWidth="1"
        />
      ))}
      <path
        d={`${polygon} Z`}
        fill="var(--nexus-primary-soft)"
        stroke="var(--nexus-primary)"
        strokeWidth="2"
      />
    </svg>
  );
}
