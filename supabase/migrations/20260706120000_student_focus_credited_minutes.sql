-- PR-038: credited focus minutes validated server-side.
ALTER TABLE public.student_focus_sessions
  ADD COLUMN credited_minutes INTEGER
  CHECK (credited_minutes IS NULL OR (credited_minutes >= 0 AND credited_minutes <= 240));
