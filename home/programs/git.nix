{
  config,
  theme,
  ...
}: let
  c = theme.colors;
in {
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUfVjN3hYmmXaDlfw0si0aKKHnjViSW5fQ5KynxVcZC";
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
    settings = {
      user.name = "jackson";
      user.email = "jacksonwc@proton.me";

      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";

      init.defaultBranch = "main";
      fetch.prune = true;
      push.autoSetupRemote = true;
      pull.rebase = true;

      core.autocrlf = "input";
      merge.conflictstyle = "diff3";
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
    };
  };

  home.file.".ssh/allowed_signers".text = ''
    jacksonwc@proton.me namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUfVjN3hYmmXaDlfw0si0aKKHnjViSW5fQ5KynxVcZC
  '';

  home.file."Library/Application Support/lazygit/config.yml".text = ''
    gui:
      theme:
        activeBorderColor: ['${c.border_highlight}', bold]
        inactiveBorderColor: ['${c.comment}']
        searchingActiveBorderColor: ['${c.cyan}', bold]
        optionsTextColor: ['${c.blue1}']
        selectedLineBgColor: ['${c.bg_highlight}']
        inactiveViewSelectedLineBgColor: ['${c.bg_visual}']
        cherryPickedCommitFgColor: ['${c.blue}']
        cherryPickedCommitBgColor: ['${c.cyan}']
        markedBaseCommitFgColor: ['${c.bg_dark}']
        markedBaseCommitBgColor: ['${c.yellow}']
        unstagedChangesColor: ['${c.red}']
        defaultFgColor: ['${c.fg}']
  '';
}
