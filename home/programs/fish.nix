{
  pkgs,
  user,
  lib,
  theme,
  ...
}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "nvm";
        src = pkgs.fishPlugins.nvm.src;
      }
    ];
    shellAliases = {
      bu = "brew update && brew upgrade && brew cleanup && brew autoremove";
      icloud = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs\"";
      g = "git";
      ga = "git add .";
      gs = "git status -s";
      gc = "git commit -m";
      lg = "lazygit";
      ls = "eza --icons --group-directories-first";
      ll = "eza --long --no-filesize --no-user --icons --all --group-directories-first";
      tree = "eza --tree --level=2 --all";
      c = "clear";
      ta = "tmux attach";
    };
    functions = {
      fn.body = ''
        nvim (fd --type f --hidden --exclude .git | fzf --preview "bat --color=always --style=numbers --line-range=:500 {}")
      '';
      fp.body = ''
        set dir (fd --type d --hidden --exclude .git | fzf)
        if test -n "$dir"
          cd "$dir"
          nvim .
        end
      '';
    };
    interactiveShellInit = ''
         set -g fish_greeting
         fish_add_path -m /etc/profiles/per-user/${user}/bin
         fish_add_path -a /opt/homebrew/bin

         set -gx JAVA_HOME "${pkgs.jdk}/lib/openjdk"
         fish_add_path $JAVA_HOME/bin

      # Flexoki tokens from Nix theme
         set -gx THEME_BG "${theme.colors.black}"
         set -gx THEME_FG "${theme.colors.text}"
         set -gx THEME_MUTED "${theme.colors.muted}"
         set -gx THEME_BLUE "${theme.colors.blue}"
         set -gx THEME_GREEN "${theme.colors.green}"
         set -gx THEME_RED "${theme.colors.red}"

         set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
         set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
         # set -gx FZF_DEFAULT_OPTS '--color=bg+:#283457,bg:-1,gutter:-1,spinner:#ff9e64,hl:#7ad5ff,fg:#c0caf5,header:#9ece6a,info:#0db9d7,pointer:#7aa2f7,marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7ad5ff --prompt="❯ " --pointer="❯" --layout=reverse --border --height=40%'
         set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

    '';
  };
}
