{config, ...}: {
  system.activationScripts.applications.text = ''
    appsDir="/Applications/Nix Apps"
    systemApps="${config.system.build.applications}/Applications"

    rm -rf "$appsDir"
    mkdir -p "$appsDir"

    if [ -d "$systemApps" ]; then
      for app in "$systemApps"/*.app; do
        [ -e "$app" ] || continue
        ln -s "$app" "$appsDir/$(basename "$app")"
      done
    fi
  '';
}
