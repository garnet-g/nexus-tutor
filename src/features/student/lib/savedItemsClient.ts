export type SavedItemPayload = {
  itemType: "question" | "lesson" | "topic" | "note";
  itemId?: string | null;
  title: string;
  description?: string | null;
  href: string;
  metadata?: Record<string, unknown>;
};

export async function createSavedItem(payload: SavedItemPayload) {
  const response = await fetch("/api/students/saved-items", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  const body = await response.json();

  if (!response.ok || !body.success) {
    throw new Error(body.error?.message ?? "Could not save item.");
  }

  return body.data.item as { id: string };
}

export async function removeSavedItem(id: string) {
  const response = await fetch(`/api/students/saved-items?id=${encodeURIComponent(id)}`, {
    method: "DELETE",
  });
  const body = await response.json();

  if (!response.ok || !body.success) {
    throw new Error(body.error?.message ?? "Could not remove saved item.");
  }
}

export async function removeSavedItemByReference(
  itemType: SavedItemPayload["itemType"],
  itemId: string,
) {
  const response = await fetch(
    `/api/students/saved-items?itemType=${encodeURIComponent(itemType)}&itemId=${encodeURIComponent(itemId)}`,
    { method: "DELETE" },
  );
  const body = await response.json();

  if (!response.ok || !body.success) {
    throw new Error(body.error?.message ?? "Could not remove saved item.");
  }
}
