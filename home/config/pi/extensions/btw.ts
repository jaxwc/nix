import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function btw(pi: ExtensionAPI) {
  pi.registerCommand("btw", {
    description: "Add a note while the agent is working",
    handler: async (args, ctx) => {
      const note = args.trim();
      if (!note) {
        ctx.ui.notify("Usage: /btw <note>", "warning");
        return;
      }

      if (ctx.isIdle()) {
        pi.sendUserMessage(note);
        return;
      }

      pi.sendUserMessage(note, { deliverAs: "steer" });
      ctx.ui.notify("Added note to the current run.", "info");
    },
  });
}
