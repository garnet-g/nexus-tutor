---
milestone: v2-tier-1
phase: 2.2
agent: coder
status: READY_FOR_QA
---

# CODER-CHANGELOG — Phase 2.2 Camera

## Summary

Ask Nex with Camera for Homework and Explain: multipart upload → Supabase Storage → Gemini vision extraction → `generateNexResponse`.

## Deliverables

- Migration `20250615130000_nex_uploads_storage.sql` (bucket + RLS)
- `POST /api/nex/camera` with auth, premium gate, 5MB image validation
- `extractImageText.ts`, `CameraCaptureButton.tsx`, Nex page premium flag
- Scope-check V2 allowlist for camera route
- 4 extractImageText tests + `e2e/nex-camera.spec.ts`

## Criteria

V2-CAMERA-01 through V2-CAMERA-08 addressed.
