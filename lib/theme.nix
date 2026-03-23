{name ? "tokyo-night-storm"}: let
  rawHexValue = color: builtins.substring 1 6 color;

  themes = {
    "tokyo-night-storm" = {
      name = "tokyo-night-storm";
      ghosttyTheme = "Tokyonight Storm";

      colors = {
        black = "#24283b";
        bg1 = "#1f2335";
        bg2 = "#292e42";
        text = "#c0caf5";
        subtext1 = "#a9b1d6";
        muted = "#737aa2";
        uiMuted = "#565f89";
        red = "#f7768e";
        orange = "#ff9e64";
        yellow = "#e0af68";
        green = "#9ece6a";
        cyan = "#7dcfff";
        blue = "#7aa2f7";
        pine = "#2ac3de";
        purple = "#bb9af7";
        magenta = "#bb9af7";
        transparent = "#00000000";
      };
    };
  };
in
  if builtins.hasAttr name themes
  then themes.${name} // {inherit rawHexValue;}
  else throw "Unknown theme '${name}'. Available themes: ${builtins.concatStringsSep ", " (builtins.attrNames themes)}"
