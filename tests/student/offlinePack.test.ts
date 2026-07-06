/**
 * @vitest-environment jsdom
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

import {
  getOfflineCachePrefix,
  getOfflineIdbName,
  purgeOfflineCaches,
  rememberOfflineStudentNamespace,
} from "@/lib/offline/offlineStorage";

describe("offline storage namespace", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it("scopes cache keys per student", () => {
    expect(getOfflineCachePrefix("student-a")).toBe("nexus-offline:student-a:");
    expect(getOfflineIdbName("student-b")).toBe("nexus-offline-student-b");
  });

  it("stores active student namespace", () => {
    rememberOfflineStudentNamespace("student-new");
    expect(localStorage.getItem("nexus-offline-student-id")).toBe("student-new");
  });

  it("clears namespace marker on purge", async () => {
    localStorage.setItem("nexus-offline-student-id", "student-1");

    const cacheDelete = vi.fn(async () => true);
    vi.stubGlobal("caches", {
      keys: async () => ["nexus-offline:student-1:recommended-study-pack"],
      delete: cacheDelete,
    });

    await purgeOfflineCaches("student-1");

    expect(cacheDelete).toHaveBeenCalledWith(
      "nexus-offline:student-1:recommended-study-pack",
    );
    expect(localStorage.getItem("nexus-offline-student-id")).toBeNull();
  });
});
