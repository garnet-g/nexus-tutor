-- Explain-mode response cache: avoids re-generating answers to the same
-- topic + normalized question across students, bounded by a TTL checked in
-- application code (nexResponseCacheService.ts).

CREATE TABLE public.nex_response_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cache_key TEXT NOT NULL UNIQUE,
  topic_id UUID REFERENCES public.topics(id) ON DELETE CASCADE,
  normalized_question TEXT NOT NULL,
  response_text TEXT NOT NULL,
  hit_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_hit_at TIMESTAMPTZ
);

CREATE INDEX idx_nex_response_cache_topic
  ON public.nex_response_cache(topic_id, created_at DESC);

ALTER TABLE public.nex_response_cache ENABLE ROW LEVEL SECURITY;

-- Service-role only: this is an internal cost-optimization cache, not
-- student-owned data, so no student RLS policy is needed.
CREATE POLICY nex_response_cache_service_role ON public.nex_response_cache
  FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');
