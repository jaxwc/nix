{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jackson";
        email = "jacksonwc@proton.me";
      };
    };
  };
}
