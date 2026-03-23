{...}: {
  xdg.configFile."opencode/opencode.json".source = ../config/opencode/opencode.json;

  xdg.configFile."opencode/agent" = {
    source = ../config/opencode/agent;
    recursive = true;
  };

  xdg.configFile."opencode/skills" = {
    source = ../config/opencode/skills;
    recursive = true;
  };
}
