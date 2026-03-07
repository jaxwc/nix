{}: {
  name = "flexoki-dark";
  ghosttyTheme = "Flexoki Dark";
  nvimVariant = "moon";

  rawHexValue = color: builtins.substring 1 6 color;

  colors = {
    black = "#100f0f";
    bg1 = "#1c1b1a";
    bg2 = "#282726";
    text = "#cecdc3";
    subtext1 = "#b7b5ac";
    muted = "#878580";
    uiMuted = "#575653";
    red = "#d14d41";
    orange = "#da702c";
    yellow = "#d0a215";
    green = "#879a39";
    cyan = "#3aa99f";
    blue = "#4385be";
    pine = "#24837b";
    purple = "#8b7ec8";
    magenta = "#ce5d97";
    transparent = "#00000000";
  };
}
