{config, ...}: {
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
}
