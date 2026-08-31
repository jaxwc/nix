{config, ...}: {
  xdg.configFile."herdr/config.toml" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home/config/herdr/config.toml";
  };
}
