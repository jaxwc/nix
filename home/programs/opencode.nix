{...}: {
  xdg.configFile."opencode/opencode.json" = {
    source = ../config/opencode/opencode.json;
  };
  xdg.configFile."opencode/agents" = {
    source = ../config/opencode/agents;
    recursive = true;
  };
  xdg.configFile."opencode/skills" = {
    source = ../config/opencode/skills;
    recursive = true;
  };
}
