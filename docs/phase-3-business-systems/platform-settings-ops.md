# Platform settings operator notes

## Cache window (PR-141)

`getPlatformSettings()` caches `platform_settings` rows in memory for **60 seconds** (`CACHE_TTL_MS = 60_000` in `src/lib/platform/getPlatformSettings.ts`).

Implications for operators:

- Pricing, daily limits, and promotion changes written via `/admin/platform-settings` may take up to one minute to appear on student-facing pages that read cached settings.
- The admin settings editor surfaces this window in its page description.
- For incident response, assume a brief staleness window rather than immediate global consistency.
