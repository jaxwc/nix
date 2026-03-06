{ user, ... }:
let
  profileBin = "/etc/profiles/per-user/${user}/bin";
in {
  home.file.".aerospace.toml".text = builtins.replaceStrings
    [ "@USER@" "@HOME@" "@PROFILE_BIN@" ]
    [ user "/Users/${user}" profileBin ]
    (builtins.readFile ../config/aerospace/aerospace.toml);
}
