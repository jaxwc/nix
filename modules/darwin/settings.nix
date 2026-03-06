{ pkgs, user, ... }:
{
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  environment.systemPackages = with pkgs; [
    curl
  ];

  launchd.user.envVariables.PATH =
    "/etc/profiles/per-user/${user}/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    taps = [ "epk/epk" ];
    brews = [ ];
    casks = [
      "1password@beta"
      "cleanshot"
      "fantastical"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-sf-mono-nerd-font"
      "font-sf-pro"
      "ghostty"
      "jellyfin-media-player"
      "obsidian"
      "protonvpn"
      "raycast"
      "sf-symbols"
      "spotify"
      "tailscale-app"
    ];
  };
  system.stateVersion = 6;
}
