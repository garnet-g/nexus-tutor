import type { NextConfig } from "next";

import {
  AUTHENTICATED_ROUTE_PREFIXES,
  buildBaseSecurityHeaders,
  buildNexPrivateHeaders,
  buildPrivateCacheHeaders,
  NEX_ROUTE_PREFIXES,
} from "./src/lib/security/securityHeaders";

function routeHeaderBlock(
  source: string,
  headers: Array<{ key: string; value: string }>,
) {
  return { source, headers };
}

const nextConfig: NextConfig = {
  async headers() {
    const base = buildBaseSecurityHeaders();
    const nexPrivate = buildNexPrivateHeaders();
    const privateCache = buildPrivateCacheHeaders();

    return [
      routeHeaderBlock("/:path*", base),
      ...NEX_ROUTE_PREFIXES.flatMap((prefix) => [
        routeHeaderBlock(prefix, nexPrivate),
        routeHeaderBlock(`${prefix}/:path*`, nexPrivate),
      ]),
      ...AUTHENTICATED_ROUTE_PREFIXES.map((prefix) =>
        routeHeaderBlock(`${prefix}/:path*`, [...base, ...privateCache]),
      ),
      routeHeaderBlock("/parent", [...base, ...privateCache]),
      routeHeaderBlock("/parent/:path*", [...base, ...privateCache]),
    ];
  },
};

export default nextConfig;
