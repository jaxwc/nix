{pkgs, ...}: {
  home.packages = with pkgs; [
    aerospace
    alejandra
    bash
    eza
    fd
    ghostscript
    gh
    imagemagick
    jankyborders
    jdk
    jq
    lazygit
    lua5_4
    luarocks
    nixd
    nodejs
    opencode
    python314
    ripgrep
    sbarlua
    sketchybar
    sketchybar-app-font
  ];
}
