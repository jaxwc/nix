{ user, theme, ... }:
let
  profileBin = "/etc/profiles/per-user/${user}/bin";
  hex = theme.rawHexValue;
  activeBorderColor = "0xff${hex theme.colors.border_highlight}";
  inactiveBorderColor = "0xff${hex theme.colors.comment}";
in {
  home.file.".aerospace.toml".text = builtins.replaceStrings
    [ "@USER@" "@HOME@" "@PROFILE_BIN@" "@ACTIVE_BORDER_COLOR@" "@INACTIVE_BORDER_COLOR@" ]
    [ user "/Users/${user}" profileBin activeBorderColor inactiveBorderColor ]
    (builtins.readFile ../config/aerospace/aerospace.toml);
}
