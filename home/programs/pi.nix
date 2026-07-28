{
  config,
  lib,
  pkgs,
  pkgs-small,
  piWebAccessSrc,
  theme,
  ...
}: let
  c = theme.colors;
  piConfig = "${config.home.homeDirectory}/.config/nix/home/config/pi";
  piWebAccessPath = "${config.home.homeDirectory}/.pi/agent/packages/pi-web-access";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${piConfig}/${path}";

  piWebAccessManifest = builtins.fromJSON (builtins.readFile "${piWebAccessSrc}/package.json");
  piWebAccessSource = pkgs.runCommand "pi-web-access-source-${piWebAccessManifest.version}" {} ''
    mkdir -p "$out"
    cp -R ${piWebAccessSrc}/. "$out/"
    chmod -R u+w "$out"
    cp ${../packages/pi-web-access/package-lock.json} "$out/package-lock.json"
  '';
  piWebAccess = pkgs.buildNpmPackage {
    pname = "pi-web-access";
    version = piWebAccessManifest.version;
    src = piWebAccessSource;
    npmDepsHash = "sha256-gcesczWMoZgVHaCR3tWGr55W8pDc9byk8vnsXluGSw4=";
    npmInstallFlags = ["--omit=peer"];
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R . "$out/"
      runHook postInstall
    '';
  };

  piTheme = {
    "$schema" = "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    name = "spiderverse";
    vars = builtins.removeAttrs c ["none"];
    colors = {
      accent = "magenta";
      border = "border";
      borderAccent = "border_highlight";
      borderMuted = "border";
      success = "green";
      error = "error";
      warning = "warning";
      muted = "dark5";
      dim = "comment";
      text = "fg";
      thinkingText = "dark5";

      selectedBg = "bg_visual";
      userMessageBg = "bg_float";
      userMessageText = "fg";
      customMessageBg = "bg_popup";
      customMessageText = "fg";
      customMessageLabel = "magenta";
      toolPendingBg = "bg_float";
      toolSuccessBg = "bg_float";
      toolErrorBg = "bg_popup";
      toolTitle = "cyan";
      toolOutput = "fg_dark";

      mdHeading = "magenta";
      mdLink = "cyan";
      mdLinkUrl = "comment";
      mdCode = "blue5";
      mdCodeBlock = "fg";
      mdCodeBlockBorder = "dark5";
      mdQuote = "fg_dark";
      mdQuoteBorder = "purple";
      mdHr = "border";
      mdListBullet = "cyan";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "dark5";

      syntaxComment = "comment";
      syntaxKeyword = "magenta";
      syntaxFunction = "cyan";
      syntaxVariable = "fg";
      syntaxString = "green1";
      syntaxNumber = "orange";
      syntaxType = "purple";
      syntaxOperator = "blue5";
      syntaxPunctuation = "dark5";

      thinkingOff = "comment";
      thinkingMinimal = "dark5";
      thinkingLow = "blue";
      thinkingMedium = "cyan";
      thinkingHigh = "purple";
      thinkingXhigh = "magenta";
      thinkingMax = "red";
      bashMode = "orange";
    };
    export = {
      pageBg = "bg";
      cardBg = "bg_dark";
      infoBg = "bg_float";
    };
  };
in {
  home.packages = [pkgs-small.pi-coding-agent];

  home.file = {
    ".pi/agent/AGENTS.md".source = outOfStore "AGENTS.md";
    ".pi/agent/skills/meal-planner".source = outOfStore "skills/meal-planner";
    ".pi/agent/packages/pi-web-access".source = piWebAccess;
    ".pi/agent/extensions/spiderverse-ui.ts".source =
      outOfStore "extensions/spiderverse-ui.ts";
    ".pi/agent/extensions/copy-all.ts".source =
      outOfStore "extensions/copy-all.ts";
    ".pi/agent/extensions/ask-user.ts".source =
      outOfStore "extensions/ask-user.ts";
    ".pi/agent/extensions/btw.ts".source = outOfStore "extensions/btw.ts";
    ".pi/agent/extensions/codex-usage.ts".source =
      outOfStore "extensions/codex-usage.ts";
    ".pi/agent/extensions/server-ssh.ts".source =
      outOfStore "extensions/server-ssh.ts";
    ".pi/agent/extensions/plan-mode".source =
      outOfStore "extensions/plan-mode";
    ".pi/agent/keybindings.json".text = builtins.toJSON {
      "tui.select.up" = ["up" "ctrl+k"];
      "tui.select.down" = ["down" "ctrl+j"];
    };
    ".pi/agent/themes/spiderverse.json".text = builtins.toJSON piTheme;
    ".pi/web-search.json".text = builtins.toJSON {
      provider = "openai";
      workflow = "none";
      allowBrowserCookies = false;
    };
  };

  home.activation.piSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settings="${config.home.homeDirectory}/.pi/agent/settings.json"
    mkdir -p "$(dirname "$settings")"
    source="$settings"
    if [ ! -f "$source" ]; then
      source=$(mktemp)
      printf '{}\n' > "$source"
    fi
    target=$(mktemp)
    ${pkgs.jq}/bin/jq --arg piWebAccess "${piWebAccessPath}" '
      def packageSource: if type == "string" then . else (.source // "") end;
      . + {
      theme: "spiderverse",
      defaultProvider: "openai-codex",
      defaultModel: "gpt-5.6-sol",
      defaultThinkingLevel: "low",
      defaultProjectTrust: "ask",
      compaction: {
        enabled: true,
        reserveTokens: 65536,
        keepRecentTokens: 30000
      }
    }
    | del(.powerline)
    | .packages = (
        ((.packages // []) | map(select(
          packageSource
          | (
              contains("-pi-web-access-")
              or endswith("/pi-web-access")
              or startswith("npm:pi-web-access")
              or contains("nicobailon/pi-web-access")
              or startswith("npm:pi-powerline-footer")
              or contains("nicobailon/pi-powerline-footer")
            )
          | not
        )))
        + [{source: $piWebAccess, skills: []}]
      )
    ' "$source" > "$target"
    install -m 600 "$target" "$settings"
    rm -f "$target"
    if [ "$source" != "$settings" ]; then rm -f "$source"; fi

    agent_dir="${config.home.homeDirectory}/.pi/agent"
    sessions_dir="$agent_dir/sessions"
    chmod 700 "$agent_dir"
    if [ -d "$sessions_dir" ]; then
      find "$sessions_dir" -type d -exec chmod 700 {} +
      find "$sessions_dir" -type f -name '*.jsonl' -exec chmod 600 {} +
    fi
  '';
}
