{pkgs, ...}: {
  home.packages = with pkgs; [
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
    opencode
    python314
    ripgrep
    sbarlua
    sketchybar
    sketchybar-app-font
    llama-cpp
    claude-code
  ];
}
