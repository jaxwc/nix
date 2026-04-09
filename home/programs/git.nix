{...}: {
  programs.git = {
    enable = true;
    userName = "jackson";
    userEmail = "jacksonwc@proton.me";
    settings = {
      init.defaultBranch = "main";
      fetch.prune = true;
      push.autoSetupRemote = true;
    };
  };
}
