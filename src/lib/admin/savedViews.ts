export function buildSavedViewHref(view: {
  route: string;
  filters: Record<string, unknown>;
}): string {
  const params = new URLSearchParams();

  for (const [key, value] of Object.entries(view.filters)) {
    if (value === undefined || value === null || value === "") {
      continue;
    }
    if (typeof value === "object") {
      params.set(key, JSON.stringify(value));
    } else {
      params.set(key, String(value));
    }
  }

  const query = params.toString();
  return query ? `${view.route}?${query}` : view.route;
}
