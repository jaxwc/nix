{theme, ...}: let
  c = theme.colors;
in {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command_timeout = 3600;
      "$schema" = "https://starship.rs/config-schema.json";
      follow_symlinks = false;
      add_newline = true;

      format = "$directory\${custom.giturl}$git_branch\${custom.git_worktree}$git_status$line_break$character";

      right_format = "$all";

      palette = "active";

      palettes.active = {
        base = c.bg;
        mantle = c.bg_dark;
        crust = c.bg_highlight;
        text = c.fg;
        subtext1 = c.fg_dark;
        subtext0 = c.dark5;
        muted = c.comment;
        red = c.red;
        orange = c.orange;
        yellow = c.yellow;
        green = c.green;
        cyan = c.cyan;
        blue = c.blue;
        purple = c.purple;
        magenta = c.magenta;
        sapphire = c.blue;
        lavender = c.purple;
        peach = c.orange;
        teal = c.teal;
        pine = c.blue1;
        maroon = c.red;
        pink = c.magenta;
        flamingo = c.magenta;
        rosewater = c.fg;
        gold = c.yellow;
        rose = c.red;
        sky = c.blue;
        foam = c.cyan;
        black = c.black;
      };

      os.symbols = {
        Windows = "󰍲";
        Ubuntu = "󰕈";
        SUSE = "";
        Raspbian = "󰐿";
        Mint = "󰣭";
        Macos = " ";
        Manjaro = "";
        Linux = "󰌽";
        Gentoo = "󰣨";
        Fedora = "󰣛";
        Alpine = "";
        Amazon = "";
        Android = "";
        Arch = "󰣇";
        Artix = "󰣇";
        CentOS = "";
        Debian = "󰣚";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
      };

      directory = {
        style = "sapphire";
        format = "[ $path ]($style)";
        truncation_length = 2;
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
          "Others" = " ";
        };
      };

      os.disabled = true;
      username.disabled = true;
      package.disabled = true;

      custom.giturl = {
        description = "Display symbol for remote Git server";
        shell = ["sh"];
        command = ''
          # Get default remote URL and map provider icon
          URL=$(git ls-remote --get-url 2>/dev/null)
          case "$URL" in
            *github*|*GitHub*) echo " " ;;
            *codeberg*|*Codeberg*) echo "󰲋 " ;;
            *gitlab*|*GitLab*) echo " " ;;
            *bitbucket*|*Bitbucket*) echo " " ;;
            *git*) echo " " ;;
            *) echo " " ;;
          esac
        '';
        when = "git rev-parse --is-inside-work-tree 2>/dev/null";
        format = "$output";
        require_repo = true;
        ignore_timeout = true;
      };

      custom.git_worktree = {
        description = "Show indicator when inside a git worktree";
        shell = ["sh"];
        command = ''
          common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
          git_dir=$(git rev-parse --path-format=absolute --git-dir 2>/dev/null)
          if [ "$common_dir" != "$git_dir" ]; then echo "⛓ "; fi
        '';
        when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1";
        format = "( [$output]($style))";
        style = "bold green";
        require_repo = true;
        ignore_timeout = true;
      };

      git_branch = {
        symbol = "[](black) ";
        style = "fg:lavender bg:black";
        format = " [$symbol$branch]($style)[](black)";
      };

      git_status.format = " [($all_status$ahead_behind )]($style)";

      bun.detect_files = ["bun.lock" "bun.lockb"];

      nodejs = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };

      c = {
        symbol = " ";
        format = "[ $symbol( $version) ]($style)";
      };

      rust = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };

      golang = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
        detect_files = ["go.mod"];
      };

      php = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };

      java = {
        symbol = " ";
        format = "[ $symbol( $version) ]($style)";
      };

      kotlin = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };

      haskell = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };

      python = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };

      docker_context = {
        symbol = "";
        format = "[ $symbol( $context) ]($style)";
      };

      time = {
        disabled = true;
        time_format = "%R";
        style = "bg:peach";
        format = "[[  $time ](fg:mantle bg:foam)]($style)";
      };

      line_break.disabled = true;

      character = {
        disabled = false;
        success_symbol = "[→](bold fg:green)";
        error_symbol = "[✘ ](bold fg:red)";
        vimcmd_symbol = "[:](bold fg:yellow)";
        vimcmd_replace_one_symbol = "[󰝿 :](bold purple)";
        vimcmd_replace_symbol = "[  :](bold purple)";
        vimcmd_visual_symbol = "[  :](bold cyan)";
      };
    };
  };
}
