{ user, ... }:
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  home.sessionPath = [
    "/etc/profiles/per-user/${user}/bin"
  ];

  programs.home-manager.enable = true;
}
