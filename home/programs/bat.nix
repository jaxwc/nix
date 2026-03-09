{pkgs, theme, ...}: let
  c = theme.colors;

  flexokiDarkTmTheme = pkgs.writeText "bat-flexoki-dark.tmTheme" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>name</key>
      <string>flexoki-dark</string>
      <key>settings</key>
      <array>
        <dict>
          <key>settings</key>
          <dict>
            <key>background</key>
            <string>${c.black}</string>
            <key>foreground</key>
            <string>${c.text}</string>
            <key>caret</key>
            <string>${c.text}</string>
            <key>selection</key>
            <string>${c.bg2}</string>
            <key>lineHighlight</key>
            <string>${c.bg1}</string>
            <key>invisibles</key>
            <string>${c.uiMuted}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Comment</string>
          <key>scope</key>
          <string>comment</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.muted}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>String</string>
          <key>scope</key>
          <string>string</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.green}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Number</string>
          <key>scope</key>
          <string>constant.numeric</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.orange}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Keyword</string>
          <key>scope</key>
          <string>keyword</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.purple}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Function</string>
          <key>scope</key>
          <string>entity.name.function</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.blue}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Type</string>
          <key>scope</key>
          <string>storage.type, support.type</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.yellow}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Constant</string>
          <key>scope</key>
          <string>constant.language, constant.character, support.constant</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.cyan}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Invalid</string>
          <key>scope</key>
          <string>invalid</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.black}</string>
            <key>background</key>
            <string>${c.red}</string>
          </dict>
        </dict>
      </array>
    </dict>
    </plist>
  '';

  flexokiDarkThemeDir = pkgs.runCommand "bat-flexoki-dark-theme" {} ''
    mkdir -p "$out"
    cp "${flexokiDarkTmTheme}" "$out/flexoki-dark.tmTheme"
  '';
in {
  programs.bat = {
    enable = true;
    themes = {
      flexoki-dark = {
        src = flexokiDarkThemeDir;
        file = "flexoki-dark.tmTheme";
      };
    };
    config = {
      theme = "flexoki-dark";
      style = "numbers,changes,header";
    };
  };
}
