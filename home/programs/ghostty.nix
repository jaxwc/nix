{theme, ...}: {
  xdg.configFile."ghostty/config" = {
    text = ''
      auto-update-channel = stable
      font-family = JetBrainsMono Nerd Font
      font-size = 16
      theme = nix-theme
      background-opacity = 0.65
      background-blur = true
      window-padding-x = 8
      window-padding-y = 8
      window-padding-balance = true
      cursor-style = block
      cursor-style-blink = false
      cursor-invert-fg-bg = true
      mouse-hide-while-typing = true
      macos-titlebar-style = hidden
      macos-option-as-alt = true
      shell-integration-features = no-cursor
      keybind = super+shift+r=reload_config
    '';
  };
  xdg.configFile."ghostty/themes/nix-theme" = {
    text = ''
      foreground = ${theme.colors.fg}
      background = ${theme.colors.bg}
      cursor-color = ${theme.colors.cyan}
      cursor-text = ${theme.colors.bg}
      selection-foreground = ${theme.colors.fg}
      selection-background = ${theme.colors.bg_highlight}
      search-foreground = ${theme.colors.bg}
      search-background = ${theme.colors.yellow}
      search-selected-foreground = ${theme.colors.bg}
      search-selected-background = ${theme.colors.magenta}
      split-divider-color = ${theme.colors.border_highlight}
      unfocused-split-fill = ${theme.colors.bg_dark}
      palette = 0=${theme.colors.black}
      palette = 1=${theme.colors.red}
      palette = 2=${theme.colors.green}
      palette = 3=${theme.colors.yellow}
      palette = 4=${theme.colors.blue}
      palette = 5=${theme.colors.magenta}
      palette = 6=${theme.colors.cyan}
      palette = 7=${theme.colors.fg_dark}
      palette = 8=${theme.colors.terminal_black}
      palette = 9=${theme.colors.red1}
      palette = 10=${theme.colors.green1}
      palette = 11=${theme.colors.yellow}
      palette = 12=${theme.colors.blue1}
      palette = 13=${theme.colors.purple}
      palette = 14=${theme.colors.blue5}
      palette = 15=${theme.colors.fg}
    '';
  };
}
