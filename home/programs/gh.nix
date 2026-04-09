{...}: {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = false;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
    };
  };
}
