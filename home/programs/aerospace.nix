{
  user,
  theme,
  ...
}: let
  profileBin = "/etc/profiles/per-user/${user}/bin";
  hex = theme.rawHexValue;
  # Keep in sync with sketchybar's space colors (muted = active, dim = inactive)
  activeBorderColor = "0xff${hex theme.colors.dark5}";
  inactiveBorderColor = "0xff${hex theme.colors.dark3}";
in {
  home.file.".aerospace.toml".text =
    builtins.replaceStrings
    ["@USER@" "@HOME@" "@PROFILE_BIN@" "@ACTIVE_BORDER_COLOR@" "@INACTIVE_BORDER_COLOR@"]
    [user "/Users/${user}" profileBin activeBorderColor inactiveBorderColor]
    (builtins.readFile ../config/aerospace/aerospace.toml);
}
