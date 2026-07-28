import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";
import { Type, type Static } from "typebox";

const optionSchema = Type.Object({
  label: Type.String({ description: "Short display label for this option" }),
  description: Type.Optional(
    Type.String({ description: "Optional one-line explanation" }),
  ),
});

const askUserParameters = Type.Object({
  question: Type.String({ description: "The single question to ask" }),
  options: Type.Array(optionSchema, {
    minItems: 2,
    maxItems: 5,
    description:
      "Two to five choices. Do not add an Other/custom option; one is provided automatically.",
  }),
});

export type AskUserInput = Static<typeof askUserParameters>;

type AskUserDetails = {
  question: string;
  options: string[];
  answer: string | null;
  selectedIndex: number | null;
  custom: boolean;
  dismissed: boolean;
};

export default function askUser(pi: ExtensionAPI) {
  pi.registerTool({
    name: "ask_user",
    label: "Ask User",
    description:
      "Ask the user one multiple-choice question with 2-5 choices. The user can instead write a custom answer or dismiss the question.",
    promptSnippet:
      "Ask the user one multiple-choice question with an optional free-form answer",
    promptGuidelines: [
      "Use ask_user when a question has a small, enumerable set of likely answers instead of asking it in plain text.",
      "Ask exactly one question per ask_user call; use subsequent calls for follow-up questions.",
    ],
    parameters: askUserParameters,

    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      const details = (
        answer: string | null,
        selectedIndex: number | null,
        custom: boolean,
      ): AskUserDetails => ({
        question: params.question,
        options: params.options.map((option) => option.label),
        answer,
        selectedIndex,
        custom,
        dismissed: answer === null,
      });

      if (ctx.mode !== "tui") {
        return {
          content: [
            {
              type: "text" as const,
              text: "No interactive TUI is available. Ask the user in plain text instead.",
            },
          ],
          details: details(null, null, false),
        };
      }

      if (signal?.aborted) {
        return {
          content: [{ type: "text" as const, text: "Cancelled" }],
          details: details(null, null, false),
        };
      }

      const choices = params.options.map((option, index) => {
        const description = option.description ? ` — ${option.description}` : "";
        return `${index + 1}. ${option.label}${description}`;
      });
      const customChoice = "Write my own answer…";
      const choice = await ctx.ui.select(params.question, [...choices, customChoice], {
        signal,
      });

      if (choice === undefined) {
        return {
          content: [
            {
              type: "text" as const,
              text: "User dismissed the question without answering. Do not assume an answer.",
            },
          ],
          details: details(null, null, false),
        };
      }

      if (choice === customChoice) {
        const answer = (await ctx.ui.input("Your answer:", "Type your answer", {
          signal,
        }))?.trim();
        if (!answer) {
          return {
            content: [
              {
                type: "text" as const,
                text: "User dismissed the question without answering. Do not assume an answer.",
              },
            ],
            details: details(null, null, false),
          };
        }
        return {
          content: [
            { type: "text" as const, text: `User wrote their own answer: ${answer}` },
          ],
          details: details(answer, null, true),
        };
      }

      const selectedIndex = choices.indexOf(choice);
      const answer = params.options[selectedIndex]?.label;
      if (selectedIndex < 0 || answer === undefined) {
        throw new Error("ask_user received an unknown selection");
      }

      return {
        content: [
          {
            type: "text" as const,
            text: `User selected option ${selectedIndex + 1}: ${answer}`,
          },
        ],
        details: details(answer, selectedIndex, false),
      };
    },

    renderCall(args, theme) {
      const question = typeof args.question === "string" ? args.question : "";
      return new Text(
        theme.fg("toolTitle", theme.bold("ask_user ")) +
          theme.fg("muted", question),
        0,
        0,
      );
    },

    renderResult(result, _options, theme) {
      const details = result.details as AskUserDetails | undefined;
      if (!details || details.dismissed || details.answer === null) {
        return new Text(theme.fg("warning", "✗ dismissed"), 0, 0);
      }
      const prefix = details.custom
        ? theme.fg("muted", "(wrote) ")
        : `${(details.selectedIndex ?? 0) + 1}. `;
      return new Text(
        theme.fg("success", "✓ ") + prefix + theme.fg("accent", details.answer),
        0,
        0,
      );
    },
  });
}
