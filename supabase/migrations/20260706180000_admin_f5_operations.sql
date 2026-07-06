-- Phase F5: admin communications idempotency + experiment exposure metrics

ALTER TABLE public.admin_communication_logs
  ADD COLUMN IF NOT EXISTS idempotency_key TEXT;

CREATE INDEX IF NOT EXISTS idx_admin_communication_logs_idempotency
  ON public.admin_communication_logs(idempotency_key)
  WHERE idempotency_key IS NOT NULL;

CREATE TABLE IF NOT EXISTS public.admin_experiment_exposures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  experiment_key TEXT NOT NULL,
  subject_id TEXT NOT NULL,
  variant TEXT NOT NULL,
  exposed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (experiment_key, subject_id)
);

CREATE INDEX IF NOT EXISTS idx_admin_experiment_exposures_key
  ON public.admin_experiment_exposures(experiment_key, exposed_at DESC);

ALTER TABLE public.admin_experiment_exposures ENABLE ROW LEVEL SECURITY;
