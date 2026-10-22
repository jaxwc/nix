{name ? "saffron-nightfall"}: let
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
        accent = "#7dcfff";
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
        accent = "#18d8f0";
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

    # Rex's built-in "Saffron Nightfall" (Rex Beta.app themes.json): ANSI colors, semantic UI
    # colors (canvas, surfaces, strokes, containers), and its 256-color palette for extra shades.
    "saffron-nightfall" = {
      name = "saffron_nightfall";
      transparent = "#00000000";

      colors = {
        accent = "#ffc247"; # accent
        bg = "#131320"; # canvas
        bg_dark = "#131320"; # canvas
        bg_dark1 = "#131320"; # canvas
        bg_float = "#1a1a26"; # surfaceSubtle
        bg_highlight = "#232330"; # surfaceRaised
        bg_popup = "#232330"; # surfaceRaised
        bg_search = "#322c2c"; # accentContainer
        bg_sidebar = "#1a1a26"; # surfaceSubtle
        bg_statusline = "#1a1a26"; # surfaceSubtle
        bg_visual = "#33324e"; # terminalSelection
        black = "#1e1e30"; # ansi 0
        blue = "#7d8fd0"; # ansi 4
        blue0 = "#3a4060"; # palette 18
        blue1 = "#98a9e0"; # ansi 12
        blue2 = "#76b7ad"; # ansi 6
        blue5 = "#93cfc5"; # ansi 14
        blue6 = "#c6cec3"; # palette 195
        blue7 = "#26293f"; # palette 17
        border = "#34343e"; # strokeSubtle
        border_highlight = "#ffc247"; # accentBorder
        comment = "#6f6d70"; # contentTertiary
        cyan = "#76b7ad"; # ansi 6
        dark3 = "#484850"; # stroke
        dark5 = "#8d8a89"; # contentSecondary
        diff_add = "#252a2d"; # successContainer
        diff_change = "#222438"; # infoContainer
        diff_delete = "#2f212b"; # dangerContainer
        error = "#e0705f"; # danger
        fg = "#d9d4c8"; # content
        fg_dark = "#b7b2a5"; # ansi 7
        fg_float = "#f1ecdf"; # ansi 15
        fg_gutter = "#484850"; # stroke
        fg_sidebar = "#b7b2a5"; # ansi 7
        red = "#e0705f"; # ansi 1
        red1 = "#ee8b7a"; # ansi 9
        orange = "#ed9258"; # palette 208
        yellow = "#ffc247"; # ansi 3
        yellow1 = "#ffd36e"; # ansi 11
        green = "#9cb56b"; # ansi 2
        green1 = "#b6cc87"; # ansi 10
        green2 = "#7f915c"; # palette 40
        hint = "#76b7ad"; # ansi 6
        info = "#7d8fd0"; # info
        magenta = "#bb87c0"; # ansi 5
        magenta2 = "#ce7e99"; # palette 199
        none = "NONE";
        purple = "#d0a3d3"; # ansi 13
        teal = "#93cfc5"; # ansi 14
        terminal_black = "#625f72"; # ansi 8
        todo = "#7d8fd0"; # info
        warning = "#ffc247"; # warning
      };
    };
  };
in
  if builtins.hasAttr name themes
  then themes.${name} // {inherit rawHexValue transparency withAlpha;}
  else throw "Unknown theme '${name}'. Available themes: ${builtins.concatStringsSep ", " (builtins.attrNames themes)}"
