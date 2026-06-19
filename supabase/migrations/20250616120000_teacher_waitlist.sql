-- Teacher waitlist capture (marketing only — no teacher accounts in V1)

CREATE TABLE public.teacher_waitlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  full_name TEXT NOT NULL,
  school_name TEXT NOT NULL,
  curriculum TEXT CHECK (curriculum IN ('CBC', 'KCSE')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_teacher_waitlist_email_lower
  ON public.teacher_waitlist (LOWER(email));

ALTER TABLE public.teacher_waitlist ENABLE ROW LEVEL SECURITY;

-- No authenticated policies — inserts via service role API only
