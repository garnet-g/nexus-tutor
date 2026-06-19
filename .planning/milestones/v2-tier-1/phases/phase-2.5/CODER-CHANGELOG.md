---
milestone: v2-tier-1
phase: 2.5
agent: coder
status: READY_FOR_QA
---

# CODER-CHANGELOG — Phase 2.5 Voice

## Summary

Push-to-talk voice tutoring on Nex: browser capture → server STT → existing Nex pipeline → TTS reply. No parallel chat system.

## Deliverables

- `voiceTranscribe.ts` — Gemini STT with Whisper fallback, Kenya English hint
- `voiceSynthesize.ts` — Gemini TTS attempt with OpenAI `tts-1` fallback + mock WAV
- `POST /api/nex/voice` — auth, premium gate, 2MB/30s validation, usage limits
- `voiceSchemas.ts` — upload validation + premium helper
- `VoicePushToTalk.tsx` — press-hold-release, 48px target, mic permission UX
- `NexChatPanel` + `/nex` page integration
- `nex_messages` metadata `inputType: "voice"`
- Scope-check allowlist for `/api/nex/voice`
- `tests/voicePipeline.test.ts`
- `LOCAL-DEV.md` + `api-standards.md` updates

## Criteria

V2-VOICE-01 through V2-VOICE-09 addressed.
