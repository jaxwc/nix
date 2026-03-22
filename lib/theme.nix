{name ? "flexoki-dark"}: let
  rawHexValue = color: builtins.substring 1 6 color;

  themes = {
    "flexoki-dark" = {
      name = "flexoki-dark";
      ghosttyTheme = "Flexoki Dark";

      colors = {
        black = "#100f0f";
        bg1 = "#1c1b1a";
        bg2 = "#282726";
        text = "#cecdc3";
        subtext1 = "#b7b5ac";
        muted = "#878580";
        uiMuted = "#575653";
        red = "#d14d41";
        orange = "#da702c";
        yellow = "#d0a215";
        green = "#879a39";
        cyan = "#3aa99f";
        blue = "#4385be";
        pine = "#24837b";
        purple = "#8b7ec8";
        magenta = "#ce5d97";
        transparent = "#00000000";
      };
    };

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
