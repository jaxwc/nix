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
        bg = "#07060e";
        bg_dark = "#050409";
        bg_dark1 = "#030308";
        bg_float = "#16092f";
        bg_highlight = "#28176a";
        bg_popup = "#1d1148";
        bg_search = "#4526b8";
        bg_sidebar = "#080612";
        bg_statusline = "#050409";
        bg_visual = "#6a39dc";
        black = "#05030a";
        blue = "#3060f0";
        blue0 = "#1a2872";
        blue1 = "#18d8f0";
        blue2 = "#11c8ff";
        blue5 = "#97edff";
        blue6 = "#d6fbff";
        blue7 = "#1e2d80";
        border = "#29155f";
        border_highlight = "#18d8f0";
        comment = "#7a72a8";
        cyan = "#18d8f0";
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
        orange = "#ff6820";
        yellow = "#ffe066";
        green = "#40e055";
        green1 = "#80f095";
        green2 = "#2ab040";
        hint = "#40e055";
        info = "#18d8f0";
        magenta = "#ff38c8";
        magenta2 = "#ff00a8";
        none = "NONE";
        purple = "#8840f0";
        teal = "#10c8d8";
        terminal_black = "#342d62";
        todo = "#8840f0";
        warning = "#ffe066";
      };
    };
  };
in
  if builtins.hasAttr name themes
  then themes.${name} // {inherit rawHexValue;}
  else throw "Unknown theme '${name}'. Available themes: ${builtins.concatStringsSep ", " (builtins.attrNames themes)}"
