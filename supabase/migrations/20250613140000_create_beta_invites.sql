-- Beta invite codes for gated signup during private beta

CREATE TABLE public.beta_invites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code TEXT NOT NULL UNIQUE,
  max_uses INTEGER NOT NULL DEFAULT 1 CHECK (max_uses > 0),
  use_count INTEGER NOT NULL DEFAULT 0 CHECK (use_count >= 0),
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT beta_invites_use_count_lte_max CHECK (use_count <= max_uses)
);

CREATE INDEX idx_beta_invites_code ON public.beta_invites(invite_code);
CREATE INDEX idx_beta_invites_active ON public.beta_invites(is_active) WHERE is_active = true;

CREATE TRIGGER trg_beta_invites_updated_at
  BEFORE UPDATE ON public.beta_invites
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.beta_invites ENABLE ROW LEVEL SECURITY;

-- No authenticated policies — access via service role only (admin API)
