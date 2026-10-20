{config, ...}: {
  xdg.configFile."rex/init.lua" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home/config/rex/init.lua";
  };
}
