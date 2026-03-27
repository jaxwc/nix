{theme, ...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";

    colors = {
      "bg+" = theme.colors.bg_visual;
      bg = theme.colors.bg_dark;
      border = theme.colors.border_highlight;
      fg = theme.colors.fg;
      "fg+" = theme.colors.fg;
      gutter = theme.colors.bg_dark;
      header = theme.colors.orange;
      hl = theme.colors.blue1;
      "hl+" = theme.colors.blue1;
      info = theme.colors.dark3;
      marker = theme.colors.magenta2;
      pointer = theme.colors.magenta2;
      prompt = theme.colors.blue1;
      query = theme.colors.fg;
      scrollbar = theme.colors.border_highlight;
      "selected-bg" = theme.colors.bg_visual;
      separator = theme.colors.orange;
      spinner = theme.colors.magenta2;
    };

    defaultOptions = [
      "--ansi"
      "--border=none"
      "--highlight-line"
      "--info=inline-right"
      "--layout=reverse"
      "--prompt=❯ "
      "--pointer=❯"
      "--height=40%"
    ];

    fileWidgetOptions = [
      "--preview=bat --color=always --style=numbers --line-range=:500 {}"
    ];
  };
}
