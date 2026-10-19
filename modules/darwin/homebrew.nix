{...}: {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    onActivation.extraFlags = ["--force-cleanup"];
    brews = [
      "mas"
      "herdr"
      "mysql"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Obsidian Web Clipper" = 6720708363;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "Noir" = 1592917505;
      "wBlock" = 6746388723;
    };
    casks = [
      "1password@beta"
      "cleanshot"
      "fantastical"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-sf-pro"
      "ghostty"
      "obsidian"
      "protonvpn"
      "sf-symbols"
      "spotify"
      "tailscale-app"
      "t3-code@nightly"
      "codex"
      "orbstack"
      "tinycast"
      "chatgpt"
    ];
  };
}
