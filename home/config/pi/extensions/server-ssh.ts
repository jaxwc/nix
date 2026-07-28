import { spawn } from "node:child_process";
import type { ExtensionAPI, BashOperations, ReadOperations } from "@earendil-works/pi-coding-agent";
import { createBashTool, createReadTool } from "@earendil-works/pi-coding-agent";

const REMOTE = "jackson@intersect";

function ssh(remote: string, command: string, signal?: AbortSignal): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const child = spawn("ssh", ["-o", "BatchMode=yes", remote, command], {
      stdio: ["ignore", "pipe", "pipe"],
    });
    const stdout: Buffer[] = [];
    const stderr: Buffer[] = [];
    child.stdout.on("data", (chunk) => stdout.push(chunk));
    child.stderr.on("data", (chunk) => stderr.push(chunk));
    const abort = () => child.kill();
    signal?.addEventListener("abort", abort, { once: true });
    child.on("error", reject);
    child.on("close", (code) => {
      signal?.removeEventListener("abort", abort);
      if (signal?.aborted) return reject(new Error("SSH command aborted"));
      if (code !== 0) {
        return reject(new Error(`SSH failed (${code}): ${Buffer.concat(stderr).toString().trim()}`));
      }
      resolve(Buffer.concat(stdout));
    });
  });
}

function assertReadOnly(command: string): void {
  if (/\bsudo\b/i.test(command)) throw new Error("sudo is disabled in server read-only mode");
  if (/[;&|><`\n\r]/.test(command) || /\$\s*\(/.test(command)) {
    throw new Error("Shell operators, redirection, substitutions, and pipelines are disabled in server read-only mode");
  }

  const first = command.trim().match(/^(?:[A-Za-z_][A-Za-z0-9_]*=[^\s]+\s+)*([^\s]+)/)?.[1] ?? "";
  const executable = first.split("/").pop() ?? "";
  const allowed = new Set([
    "awk", "cat", "df", "dmesg", "docker", "du", "env", "file", "find", "free",
    "git", "grep", "head", "hostname", "id", "ip", "journalctl", "ls", "lsblk",
    "lscpu", "lsof", "nixos-version", "nix-store", "podman", "printenv", "ps", "pwd",
    "readlink", "realpath", "sed", "ss", "stat", "systemctl", "tail", "tr", "uname",
    "uptime", "wc", "who", "whoami",
  ]);
  if (!allowed.has(executable)) throw new Error(`Command '${executable || command}' is not allowed in server read-only mode`);

  if (executable === "systemctl" && /\b(start|stop|restart|reload|enable|disable|mask|unmask|edit|set-property)\b/i.test(command)) {
    throw new Error("Mutating systemctl operations are disabled");
  }
  if (/^(docker|podman)$/.test(executable) && !/^\s*(docker|podman)\s+(ps|inspect|logs|stats|images|info|version)\b/.test(command)) {
    throw new Error(`Only read-only ${executable} operations are enabled`);
  }
  if (executable === "find" && /-(delete|exec|execdir|ok|okdir)\b/.test(command)) {
    throw new Error("Mutating find operations are disabled");
  }
  if (executable === "git" && !/^\s*git\s+(status|log|diff|show|branch|remote|rev-parse|describe)\b/.test(command)) {
    throw new Error("Only read-only git operations are enabled");
  }
}

function readOps(remote: string, remoteCwd: string, localCwd: string): ReadOperations {
  const remotePath = (path: string) => path.startsWith(localCwd) ? remoteCwd + path.slice(localCwd.length) : path;
  return {
    readFile: (path) => ssh(remote, `cat ${JSON.stringify(remotePath(path))}`),
    access: (path) => ssh(remote, `test -r ${JSON.stringify(remotePath(path))}`).then(() => undefined),
    detectImageMimeType: async (path) => {
      try {
        const mime = (await ssh(remote, `file --mime-type -b ${JSON.stringify(remotePath(path))}`)).toString().trim();
        return ["image/jpeg", "image/png", "image/gif", "image/webp"].includes(mime) ? mime : null;
      } catch { return null; }
    },
  };
}

function bashOps(remote: string, remoteCwd: string, localCwd: string): BashOperations {
  const remotePath = (path: string) => path.startsWith(localCwd) ? remoteCwd + path.slice(localCwd.length) : path;
  return {
    exec: (command, cwd, { onData, signal, timeout }) => new Promise((resolve, reject) => {
      try { assertReadOnly(command); } catch (error) { reject(error); return; }
      const child = spawn("ssh", ["-o", "BatchMode=yes", remote, `cd ${JSON.stringify(remotePath(cwd))} && ${command}`], {
        stdio: ["ignore", "pipe", "pipe"],
      });
      let timedOut = false;
      const timer = timeout ? setTimeout(() => { timedOut = true; child.kill(); }, timeout * 1000) : undefined;
      child.stdout.on("data", onData);
      child.stderr.on("data", onData);
      const abort = () => child.kill();
      signal?.addEventListener("abort", abort, { once: true });
      child.on("error", reject);
      child.on("close", (code) => {
        if (timer) clearTimeout(timer);
        signal?.removeEventListener("abort", abort);
        if (signal?.aborted) reject(new Error("aborted"));
        else if (timedOut) reject(new Error(`timeout:${timeout}`));
        else resolve({ exitCode: code });
      });
    }),
  };
}

export default function (pi: ExtensionAPI) {
  const localCwd = process.cwd();
  const localRead = createReadTool(localCwd);
  const localBash = createBashTool(localCwd);
  let connected = false;
  let remoteCwd = "";
  let previousTools: string[] | undefined;

  pi.registerTool({
    ...localRead,
    async execute(id, params, signal, onUpdate) {
      if (!connected) return localRead.execute(id, params, signal, onUpdate);
      return createReadTool(localCwd, { operations: readOps(REMOTE, remoteCwd, localCwd) }).execute(id, params, signal, onUpdate);
    },
  });

  pi.registerTool({
    ...localBash,
    async execute(id, params, signal, onUpdate) {
      if (!connected) return localBash.execute(id, params, signal, onUpdate);
      return createBashTool(localCwd, { operations: bashOps(REMOTE, remoteCwd, localCwd) }).execute(id, params, signal, onUpdate);
    },
  });

  pi.registerCommand("server-connect", {
    description: `Connect read-only tools to ${REMOTE}`,
    handler: async (_args, ctx) => {
      if (connected) return ctx.ui.notify(`Already connected to ${REMOTE}:${remoteCwd}`, "info");
      try {
        remoteCwd = (await ssh(REMOTE, "pwd")).toString().trim();
        connected = true;
        previousTools = pi.getActiveTools();
        pi.setActiveTools(previousTools.filter((name) => !["edit", "write", "ls", "find", "grep"].includes(name)));
        ctx.ui.setStatus("server-ssh", ctx.ui.theme.fg("accent", `SSH RO: ${REMOTE}`));
        ctx.ui.notify(`Connected read-only to ${REMOTE}:${remoteCwd}`, "info");
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
      }
    },
  });

  pi.registerCommand("server-disconnect", {
    description: "Disconnect SSH tools and restore local tools",
    handler: async (_args, ctx) => {
      connected = false;
      remoteCwd = "";
      if (previousTools) pi.setActiveTools(previousTools);
      previousTools = undefined;
      ctx.ui.setStatus("server-ssh", undefined);
      ctx.ui.notify(`Disconnected from ${REMOTE}; read and bash are local at ${localCwd}`, "info");
    },
  });

  pi.registerCommand("server-status", {
    description: "Show whether tools are local or connected over SSH",
    handler: async (_args, ctx) => {
      ctx.ui.notify(
        connected ? `SSH read-only: ${REMOTE}:${remoteCwd}` : `Local: ${localCwd}`,
        "info",
      );
    },
  });

  pi.on("user_bash", () => connected ? { operations: bashOps(REMOTE, remoteCwd, localCwd) } : undefined);

  pi.on("before_agent_start", (event) => {
    const mode = connected
      ? `SERVER SSH MODE (authoritative current state): Connected read-only to ${REMOTE}. The working directory maps to ${remoteCwd}. read and bash operate remotely. edit/write and local discovery tools are disabled. sudo and mutating commands are prohibited. Clearly state that observations come from the remote server.`
      : `LOCAL MODE (authoritative current state): SSH is disconnected. All tools and paths operate on the local machine at ${localCwd}. Ignore any older conversation statements claiming SSH mode is active.`;
    return { systemPrompt: event.systemPrompt + `\n\n${mode}` };
  });
}
