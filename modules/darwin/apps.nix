{
  config,
  user,
  ...
}: {
  system.activationScripts.applications.text = ''
    appsDir="/Applications/Nix Apps"
    systemApps="${config.system.build.applications}/Applications"
    userApps="${config.home-manager.users.${user}.home.path}/Applications"

    rm -rf "$appsDir"
    mkdir -p "$appsDir"

    linkAppsFrom() {
      local sourceDir="$1"

      [ -d "$sourceDir" ] || return 0

      for app in "$sourceDir"/*.app; do
        [ -e "$app" ] || continue
        ln -sfn "$app" "$appsDir/$(basename "$app")"
      done
    }

    linkAppsFrom "$systemApps"
    linkAppsFrom "$userApps"
  '';
}
