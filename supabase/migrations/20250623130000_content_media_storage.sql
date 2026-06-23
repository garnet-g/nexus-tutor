-- Authoring Studio: public-read content media bucket; super_admin write via authenticated client.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'content-media',
  'content-media',
  true,
  10485760,
  ARRAY[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
    'application/pdf',
    'video/mp4'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Public read for lesson images, attachments, and embed poster assets.
CREATE POLICY content_media_public_select ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'content-media');

CREATE POLICY content_media_super_admin_insert ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'content-media'
    AND public.is_super_admin()
  );

CREATE POLICY content_media_super_admin_update ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'content-media'
    AND public.is_super_admin()
  )
  WITH CHECK (
    bucket_id = 'content-media'
    AND public.is_super_admin()
  );

CREATE POLICY content_media_super_admin_delete ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'content-media'
    AND public.is_super_admin()
  );
