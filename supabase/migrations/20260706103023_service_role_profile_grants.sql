-- Older core tables predate the service-role default privileges. RLS bypass
-- does not provide PostgreSQL table privileges, so trusted server operations
-- and the isolated local seed harness need explicit least-privilege grants.

GRANT SELECT, INSERT, UPDATE ON TABLE public.student_profiles TO service_role;
GRANT SELECT, INSERT, UPDATE ON TABLE public.parent_profiles TO service_role;
GRANT SELECT, INSERT ON TABLE public.super_admin_profiles TO service_role;

GRANT SELECT ON TABLE public.subscription_plans TO service_role;
GRANT SELECT, INSERT ON TABLE public.student_subscriptions TO service_role;

-- Auth-keyed admin account detail reads.
GRANT SELECT, INSERT ON TABLE public.admin_role_assignments TO service_role;
GRANT SELECT ON TABLE public.student_parent_links TO service_role;
GRANT SELECT ON TABLE public.nex_daily_usage TO service_role;
GRANT SELECT ON TABLE public.academic_health_scores TO service_role;
