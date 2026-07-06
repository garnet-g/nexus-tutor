-- PR-129 / PR-130: Durable notification outbox with retry, backoff, and dead-letter.
CREATE TABLE public.notification_outbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  idempotency_key TEXT NOT NULL,
  channel TEXT NOT NULL CHECK (channel IN ('sms', 'email')),
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'retry_scheduled', 'sent', 'dead_letter')),
  payload JSONB NOT NULL,
  attempt_count INTEGER NOT NULL DEFAULT 0,
  max_attempts INTEGER NOT NULL DEFAULT 5,
  next_attempt_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_error TEXT,
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT notification_outbox_idempotency_key_unique UNIQUE (idempotency_key)
);

CREATE INDEX idx_notification_outbox_processable
  ON public.notification_outbox (next_attempt_at)
  WHERE status IN ('pending', 'retry_scheduled');

CREATE INDEX idx_notification_outbox_dead_letter
  ON public.notification_outbox (created_at DESC)
  WHERE status = 'dead_letter';

CREATE TRIGGER trg_notification_outbox_updated_at
  BEFORE UPDATE ON public.notification_outbox
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.notification_outbox ENABLE ROW LEVEL SECURITY;

CREATE POLICY notification_outbox_service_role ON public.notification_outbox
  FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');
