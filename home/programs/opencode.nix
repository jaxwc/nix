{...}: {
  xdg.configFile."opencode" = {
    source = ../config/opencode;
    recursive = true;
  };
}
