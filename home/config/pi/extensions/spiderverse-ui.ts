import { homedir } from "node:os";
import { relative } from "node:path";
import type { AssistantMessage } from "@earendil-works/pi-ai";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const LIVE_UPDATE_INTERVAL_MS = 750;
const GIT_REFRESH_DEBOUNCE_MS = 300;
const ESTIMATED_CHARS_PER_TOKEN = 4;

function formatDirectory(cwd: string) {
  const home = homedir();
  if (cwd === home) return "~";
  if (cwd.startsWith(`${home}/`)) return `~/${relative(home, cwd)}`;
  return cwd;
}

function formatTokens(tokens: number) {
  if (tokens < 1_000) return `${tokens}`;
  if (tokens < 1_000_000) return `${Math.round(tokens / 1_000)}k`;
  return `${(tokens / 1_000_000).toFixed(1)}m`;
}

type Rgb = [number, number, number];

const RESET = "\x1b[0m";
const BOLD = "\x1b[1m";
const SPIDERVERSE_PALETTE: Rgb[] = [
  [255, 45, 163],
  [160, 68, 255],
  [72, 118, 255],
  [72, 224, 255],
  [72, 118, 255],
  [160, 68, 255],
];
const PI_LOGO = [
  "  ██████╗  ██╗ ",
  "  ██╔══██╗ ██║ ",
  "  ██████╔╝ ██║ ",
  "  ██╔═══╝  ██║ ",
  "  ██║      ██║ ",
  "  ╚═╝      ╚═╝ ",
];

function mix(start: number, end: number, amount: number) {
  return Math.round(start + (end - start) * amount);
}

function sampleGradient(position: number): Rgb {
  const wrapped = ((position % 1) + 1) % 1;
  const scaled = wrapped * SPIDERVERSE_PALETTE.length;
  const index = Math.floor(scaled);
  const nextIndex = (index + 1) % SPIDERVERSE_PALETTE.length;
  const amount = scaled - index;
  const start = SPIDERVERSE_PALETTE[index]!;
  const end = SPIDERVERSE_PALETTE[nextIndex]!;
  return [
    mix(start[0], end[0], amount),
    mix(start[1], end[1], amount),
    mix(start[2], end[2], amount),
  ];
}

function gradientText(text: string, phase: number) {
  const characters = [...text];
  const span = Math.max(characters.length - 1, 1);
  return characters
    .map((character, index) => {
      if (character === " ") return character;
      const [red, green, blue] = sampleGradient(index / span + phase);
      return `\x1b[38;2;${red};${green};${blue}m${character}${RESET}`;
    })
    .join("");
}

function center(text: string, width: number) {
  const padding = Math.max(0, Math.floor((width - visibleWidth(text)) / 2));
  return truncateToWidth(`${" ".repeat(padding)}${text}`, width, "");
}

function spiderverseHeader(width: number, cwd: string) {
  const logo = PI_LOGO.map((line, row) =>
    center(gradientText(line, row * 0.045), width),
  );
  const directory = center(
    `${BOLD}${gradientText(formatDirectory(cwd), 0.18)}${RESET}`,
    width,
  );
  return ["", ...logo, directory, ""];
}

function sessionCost(ctx: ExtensionContext) {
  return ctx.sessionManager.getBranch().reduce((total, entry) => {
    if (entry.type !== "message" || entry.message.role !== "assistant") {
      return total;
    }
    return total + (entry.message as AssistantMessage).usage.cost.total;
  }, 0);
}

function columns(left: string, right: string, width: number) {
  if (!right) return truncateToWidth(left, width);

  const gap = width - visibleWidth(left) - visibleWidth(right);
  if (gap >= 1) return `${left}${" ".repeat(gap)}${right}`;

  const leftWidth = Math.max(1, Math.floor(width * 0.45));
  const rightWidth = Math.max(1, width - leftWidth - 1);
  const fittedLeft = truncateToWidth(left, leftWidth);
  const fittedRight = truncateToWidth(right, rightWidth);
  const fittedGap = Math.max(
    1,
    width - visibleWidth(fittedLeft) - visibleWidth(fittedRight),
  );
  return truncateToWidth(
    `${fittedLeft}${" ".repeat(fittedGap)}${fittedRight}`,
    width,
  );
}

export default function spiderverseUi(pi: ExtensionAPI) {
  let changedFiles: number | null = null;
  let tokensPerSecond: number | null = null;
  let streamStartedAt: number | null = null;
  let streamedCharacters = 0;
  let lastLiveUpdate = 0;
  let requestRender: (() => void) | undefined;
  let currentContext: ExtensionContext | undefined;
  let refreshRunning = false;
  let refreshQueued = false;
  let refreshTimer: ReturnType<typeof setTimeout> | undefined;
  let cachedSessionCost = 0;

  const render = () => requestRender?.();

  async function refreshGit(ctx: ExtensionContext) {
    currentContext = ctx;
    if (refreshRunning) {
      refreshQueued = true;
      return;
    }

    refreshRunning = true;
    try {
      const result = await pi.exec(
        "git",
        ["status", "--porcelain=v1", "--untracked-files=normal"],
        { timeout: 3_000 },
      );
      changedFiles =
        result.code === 0
          ? result.stdout.split("\n").filter((line) => line.length > 0).length
          : null;
      render();
    } finally {
      refreshRunning = false;
      if (refreshQueued) {
        refreshQueued = false;
        if (currentContext) void refreshGit(currentContext);
      }
    }
  }

  function scheduleGitRefresh(ctx: ExtensionContext) {
    currentContext = ctx;
    if (refreshTimer) clearTimeout(refreshTimer);
    refreshTimer = setTimeout(() => {
      refreshTimer = undefined;
      void refreshGit(ctx);
    }, GIT_REFRESH_DEBOUNCE_MS);
  }

  function refreshSessionCost(ctx: ExtensionContext) {
    cachedSessionCost = sessionCost(ctx);
  }

  pi.on("session_start", (_event, ctx) => {
    currentContext = ctx;
    changedFiles = null;
    tokensPerSecond = null;
    refreshSessionCost(ctx);
    scheduleGitRefresh(ctx);

    if (ctx.mode !== "tui") return;

    ctx.ui.setTitle(`pi · ${formatDirectory(ctx.cwd)}`);
    ctx.ui.setHeader((_tui, _theme) => ({
      render: (width: number) => spiderverseHeader(width, ctx.cwd),
      invalidate() {},
    }));
    ctx.ui.setFooter((tui, theme, footerData) => {
      requestRender = () => tui.requestRender();
      const unsubscribeBranch = footerData.onBranchChange(() => {
        refreshSessionCost(ctx);
        tui.requestRender();
        scheduleGitRefresh(ctx);
      });

      return {
        dispose: unsubscribeBranch,
        invalidate() {},
        render(width: number) {
          const separator = theme.fg("dim", " · ");
          const thinkingLevel = pi.getThinkingLevel();
          const thinking = theme.fg(
            thinkingLevel === "off"
              ? "thinkingOff"
              : thinkingLevel === "minimal"
                ? "thinkingMinimal"
                : thinkingLevel === "low"
                  ? "thinkingLow"
                  : thinkingLevel === "medium"
                    ? "thinkingMedium"
                    : thinkingLevel === "high"
                      ? "thinkingHigh"
                      : thinkingLevel === "max"
                        ? "thinkingMax"
                        : "thinkingXhigh",
            thinkingLevel,
          );
          const model = ctx.model
            ? theme.fg("muted", `${ctx.model.provider}/`) +
              theme.fg("accent", ctx.model.id) +
              separator +
              thinking
            : theme.fg("warning", "no model");

          const usage = ctx.getContextUsage();
          const percent =
            usage?.percent == null ? "?" : `${Math.round(usage.percent)}`;
          const contextWindow = usage?.contextWindow ?? ctx.model?.contextWindow;
          const context = theme.fg(
            "mdLink",
            `${percent}%/${contextWindow ? formatTokens(contextWindow) : "?"}`,
          );
          const cost = theme.fg("success", `$${cachedSessionCost.toFixed(2)}`);
          const speed = theme.fg(
            "syntaxFunction",
            tokensPerSecond == null
              ? "— tok/s"
              : `${Math.round(tokensPerSecond)} tok/s`,
          );
          const stats = context + separator + cost + separator + speed;

          const branch = footerData.getGitBranch();
          let git = "";
          if (branch) {
            git = theme.fg("syntaxType", branch);
            if (changedFiles === 0) {
              git += separator + theme.fg("success", "clean");
            } else if (changedFiles != null) {
              git +=
                separator +
                theme.fg(
                  "warning",
                  `${changedFiles} ${changedFiles === 1 ? "file" : "files"} changed`,
                );
            }
          }

          const lines = [
            columns(theme.fg("mdLink", formatDirectory(ctx.cwd)), model, width),
            columns(stats, git, width),
          ];

          for (const status of footerData.getExtensionStatuses().values()) {
            for (const line of status.split("\n")) {
              lines.push(truncateToWidth(line, width, theme.fg("dim", "...")));
            }
          }

          return lines;
        },
      };
    });
  });

  pi.on("agent_start", () => {
    tokensPerSecond = null;
    streamStartedAt = null;
    streamedCharacters = 0;
    lastLiveUpdate = 0;
    render();
  });

  pi.on("message_update", (event) => {
    if (event.message.role !== "assistant") return;
    const update = event.assistantMessageEvent;
    if (update.type !== "text_delta" && update.type !== "thinking_delta")
      return;
    if (!update.delta) return;

    const now = Date.now();
    streamStartedAt ??= now;
    streamedCharacters += update.delta.length;
    const elapsedMs = now - streamStartedAt;

    if (elapsedMs > 0 && now - lastLiveUpdate >= LIVE_UPDATE_INTERVAL_MS) {
      tokensPerSecond =
        streamedCharacters / ESTIMATED_CHARS_PER_TOKEN / (elapsedMs / 1_000);
      lastLiveUpdate = now;
      render();
    }
  });

  pi.on("agent_settled", (_event, ctx) => {
    refreshSessionCost(ctx);
    scheduleGitRefresh(ctx);
    tokensPerSecond = null;
    render();
  });

  pi.on("session_shutdown", (_event, ctx) => {
    currentContext = undefined;
    requestRender = undefined;
    if (refreshTimer) clearTimeout(refreshTimer);
    refreshTimer = undefined;
    if (ctx.mode === "tui") {
      ctx.ui.setHeader(undefined);
      ctx.ui.setFooter(undefined);
    }
  });
}
