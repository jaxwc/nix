{...}: {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    brews = [];
    casks = [
      "1password@beta"
      "cleanshot"
      "fantastical"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-sf-pro"
      "ghostty"
      "intellij-idea"
      "jellyfin-media-player"
      "obsidian"
      "protonvpn"
      "raycast"
      "sf-symbols"
      "spotify"
      "zen"
      "tailscale-app"
      "helium-browser"
    ];
  };
}
