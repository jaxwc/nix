const SIMPLE_READ_COMMANDS = new Set([
  "cat",
  "date",
  "df",
  "du",
  "eza",
  "file",
  "grep",
  "head",
  "id",
  "jq",
  "ls",
  "pwd",
  "stat",
  "tail",
  "type",
  "uname",
  "uptime",
  "wc",
  "which",
  "whoami",
]);

const SHELL_CONTROL_PATTERN = /[\n\r;&|><`]/;
const SHELL_SUBSTITUTION_PATTERN = /\$\(|\$\{/;

export interface CommandValidation {
  safe: boolean;
  reason?: string;
}

function blocked(reason: string): CommandValidation {
  return { safe: false, reason };
}

function validateGit(args: string[]): CommandValidation {
  const [subcommand, ...rest] = args;
  if (!subcommand) return blocked("git requires a read-only subcommand");

  if (rest.some((arg) => arg === "--output" || arg.startsWith("--output="))) {
    return blocked("git output files are not allowed in plan mode");
  }
  if (rest.some((arg) => arg === "--ext-diff" || arg === "--textconv")) {
    return blocked("external git helpers are not allowed in plan mode");
  }

  if (["status", "log", "diff", "show", "ls-files", "ls-tree"].includes(subcommand)) {
    return { safe: true };
  }

  if (subcommand === "config" && rest[0] === "--get" && rest.length >= 2) {
    return { safe: true };
  }

  if (subcommand === "branch") {
    const mutationFlag = rest.some((arg) =>
      ["-d", "-D", "-m", "-M", "-c", "-C", "--delete", "--move", "--copy"].includes(arg),
    );
    const createsBranch = rest.some((arg) => !arg.startsWith("-"));
    if (!mutationFlag && !createsBranch) return { safe: true };
  }

  if (subcommand === "remote") {
    if (rest.length === 0 || (rest.length === 1 && rest[0] === "-v")) {
      return { safe: true };
    }
    if (rest[0] === "show" && rest.length === 2) return { safe: true };
  }

  return blocked(`git ${subcommand} is not an approved read-only operation`);
}

export function validatePlanCommand(command: string): CommandValidation {
  const trimmed = command.trim();
  if (!trimmed) return blocked("empty commands are not allowed");
  if (SHELL_CONTROL_PATTERN.test(trimmed)) {
    return blocked("shell chaining, pipes, redirects, and background jobs are disabled");
  }
  if (SHELL_SUBSTITUTION_PATTERN.test(trimmed)) {
    return blocked("shell command substitution is disabled");
  }

  const tokens = trimmed.split(/\s+/);
  const executable = tokens[0];
  const args = tokens.slice(1);
  if (!executable || !/^[a-zA-Z0-9_.-]+$/.test(executable)) {
    return blocked("the command must start with an approved executable");
  }

  if (SIMPLE_READ_COMMANDS.has(executable)) return { safe: true };

  if (executable === "rg") {
    if (args.some((arg) => arg === "--pre" || arg.startsWith("--pre="))) {
      return blocked("rg preprocessors can execute commands");
    }
    return { safe: true };
  }

  if (executable === "fd") {
    if (args.some((arg) => ["-x", "-X", "--exec", "--exec-batch"].includes(arg))) {
      return blocked("fd execution options are disabled");
    }
    return { safe: true };
  }

  if (executable === "find") {
    const unsafeFindOptions = new Set([
      "-delete",
      "-exec",
      "-execdir",
      "-ok",
      "-okdir",
      "-fprint",
      "-fprint0",
      "-fprintf",
    ]);
    if (args.some((arg) => unsafeFindOptions.has(arg))) {
      return blocked("find mutation and execution options are disabled");
    }
    return { safe: true };
  }

  if (executable === "git") return validateGit(args);

  if (["npm", "pnpm", "yarn"].includes(executable)) {
    const subcommand = args[0];
    if (["list", "ls", "view", "info", "outdated", "why"].includes(subcommand ?? "")) {
      return { safe: true };
    }
    if (subcommand === "audit" && !args.includes("--fix")) return { safe: true };
    return blocked(`${executable} is limited to package-information commands`);
  }

  return blocked(`${executable} is not approved in plan mode`);
}
