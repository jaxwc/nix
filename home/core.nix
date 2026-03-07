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

  programs.home-manager.enable = true;
}
