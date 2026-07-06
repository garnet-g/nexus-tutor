const OFFLINE_CACHE_PREFIX = "nexus-offline:";
const OFFLINE_IDB_PREFIX = "nexus-offline-";
const STUDENT_NAMESPACE_KEY = "nexus-offline-student-id";

export function getOfflineCachePrefix(studentId: string) {
  return `${OFFLINE_CACHE_PREFIX}${studentId}:`;
}

export function getOfflineIdbName(studentId: string) {
  return `${OFFLINE_IDB_PREFIX}${studentId}`;
}

export async function purgeOfflineCaches(studentId?: string | null): Promise<void> {
  if (typeof window === "undefined") {
    return;
  }

  const namespaces = new Set<string>();
  if (studentId) {
    namespaces.add(studentId);
  }

  const stored = window.localStorage.getItem(STUDENT_NAMESPACE_KEY);
  if (stored) {
    namespaces.add(stored);
  }

  if ("caches" in window) {
    const keys = await caches.keys();
    await Promise.all(
      keys
        .filter((key) =>
          [...namespaces].some((id) => key.startsWith(getOfflineCachePrefix(id))),
        )
        .map((key) => caches.delete(key)),
    );
  }

  if ("indexedDB" in window) {
    const databases = await indexedDB.databases?.();
    await Promise.all(
      (databases ?? [])
        .map((db) => db.name)
        .filter((name): name is string =>
          Boolean(
            name &&
              [...namespaces].some((id) => name.startsWith(getOfflineIdbName(id))),
          ),
        )
        .map(
          (name) =>
            new Promise<void>((resolve) => {
              const request = indexedDB.deleteDatabase(name);
              request.onsuccess = () => resolve();
              request.onerror = () => resolve();
              request.onblocked = () => resolve();
            }),
        ),
    );
  }

  window.localStorage.removeItem(STUDENT_NAMESPACE_KEY);
}

export function rememberOfflineStudentNamespace(studentId: string) {
  if (typeof window === "undefined") {
    return;
  }

  const previous = window.localStorage.getItem(STUDENT_NAMESPACE_KEY);
  if (previous && previous !== studentId) {
    void purgeOfflineCaches(previous);
  }

  window.localStorage.setItem(STUDENT_NAMESPACE_KEY, studentId);
}

export async function cacheOfflinePackUrls(
  studentId: string,
  packKey: string,
  urls: string[],
): Promise<void> {
  if (!("caches" in window)) {
    return;
  }

  const cache = await caches.open(`${getOfflineCachePrefix(studentId)}${packKey}`);
  await Promise.all(
    urls.map(async (url) => {
      const response = await fetch(url, { credentials: "same-origin" });
      if (response.ok) {
        await cache.put(url, response);
      }
    }),
  );
}
