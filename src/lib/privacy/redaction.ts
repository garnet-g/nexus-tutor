/** Redact phone numbers for exports and operator-facing log snapshots. */
export function redactPhoneNumber(phone: string | null | undefined): string {
  if (!phone) {
    return "—";
  }

  const trimmed = phone.trim();
  if (trimmed.length < 6) {
    return "***";
  }

  return `${trimmed.slice(0, 5)}***${trimmed.slice(-2)}`;
}

/** Never export raw SMS/email bodies — replace with a stable placeholder. */
export function redactMessageBody(body: string | null | undefined): string {
  if (!body || body.trim().length === 0) {
    return "[empty]";
  }

  return "[redacted]";
}

export function redactEmailAddress(email: string | null | undefined): string {
  if (!email) {
    return "—";
  }

  const [local, domain] = email.split("@");
  if (!domain) {
    return "***";
  }

  const visible = local.slice(0, 2);
  return `${visible}***@${domain}`;
}
