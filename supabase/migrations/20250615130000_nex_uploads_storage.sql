-- Nex camera uploads: private bucket, student-scoped paths {student_id}/{file}
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'nex-uploads',
  'nex-uploads',
  false,
  5242880,
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO UPDATE SET
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

CREATE POLICY nex_uploads_student_select ON storage.objects
  FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'nex-uploads'
    AND (storage.foldername(name))[1] IN (
      SELECT id::text FROM public.student_profiles WHERE user_id = auth.uid()
    )
  );

CREATE POLICY nex_uploads_student_insert ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'nex-uploads'
    AND (storage.foldername(name))[1] IN (
      SELECT id::text FROM public.student_profiles WHERE user_id = auth.uid()
    )
  );

CREATE POLICY nex_uploads_student_delete ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'nex-uploads'
    AND (storage.foldername(name))[1] IN (
      SELECT id::text FROM public.student_profiles WHERE user_id = auth.uid()
    )
  );
