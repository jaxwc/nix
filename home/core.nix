{
  user,
  ...
}: {
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  home.file.".hushlogin".text = "";

  programs.home-manager.enable = true;
}
