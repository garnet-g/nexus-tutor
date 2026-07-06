const CACHE_VERSION = "v1";

self.addEventListener("install", (event) => {
  event.waitUntil(self.skipWaiting());
});

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener("fetch", (event) => {
  const request = event.request;
  if (request.method !== "GET") {
    return;
  }

  event.respondWith(
    caches.match(request).then((cached) => cached ?? fetch(request)),
  );
});

self.addEventListener("message", (event) => {
  if (event.data?.type === "NEXUS_OFFLINE_VERSION") {
    event.source?.postMessage({ type: "NEXUS_OFFLINE_VERSION", version: CACHE_VERSION });
  }
});
