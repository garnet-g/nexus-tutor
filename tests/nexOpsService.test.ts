import { describe, expect, it } from "vitest";

import {
  buildNexOpsSnapshot,
  estimateTextTokens,
  getNexOpsPricingConfig,
  type NexOpsMessageRow,
} from "@/server/services/nexOpsService";

const baseNow = new Date("2026-06-22T09:00:00.000Z");

function row(input: Partial<NexOpsMessageRow> & Pick<NexOpsMessageRow, "id" | "role" | "message_content">): NexOpsMessageRow {
  return {
    nex_session_id: "session-1",
    student_id: "student-1",
    metadata: {},
    created_at: "2026-06-22T06:00:00.000Z",
    nex_sessions: { session_mode: "practice" },
    ...input,
  };
}

describe("nexOpsService", () => {
  it("estimates text tokens with the dashboard chars-per-token rule", () => {
    expect(estimateTextTokens("12345678")).toBe(2);
    expect(estimateTextTokens("")).toBe(0);
    expect(estimateTextTokens("abc")).toBe(1);
  });

  it("builds provider, mode, fallback, and KES cost metrics from Nex messages", () => {
    const snapshot = buildNexOpsSnapshot({
      now: baseNow,
      usdToKesRate: 130,
      messages: [
        row({
          id: "student-gemini",
          role: "student",
          message_content: "a".repeat(400),
          created_at: "2026-06-22T05:50:00.000Z",
        }),
        row({
          id: "nex-gemini",
          role: "nex",
          message_content: "b".repeat(800),
          metadata: { provider: "gemini", validationPassed: true },
          created_at: "2026-06-22T05:51:00.000Z",
        }),
        row({
          id: "student-openai",
          role: "student",
          message_content: "c".repeat(200),
          nex_session_id: "session-2",
          created_at: "2026-06-21T05:50:00.000Z",
          nex_sessions: { session_mode: "explain" },
        }),
        row({
          id: "nex-openai",
          role: "nex",
          message_content: "d".repeat(400),
          metadata: { provider: "openai", validationPassed: true },
          nex_session_id: "session-2",
          created_at: "2026-06-21T05:51:00.000Z",
          nex_sessions: { session_mode: "explain" },
        }),
      ],
      pricing: {
        ...getNexOpsPricingConfig(),
        providerRates: {
          gemini: { inputUsdPerMillion: 1, outputUsdPerMillion: 2 },
          openai: { inputUsdPerMillion: 10, outputUsdPerMillion: 20 },
          mock: { inputUsdPerMillion: 0, outputUsdPerMillion: 0 },
          cache: { inputUsdPerMillion: 0, outputUsdPerMillion: 0 },
        },
      },
    });

    expect(snapshot.summary.messagesToday).toBe(1);
    expect(snapshot.summary.messages7d).toBe(2);
    expect(snapshot.summary.estimatedTokens7d).toBe(450);
    expect(snapshot.summary.fallbackRatePercent).toBe(50);
    expect(snapshot.summary.estimatedCostUsd).toBeCloseTo(0.003);
    expect(snapshot.summary.estimatedCostKes).toBeCloseTo(0.39);
    expect(snapshot.byProvider).toEqual([
      expect.objectContaining({
        provider: "OpenAI",
        messages: 1,
        estimatedTokens: 150,
        estimatedCostKes: 0.325,
      }),
      expect.objectContaining({
        provider: "Gemini",
        messages: 1,
        estimatedTokens: 300,
        estimatedCostKes: 0.065,
      }),
    ]);
    expect(snapshot.byMode).toEqual([
      { mode: "Explain", messages: 1 },
      { mode: "Practice", messages: 1 },
    ]);
  });

  it("keeps validation failures open until an ops review status is set", () => {
    const snapshot = buildNexOpsSnapshot({
      now: baseNow,
      messages: [
        row({
          id: "student-flagged",
          role: "student",
          message_content: "Solve x + 2 = 5",
          created_at: "2026-06-22T05:50:00.000Z",
        }),
        row({
          id: "nex-flagged",
          role: "nex",
          message_content: "x is 9",
          metadata: { provider: "gemini", validationPassed: false },
          created_at: "2026-06-22T05:51:00.000Z",
        }),
        row({
          id: "nex-resolved",
          role: "nex",
          message_content: "Resolved old issue",
          metadata: {
            provider: "gemini",
            validationPassed: false,
            opsReviewStatus: "resolved",
          },
          created_at: "2026-06-22T05:52:00.000Z",
        }),
      ],
    });

    expect(snapshot.flagged).toEqual([
      expect.objectContaining({
        messageId: "nex-flagged",
        status: "open",
        provider: "Gemini",
        promptPreview: "Solve x + 2 = 5",
        responsePreview: "x is 9",
      }),
      expect.objectContaining({
        messageId: "nex-resolved",
        status: "resolved",
      }),
    ]);
    expect(snapshot.summary.openFlaggedCount).toBe(1);
  });

  it("buckets cache-served explain responses as cache at zero cost, not gemini", () => {
    const snapshot = buildNexOpsSnapshot({
      now: baseNow,
      usdToKesRate: 130,
      messages: [
        row({
          id: "student-cache",
          role: "student",
          message_content: "e".repeat(400),
          created_at: "2026-06-22T05:50:00.000Z",
        }),
        row({
          id: "nex-cache",
          role: "nex",
          message_content: "f".repeat(800),
          metadata: { provider: "cache", validationPassed: true },
          created_at: "2026-06-22T05:51:00.000Z",
        }),
      ],
      pricing: {
        ...getNexOpsPricingConfig(),
        providerRates: {
          gemini: { inputUsdPerMillion: 1, outputUsdPerMillion: 2 },
          openai: { inputUsdPerMillion: 10, outputUsdPerMillion: 20 },
          mock: { inputUsdPerMillion: 0, outputUsdPerMillion: 0 },
          cache: { inputUsdPerMillion: 0, outputUsdPerMillion: 0 },
        },
      },
    });

    expect(snapshot.byProvider).toEqual([
      expect.objectContaining({
        provider: "Cache",
        providerKey: "cache",
        messages: 1,
        estimatedTokens: 300,
        estimatedCostUsd: 0,
        estimatedCostKes: 0,
      }),
    ]);
    expect(snapshot.summary.estimatedCostUsd).toBe(0);
  });
});
