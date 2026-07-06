#!/usr/bin/env tsx
/**
 * PR-135: DB-driven topic coverage matrix.
 * Exits non-zero when any active topic is labeled PROD_READY without meeting DEC-002 thresholds.
 */
import { findUnderTargetProdReadyTopics, loadTopicCoverageMatrix } from "../src/server/services/topicCoverageMatrixService";

async function main() {
  const rows = await loadTopicCoverageMatrix();
  const prodReady = rows.filter((row) => row.readinessLabel === "PROD_READY");
  const underTarget = findUnderTargetProdReadyTopics(rows);

  console.log(`Topic coverage matrix: ${rows.length} active topics`);
  console.log(`PROD_READY topics: ${prodReady.length}`);

  if (underTarget.length > 0) {
    console.error("Under-target PROD_READY topics:");
    for (const row of underTarget) {
      console.error(
        `- ${row.curriculumCode}/${row.subjectCode}/${row.topicTitle} (${row.topicId})`,
      );
    }
    process.exit(1);
  }

  console.log("Coverage matrix passed.");
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
