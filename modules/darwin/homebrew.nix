{ ... }:
{
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
}
