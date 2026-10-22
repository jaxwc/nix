{name ? "spiderverse"}: let
  rawHexValue = color: builtins.substring 1 6 color;
  withAlpha = alpha: color: "${color}${alpha}";
  transparency = {
    color = "#00000000";
    terminalOpacity = 0.65;
    subtle = "30";
    selection = "55";
    muted = "aa";
  };

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
        diff_add = "#20303b";
        diff_change = "#252e49";
        diff_delete = "#37222c";
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
        diff_add = "#122e18";
        diff_change = "#2a235a";
        diff_delete = "#4a1830";
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

    # From Rex's built-in "Saffron Nightfall" (themes.json); extra shades derived from its ANSI palette
    "saffron-nightfall" = {
      name = "saffron_nightfall";
      transparent = "#00000000";

      colors = {
        bg = "#131320";
        bg_dark = "#0f0f1a";
        bg_dark1 = "#0b0b14";
        bg_float = "#1a1a2a";
        bg_highlight = "#1e1e30";
        bg_popup = "#1a1a2a";
        bg_search = "#4a4870";
        bg_sidebar = "#0f0f1a";
        bg_statusline = "#0f0f1a";
        bg_visual = "#33324e";
        black = "#1e1e30";
        blue = "#7d8fd0";
        blue0 = "#4a5590";
        blue1 = "#93cfc5";
        blue2 = "#76b7ad";
        blue5 = "#98a9e0";
        blue6 = "#c4cef0";
        blue7 = "#2e3558";
        border = "#1e1e30";
        border_highlight = "#ffc247";
        comment = "#625f72";
        cyan = "#76b7ad";
        dark3 = "#4a4860";
        dark5 = "#8a8698";
        diff_add = "#1f2a1e";
        diff_change = "#22243a";
        diff_delete = "#33201f";
        error = "#e0705f";
        fg = "#d9d4c8";
        fg_dark = "#b7b2a5";
        fg_float = "#f1ecdf";
        fg_gutter = "#33324e";
        fg_sidebar = "#b7b2a5";
        red = "#e0705f";
        red1 = "#ee8b7a";
        orange = "#f0955a";
        yellow = "#ffc247";
        green = "#9cb56b";
        green1 = "#b6cc87";
        green2 = "#7d9552";
        hint = "#76b7ad";
        info = "#7d8fd0";
        magenta = "#d0a3d3";
        magenta2 = "#bb87c0";
        none = "NONE";
        purple = "#bb87c0";
        teal = "#93cfc5";
        terminal_black = "#625f72";
        todo = "#7d8fd0";
        warning = "#ffc247";
      };
    };
  };
in
  if builtins.hasAttr name themes
  then themes.${name} // {inherit rawHexValue transparency withAlpha;}
  else throw "Unknown theme '${name}'. Available themes: ${builtins.concatStringsSep ", " (builtins.attrNames themes)}"
