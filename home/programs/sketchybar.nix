{
  pkgs,
  user,
  ...
}: let
  profileBin = "/etc/profiles/per-user/${user}/bin";
  homeDir = "/Users/${user}";
  renderedSketchybar = pkgs.runCommand "hm-sketchybar-config" {} ''
    cp -R ${../config/sketchybar} "$out"
    chmod -R u+w "$out"

    substituteInPlace "$out/sketchybarrc" \
      --replace "@USER@" "${user}" \
      --replace "@HOME@" "${homeDir}" \
      --replace "@PROFILE_BIN@" "${profileBin}" \
      --replace "@LUA_BIN@" "${pkgs.lua5_4}/bin/lua"

    substituteInPlace "$out/items/spaces.lua" \
      --replace "@USER@" "${user}" \
      --replace "@HOME@" "${homeDir}" \
      --replace "@PROFILE_BIN@" "${profileBin}" \
      --replace "@LUA_BIN@" "${pkgs.lua5_4}/bin/lua"
  '';
in {
  xdg.configFile."sketchybar" = {
    source = renderedSketchybar;
    recursive = true;
  };

  home.file.".local/share/sketchybar_lua/sketchybar.so".source = "${pkgs.sbarlua}/lib/lua/5.4/sketchybar.so";
}
