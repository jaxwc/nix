import {
  copyToClipboard,
  type ExtensionAPI,
  type SessionEntry,
} from "@earendil-works/pi-coding-agent";

function contentToText(content: unknown): string {
  if (typeof content === "string") return content.trim();
  if (!Array.isArray(content)) return "";

  return content
    .map((block) => {
      if (!block || typeof block !== "object") return "";
      if ("type" in block && block.type === "text" && "text" in block) {
        return typeof block.text === "string" ? block.text : "";
      }
      if ("type" in block && block.type === "image") return "[Image omitted]";
      return "";
    })
    .filter(Boolean)
    .join("\n")
    .trim();
}

function serializeChat(entries: SessionEntry[]): string {
  const messages: string[] = [];

  for (const entry of entries) {
    if (entry.type !== "message") continue;
    if (entry.message.role !== "user" && entry.message.role !== "assistant") {
      continue;
    }

    const text = contentToText(entry.message.content);
    if (!text) continue;

    const label = entry.message.role === "user" ? "User" : "Assistant";
    messages.push(`## ${label}\n\n${text}`);
  }

  return messages.join("\n\n");
}

export default function copyAll(pi: ExtensionAPI) {
  pi.registerCommand("copy-all", {
    description: "Copy the whole chat transcript",
    handler: async (_args, ctx) => {
      const transcript = serializeChat(ctx.sessionManager.getBranch());
      if (!transcript) {
        ctx.ui.notify("No user or assistant messages to copy yet.", "warning");
        return;
      }

      try {
        await copyToClipboard(transcript);
        const messageCount = ctx.sessionManager
          .getBranch()
          .filter(
            (entry) =>
              entry.type === "message" &&
              (entry.message.role === "user" || entry.message.role === "assistant"),
          ).length;
        ctx.ui.notify(
          `Copied ${messageCount} chat messages to the clipboard.`,
          "info",
        );
      } catch (error) {
        ctx.ui.notify(
          `Could not copy chat: ${error instanceof Error ? error.message : String(error)}`,
          "error",
        );
      }
    },
  });
}
