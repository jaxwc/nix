import { spawn } from "node:child_process";
import type { ExtensionAPI, BashOperations, EditOperations, ReadOperations, WriteOperations } from "@earendil-works/pi-coding-agent";
import { createBashTool, createEditTool, createReadTool, createWriteTool } from "@earendil-works/pi-coding-agent";

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

function writeOps(remote: string, remoteCwd: string, localCwd: string): WriteOperations {
  const remotePath = (path: string) => path.startsWith(localCwd) ? remoteCwd + path.slice(localCwd.length) : path;
  return {
    writeFile: async (path, content) => {
      const encoded = Buffer.from(content).toString("base64");
      await ssh(remote, `printf %s ${JSON.stringify(encoded)} | base64 -d > ${JSON.stringify(remotePath(path))}`);
    },
    mkdir: (path) => ssh(remote, `mkdir -p ${JSON.stringify(remotePath(path))}`).then(() => undefined),
  };
}

function editOps(remote: string, remoteCwd: string, localCwd: string): EditOperations {
  const read = readOps(remote, remoteCwd, localCwd);
  const write = writeOps(remote, remoteCwd, localCwd);
  return { readFile: read.readFile, access: read.access, writeFile: write.writeFile };
}

function bashOps(remote: string, remoteCwd: string, localCwd: string, readOnly: boolean): BashOperations {
  const remotePath = (path: string) => path.startsWith(localCwd) ? remoteCwd + path.slice(localCwd.length) : path;
  return {
    exec: (command, cwd, { onData, signal, timeout }) => new Promise((resolve, reject) => {
      if (readOnly) {
        try { assertReadOnly(command); } catch (error) { reject(error); return; }
      }
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
  const localWrite = createWriteTool(localCwd);
  const localEdit = createEditTool(localCwd);
  const localBash = createBashTool(localCwd);
  let mode: "read-only" | "write" | undefined;
  let remoteCwd = "";
  let previousTools: string[] | undefined;

  pi.registerTool({
    ...localRead,
    async execute(id, params, signal, onUpdate) {
      if (!mode) return localRead.execute(id, params, signal, onUpdate);
      return createReadTool(localCwd, { operations: readOps(REMOTE, remoteCwd, localCwd) }).execute(id, params, signal, onUpdate);
    },
  });

  pi.registerTool({
    ...localWrite,
    async execute(id, params, signal, onUpdate) {
      if (mode !== "write") return localWrite.execute(id, params, signal, onUpdate);
      return createWriteTool(localCwd, { operations: writeOps(REMOTE, remoteCwd, localCwd) }).execute(id, params, signal, onUpdate);
    },
  });

  pi.registerTool({
    ...localEdit,
    async execute(id, params, signal, onUpdate) {
      if (mode !== "write") return localEdit.execute(id, params, signal, onUpdate);
      return createEditTool(localCwd, { operations: editOps(REMOTE, remoteCwd, localCwd) }).execute(id, params, signal, onUpdate);
    },
  });

  pi.registerTool({
    ...localBash,
    async execute(id, params, signal, onUpdate) {
      if (!mode) return localBash.execute(id, params, signal, onUpdate);
      return createBashTool(localCwd, { operations: bashOps(REMOTE, remoteCwd, localCwd, mode === "read-only") }).execute(id, params, signal, onUpdate);
    },
  });

  pi.registerCommand("server-connect", {
    description: `Connect read-only tools to ${REMOTE}`,
    handler: async (_args, ctx) => {
      if (mode) return ctx.ui.notify(`Already connected (${mode}) to ${REMOTE}:${remoteCwd}`, "info");
      try {
        remoteCwd = (await ssh(REMOTE, "pwd")).toString().trim();
        mode = "read-only";
        previousTools = pi.getActiveTools();
        pi.setActiveTools(previousTools.filter((name) => !["edit", "write", "ls", "find", "grep"].includes(name)));
        ctx.ui.setStatus("server-ssh", ctx.ui.theme.fg("accent", `SSH RO: ${REMOTE}`));
        ctx.ui.notify(`Connected read-only to ${REMOTE}:${remoteCwd}`, "info");
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
      }
    },
  });

  pi.registerCommand("server-connect-write", {
    description: `Connect read, write, edit, and bash tools to ${REMOTE}`,
    handler: async (_args, ctx) => {
      if (mode) return ctx.ui.notify(`Already connected (${mode}) to ${REMOTE}:${remoteCwd}`, "info");
      try {
        remoteCwd = (await ssh(REMOTE, "pwd")).toString().trim();
        mode = "write";
        previousTools = pi.getActiveTools();
        pi.setActiveTools(Array.from(new Set([...previousTools, "read", "write", "edit", "bash"])));
        ctx.ui.setStatus("server-ssh", ctx.ui.theme.fg("warning", `SSH RW: ${REMOTE}`));
        ctx.ui.notify(`Connected with write access to ${REMOTE}:${remoteCwd}`, "warning");
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
      }
    },
  });

  pi.registerCommand("server-disconnect", {
    description: "Disconnect SSH tools and restore local tools",
    handler: async (_args, ctx) => {
      mode = undefined;
      remoteCwd = "";
      if (previousTools) pi.setActiveTools(previousTools);
      previousTools = undefined;
      ctx.ui.setStatus("server-ssh", undefined);
      ctx.ui.notify(`Disconnected from ${REMOTE}; tools are local at ${localCwd}`, "info");
    },
  });

  pi.registerCommand("server-status", {
    description: "Show whether tools are local or connected over SSH",
    handler: async (_args, ctx) => {
      ctx.ui.notify(
        mode ? `SSH ${mode}: ${REMOTE}:${remoteCwd}` : `Local: ${localCwd}`,
        "info",
      );
    },
  });

  pi.on("user_bash", () => mode ? { operations: bashOps(REMOTE, remoteCwd, localCwd, mode === "read-only") } : undefined);

  pi.on("before_agent_start", (event) => {
    const modePrompt = mode === "read-only"
      ? `SERVER SSH MODE (authoritative current state): Connected read-only to ${REMOTE}. The working directory maps to ${remoteCwd}. read and bash operate remotely. edit/write and local discovery tools are disabled. sudo and mutating commands are prohibited. Clearly state that observations come from the remote server.`
      : mode === "write"
        ? `SERVER SSH MODE (authoritative current state): Connected with write access to ${REMOTE}. The working directory maps to ${remoteCwd}. read, write, edit, bash, and user shell commands operate remotely. Changes affect the remote server. Clearly state that operations are occurring on the remote server.`
        : `LOCAL MODE (authoritative current state): SSH is disconnected. All tools and paths operate on the local machine at ${localCwd}. Ignore any older conversation statements claiming SSH mode is active.`;
    return { systemPrompt: event.systemPrompt + `\n\n${modePrompt}` };
  });
}
