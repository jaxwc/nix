import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { validatePlanCommand } from "./utils.ts";

const PLAN_TOOLS = new Set(["read", "grep", "find", "ls", "bash"]);
const STATE_TYPE = "plan-mode-state";

interface PlanModeState {
  enabled: boolean;
  toolsBeforePlanMode?: string[];
}

export default function planMode(pi: ExtensionAPI) {
  let enabled = false;
  let toolsBeforePlanMode: string[] | undefined;

  pi.registerFlag("plan", {
    description: "Start in read-only plan mode",
    type: "boolean",
    default: false,
  });

  function availableToolNames(): Set<string> {
    return new Set(pi.getAllTools().map((tool) => tool.name));
  }

  function applyPlanTools(): void {
    const available = availableToolNames();
    pi.setActiveTools(
      [...PLAN_TOOLS].filter((name) => available.has(name)),
    );
  }

  function restoreTools(): void {
    if (!toolsBeforePlanMode) return;
    const available = availableToolNames();
    pi.setActiveTools(
      toolsBeforePlanMode.filter((name) => available.has(name)),
    );
    toolsBeforePlanMode = undefined;
  }

  function updateStatus(ctx: ExtensionContext): void {
    ctx.ui.setStatus(
      "plan-mode",
      enabled ? ctx.ui.theme.fg("warning", "PLAN") : undefined,
    );
  }

  function persistState(): void {
    pi.appendEntry(STATE_TYPE, {
      enabled,
      toolsBeforePlanMode,
    } satisfies PlanModeState);
  }

  function enterPlanMode(ctx: ExtensionContext): void {
    if (!enabled) {
      toolsBeforePlanMode = pi.getActiveTools();
      enabled = true;
      applyPlanTools();
      persistState();
      updateStatus(ctx);
      ctx.ui.notify(
        "Plan mode enabled. Tools are restricted to read-only exploration.",
        "info",
      );
      return;
    }

    applyPlanTools();
    updateStatus(ctx);
    ctx.ui.notify("Plan mode is already enabled.", "info");
  }

  function enterBuildMode(ctx: ExtensionContext): void {
    if (!enabled) {
      ctx.ui.notify("Build mode is already active.", "info");
      return;
    }

    enabled = false;
    restoreTools();
    persistState();
    updateStatus(ctx);
    ctx.ui.notify("Build mode enabled. Previous tools restored.", "info");
  }

  pi.registerCommand("plan", {
    description: "Enter read-only planning mode",
    handler: async (args, ctx) => {
      enterPlanMode(ctx);
      const prompt = args.trim();
      if (prompt) pi.sendUserMessage(prompt);
    },
  });

  pi.registerCommand("build", {
    description: "Leave plan mode and restore editing tools",
    handler: async (args, ctx) => {
      enterBuildMode(ctx);
      const prompt = args.trim();
      if (prompt) pi.sendUserMessage(prompt);
    },
  });

  pi.on("tool_call", async (event) => {
    if (!enabled) return;

    if (!PLAN_TOOLS.has(event.toolName)) {
      return {
        block: true,
        reason: `Plan mode blocks the '${event.toolName}' tool. Use /build to restore normal tools.`,
      };
    }

    if (event.toolName === "bash") {
      const input = event.input as { command?: unknown };
      const command = typeof input.command === "string" ? input.command : "";
      const validation = validatePlanCommand(command);
      if (!validation.safe) {
        return {
          block: true,
          reason: `Plan mode blocked this command: ${validation.reason ?? "not read-only"}. Use /build before making changes.`,
        };
      }
    }
  });

  pi.on("before_agent_start", async (event) => {
    if (!enabled) return;

    return {
      systemPrompt: `${event.systemPrompt}\n\n[PLAN MODE ACTIVE]\nYou are in a read-only planning mode. Investigate the project thoroughly before proposing changes. You may read files, search the project, list paths, and run only approved read-only shell commands. Do not edit files, write files, install packages, change Git state, or otherwise mutate the environment. Ask concise clarifying questions when requirements are ambiguous. Your final response should be an actionable numbered plan that identifies relevant files, key implementation decisions, safety concerns, and validation steps. Do not implement the plan. Tell the user to use /build when they are ready to proceed.`,
    };
  });

  pi.on("session_start", async (_event, ctx) => {
    const saved = ctx.sessionManager
      .getEntries()
      .filter(
        (entry) => entry.type === "custom" && entry.customType === STATE_TYPE,
      )
      .at(-1) as { data?: PlanModeState } | undefined;

    if (saved?.data) {
      enabled = saved.data.enabled === true;
      toolsBeforePlanMode = saved.data.toolsBeforePlanMode;
    }

    const enabledByFlag = pi.getFlag("plan") === true;
    if (enabledByFlag) enabled = true;

    if (enabled) {
      toolsBeforePlanMode ??= pi.getActiveTools();
      applyPlanTools();
      if (enabledByFlag && saved?.data?.enabled !== true) persistState();
    }
    updateStatus(ctx);
  });
}
