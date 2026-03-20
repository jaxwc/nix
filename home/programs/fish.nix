{
  pkgs,
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
      fish_vi_key_bindings
      # Force block cursor in all fish vi modes
      set -g fish_cursor_default block
      set -g fish_cursor_insert block
      set -g fish_cursor_replace_one block
      set -g fish_cursor_replace block
      set -g fish_cursor_visual block
      set -g fish_cursor_external block

               set -gx JAVA_HOME "${pkgs.jdk}/lib/openjdk"
               fish_add_path $JAVA_HOME/bin

               set -gx THEME_BG "${theme.colors.black}"
               set -gx THEME_FG "${theme.colors.text}"
               set -gx THEME_MUTED "${theme.colors.muted}"
               set -gx THEME_BLUE "${theme.colors.blue}"
               set -gx THEME_GREEN "${theme.colors.green}"
               set -gx THEME_RED "${theme.colors.red}"

               set -l foreground ${theme.rawHexValue theme.colors.text}
               set -l selection ${theme.rawHexValue theme.colors.bg2}
               set -l comment ${theme.rawHexValue theme.colors.muted}
               set -l red ${theme.rawHexValue theme.colors.red}
               set -l orange ${theme.rawHexValue theme.colors.orange}
               set -l yellow ${theme.rawHexValue theme.colors.yellow}
               set -l green ${theme.rawHexValue theme.colors.green}
               set -l purple ${theme.rawHexValue theme.colors.purple}
               set -l cyan ${theme.rawHexValue theme.colors.cyan}
               set -l blue ${theme.rawHexValue theme.colors.blue}

               set -g fish_color_normal $foreground
               set -g fish_color_command $green
               set -g fish_color_keyword $purple
               set -g fish_color_quote $yellow
               set -g fish_color_redirection $foreground
               set -g fish_color_end $orange
               set -g fish_color_option $purple
               set -g fish_color_error $red
               set -g fish_color_param $blue
               set -g fish_color_comment $comment
               set -g fish_color_selection --background=$selection
               set -g fish_color_search_match --background=$selection
               set -g fish_color_operator $cyan
               set -g fish_color_escape $yellow
               set -g fish_color_autosuggestion $comment

               set -g fish_pager_color_progress $comment
               set -g fish_pager_color_prefix $cyan
               set -g fish_pager_color_completion $foreground
               set -g fish_pager_color_description $comment
               set -g fish_pager_color_selected_background --background=$selection

    '';
  };
}
