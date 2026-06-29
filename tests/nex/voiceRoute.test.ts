/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

import { POST } from "@/app/api/nex/voice/route";

vi.mock("server-only", () => ({}));

const getUser = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser },
    from: (...args: unknown[]) => from(...args),
  })),
}));

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  getEffectiveSubscriptionConfigWithFallback: vi.fn(async () => ({})),
  getNexDailyLimit: vi.fn(() => 50),
}));

vi.mock("@/server/services/nexUsageService", () => ({
  getNexDailyUsageCount: vi.fn(async () => 0),
  getSecondsUntilNairobiMidnight: vi.fn(() => 3600),
  getStudentPlanCode: vi.fn(async () => "premium"),
  incrementNexDailyUsage: vi.fn(async () => undefined),
}));

vi.mock("@/lib/nex/voiceTranscribe", () => ({
  transcribeVoiceAudio: vi.fn(async () => ({
    transcript: "Explain fractions to me",
    provider: "mock",
  })),
}));

vi.mock("@/lib/nex/voiceSynthesize", () => ({
  synthesizeVoiceResponse: vi.fn(async () => ({
    audioBase64: "dGVzdA==",
    mimeType: "audio/wav",
    provider: "mock",
  })),
}));

vi.mock("@/lib/nex/generateNexResponse", () => ({
  generateNexResponse: vi.fn(async () => ({
    response:
      "Fractions show parts of a whole. What fraction is one slice of a pizza cut into four equal parts?",
    sessionMode: "explain",
    provider: "mock",
    validationPassed: true,
    metadata: {},
  })),
}));

vi.mock("@/server/services/misconceptionService", () => ({
  shouldPersistMisconception: vi.fn(() => false),
  resolveMisconceptionFromMessage: vi.fn(),
  persistStudentMisconception: vi.fn(),
  applyAssessmentMasteryUpdate: vi.fn(),
}));

const STUDENT_ID = "11111111-1111-4111-8111-111111111111";
const USER_ID = "22222222-2222-4222-8222-222222222222";

function authedUser() {
  getUser.mockResolvedValue({
    data: { user: { id: USER_ID } },
    error: null,
  });
}

function mockStudentProfile() {
  from.mockImplementation((table: string) => {
    if (table === "student_profiles") {
      return {
        select: () => ({
          eq: () => ({
            maybeSingle: async () => ({
              data: { id: STUDENT_ID },
              error: null,
            }),
          }),
        }),
      };
    }

    return {
      select: () => ({
        eq: () => ({
          maybeSingle: async () => ({ data: null, error: null }),
          order: () => ({ limit: async () => ({ data: [] }) }),
        }),
      }),
      insert: () => ({
        select: () => ({
          single: async () => ({ data: { id: "session-1" }, error: null }),
        }),
      }),
      update: () => ({
        eq: async () => ({ error: null }),
      }),
    };
  });
}

function buildVoiceRequest(options?: {
  audio?: Blob;
  audioName?: string;
  durationSeconds?: string;
}) {
  const formData = new FormData();
  if (options?.audio) {
    formData.append("audio", options.audio, options.audioName ?? "voice.webm");
  }
  if (options?.durationSeconds) {
    formData.append("durationSeconds", options.durationSeconds);
  }

  return new Request("http://localhost/api/nex/voice", {
    method: "POST",
    body: formData,
  });
}

beforeEach(async () => {
  vi.clearAllMocks();
  const { getStudentPlanCode } = await import("@/server/services/nexUsageService");
  vi.mocked(getStudentPlanCode).mockResolvedValue("premium");
  authedUser();
  mockStudentProfile();
});

describe("POST /api/nex/voice", () => {
  it("returns 401 when the session is missing", async () => {
    getUser.mockResolvedValue({ data: { user: null }, error: null });

    const response = await POST(buildVoiceRequest());
    const body = await response.json();

    expect(response.status).toBe(401);
    expect(body.error.code).toBe("UNAUTHORIZED");
  });

  it("returns 403 when the student profile is missing", async () => {
    from.mockImplementation((table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: null, error: null }),
            }),
          }),
        };
      }
      return { select: vi.fn() };
    });

    const response = await POST(buildVoiceRequest());
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
  });

  it("returns 403 for free-plan students", async () => {
    const { getStudentPlanCode } = await import("@/server/services/nexUsageService");
    vi.mocked(getStudentPlanCode).mockResolvedValue("free");

    const response = await POST(buildVoiceRequest());
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("PREMIUM_REQUIRED");
  });

  it("returns 400 when audio is missing", async () => {
    const response = await POST(buildVoiceRequest());
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
  });

  it("returns 400 for unsupported mime types", async () => {
    const { transcribeVoiceAudio } = await import("@/lib/nex/voiceTranscribe");
    const audio = new Blob([new Uint8Array([1, 2, 3])], { type: "text/plain" });

    const response = await POST(
      buildVoiceRequest({ audio, audioName: "voice.txt" }),
    );
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
    expect(transcribeVoiceAudio).not.toHaveBeenCalled();
  });

  it("returns 400 when duration exceeds 30 seconds", async () => {
    const { transcribeVoiceAudio } = await import("@/lib/nex/voiceTranscribe");
    const audio = new Blob([new Uint8Array([1, 2, 3])], { type: "audio/webm" });

    const response = await POST(
      buildVoiceRequest({ audio, durationSeconds: "31" }),
    );
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
    expect(transcribeVoiceAudio).not.toHaveBeenCalled();
  });
});
