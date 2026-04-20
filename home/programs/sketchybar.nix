{
  pkgs,
  user,
  theme,
  ...
}: let
  luaPkg = pkgs.sbarlua.luaModule;
  luaVersion = pkgs.lib.versions.majorMinor (pkgs.lib.getVersion luaPkg);
  profileBin = "/etc/profiles/per-user/${user}/bin";
  homeDir = "/Users/${user}";
  c = theme.colors;
  hex = theme.rawHexValue;
  ff = color: "0xff${hex color}";
  argb = alpha: color: "0x${alpha}${hex color}";

  colorsLua = pkgs.writeText "colors.lua" ''
    return {
      black       = ${ff c.black},
      white       = ${ff c.fg},
      red         = ${ff c.red},
      green       = ${ff c.green},
      blue        = ${ff c.blue},
      yellow      = ${ff c.yellow},
      orange      = ${ff c.orange},
      magenta     = ${ff c.magenta},
      cyan        = ${ff c.cyan},
      purple      = ${ff c.purple},
      grey        = ${ff c.comment},
      transparent = 0x00000000,
      bar = {
        bg     = ${argb "f0" c.bg_dark},
        border = ${ff c.border},
      },
      popup = {
        bg     = ${argb "e0" c.bg_float},
        border = ${ff c.border_highlight},
      },
      bg1 = ${ff c.bg_float},
      bg2 = ${ff c.bg_highlight},
      with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
      end,
    }
  '';

  renderedSketchybar = pkgs.runCommand "hm-sketchybar-config" {} ''
    cp -R ${../config/sketchybar} "$out"
    chmod -R u+w "$out"
    cp ${colorsLua} "$out/colors.lua"
    substituteInPlace "$out/sketchybarrc" \
      --replace "@USER@" "${user}" \
      --replace "@HOME@" "${homeDir}" \
      --replace "@PROFILE_BIN@" "${profileBin}" \
      --replace "@LUA_BIN@" "${luaPkg}/bin/lua"
    substituteInPlace "$out/items/spaces.lua" \
      --replace "@USER@" "${user}" \
      --replace "@HOME@" "${homeDir}" \
      --replace "@PROFILE_BIN@" "${profileBin}" \
      --replace "@LUA_BIN@" "${luaPkg}/bin/lua"
  '';
in {
  xdg.configFile."sketchybar" = {
    source = renderedSketchybar;
    recursive = true;
  };
  home.file.".local/share/sketchybar_lua/sketchybar.so".source = "${pkgs.sbarlua}/lib/lua/${luaVersion}/sketchybar.so";
}
