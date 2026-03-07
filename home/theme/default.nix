{...}: {
  _module.args.theme =
    (import ./flexoki-dark.nix)
    // {
      rawHexValue = color: builtins.substring 1 6 color;
    };
}
