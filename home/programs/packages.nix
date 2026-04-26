{
  pkgs,
  pkgs-small,
  ...
}: {
  home.packages = with pkgs;
    [
      aerospace
      alejandra
      bash
      eza
      fd
      ghostscript
      imagemagick
      jankyborders
      jdk
      jq
      lazygit
      lua5_5
      luarocks
      maven
      nixd
      nodejs
      python314
      ripgrep
      sbarlua
      sketchybar
      sketchybar-app-font
      llama-cpp
    ]
    ++ (with pkgs-small; [
      opencode
    ]);
}
