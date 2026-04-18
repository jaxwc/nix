{name ? "spiderverse"}: let
  rawHexValue = color: builtins.substring 1 6 color;

  themes = {
    "tokyo-night-storm" = {
      name = "tokyonight_storm";
      ghosttyTheme = "Tokyonight Storm";
      transparent = "#00000000";

      colors = {
        bg = "#24283b";
        bg_dark = "#1f2335";
        bg_dark1 = "#1b1e2d";
        bg_float = "#1f2335";
        bg_highlight = "#292e42";
        bg_popup = "#1f2335";
        bg_search = "#3d59a1";
        bg_sidebar = "#1f2335";
        bg_statusline = "#1f2335";
        bg_visual = "#2e3c64";
        black = "#1d202f";
        blue = "#7aa2f7";
        blue0 = "#3d59a1";
        blue1 = "#2ac3de";
        blue2 = "#0db9d7";
        blue5 = "#89ddff";
        blue6 = "#b4f9f8";
        blue7 = "#394b70";
        border = "#1d202f";
        border_highlight = "#29a4bd";
        comment = "#565f89";
        cyan = "#7dcfff";
        dark3 = "#545c7e";
        dark5 = "#737aa2";
        error = "#db4b4b";
        fg = "#c0caf5";
        fg_dark = "#a9b1d6";
        fg_float = "#c0caf5";
        fg_gutter = "#3b4261";
        fg_sidebar = "#a9b1d6";
        red = "#f7768e";
        red1 = "#db4b4b";
        orange = "#ff9e64";
        yellow = "#e0af68";
        green = "#9ece6a";
        green1 = "#73daca";
        green2 = "#41a6b5";
        hint = "#1abc9c";
        info = "#0db9d7";
        magenta = "#bb9af7";
        magenta2 = "#ff007c";
        none = "NONE";
        purple = "#9d7cd8";
        teal = "#1abc9c";
        terminal_black = "#414868";
        todo = "#7aa2f7";
        warning = "#e0af68";
      };
    };

    "spiderverse" = {
      name = "spiderverse";
      transparent = "#00000000";

      colors = {
        bg = "#0b0918";
        bg_dark = "#07050f";
        bg_dark1 = "#040309";
        bg_float = "#16092f";
        bg_highlight = "#28176a";
        bg_popup = "#1d1148";
        bg_search = "#4526b8";
        bg_sidebar = "#080612";
        bg_statusline = "#07050f";
        bg_visual = "#6a39dc";
        black = "#05030a";
        blue = "#5f86ff";
        blue0 = "#2b37a3";
        blue1 = "#35e8ff";
        blue2 = "#11c8ff";
        blue5 = "#97edff";
        blue6 = "#d6fbff";
        blue7 = "#3c4690";
        border = "#29155f";
        border_highlight = "#35e8ff";
        comment = "#7a72a8";
        cyan = "#35e8ff";
        dark3 = "#655d92";
        dark5 = "#a198ce";
        error = "#ff4b87";
        fg = "#f1ebff";
        fg_dark = "#d0c7f4";
        fg_float = "#fbf7ff";
        fg_gutter = "#3b3168";
        fg_sidebar = "#ddd5fb";
        red = "#ff4b87";
        red1 = "#ff1f6d";
        orange = "#ffb347";
        yellow = "#ffe066";
        green = "#2cf0cb";
        green1 = "#82ffe4";
        green2 = "#19c7ab";
        hint = "#2cf0cb";
        info = "#35e8ff";
        magenta = "#ff38c8";
        magenta2 = "#ff00a8";
        none = "NONE";
        purple = "#b18cff";
        teal = "#14d0db";
        terminal_black = "#342d62";
        todo = "#b18cff";
        warning = "#ffe066";
      };
    };
  };
in
  if builtins.hasAttr name themes
  then themes.${name} // {inherit rawHexValue;}
  else throw "Unknown theme '${name}'. Available themes: ${builtins.concatStringsSep ", " (builtins.attrNames themes)}"
