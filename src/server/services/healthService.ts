import "server-only";

import { runHealthProbes } from "@/lib/health/probes";
import type {
  AdminHealthPresentationItem,
  AdminHealthPresentationStatus,
  ProbeStatus,
} from "@/lib/health/types";
import { getNotificationOutboxHealthItem } from "@/server/services/notificationOutboxService";

function mapProbeToPresentationStatus(
  status: ProbeStatus,
): AdminHealthPresentationStatus {
  if (status === "misconfigured") {
    return "critical";
  }

  if (status === "degraded" || status === "not_verified") {
    return "watch";
  }

  return "healthy";
}

export async function getDeploymentHealthSummary(options?: {
  checkReachability?: boolean;
}): Promise<AdminHealthPresentationItem[]> {
  const probes = await runHealthProbes(options);

  const probeItems = probes.map((probe) => ({
    name: probe.name,
    status: mapProbeToPresentationStatus(probe.status),
    detail: probe.detail,
    probeStatus: probe.status,
  }));

  const outboxHealth = await getNotificationOutboxHealthItem();

  return [...probeItems, outboxHealth];
}
