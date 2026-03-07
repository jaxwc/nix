{theme, ...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";

    colors = {
      "bg+" = theme.colors.bg2;
      bg = "-1";
      gutter = "-1";
      spinner = theme.colors.orange;
      hl = theme.colors.blue;
      fg = theme.colors.text;
      header = theme.colors.green;
      info = theme.colors.cyan;
      pointer = theme.colors.blue;
      marker = theme.colors.green;
      "fg+" = theme.colors.text;
      prompt = theme.colors.blue;
      "hl+" = theme.colors.cyan;
      "selected-bg" = theme.colors.bg2;
    };

    defaultOptions = [
      "--prompt=❯ "
      "--pointer=❯"
      "--layout=reverse"
      "--border"
      "--height=40%"
    ];

    fileWidgetOptions = [
      "--preview=bat --color=always --style=numbers --line-range=:500 {}"
    ];
  };
}
