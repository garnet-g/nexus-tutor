-- Voice response cache: reuses previously synthesized TTS audio for
-- identical Nex response text instead of re-calling the TTS provider.

INSERT INTO storage.buckets (id, name, public)
VALUES ('nex-voice-cache', 'nex-voice-cache', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY nex_voice_cache_service_only ON storage.objects FOR ALL
  USING (bucket_id = 'nex-voice-cache' AND auth.role() = 'service_role')
  WITH CHECK (bucket_id = 'nex-voice-cache' AND auth.role() = 'service_role');

CREATE TABLE public.nex_voice_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_hash TEXT NOT NULL UNIQUE,
  storage_path TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  provider TEXT NOT NULL,
  hit_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_hit_at TIMESTAMPTZ
);

ALTER TABLE public.nex_voice_cache ENABLE ROW LEVEL SECURITY;

CREATE POLICY nex_voice_cache_service_role ON public.nex_voice_cache
  FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');
