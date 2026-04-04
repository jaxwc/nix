{
  pkgs,
  user,
  ...
}: {
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  environment.shells = [pkgs.fish];
  environment.systemPackages = with pkgs; [
    curl
  ];

  launchd.user.envVariables.PATH = "/etc/profiles/per-user/${user}/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.stateVersion = 6;
}
