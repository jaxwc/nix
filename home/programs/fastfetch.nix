{...}: {
  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
    display = {
      key.width = 10;
      size.binaryPrefix = "jedec";
      separator = "";
    };
    logo = {
      type = "builtin";
      source = "NixOS_small";
      position = "left";
      padding = {
        top = 1;
        right = 4;
        left = 0;
      };
    };
    modules = [
      "break"
      {
        type = "host";
        key = "host";
        keyColor = "yellow";
      }
      {
        type = "packages";
        key = "pkgs";
        keyColor = "cyan";
      }
      {
        type = "shell";
        key = "sh";
        keyColor = "blue";
        format = "{pretty-name}";
      }
      {
        type = "cpu";
        key = "cpu";
        keyColor = "red";
      }
      {
        type = "gpu";
        key = "gpu";
        keyColor = "green";
      }
      {
        type = "memory";
        key = "ram";
        keyColor = "yellow";
        format = "{used} / {total}";
      }
    ];
  };
}
