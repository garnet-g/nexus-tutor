-- PR-067: DB-enforced idempotency for admin communication sends.
-- Replaces the non-unique partial index from 20260706180000.

DROP INDEX IF EXISTS public.idx_admin_communication_logs_idempotency;

CREATE UNIQUE INDEX idx_admin_communication_logs_idempotency_unique
  ON public.admin_communication_logs(idempotency_key)
  WHERE idempotency_key IS NOT NULL;

ALTER TABLE public.admin_communication_logs
  ADD COLUMN IF NOT EXISTS metadata JSONB NOT NULL DEFAULT '{}'::jsonb;
