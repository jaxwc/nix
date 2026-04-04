{...}: {
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        name = "jackson";
        email = "jacksonwc@proton.me";
      };
    };
  };
}
