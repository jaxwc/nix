{theme, ...}: let
  c = theme.colors;
in {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command_timeout = 3600;
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;

      format = " ➜$directory\${custom.giturl}$git_branch$git_state$git_status$line_break$character";

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

      custom.giturl = {
        description = "Display symbol for remote Git server";
        shell = ["sh"];
        command = ''
          # Get remote URL and map provider icon
          URL=$(git remote get-url origin 2>/dev/null)
          case "$URL" in
            *github*|*GitHub*) echo " " ;;
            *gitlab*|*GitLab*) echo " " ;;
            *bitbucket*|*Bitbucket*) echo " " ;;
            *) echo " " ;;
          esac
        '';
        when = "git rev-parse --is-inside-work-tree 2>/dev/null";
        format = "(at $output)";
      };

      git_branch = {
        symbol = "[](black) ";
        style = "fg:lavender bg:black";
        format = "  on [$symbol$branch]($style)[](black)";
      };

      git_status.format = " [($all_status$ahead_behind )]($style)";

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

      python = {
        symbol = "";
        format = "[$symbol$version]($style)";
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
        success_symbol = "[ ](bold fg:green)";
        error_symbol = "[✘ ](bold fg:red)";
        vimcmd_symbol = "[ :](bold yellow)";
        vimcmd_replace_one_symbol = "[󰝿 :](bold purple)";
        vimcmd_replace_symbol = "[  :](bold purple)";
        vimcmd_visual_symbol = "[  :](bold cyan)";
      };
    };
  };
}
