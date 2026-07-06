export type FeatureRegistryEntry = {
  /** Default when no rollout row exists — unreleased utilities start false. */
  defaultEnabled: boolean;
  studentRoutes?: string[];
  apiRoutePrefixes?: string[];
};

export const FEATURE_REGISTRY = {
  "student.study_search": {
    defaultEnabled: false,
    studentRoutes: ["/study-search"],
  },
  "student.offline_packs": {
    defaultEnabled: false,
    studentRoutes: ["/offline"],
    apiRoutePrefixes: ["/api/students/offline-packs"],
  },
  "student.concept_library": {
    defaultEnabled: false,
    studentRoutes: ["/library"],
  },
} as const satisfies Record<string, FeatureRegistryEntry>;

export type FeatureKey = keyof typeof FEATURE_REGISTRY;

export function isRegisteredFeatureKey(value: string): value is FeatureKey {
  return value in FEATURE_REGISTRY;
}

export function findFeatureKeyForPath(pathname: string): FeatureKey | null {
  for (const [key, entry] of Object.entries(FEATURE_REGISTRY) as Array<
    [FeatureKey, FeatureRegistryEntry]
  >) {
    if (entry.studentRoutes?.some((route) => pathname === route || pathname.startsWith(`${route}/`))) {
      return key;
    }
    if (
      entry.apiRoutePrefixes?.some(
        (prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`),
      )
    ) {
      return key;
    }
  }
  return null;
}
