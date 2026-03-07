{ user, pkgs, lib, ... }:
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  home.packages = [ pkgs.mysides ];

  home.sessionPath = [
    "/etc/profiles/per-user/${user}/bin"
  ];

  home.file.".hushlogin".text = "";

  home.activation.finderSidebar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    MYSIDES="${pkgs.mysides}/bin/mysides"

    "$MYSIDES" list | while IFS= read -r line; do
      name="''${line%% -> *}"
      if [ -n "$name" ]; then
        "$MYSIDES" remove "$name" >/dev/null 2>&1 || true
      fi
    done

    "$MYSIDES" add "iCloud Drive" "file://$HOME/Library/Mobile%20Documents/com~apple~CloudDocs" >/dev/null 2>&1 || true
    "$MYSIDES" add "$USER" "file://$HOME" >/dev/null 2>&1 || true
    "$MYSIDES" add "Downloads" "file://$HOME/Downloads" >/dev/null 2>&1 || true

    /usr/bin/killall Finder >/dev/null 2>&1 || true
  '';

  programs.home-manager.enable = true;
}
