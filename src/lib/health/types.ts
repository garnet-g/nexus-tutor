export type ProbeStatus =
  | "configured"
  | "reachable"
  | "degraded"
  | "misconfigured"
  | "not_verified";

export interface HealthProbe {
  id: string;
  name: string;
  status: ProbeStatus;
  detail: string;
}

export type AdminHealthPresentationStatus = "healthy" | "watch" | "critical";

export interface AdminHealthPresentationItem {
  name: string;
  status: AdminHealthPresentationStatus;
  detail: string;
  probeStatus: ProbeStatus;
}
