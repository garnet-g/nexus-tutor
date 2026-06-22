-- Phase 3b admin tables:
--   1. public.nex_message_flags — safety review queue for flagged Nex chat
--      messages (student-raised, admin-raised, or system-detected). Admins
--      triage these in the Nex review surface and resolve / escalate them.
--   2. public.coupons — growth coupon catalogue managed by super admins.
--
-- Both are admin-only tables. Reads and writes go exclusively through the
-- service-role client, which bypasses RLS. This mirrors how other admin-only
-- tables (e.g. admin_audit_log, platform_settings) are treated: deny-all by
-- default with no permissive anon/authenticated policies.
--
-- OUT OF SCOPE: coupon REDEMPTION (validating a code and decrementing
-- used_count at checkout) is a learner-facing billing concern handled
-- elsewhere — this admin migration only manages the coupon catalogue.

CREATE TABLE public.nex_message_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id UUID REFERENCES public.nex_messages(id) ON DELETE SET NULL,
  session_id UUID,
  student_id UUID,
  reason TEXT,
  source TEXT NOT NULL DEFAULT 'admin'
    CHECK (source IN ('student', 'admin', 'system')),
  status TEXT NOT NULL DEFAULT 'open'
    CHECK (status IN ('open', 'resolved', 'escalated')),
  notes TEXT,
  resolved_by UUID REFERENCES auth.users(id),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_nex_message_flags_status ON public.nex_message_flags(status, created_at DESC);
CREATE INDEX idx_nex_message_flags_message ON public.nex_message_flags(message_id);
CREATE INDEX idx_nex_message_flags_student ON public.nex_message_flags(student_id);

CREATE TABLE public.coupons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  discount_type TEXT NOT NULL CHECK (discount_type IN ('percent', 'fixed')),
  discount_value NUMERIC NOT NULL CHECK (discount_value > 0),
  applies_to_plan TEXT NOT NULL DEFAULT 'any'
    CHECK (applies_to_plan IN ('premium', 'family', 'any')),
  max_uses INTEGER,
  used_count INTEGER NOT NULL DEFAULT 0,
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_coupons_code ON public.coupons(code);
CREATE INDEX idx_coupons_is_active ON public.coupons(is_active);

-- Deny-all by default: no permissive policies for anon/authenticated.
-- Admin reads and writes go exclusively through the service-role client, which
-- bypasses RLS. This mirrors how other admin-only tables (e.g.
-- admin_audit_log, platform_settings) are treated.
ALTER TABLE public.nex_message_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;
