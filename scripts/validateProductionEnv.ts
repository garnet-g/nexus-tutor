#!/usr/bin/env tsx
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

import { validateEnvironment } from "../src/lib/env/validateEnv";

function loadLocalEnvFiles(): void {
  for (const filename of [".env.local", ".env"]) {
    const filePath = join(process.cwd(), filename);
    if (!existsSync(filePath)) continue;

    for (const line of readFileSync(filePath, "utf8").split("\n")) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith("#")) continue;

      const separator = trimmed.indexOf("=");
      if (separator === -1) continue;

      const key = trimmed.slice(0, separator).trim();
      let value = trimmed.slice(separator + 1).trim();
      if (
        (value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))
      ) {
        value = value.slice(1, -1);
      }

      if (process.env[key] === undefined) {
        process.env[key] = value;
      }
    }
  }
}

loadLocalEnvFiles();
const result = validateEnvironment();
if (!result.ok) {
  for (const error of result.errors) {
    console.error(`env:check failed: ${error}`);
  }
  process.exit(1);
}

console.log("env:check passed");
