{theme, ...}: {
  xdg.configFile."ghostty/config" = {
    text = ''
      auto-update-channel = tip

      font-family = JetBrainsMono Nerd Font
      font-size = 16

      theme = ${theme.ghosttyTheme}
      background-opacity = 0.70
      background-blur = true
      background = ${theme.colors.black}

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
}
