import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Key, matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";

interface WindowUsage { usedPercent: number; windowDurationMins: number; resetsAt: number }
interface Limit {
  limitId: string;
  limitName: string | null;
  primary: WindowUsage | null;
  secondary: WindowUsage | null;
  credits: { balance: string | null; unlimited: boolean } | null;
}
interface UsageResult {
  rateLimits: Limit;
  rateLimitsByLimitId?: Record<string, Limit>;
  rateLimitResetCredits?: { availableCount: number } | null;
}

interface RawWindow { used_percent: number; limit_window_seconds: number; reset_at: number }
interface RawLimit {
  primary_window?: RawWindow | null;
  secondary_window?: RawWindow | null;
}
interface RawUsage {
  rate_limit?: RawLimit | null;
  credits?: { balance?: string | null; unlimited: boolean } | null;
  additional_rate_limits?: Array<{
    metered_feature: string;
    limit_name: string;
    rate_limit?: RawLimit | null;
  }> | null;
  rate_limit_reset_credits?: { available_count: number } | null;
}

function mapWindow(window?: RawWindow | null): WindowUsage | null {
  return window ? {
    usedPercent: window.used_percent,
    windowDurationMins: window.limit_window_seconds / 60,
    resetsAt: window.reset_at,
  } : null;
}

function mapLimit(limitId: string, limitName: string | null, limit?: RawLimit | null, credits: Limit["credits"] = null): Limit {
  return {
    limitId,
    limitName,
    primary: mapWindow(limit?.primary_window),
    secondary: mapWindow(limit?.secondary_window),
    credits,
  };
}

async function getUsage(): Promise<UsageResult> {
  const agentDir = process.env.PI_CODING_AGENT_DIR ?? join(homedir(), ".pi", "agent");
  const auth = JSON.parse(await readFile(join(agentDir, "auth.json"), "utf8"))["openai-codex"];
  if (auth?.type !== "oauth" || !auth.access || !auth.accountId) {
    throw new Error("Log in to openai-codex with /login first");
  }

  const response = await fetch("https://chatgpt.com/backend-api/wham/usage", {
    headers: {
      Authorization: `Bearer ${auth.access}`,
      "ChatGPT-Account-Id": auth.accountId,
      "User-Agent": "pi-codex-usage",
    },
    signal: AbortSignal.timeout(15_000),
  });
  if (!response.ok) {
    if (response.status === 401) throw new Error("Codex login expired; use /login to refresh it");
    throw new Error(`Unable to read Codex usage (${response.status})`);
  }

  const raw = await response.json() as RawUsage;
  const credits = raw.credits ? {
    balance: raw.credits.balance ?? null,
    unlimited: raw.credits.unlimited,
  } : null;
  const primary = mapLimit("codex", null, raw.rate_limit, credits);
  const limits = [primary, ...(raw.additional_rate_limits ?? []).map((entry) =>
    mapLimit(entry.metered_feature, entry.limit_name, entry.rate_limit))];

  return {
    rateLimits: primary,
    rateLimitsByLimitId: Object.fromEntries(limits.map((limit) => [limit.limitId, limit])),
    rateLimitResetCredits: raw.rate_limit_reset_credits
      ? { availableCount: raw.rate_limit_reset_credits.available_count }
      : null,
  };
}

function pad(text: string, width: number): string {
  return text + " ".repeat(Math.max(0, width - visibleWidth(text)));
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("codex-usage", {
    description: "Show Codex plan usage and remaining credits",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("/codex-usage is available in interactive mode", "warning");
        return;
      }

      let usage: UsageResult;
      try {
        usage = await getUsage();
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
        return;
      }

      await ctx.ui.custom<void>((tui, theme, _keybindings, done) => ({
        render(width: number) {
          const inner = Math.max(20, width - 4);
          const limits = Object.values(usage.rateLimitsByLimitId ?? { [usage.rateLimits.limitId]: usage.rateLimits });
          const out: string[] = [];
          const line = (text = "") => out.push(truncateToWidth(text, width, ""));
          const rule = () => line(theme.fg("borderMuted", "─".repeat(inner)));

          line();
          line("  " + theme.fg("accent", theme.bold("Codex Usage")));
          line("  " + theme.fg("muted", "Your shared agentic usage limits"));
          line();

          for (const limit of limits) {
            const windows = [limit.primary, limit.secondary].filter((w): w is WindowUsage => Boolean(w));
            const title = limit.limitName || (windows[0]?.windowDurationMins === 10080 ? "Weekly usage limit" : "Codex");
            line("  " + theme.bold(title));
            if (!windows.length) line("  " + theme.fg("muted", "Usage unavailable"));
            for (const window of windows) {
              const remaining = Math.max(0, Math.min(100, 100 - Math.round(window.usedPercent)));
              const barWidth = Math.max(10, inner - 2);
              const filled = Math.round(barWidth * remaining / 100);
              line("  " + theme.fg("success", "█".repeat(filled)) + theme.fg("borderMuted", "░".repeat(barWidth - filled)));
              line("  " + theme.bold(`${remaining}%`) + " remaining");
              line("  " + theme.fg("muted", `Resets ${new Date(window.resetsAt * 1000).toLocaleString()}`));
            }
            line(); rule(); line();
          }

          const credits = usage.rateLimits.credits;
          line("  " + theme.bold("Credits remaining"));
          line("  " + theme.fg("accent", credits?.unlimited ? "Unlimited" : (credits?.balance ?? "Unavailable")));
          const resetCount = usage.rateLimitResetCredits?.availableCount;
          if (resetCount != null) line("  " + theme.fg("muted", `Free full resets available: ${resetCount}`));
          line();
          line("  " + theme.fg("dim", "esc or q to close  •  data provided by Codex CLI"));
          return out.map((value) => pad(value, Math.min(width, Math.max(0, width))));
        },
        invalidate() {},
        handleInput(data: string) {
          if (matchesKey(data, Key.escape) || data === "q" || matchesKey(data, Key.enter)) done();
          tui.requestRender();
        },
      }));
    },
  });
}
