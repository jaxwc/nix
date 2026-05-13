{...}: {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    brews = [
      "mas"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Obsidian Web Clipper" = 6720708363;
      "wBlock" = 6746388723;
      "Noir - Dark Mode for Safari" = 1592917505;
    };
    casks = [
      "1password@beta"
      "cleanshot"
      "fantastical"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-sf-pro"
      "ghostty"
      "jellyfin-media-player"
      "obsidian"
      "protonvpn"
      "sf-symbols"
      "spotify"
      "tailscale-app"
      "tuna"
    ];
  };
}
